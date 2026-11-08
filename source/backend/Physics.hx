package backend;

/**
	Self-contained 2D physics system: a world of rigid bodies (circles and
	convex polygons integrated per frame with gravity, damping and velocity
	limits) plus AABB collision resolution, impulse/force application and an
	impact event queue. Exposed through a chipmunk-style API
	(worldCreate / worldStep / add* / set* / getTransform / readAll ...).
	Shapes are attached to bodies, so compound bodies are possible through
	the addShape* calls; the add* convenience creators build one-shape bodies.
**/
enum abstract PhysBodyType(Int) from Int to Int
{
	var DYNAMIC:Int = 0;
	var STATIC:Int = 1;
	var KINEMATIC:Int = 2;
}

class Physics
{
	public static var instance:Physics = null;

	public static inline var ERR_WORLD:String = 'ERR_WORLD';
	public static inline var ERR_BODY:String = 'ERR_BODY';
	public static inline var ERR_LIMIT:String = 'ERR_LIMIT';

	var worldActive:Bool = false;
	var worldGravityX:Float = 0;
	var worldGravityY:Float = 980;
	var worldIterations:Int = 4;
	var bodies:Map<Int, PhysBody> = new Map<Int, PhysBody>();
	var nextBodyId:Int = 1;
	var impacts:Array<PhysImpact> = [];
	var lastError:String = null;

	public function new()
	{
		if (instance == null) instance = this;
	}

	public static function boot():Physics
	{
		if (instance == null) instance = new Physics();
		instance.worldCreate();
		return instance;
	}

	public function worldCreate():Bool
	{
		worldActive = true;
		worldGravityX = 0;
		worldGravityY = 980;
		worldIterations = 4;
		bodies.clear();
		impacts.resize(0);
		nextBodyId = 1;
		lastError = null;
		return true;
	}

	public function worldFree():Bool
	{
		worldActive = false;
		bodies.clear();
		impacts.resize(0);
		return true;
	}

	public function worldSetGravity(gx:Float, gy:Float):Bool
	{
		if (!worldActive) return fail(ERR_WORLD);
		worldGravityX = gx;
		worldGravityY = gy;
		return true;
	}

	public function worldSetIterations(iterations:Int):Bool
	{
		if (!worldActive) return fail(ERR_WORLD);
		if (iterations < 1 || iterations > 32) return fail(ERR_LIMIT);
		worldIterations = iterations;
		return true;
	}

	/**
		Advances the world: semi-implicit Euler integration, then AABB
		collision resolution over the configured iteration count.
	**/
	public function worldStep(delta:Float):Void
	{
		if (!worldActive || delta <= 0) return;
		var step:Float = Math.min(delta, 1 / 20);

		for (body in bodies)
		{
			if (body.bodyType == STATIC || body.sleeping) continue;
			if (body.bodyType == DYNAMIC)
			{
				body.vy += worldGravityY * body.gravityScale * step;
				body.vx += worldGravityX * body.gravityScale * step;
				body.vx += body.forceX / body.mass * step;
				body.vy += body.forceY / body.mass * step;
			}
			body.forceX = 0;
			body.forceY = 0;

			if (body.linearDamping > 0)
			{
				var damp:Float = 1 - body.linearDamping * step;
				if (damp < 0) damp = 0;
				body.vx *= damp;
				body.vy *= damp;
			}
			if (body.velocityLimit > 0)
			{
				var speed:Float = Math.sqrt(body.vx * body.vx + body.vy * body.vy);
				if (speed > body.velocityLimit)
				{
					var k:Float = body.velocityLimit / speed;
					body.vx *= k;
					body.vy *= k;
				}
			}

			body.x += body.vx * step;
			body.y += body.vy * step;
			body.angle += body.angularVelocity * step;
			if (body.squash > 0)
			{
				body.squash -= step * 4;
				if (body.squash < 0) body.squash = 0;
			}
		}

		for (_ in 0...worldIterations)
			if (!resolveCollisions()) break;
	}

	function resolveCollisions():Bool
	{
		var anyHit:Bool = false;
		var list:Array<PhysBody> = [];
		for (body in bodies) list.push(body);

		for (i in 0...list.length)
		{
			var a:PhysBody = list[i];
			var aMin:PhysAABB = bodyBounds(a);
			for (j in i + 1...list.length)
			{
				var b:PhysBody = list[j];
				if (a.bodyType == STATIC && b.bodyType == STATIC) continue;
				var bMin:PhysAABB = bodyBounds(b);
				if (!aMin.overlaps(bMin)) continue;
				anyHit = true;
				collide(a, b, aMin, bMin);
			}
		}
		return anyHit;
	}

	function collide(a:PhysBody, b:PhysBody, aBox:PhysAABB, bBox:PhysAABB):Void
	{
		// AABB penetration on both axes, resolve along the smaller one
		var px:Float = Math.min(aBox.maxX - bBox.minX, bBox.maxX - aBox.minX);
		var py:Float = Math.min(aBox.maxY - bBox.minY, bBox.maxY - aBox.minY);
		var strength:Float = Math.abs(a.vy - b.vy) + Math.abs(a.vx - b.vx);

		if (a.sensor || b.sensor)
		{
			recordImpact(a, b, strength);
			return;
		}

		var nx:Float = 0;
		var ny:Float = 0;
		if (py < px)
		{
			ny = (a.y < b.y) ? -1 : 1;
			var push:Float = py / 2;
			if (a.bodyType == DYNAMIC) { a.y += ny * push; a.vy = -a.vy * a.elasticity; }
			if (b.bodyType == DYNAMIC) { b.y -= ny * push; b.vy = -b.vy * b.elasticity; }
		}
		else
		{
			nx = (a.x < b.x) ? -1 : 1;
			var push:Float = px / 2;
			if (a.bodyType == DYNAMIC) { a.x += nx * push; a.vx = -a.vx * a.elasticity; }
			if (b.bodyType == DYNAMIC) { b.x -= nx * push; b.vx = -b.vx * b.elasticity; }
		}

		// simple tangential friction
		if (a.bodyType == DYNAMIC) { a.vx *= 1 - a.friction * 0.05; a.vy *= 1 - a.friction * 0.05; }
		if (b.bodyType == DYNAMIC) { b.vx *= 1 - b.friction * 0.05; b.vy *= 1 - b.friction * 0.05; }

		if (strength > 40)
		{
			recordImpact(a, b, strength);
			if (a.autoSquash) a.squash = Math.min(0.4, strength / 2000);
			if (b.autoSquash) b.squash = Math.min(0.4, strength / 2000);
		}
	}

	function recordImpact(a:PhysBody, b:PhysBody, strength:Float):Void
	{
		a.impacted = true;
		b.impacted = true;
		a.impactStrength = strength;
		b.impactStrength = strength;
		impacts.push(new PhysImpact(a.id, b.id, (a.x + b.x) / 2, (a.y + b.y) / 2, strength));
	}

	function bodyBounds(body:PhysBody):PhysAABB
	{
		var box:PhysAABB = new PhysAABB();
		var cos:Float = Math.cos(body.angle * Math.PI / 180);
		var sin:Float = Math.sin(body.angle * Math.PI / 180);
		var first:Bool = true;
		for (shape in body.shapes)
		{
			if (first)
			{
				box.minX = box.maxX = 0;
				box.minY = box.maxY = 0;
				first = false;
			}
			// collect rotated world-space extreme points of the shape
			var points:Array<Float> = shapeWorldPoints(body, shape, cos, sin);
			var i:Int = 0;
			while (i < points.length)
			{
				var wx:Float = points[i];
				var wy:Float = points[i + 1];
				if (wx < box.minX) box.minX = wx;
				if (wx > box.maxX) box.maxX = wx;
				if (wy < box.minY) box.minY = wy;
				if (wy > box.maxY) box.maxY = wy;
				i += 2;
			}
		}
		return box;
	}

	function shapeWorldPoints(body:PhysBody, shape:PhysShape, cos:Float, sin:Float):Array<Float>
	{
		var out:Array<Float> = [];
		if (shape.type == CIRCLE)
		{
			// circle: rotate the center, extent is the radius in every direction
			var cx:Float = body.x + shape.ox * cos - shape.oy * sin;
			var cy:Float = body.y + shape.ox * sin + shape.oy * cos;
			var r:Float = shape.radius * body.scale;
			out.push(cx - r); out.push(cy - r);
			out.push(cx + r); out.push(cy - r);
			out.push(cx - r); out.push(cy + r);
			out.push(cx + r); out.push(cy + r);
			return out;
		}
		var verts:Array<Float> = shape.type == BOX
			? [-shape.hw, -shape.hh, shape.hw, -shape.hh, shape.hw, shape.hh, -shape.hw, shape.hh]
			: shape.verts;
		var i:Int = 0;
		while (i < verts.length)
		{
			var lx:Float = (verts[i] + shape.ox) * body.scale;
			var ly:Float = (verts[i + 1] + shape.oy) * body.scale;
			out.push(body.x + lx * cos - ly * sin);
			out.push(body.y + lx * sin + ly * cos);
			i += 2;
		}
		return out;
	}

	// ---------------------------------------------------------------- body CRUD

	public function addBody(?x:Float = 0, ?y:Float = 0):Int
	{
		if (!worldActive) { fail(ERR_WORLD); return 0; }
		var body:PhysBody = new PhysBody();
		body.id = nextBodyId++;
		body.x = x;
		body.y = y;
		body.mass = 1;
		bodies.set(body.id, body);
		return body.id;
	}

	public function remove(id:Int):Bool
	{
		if (!worldActive) return fail(ERR_WORLD);
		if (!bodies.exists(id)) return fail(ERR_BODY);
		bodies.remove(id);
		return true;
	}

	// ------------------------------------------------- one-shape convenience creators

	public function addCircle(x:Float, y:Float, radius:Float):Int
	{
		var id:Int = addBody(x, y);
		if (id == 0) return 0;
		addShapeCircle(id, 0, 0, radius);
		return id;
	}

	public function addBox(x:Float, y:Float, width:Float, height:Float):Int
	{
		var id:Int = addBody(x, y);
		if (id == 0) return 0;
		addShapeBox(id, 0, 0, width, height);
		return id;
	}

	public function addTriangle(x:Float, y:Float, size:Float):Int
	{
		return addPolygon(x, y, polygonVerts(3, size, -90));
	}

	public function addRightTriangle(x:Float, y:Float, width:Float, height:Float):Int
	{
		return addPolygon(x, y, [-width / 2, height / 2, width / 2, height / 2, -width / 2, -height / 2]);
	}

	public function addDiamond(x:Float, y:Float, radius:Float):Int
	{
		return addPolygon(x, y, [0, -radius, radius, 0, 0, radius, -radius, 0]);
	}

	public function addHexagon(x:Float, y:Float, radius:Float):Int
	{
		return addPolygon(x, y, polygonVerts(6, radius, -90));
	}

	public function addRegular(x:Float, y:Float, sides:Int, radius:Float, ?rotation:Float = 0):Int
	{
		return addPolygon(x, y, polygonVerts(sides, radius, rotation));
	}

	public function addStar(x:Float, y:Float, radius:Float, ?innerRadius:Float = 0, ?points:Int = 5):Int
	{
		if (innerRadius <= 0) innerRadius = radius * 0.5;
		var verts:Array<Float> = [];
		var step:Float = Math.PI / points;
		var angle:Float = -Math.PI / 2;
		for (i in 0...(points * 2))
		{
			var r:Float = (i % 2 == 0) ? radius : innerRadius;
			verts.push(Math.cos(angle) * r);
			verts.push(Math.sin(angle) * r);
			angle += step;
		}
		return addPolygon(x, y, verts);
	}

	public function addCross(x:Float, y:Float, size:Float, ?thickness:Float = 0):Int
	{
		if (thickness <= 0) thickness = size * 0.34;
		var arm:Float = size;
		var t:Float = thickness;
		var verts:Array<Float> = [
			-t / 2, -arm / 2,  t / 2, -arm / 2,
			t / 2,  -t / 2,  arm / 2,  -t / 2,
			arm / 2,  t / 2,  t / 2,   t / 2,
			t / 2,   arm / 2, -t / 2,  arm / 2,
			-t / 2,   t / 2, -arm / 2,  t / 2,
			-arm / 2, -t / 2, -t / 2,  -t / 2
		];
		return addPolygon(x, y, verts);
	}

	public function addTrapezoid(x:Float, y:Float, topWidth:Float, bottomWidth:Float, height:Float):Int
	{
		return addPolygon(x, y, [
			-topWidth / 2, -height / 2,  topWidth / 2, -height / 2,
			bottomWidth / 2, height / 2, -bottomWidth / 2, height / 2
		]);
	}

	public function addEllipse(x:Float, y:Float, radiusX:Float, radiusY:Float):Int
	{
		var verts:Array<Float> = [];
		var sides:Int = 16;
		for (i in 0...sides)
		{
			var a:Float = i / sides * Math.PI * 2;
			verts.push(Math.cos(a) * radiusX);
			verts.push(Math.sin(a) * radiusY);
		}
		return addPolygon(x, y, verts);
	}

	public function addCapsule(x:Float, y:Float, width:Float, height:Float):Int
	{
		var r:Float = Math.min(width, height) / 2;
		var verts:Array<Float> = [];
		var sides:Int = 8;
		// stadium approximated by an octagonal outline of two offset half-circles
		for (i in 0...sides)
		{
			var a:Float = -Math.PI / 2 + (i / (sides - 1)) * Math.PI;
			verts.push(Math.cos(a) * r + (width / 2 - r));
			verts.push(Math.sin(a) * r);
		}
		for (i in 0...sides)
		{
			var a:Float = Math.PI / 2 + (i / (sides - 1)) * Math.PI;
			verts.push(Math.cos(a) * r - (width / 2 - r));
			verts.push(Math.sin(a) * r);
		}
		return addPolygon(x, y, verts);
	}

	public function addPolygon(x:Float, y:Float, verts:Array<Float>):Int
	{
		var id:Int = addBody(x, y);
		if (id == 0) return 0;
		addShapePoly(id, 0, 0, verts);
		return id;
	}

	// ---------------------------------------------------------------- shapes

	public function addShapeCircle(id:Int, ox:Float, oy:Float, radius:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (radius <= 0) return fail(ERR_LIMIT);
		var shape:PhysShape = new PhysShape();
		shape.initCircle(ox, oy, radius);
		body.shapes.push(shape);
		return true;
	}

	public function addShapeBox(id:Int, ox:Float, oy:Float, width:Float, height:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (width <= 0 || height <= 0) return fail(ERR_LIMIT);
		var shape:PhysShape = new PhysShape();
		shape.initBox(ox, oy, width, height);
		body.shapes.push(shape);
		return true;
	}

	public function addShapePoly(id:Int, ox:Float, oy:Float, verts:Array<Float>):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (verts == null || verts.length < 6) return fail(ERR_LIMIT);
		var shape:PhysShape = new PhysShape();
		shape.initPoly(ox, oy, verts);
		body.shapes.push(shape);
		return true;
	}

	public function clearShapes(id:Int):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.shapes.resize(0);
		return true;
	}

	public function shapeCount(?id:Int = 0):Int
	{
		if (id != 0)
		{
			var body:PhysBody = getBody(id);
			return body == null ? 0 : body.shapes.length;
		}
		var total:Int = 0;
		for (body in bodies)
			total += body.shapes.length;
		return total;
	}

	public function shapeNames(?id:Int = 0):String
	{
		var names:Array<String> = [];
		for (body in bodies)
		{
			if (id != 0 && body.id != id) continue;
			for (shape in body.shapes)
				if (!names.contains(shape.name)) names.push(shape.name);
		}
		return names.join(',');
	}

	// ---------------------------------------------------------------- setters

	public function setPos(id:Int, x:Float, y:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.x = x;
		body.y = y;
		return true;
	}

	public function setAngle(id:Int, angle:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.angle = angle;
		return true;
	}

	public function setVelocity(id:Int, vx:Float, vy:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.vx = vx;
		body.vy = vy;
		return true;
	}

	public function setAngularVelocity(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.angularVelocity = value;
		return true;
	}

	public function setFriction(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (value < 0 || value > 1) return fail(ERR_LIMIT);
		body.friction = value;
		return true;
	}

	public function setElasticity(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (value < 0 || value > 1) return fail(ERR_LIMIT);
		body.elasticity = value;
		return true;
	}

	public function setDensity(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (value <= 0) return fail(ERR_LIMIT);
		body.density = value;
		return true;
	}

	public function setMass(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (value <= 0) return fail(ERR_LIMIT);
		body.mass = value;
		return true;
	}

	public function setGravityScale(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.gravityScale = value;
		return true;
	}

	public function setLinearDamping(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (value < 0) return fail(ERR_LIMIT);
		body.linearDamping = value;
		return true;
	}

	public function setVelocityLimit(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (value < 0) return fail(ERR_LIMIT);
		body.velocityLimit = value;
		return true;
	}

	public function setSensor(id:Int, value:Bool):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.sensor = value;
		return true;
	}

	public function setSleeping(id:Int, value:Bool):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.sleeping = value;
		return true;
	}

	public function setStatic(id:Int):Bool
	{
		return setBodyType(id, STATIC);
	}

	public function setDynamic(id:Int):Bool
	{
		return setBodyType(id, DYNAMIC);
	}

	public function setKinematic(id:Int):Bool
	{
		return setBodyType(id, KINEMATIC);
	}

	public function setBodyType(id:Int, bodyType:PhysBodyType):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.bodyType = bodyType;
		return true;
	}

	public function setFilter(id:Int, value:Int):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.filter = value;
		return true;
	}

	public function setAutoSquash(id:Int, value:Bool):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.autoSquash = value;
		return true;
	}

	public function setScale(id:Int, value:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (value <= 0) return fail(ERR_LIMIT);
		body.scale = value;
		return true;
	}

	public function setCircleRadius(id:Int, shapeIndex:Int, radius:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (shapeIndex < 0 || shapeIndex >= body.shapes.length) return fail(ERR_BODY);
		if (radius <= 0) return fail(ERR_LIMIT);
		var shape:PhysShape = body.shapes[shapeIndex];
		shape.initCircle(shape.ox, shape.oy, radius);
		return true;
	}

	public function setBoxSize(id:Int, shapeIndex:Int, width:Float, height:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		if (shapeIndex < 0 || shapeIndex >= body.shapes.length) return fail(ERR_BODY);
		if (width <= 0 || height <= 0) return fail(ERR_LIMIT);
		var shape:PhysShape = body.shapes[shapeIndex];
		shape.initBox(shape.ox, shape.oy, width, height);
		return true;
	}

	// ---------------------------------------------------------------- forces & queries

	public function applyForce(id:Int, fx:Float, fy:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.forceX += fx;
		body.forceY += fy;
		return true;
	}

	public function applyImpulse(id:Int, ix:Float, iy:Float):Bool
	{
		var body:PhysBody = getBody(id);
		if (body == null) return fail(ERR_BODY);
		body.vx += ix / body.mass;
		body.vy += iy / body.mass;
		return true;
	}

	/**
		Current transform of a body: {id, x, y, angle} or null for invalid ids.
	**/
	public function getTransform(id:Int):Dynamic
	{
		var body:PhysBody = getBody(id);
		if (body == null) return null;
		return {id: body.id, x: body.x, y: body.y, angle: body.angle};
	}

	/**
		Snapshot of every live body: array of {id, x, y, angle, vx, vy}.
	**/
	public function readAll():Array<Dynamic>
	{
		var out:Array<Dynamic> = [];
		for (body in bodies)
			out.push({id: body.id, x: body.x, y: body.y, angle: body.angle, vx: body.vx, vy: body.vy});
		return out;
	}

	/**
		Pops the next queued impact {a, b, x, y, strength} (null when empty).
	**/
	public function getImpact():Dynamic
	{
		if (impacts.length == 0) return null;
		var impact:PhysImpact = impacts.shift();
		return {a: impact.a, b: impact.b, x: impact.x, y: impact.y, strength: impact.strength};
	}

	public function clearImpact():Void
	{
		impacts.resize(0);
		for (body in bodies)
		{
			body.impacted = false;
			body.impactStrength = 0;
		}
	}

	/**
		Id of the topmost body whose bounds contain the world point (0 when none).
	**/
	public function queryPoint(px:Float, py:Float):Int
	{
		var found:Int = 0;
		for (body in bodies)
		{
			var box:PhysAABB = bodyBounds(body);
			if (px >= box.minX && px <= box.maxX && py >= box.minY && py <= box.maxY)
				found = body.id; // map order is stable per insertion, last wins = topmost
		}
		return found;
	}

	public function bodyCount():Int
	{
		var n:Int = 0;
		for (_ in bodies) n++;
		return n;
	}

	function getBody(id:Int):PhysBody
	{
		if (!worldActive) return null;
		return bodies.get(id);
	}

	function fail(code:String):Bool
	{
		lastError = code;
		return false;
	}

	/**
		Runs a built-in check: a circle dropped into a fresh world must fall.
	**/
	public function selfTest():Bool
	{
		var worldWasActive:Bool = worldActive;
		worldCreate();
		worldSetGravity(0, 980);
		var id:Int = addCircle(0, 0, 16);
		var ok:Bool = id != 0;
		if (ok)
		{
			var startY:Float = cast(getTransform(id), Dynamic).y;
			for (_ in 0...60)
				worldStep(1 / 60);
			ok = cast(getTransform(id), Dynamic).y > startY + 10;
			if (!ok) lastError = 'body did not fall';
		}
		worldCreate(); // restore a clean world
		if (!worldWasActive) worldFree();
		trace('[Physics] selfTest ' + (ok ? 'passed' : 'FAILED: ' + lastError));
		return ok;
	}

	public function toString():String
	{
		return '[Physics bodies=' + bodyCount() + ' shapes=' + shapeCount() + ' impacts=' + impacts.length
			+ (lastError != null ? ' err=' + lastError : '') + ']';
	}
}

class PhysBody
{
	public var id:Int = 0;
	public var x:Float = 0;
	public var y:Float = 0;
	public var angle:Float = 0;
	public var vx:Float = 0;
	public var vy:Float = 0;
	public var angularVelocity:Float = 0;
	public var forceX:Float = 0;
	public var forceY:Float = 0;
	public var shapes:Array<PhysShape> = [];
	public var density:Float = 1;
	public var mass:Float = 1;
	public var friction:Float = 0.6;
	public var elasticity:Float = 0.2;
	public var linearDamping:Float = 0;
	public var gravityScale:Float = 1;
	public var velocityLimit:Float = 0;
	public var bodyType:PhysBodyType = DYNAMIC;
	public var sensor:Bool = false;
	public var sleeping:Bool = false;
	public var autoSquash:Bool = false;
	public var scale:Float = 1;
	public var filter:Int = 0;
	public var impacted:Bool = false;
	public var impactStrength:Float = 0;
	public var squash:Float = 0;

	public function new() {}
}

enum PhysShapeType
{
	CIRCLE;
	BOX;
	POLY;
}

class PhysShape
{
	public var type:PhysShapeType = CIRCLE;
	public var name:String = 'circle';
	public var ox:Float = 0;
	public var oy:Float = 0;
	public var radius:Float = 16;
	public var hw:Float = 16;
	public var hh:Float = 16;
	public var verts:Array<Float> = [];

	public function new() {}

	public function initCircle(ox:Float, oy:Float, radius:Float):Void
	{
		type = CIRCLE;
		name = 'circle';
		this.ox = ox;
		this.oy = oy;
		this.radius = radius;
	}

	public function initBox(ox:Float, oy:Float, width:Float, height:Float):Void
	{
		type = BOX;
		name = 'box';
		this.ox = ox;
		this.oy = oy;
		this.hw = width / 2;
		this.hh = height / 2;
		verts.resize(0);
	}

	public function initPoly(ox:Float, oy:Float, verts:Array<Float>):Void
	{
		type = POLY;
		name = 'polygon';
		this.ox = ox;
		this.oy = oy;
		this.verts = verts.copy();
	}
}

class PhysImpact
{
	public var a:Int = 0;
	public var b:Int = 0;
	public var x:Float = 0;
	public var y:Float = 0;
	public var strength:Float = 0;

	public function new(a:Int, b:Int, x:Float, y:Float, strength:Float)
	{
		this.a = a;
		this.b = b;
		this.x = x;
		this.y = y;
		this.strength = strength;
	}
}

class PhysAABB
{
	public var minX:Float = 0;
	public var minY:Float = 0;
	public var maxX:Float = 0;
	public var maxY:Float = 0;

	public function new() {}

	public function overlaps(other:PhysAABB):Bool
	{
		return minX <= other.maxX && maxX >= other.minX && minY <= other.maxY && maxY >= other.minY;
	}
}
