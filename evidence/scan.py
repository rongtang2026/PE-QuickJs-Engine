import re, sys, collections

path = sys.argv[1]
mode = sys.argv[2] if len(sys.argv) > 2 else "all"

data = open(path, "rb").read()
# ASCII strings
strings = re.findall(rb"[\x20-\x7e]{4,}", data)
strs = [s.decode("latin1") for s in strings]
# UTF-16LE strings (Java/Haxe sometimes)
u16 = re.findall(rb"(?:[\x20-\x7e]\x00){4,}", data)
u16s = [s.decode("utf-16-le") for s in u16]

pats = {
    "quickjs": r"(?i)quickjs|js_newruntime|js_eval|qjs|jsvalue|js_call",
    "lua": r"(?i)lua[_a-z]|luajit|luabridge|lua5",
    "hscript": r"(?i)hscript",
    "version": r"0\.7\.3|0\.7\.\d|Psych Engine|psych_?engine|PE-QuickJs",
    "path": r"(?i)\.QJsEngine|/storage/emulated|/sdcard",
    "jni": r"DingLing|pe/QuickJs|pe\.QuickJs",
    "haxe_pkg": r"^(funkin|psych|states|objects|backend|flixel|lime|openfl)[._]",
    "ai": r"(?i)as an ai|language model|todo|fixme|hack|placeholder|nigg|shit|fuck|generated",
}

if mode == "count":
    for k, p in pats.items():
        rx = re.compile(p)
        n = sum(1 for s in strs if rx.search(s))
        print(f"{k:10s} {n}")
    sys.exit()

if mode in pats:
    rx = re.compile(pats[mode])
    seen = collections.Counter()
    for s in strs:
        if rx.search(s):
            seen[s] += 1
    for s, c in seen.most_common(200):
        print(f"{c:4d}  {s[:200]}")
    sys.exit()

# default: dump filtered interesting
rx = re.compile("|".join(f"(?:{p})" for p in pats.values()))
seen = collections.Counter()
for s in strs:
    if rx.search(s):
        seen[s] += 1
for s, c in seen.most_common(int(sys.argv[3]) if len(sys.argv) > 3 else 300):
    print(f"{c:4d}  {s[:220]}")
