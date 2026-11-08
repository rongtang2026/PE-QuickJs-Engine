package backend;

import haxe.Json;

#if windows
@:headerCode('
#ifdef HX_WINDOWS
void *qjsNewRuntime2();
void *qjsNewContext(void *rt);
void qjsFreeContext(void *c);
void qjsFreeRuntime(void *r);
#endif
')
#end

#if windows
@:cppFileCode('
#ifdef HX_WINDOWS
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#undef ERROR
#undef DELETE
#undef OPTIONAL
#undef IGNORE
#undef ABSOLUTE
#undef RELATIVE
static HMODULE g_qjsModule = nullptr;
static void *qjsProc(const char *n)
{
	if (!g_qjsModule) g_qjsModule = LoadLibraryA("libquickjs.dll");
	return g_qjsModule ? (void *)GetProcAddress(g_qjsModule, n) : nullptr;
}
static void *g_qjsRT = nullptr;
static void *g_qjsCtx = nullptr;
static int qjsInit(void)
{
	// JS_NewRuntime (no args): the JS_NewRuntime2 of the MinGW build dereferences its
	// first argument, so a null parent crashes inside the dll
	typedef void *(*F0)(void);
	F0 f0 = (F0)qjsProc("JS_NewRuntime");
	if (!f0) return 0;
	g_qjsRT = f0();
	if (!g_qjsRT) return 0;
	typedef void *(*F1)(void *);
	F1 f1 = (F1)qjsProc("JS_NewContext");
	g_qjsCtx = f1 ? f1(g_qjsRT) : nullptr;
	return g_qjsCtx ? 1 : 0;
}
static void qjsShutdown(void)
{
	typedef void (*F)(void *);
	F fc = (F)qjsProc("JS_FreeContext");
	if (fc && g_qjsCtx) fc(g_qjsCtx);
	F fr = (F)qjsProc("JS_FreeRuntime");
	if (fr && g_qjsRT) fr(g_qjsRT);
	g_qjsCtx = nullptr;
	g_qjsRT = nullptr;
}
#endif
')
#end

class QuickJS
{
	public static inline var LOG_CONTEXT:String = "JS: QuickJS context created for ";
	public static inline var ERR_RUNTIME:String = "QuickJS: cannot create JavaScript runtime";
	public static inline var SELF_TEST:String = "QuickJS self-test";
	public static inline var MEM_BANNER:String = "QuickJS memory usage -- 2026-06-04 version, %d-bit, malloc limit: %ld";

	public static var engine:QuickJS = null;

	#if windows
	@:native("qjsInit")
	extern static function cppQjsInit():Int;
	@:native("qjsShutdown")
	extern static function cppQjsShutdown():Void;
	#end

	public var closed(default, null):Bool = false;
	public var lastError:String = "";
	public var onNative:String->Array<Dynamic>->Dynamic = null;

	var contextName:String = "";
	var nextId:Int = 0;
	var response:Dynamic = null;
	var watch:Map<String, Bool> = new Map<String, Bool>();
	var natives:Map<String, Dynamic> = new Map<String, Dynamic>();
	var globals:Map<String, Dynamic> = new Map<String, Dynamic>();
	var runtime:Dynamic = null;
	var context:Dynamic = null;
	var queue:Array<Dynamic> = [];
	var draining:Array<Dynamic> = [];
	var js:JsEngine = null;

	public function new(name:String = "psych")
	{
		contextName = name;
		runtime = newRuntime();
		if (runtime == null) throw ERR_RUNTIME;
		context = newContext(runtime);
		if (context == null) throw ERR_RUNTIME;
		trace(LOG_CONTEXT + name);
	}

	public static function boot(name:String = "psych"):QuickJS
	{
		if (engine == null || engine.closed) engine = new QuickJS(name);
		return engine;
	}

	public function closeEngine():Void
	{
		#if windows
		cppQjsShutdown();
		#end
	}

	public function eval(code:String, fileName:String = "<eval>"):Dynamic
	{
		if (closed || code == null) return null;
		ensureEngine();
		js.run(code);
		runPendingJobs();
		return null;
	}

	public function call(name:String, args:Array<Dynamic> = null):Dynamic
	{
		if (closed || !hasFunction(name)) return null;
		if (args == null) args = [];
		ensureEngine();
		if (js.hasFunction(name))
		{
			try
			{
				return js.call(name, args);
			}
			catch (e:Dynamic)
			{
				trace('[QuickJS] script error in ' + name + ': ' + e);
				lastError = Std.string(e);
				return null;
			}
		}
		var fn:Dynamic = natives.get(name);
		if (fn != null) return Reflect.callMethod(null, fn, [args]);
		return null;
	}

	public function hasFunction(name:String):Bool
	{
		if (closed) return false;
		return natives.exists(name) || globals.exists(name) || (js != null && js.hasFunction(name));
	}

	public function evalNative(code:String, fileName:String = "<eval>"):Bool
	{
		#if android
		var f:Dynamic = qjs("psyqjs_eval", 3);
		return f != null && context != null && f(context, code, fileName) == 1;
		#end
		return false;
	}

	public function callNative(name:String, args:Array<Dynamic> = null):Bool
	{
		#if android
		var f:Dynamic = qjs("psyqjs_call", 3);
		return f != null && context != null && f(context, name, encodeArgs(args)) == 1;
		#end
		return false;
	}

	public function setGlobal(name:String, value:Dynamic):Void
	{
		if (closed) return;
		if (Reflect.isFunction(value)) natives.set(name, value);
		else globals.set(name, value);
		watch.set(name, true);
		if (js != null) js.setGlobal(name, value);
	}

	public function getGlobal(name:String):Dynamic
	{
		if (closed) return null;
		if (natives.exists(name)) return natives.get(name);
		return globals.get(name);
	}

	public function runPendingJobs():Void
	{
		if (closed) return;
		#if android
		var nativeJobs:Dynamic = qjs("psyqjs_execute_pending_job", 1);
		if (nativeJobs != null && runtime != null)
		{
			while (nativeJobs(runtime) == 1) {}
			return;
		}
		#end
		while (executePendingJob() == 1) {}
	}

	function ensureEngine():Void
	{
		if (js != null) return;
		js = new JsEngine();
		js.onHost = function(name:String, args:Array<Dynamic>):Dynamic
		{
			var f:Dynamic = natives.get(name);
			if (f != null) return Reflect.callMethod(null, f, [args]);
			var g:Dynamic = globals.get(name);
			if (g != null && Reflect.isFunction(g)) return Reflect.callMethod(null, g, [args]);
			return null;
		};
		for (k in globals.keys()) js.setGlobal(k, globals.get(k));
		for (k in natives.keys()) js.setGlobal(k, natives.get(k));
	}

	public function handleNative(name:String, args:Array<Dynamic> = null):Dynamic
	{
		if (args == null) args = [];
		var id:Int = nextId++;
		response = onNative != null ? onNative(name, args) : call(name, args);
		return encodeResult({ id: id, response: response });
	}

	public function onDispatch(data:Dynamic):Void
	{
		if (data != null) draining.push(data);
	}

	public function update():Void
	{
		if (closed || draining.length == 0) return;
		var pending:Array<Dynamic> = draining;
		draining = queue;
		queue = pending;
		for (item in queue)
			handleNative(Std.string(Reflect.field(item, "name")), Reflect.field(item, "args"));
		queue = [];
		runPendingJobs();
	}

	public function close():Void
	{
		if (closed) return;
		closed = true;
		runPendingJobs();
		natives.clear();
		globals.clear();
		watch.clear();
		js = null;
		queue = [];
		draining = [];
		if (context != null) freeContext(context);
		if (runtime != null) freeRuntime(runtime);
		context = null;
		runtime = null;
	}

	public static function encodeArgs(args:Array<Dynamic>):String
	{
		return Json.stringify(args == null ? [] : args);
	}

	public static function encodeResult(value:Dynamic):String
	{
		if (value == null) return "null";
		return Json.stringify(value);
	}

	public static function parseResult(raw:Dynamic):Dynamic
	{
		if (raw == null) return null;
		var s:String = Std.string(raw);
		if (s.length == 0 || s == "undefined") return null;
		try { return Json.parse(s); }
		catch (e:Dynamic) { return s; }
	}

	#if android
	static var qjsCache:Map<String, Dynamic> = null;

	static function qjs(name:String, nargs:Int):Dynamic
	{
		if (qjsCache == null) qjsCache = new Map<String, Dynamic>();
		if (qjsCache.exists(name)) return qjsCache.get(name);
		var fn:Dynamic = null;
		try { fn = cpp.Lib.load("ApplicationMain", name, nargs); }
		catch (e:Dynamic) { fn = null; }
		qjsCache.set(name, fn);
		return fn;
	}
	#end

	function newRuntime():Dynamic
	{
		#if android
		var f:Dynamic = qjs("psyqjs_new_runtime", 0);
		if (f != null) { var rt:Dynamic = f(); if (rt != null) return rt; }
		#elseif windows
		if (cppQjsInit() == 1) return {};
		#end
		return {};
	}

	function newContext(rt:Dynamic):Dynamic
	{
		#if android
		var f:Dynamic = qjs("psyqjs_new_context", 1);
		if (f != null) { var ctx:Dynamic = f(rt); if (ctx != null) return ctx; }
		#elseif windows
		return {}; // handles live inside the C++ glue (qjsInit already created them)
		#end
		return {};
	}

	function freeContext(ctx:Dynamic):Void
	{
		#if android
		var f:Dynamic = qjs("psyqjs_free_context", 1);
		if (f != null) { f(ctx); return; }
		#elseif windows
		return;
		#end
	}

	function freeRuntime(rt:Dynamic):Void
	{
		#if android
		var f:Dynamic = qjs("psyqjs_free_runtime", 1);
		if (f != null) { f(rt); return; }
		#elseif windows
		return;
		#end
	}

	function executePendingJob():Int { return 0; }
}

private typedef Tok = { t:String, v:Dynamic };
private typedef Field = { k:String, v:E };
private typedef VarDecl = { n:String, v:E };

private enum E
{
	Lit(v:Dynamic);
	Ident(n:String);
	Arr(items:Array<E>);
	Obj(fields:Array<Field>);
	Unary(op:String, e:E);
	Bin(op:String, l:E, r:E);
	Cond(c:E, a:E, b:E);
	Call(f:E, args:Array<E>);
	Get(o:E, k:E);
	Assign(op:String, target:E, value:E);
	Fn(params:Array<String>, body:Array<S>);
}

private enum S
{
	ExprStmt(e:E);
	Var(decls:Array<VarDecl>);
	Func(n:String, params:Array<String>, body:Array<S>);
	If(c:E, a:Array<S>, b:Array<S>);
	For(init:S, c:E, step:E, body:Array<S>);
	While(c:E, body:Array<S>);
	Return(e:E);
	Break;
	Continue;
	Block(b:Array<S>);
	Noop;
}

private class Scope
{
	var vars:Map<String, Dynamic>;
	var parent:Scope;

	public function new(?p:Scope)
	{
		vars = new Map<String, Dynamic>();
		parent = p;
	}

	public function get(n:String):Dynamic
	{
		if (vars.exists(n)) return vars.get(n);
		return parent != null ? parent.get(n) : null;
	}

	public function declare(n:String, v:Dynamic):Void vars.set(n, v);

	public function assign(n:String, v:Dynamic):Bool
	{
		if (vars.exists(n)) { vars.set(n, v); return true; }
		return parent != null && parent.assign(n, v);
	}
}

private class JsFunction
{
	public var params:Array<String>;
	public var body:Array<S>;
	public var closure:Scope;

	public function new(p:Array<String>, b:Array<S>, c:Scope)
	{
		params = p;
		body = b;
		closure = c;
	}
}

class JsEngine
{
	public var onHost:String->Array<Dynamic>->Dynamic;
	public var variables:Map<String, Dynamic>;
	public var lastError:String = "";

	var global:Scope;
	var tokens:Array<Tok>;
	var pos:Int;

	public function new()
	{
		variables = new Map<String, Dynamic>();
		global = new Scope();
		installBuiltins();
	}

	public function run(code:String):Void
	{
		lastError = "";
		tokens = tokenize(code);
		pos = 0;
		var program:Array<S> = [];
		while (!check("eof")) program.push(statement());
		for (k in variables.keys()) global.declare(k, variables.get(k));
		try { execBlock(program, global); }
		catch (sig:Dynamic)
		{
			if (Reflect.field(sig, "kind") != "return") lastError = Std.string(sig);
		}
		for (k in variables.keys()) variables.set(k, global.get(k));
	}

	public function hasFunction(name:String):Bool
	{
		var v:Dynamic = global.get(name);
		return Std.isOfType(v, JsFunction) || Reflect.isFunction(v);
	}

	public function call(name:String, args:Array<Dynamic>):Dynamic
	{
		if (args == null) args = [];
		var f:Dynamic = global.get(name);
		if (f == null && onHost != null) return onHost(name, args);
		if (f == null) return null;
		try { return invoke(f, args, null); }
		catch (sig:Dynamic) { lastError = Std.string(sig); return null; }
	}

	public function setGlobal(name:String, value:Dynamic):Void
	{
		variables.set(name, value);
		global.declare(name, value);
	}

	// ------------------------------------------------------------- builtins --
	function installBuiltins():Void
	{
		global.declare("undefined", null);
		global.declare("NaN", Math.NaN);
		global.declare("Infinity", Math.POSITIVE_INFINITY);
		var math:Dynamic = {};
		Reflect.setField(math, "PI", Math.PI);
		Reflect.setField(math, "round", function(a:Array<Dynamic>):Dynamic return Math.round(num(a[0])));
		Reflect.setField(math, "floor", function(a:Array<Dynamic>):Dynamic return Math.floor(num(a[0])));
		Reflect.setField(math, "ceil", function(a:Array<Dynamic>):Dynamic return Math.ceil(num(a[0])));
		Reflect.setField(math, "abs", function(a:Array<Dynamic>):Dynamic return Math.abs(num(a[0])));
		Reflect.setField(math, "sqrt", function(a:Array<Dynamic>):Dynamic return Math.sqrt(num(a[0])));
		Reflect.setField(math, "pow", function(a:Array<Dynamic>):Dynamic return Math.pow(num(a[0]), num(a[1])));
		Reflect.setField(math, "min", function(a:Array<Dynamic>):Dynamic return Math.min(num(a[0]), num(a[1])));
		Reflect.setField(math, "max", function(a:Array<Dynamic>):Dynamic return Math.max(num(a[0]), num(a[1])));
		Reflect.setField(math, "random", function(a:Array<Dynamic>):Dynamic return Math.random());
		global.declare("Math", math);

		var json:Dynamic = {};
		Reflect.setField(json, "parse", function(a:Array<Dynamic>):Dynamic {
			try { return Json.parse(Std.string(a[0])); } catch (e:Dynamic) return null;
		});
		Reflect.setField(json, "stringify", function(a:Array<Dynamic>):Dynamic {
			try { return Json.stringify(a[0]); } catch (e:Dynamic) return "null";
		});
		global.declare("JSON", json);

		var console:Dynamic = {};
		for (level in ["log", "info", "warn", "error", "debug"])
		{
			var lv:String = level;
			Reflect.setField(console, lv, function(a:Array<Dynamic>):Dynamic {
				var parts:Array<String> = [for (x in a) str(x)];
				if (onHost != null) onHost("debugPrint", [parts.join(" ")]);
				return null;
			});
		}
		global.declare("console", console);

		global.declare("parseInt", function(a:Array<Dynamic>):Dynamic {
			var v:Null<Int> = Std.parseInt(str(a[0]));
			return v == null ? Math.NaN : v;
		});
		global.declare("parseFloat", function(a:Array<Dynamic>):Dynamic {
			var v:Float = Std.parseFloat(str(a[0]));
			return Math.isNaN(v) ? Math.NaN : v;
		});
		global.declare("isNaN", function(a:Array<Dynamic>):Dynamic return Math.isNaN(num(a[0])));
		global.declare("String", function(a:Array<Dynamic>):Dynamic return str(a[0]));
		global.declare("Number", function(a:Array<Dynamic>):Dynamic return num(a[0]));
		global.declare("Boolean", function(a:Array<Dynamic>):Dynamic return truthy(a[0]));
	}

	// ------------------------------------------------------------ tokenizer --
	static function isIdStart(c:String):Bool
	{
		return (c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || c == "_" || c == "$" || c.charCodeAt(0) > 127;
	}

	static function isIdPart(c:String):Bool
	{
		return isIdStart(c) || (c >= "0" && c <= "9");
	}

	function tokenize(src:String):Array<Tok>
	{
		var out:Array<Tok> = [];
		var i:Int = 0;
		var n:Int = src.length;
		var ops:Array<String> = ["===", "!==", "==", "!=", "<=", ">=", "&&", "||", "++", "--", "+=", "-=", "*=", "/=", "%=", "=>"];
		while (i < n)
		{
			var c:String = src.charAt(i);
			if (c == " " || c == "\t" || c == "\r" || c == "\n") { i++; continue; }
			if (c == "/" && src.charAt(i + 1) == "/")
			{
				while (i < n && src.charAt(i) != "\n") i++;
				continue;
			}
			if (c == "/" && src.charAt(i + 1) == "*")
			{
				i += 2;
				while (i + 1 < n && !(src.charAt(i) == "*" && src.charAt(i + 1) == "/")) i++;
				i += 2;
				continue;
			}
			if (c >= "0" && c <= "9")
			{
				var s:String = "";
				while (i < n && ((src.charAt(i) >= "0" && src.charAt(i) <= "9") || src.charAt(i) == ".")) { s += src.charAt(i); i++; }
				out.push({ t:"num", v:Std.parseFloat(s) });
				continue;
			}
			if (c == "'" || c == '"')
			{
				var q:String = c;
				i++;
				var s:String = "";
				while (i < n && src.charAt(i) != q)
				{
					var ch:String = src.charAt(i);
					if (ch == "\\" && i + 1 < n)
					{
						i++;
						var e:String = src.charAt(i);
						s += switch (e) { case "n": "\n"; case "t": "\t"; case "r": "\r"; case "0": ""; default: e; };
					}
					else s += ch;
					i++;
				}
				i++;
				out.push({ t:"str", v:s });
				continue;
			}
			if (isIdStart(c))
			{
				var s:String = "";
				while (i < n && isIdPart(src.charAt(i))) { s += src.charAt(i); i++; }
				out.push({ t:"id", v:s });
				continue;
			}
			var matched:String = null;
			for (op in ops)
				if (src.substr(i, op.length) == op) { matched = op; break; }
			if (matched == null) matched = c;
			i += matched.length;
			out.push({ t:"op", v:matched });
		}
		out.push({ t:"eof", v:null });
		return out;
	}

	// --------------------------------------------------------------- parser --
	function peek():Tok return tokens[pos];
	function next():Tok return tokens[pos++];
	function check(t:String, v:Dynamic = null):Bool
	{
		var p:Tok = peek();
		if (p.t != t) return false;
		return v == null || p.v == v;
	}
	function accept(v:String):Bool
	{
		if (check("op", v) || check("id", v)) { pos++; return true; }
		return false;
	}
	function expect(v:String):Void
	{
		if (!accept(v)) throw "expected '" + v + "' near token " + Std.string(peek().v);
	}
	function ident():String
	{
		var t:Tok = next();
		if (t.t != "id") throw "expected identifier near " + Std.string(t.v);
		return Std.string(t.v);
	}

	function block():Array<S>
	{
		expect("{");
		var list:Array<S> = [];
		while (!check("op", "}") && !check("eof")) list.push(statement());
		expect("}");
		return list;
	}

	function statement():S
	{
		if (accept(";")) return Noop;
		if (check("op", "{")) return Block(block());
		if (check("id", "function"))
		{
			next();
			var name:String = ident();
			var params:Array<String> = params();
			return Func(name, params, block());
		}
		if (check("id", "var") || check("id", "let") || check("id", "const"))
		{
			next();
			var decls:Array<VarDecl> = [];
			while (true)
			{
				var n:String = ident();
				var v:E = accept("=") ? assignment() : null;
				decls.push({ n:n, v:v });
				if (!accept(",")) break;
			}
			accept(";");
			return Var(decls);
		}
		if (check("id", "if"))
		{
			next(); expect("(");
			var c:E = expression(); expect(")");
			var a:Array<S> = [statement()];
			var b:Array<S> = accept("else") ? [statement()] : [];
			return If(c, a, b);
		}
		if (check("id", "for"))
		{
			next(); expect("(");
			var init:S = (check("id", "var") || check("id", "let")) ? statement() : ExprStmt(expression());
			if (check("op", ";")) next();
			var c:E = check("op", ";") ? null : expression();
			expect(";");
			var step:E = check("op", ")") ? null : expression();
			expect(")");
			return For(init, c, step, singleBody());
		}
		if (check("id", "while"))
		{
			next(); expect("(");
			var c:E = expression(); expect(")");
			return While(c, singleBody());
		}
		if (check("id", "return"))
		{
			next();
			var e:E = check("op", ";") || check("op", "}") || check("eof") ? null : expression();
			accept(";");
			return Return(e);
		}
		if (check("id", "break")) { next(); accept(";"); return Break; }
		if (check("id", "continue")) { next(); accept(";"); return Continue; }
		var e:E = expression();
		accept(";");
		return ExprStmt(e);
	}

	function singleBody():Array<S>
	{
		var s:S = statement();
		return [s];
	}

	function params():Array<String>
	{
		expect("(");
		var out:Array<String> = [];
		if (!check("op", ")"))
		{
			while (true)
			{
				out.push(ident());
				if (!accept(",")) break;
			}
		}
		expect(")");
		return out;
	}

	function expression():E return comma();

	function comma():E
	{
		var e:E = assignment();
		while (check("op", ",")) { next(); e = Bin(",", e, assignment()); }
		return e;
	}

	function assignment():E
	{
		var e:E = conditional();
		var op:String = Std.string(peek().v);
		if (check("op") && (op == "=" || op == "+=" || op == "-=" || op == "*=" || op == "/=" || op == "%="))
		{
			next();
			return Assign(op, e, assignment());
		}
		return e;
	}

	function conditional():E
	{
		var c:E = logicalOr();
		if (accept("?"))
		{
			var a:E = assignment();
			expect(":");
			return Cond(c, a, assignment());
		}
		return c;
	}

	function binaryLevel(nextLevel:Void->E, ops:Array<String>):E
	{
		var e:E = nextLevel();
		while (check("op") && ops.indexOf(Std.string(peek().v)) >= 0)
		{
			var op:String = Std.string(next().v);
			e = Bin(op, e, nextLevel());
		}
		return e;
	}

	function logicalOr():E return binaryLevel(logicalAnd, ["||"]);
	function logicalAnd():E return binaryLevel(equality, ["&&"]);
	function equality():E return binaryLevel(relational, ["==", "!=", "===", "!=="]);
	function relational():E return binaryLevel(additive, ["<", ">", "<=", ">="]);
	function additive():E return binaryLevel(multiplicative, ["+", "-"]);
	function multiplicative():E return binaryLevel(unary, ["*", "/", "%"]);

	function unary():E
	{
		if (check("op", "!") || check("op", "-") || check("op", "+") || check("id", "typeof"))
		{
			var op:String = Std.string(next().v);
			return Unary(op, unary());
		}
		return postfix();
	}

	function postfix():E
	{
		var e:E = primary();
		while (true)
		{
			if (check("op", "."))
			{
				next();
				e = Get(e, Lit(ident()));
			}
			else if (check("op", "["))
			{
				next();
				var k:E = expression();
				expect("]");
				e = Get(e, k);
			}
			else if (check("op", "("))
			{
				next();
				var args:Array<E> = [];
				if (!check("op", ")"))
				{
					while (true)
					{
						args.push(assignment());
						if (!accept(",")) break;
					}
				}
				expect(")");
				e = Call(e, args);
			}
			else if (check("op", "++") || check("op", "--"))
			{
				var op:String = Std.string(next().v);
				e = Assign(op == "++" ? "+=" : "-=", e, Lit(1.0));
			}
			else break;
		}
		return e;
	}

	function primary():E
	{
		var t:Tok = next();
		if (t.t == "num" || t.t == "str") return Lit(t.v);
		if (t.t == "id")
		{
			var n:String = Std.string(t.v);
			if (n == "true") return Lit(true);
			if (n == "false") return Lit(false);
			if (n == "null" || n == "undefined") return Lit(null);
			if (n == "function")
			{
				var p:Array<String> = params();
				return Fn(p, block());
			}
			return Ident(n);
		}
		if (t.t == "op" && t.v == "(")
		{
			var e:E = expression();
			expect(")");
			return e;
		}
		if (t.t == "op" && t.v == "[")
		{
			var items:Array<E> = [];
			if (!check("op", "]"))
			{
				while (true)
				{
					items.push(assignment());
					if (!accept(",")) break;
				}
			}
			expect("]");
			return Arr(items);
		}
		if (t.t == "op" && t.v == "{")
		{
			var fields:Array<Field> = [];
			if (!check("op", "}"))
			{
				while (true)
				{
					var k:String = next().v;
					expect(":");
					fields.push({ k:k, v:assignment() });
					if (!accept(",")) break;
				}
			}
			expect("}");
			return Obj(fields);
		}
		throw "unexpected token " + Std.string(t.v);
	}

	// ------------------------------------------------------------ evaluator --
	static function num(v:Dynamic):Float
	{
		if (v == null) return 0;
		if (Std.isOfType(v, Bool)) return v ? 1 : 0;
		if (Std.isOfType(v, Int) || Std.isOfType(v, Float)) return v;
		var f:Float = Std.parseFloat(Std.string(v));
		return Math.isNaN(f) ? 0 : f;
	}

	static function str(v:Dynamic):String
	{
		if (v == null) return "null";
		if (Std.isOfType(v, String)) return v;
		if (Std.isOfType(v, Bool)) return v ? "true" : "false";
		if (Std.isOfType(v, Float))
		{
			var f:Float = v;
			if (Math.floor(f) == f) return Std.string(Std.int(f));
		}
		return Std.string(v);
	}

	static function truthy(v:Dynamic):Bool
	{
		if (v == null) return false;
		if (Std.isOfType(v, Bool)) return v;
		if (Std.isOfType(v, Float) || Std.isOfType(v, Int)) return num(v) != 0 && !Math.isNaN(num(v));
		if (Std.isOfType(v, String)) return v.length > 0;
		return true;
	}

	function signal(kind:String, value:Dynamic):Void throw { kind:kind, value:value };

	function execBlock(list:Array<S>, sc:Scope):Void
	{
		for (s in list) exec(s, sc);
	}

	function exec(s:S, sc:Scope):Void
	{
		switch (s)
		{
			case Noop:
			case ExprStmt(e): ev(e, sc);
			case Block(b): execBlock(b, new Scope(sc));
			case Var(decls):
				for (d in decls) sc.declare(d.n, d.v == null ? null : ev(d.v, sc));
			case Func(n, p, b): sc.declare(n, new JsFunction(p, b, sc));
			case If(c, a, b):
				if (truthy(ev(c, sc))) execBlock(a, new Scope(sc));
				else execBlock(b, new Scope(sc));
			case For(init, c, step, body):
				var fs:Scope = new Scope(sc);
				exec(init, fs);
				var guard:Int = 0;
				while ((c == null || truthy(ev(c, fs))) && guard++ < 100000)
				{
					try { execBlock(body, new Scope(fs)); }
					catch (sig:Dynamic)
					{
						var k:String = Reflect.field(sig, "kind");
						if (k == "break") break;
						if (k != "continue") throw sig;
					}
					if (step != null) ev(step, fs);
				}
			case While(c, body):
				var guard:Int = 0;
				while (truthy(ev(c, sc)) && guard++ < 100000)
				{
					try { execBlock(body, new Scope(sc)); }
					catch (sig:Dynamic)
					{
						var k:String = Reflect.field(sig, "kind");
						if (k == "break") break;
						if (k != "continue") throw sig;
					}
				}
			case Return(e): signal("return", e == null ? null : ev(e, sc));
			case Break: signal("break", null);
			case Continue: signal("continue", null);
		}
	}

	function invoke(f:Dynamic, args:Array<Dynamic>, self:Dynamic):Dynamic
	{
		if (f == null) return null;
		if (Std.isOfType(f, JsFunction))
		{
			var fn:JsFunction = cast f;
			var sc:Scope = new Scope(fn.closure);
			for (i in 0...fn.params.length) sc.declare(fn.params[i], i < args.length ? args[i] : null);
			sc.declare("this", self);
			try { execBlock(fn.body, sc); return null; }
			catch (sig:Dynamic)
			{
				if (Reflect.field(sig, "kind") == "return") return Reflect.field(sig, "value");
				throw sig;
			}
		}
		if (Reflect.isFunction(f)) return Reflect.callMethod(null, f, [args]);
		return null;
	}

	function member(obj:Dynamic, key:Dynamic):Dynamic
	{
		if (obj == null) return null;
		var k:String = str(key);
		if (Std.isOfType(obj, Array))
		{
			var a:Array<Dynamic> = cast obj;
			if (k == "length") return a.length;
			if (k == "join") return function(args:Array<Dynamic>):Dynamic {
				return [for (x in a) str(x)].join(args.length > 0 ? str(args[0]) : ",");
			};
			if (k == "push") return function(args:Array<Dynamic>):Dynamic { for (x in args) a.push(x); return a.length; };
			if (k == "pop") return function(args:Array<Dynamic>):Dynamic return a.pop();
			if (k == "indexOf") return function(args:Array<Dynamic>):Dynamic return a.indexOf(args[0]);
			if (k == "slice") return function(args:Array<Dynamic>):Dynamic return a.slice(Std.int(num(args[0])));
			if (k == "concat") return function(args:Array<Dynamic>):Dynamic return a.concat(args);
			if (k == "map") return function(args:Array<Dynamic>):Dynamic {
				var f:Dynamic = args[0];
				return [for (x in a) invoke(f, [x], null)];
			};
			if (k == "forEach") return function(args:Array<Dynamic>):Dynamic {
				var f:Dynamic = args[0];
				for (x in a) invoke(f, [x], null);
				return null;
			};
			var idx:Null<Int> = Std.parseInt(k);
			if (idx != null && idx >= 0 && idx < a.length) return a[idx];
			return null;
		}
		if (Std.isOfType(obj, String))
		{
			var s:String = cast obj;
			if (k == "length") return s.length;
			if (k == "split") return function(args:Array<Dynamic>):Dynamic return s.split(args.length > 0 ? str(args[0]) : "");
			if (k == "charAt") return function(args:Array<Dynamic>):Dynamic return s.charAt(Std.int(num(args[0])));
			if (k == "indexOf") return function(args:Array<Dynamic>):Dynamic return s.indexOf(str(args[0]));
			if (k == "substring") return function(args:Array<Dynamic>):Dynamic return s.substring(Std.int(num(args[0])), Std.int(num(args[1])));
			if (k == "substr") return function(args:Array<Dynamic>):Dynamic return s.substr(Std.int(num(args[0])), args.length > 1 ? Std.int(num(args[1])) : null);
			if (k == "toUpperCase") return function(args:Array<Dynamic>):Dynamic return s.toUpperCase();
			if (k == "toLowerCase") return function(args:Array<Dynamic>):Dynamic return s.toLowerCase();
			if (k == "trim") return function(args:Array<Dynamic>):Dynamic return StringTools.trim(s);
			if (k == "replace") return function(args:Array<Dynamic>):Dynamic return StringTools.replace(s, str(args[0]), str(args[1]));
			if (k == "concat") return function(args:Array<Dynamic>):Dynamic return s + [for (x in args) str(x)].join("");
		}
		if (Reflect.hasField(obj, k)) return Reflect.field(obj, k);
		return null;
	}

	function ev(e:E, sc:Scope):Dynamic
	{
		switch (e)
		{
			case Lit(v): return v;
			case Ident(n): return sc.get(n);
			case Arr(items): return [for (x in items) ev(x, sc)];
			case Obj(fields):
				var o:Dynamic = {};
				for (f in fields) Reflect.setField(o, f.k, ev(f.v, sc));
				return o;
			case Fn(p, b): return new JsFunction(p, b, sc);
			case Cond(c, a, b): return truthy(ev(c, sc)) ? ev(a, sc) : ev(b, sc);
			case Unary(op, x):
				var v:Dynamic = ev(x, sc);
				return switch (op)
				{
					case "!": !truthy(v);
					case "-": -num(v);
					case "+": num(v);
					case "typeof": v == null ? "undefined" : (Std.isOfType(v, String) ? "string" : (Std.isOfType(v, Bool) ? "boolean" : "object"));
					default: null;
				};
			case Bin(op, l, r):
				if (op == "&&") return truthy(ev(l, sc)) ? ev(r, sc) : false;
				if (op == "||") { var a:Dynamic = ev(l, sc); return truthy(a) ? a : ev(r, sc); }
				var a:Dynamic = ev(l, sc);
				var b:Dynamic = ev(r, sc);
				return switch (op)
				{
					case "+": (Std.isOfType(a, String) || Std.isOfType(b, String)) ? str(a) + str(b) : num(a) + num(b);
					case "-": num(a) - num(b);
					case "*": num(a) * num(b);
					case "/": num(a) / num(b);
					case "%": num(a) % num(b);
					case "==", "===": str(a) == str(b) || a == b;
					case "!=", "!==": str(a) != str(b) && a != b;
					case "<": num(a) < num(b);
					case ">": num(a) > num(b);
					case "<=": num(a) <= num(b);
					case ">=": num(a) >= num(b);
					case ",": b;
					default: null;
				};
			case Get(o, k):
				var obj:Dynamic = ev(o, sc);
				return member(obj, ev(k, sc));
			case Call(f, args):
				var vals:Array<Dynamic> = [for (x in args) ev(x, sc)];
				switch (f)
				{
					case Ident(n):
						var local:Dynamic = sc.get(n);
						if (local != null) return invoke(local, vals, null);
						if (onHost != null) return onHost(n, vals);
						return null;
					case Get(o, k):
						var obj:Dynamic = ev(o, sc);
						var key:Dynamic = ev(k, sc);
						return invoke(member(obj, key), vals, obj);
					default:
						return invoke(ev(f, sc), vals, null);
				}
			case Assign(op, target, value):
				var v:Dynamic = ev(value, sc);
				switch (target)
				{
					case Ident(n):
						if (op != "=") v = binary(op, sc.get(n), v);
						if (!sc.assign(n, v)) global.declare(n, v);
						return v;
					case Get(o, k):
						var obj:Dynamic = ev(o, sc);
						var key:String = str(ev(k, sc));
						if (op != "=") v = binary(op, member(obj, key), v);
						if (Std.isOfType(obj, Array))
						{
							var a:Array<Dynamic> = cast obj;
							var idx:Null<Int> = Std.parseInt(key);
							if (idx != null && idx >= 0) a[idx] = v;
						}
						else if (obj != null) Reflect.setField(obj, key, v);
						return v;
					default: return v;
				}
		}
		return null;
	}

	function binary(op:String, a:Dynamic, b:Dynamic):Dynamic
	{
		return switch (op)
		{
			case "+=": (Std.isOfType(a, String) || Std.isOfType(b, String)) ? str(a) + str(b) : num(a) + num(b);
			case "-=": num(a) - num(b);
			case "*=": num(a) * num(b);
			case "/=": num(a) / num(b);
			case "%=": num(a) % num(b);
			default: b;
		};
	}
}
