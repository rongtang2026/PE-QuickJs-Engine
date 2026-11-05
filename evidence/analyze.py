import sys, os, re, json, hashlib, zipfile, subprocess, shutil

AXML_JAR = "D:/FNF/job/_re/tools/apktool.jar"
T073 = "D:/FNF/job/_re/psych_tree.json"
T10 = "D:/FNF/job/_re/psych_tree_1.0.json"

def sha256(p):
    h = hashlib.sha256()
    with open(p, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()

def tree_hx(path):
    t = json.load(open(path))["tree"]
    return set(re.sub(r"^source/", "", x["path"]) for x in t
               if x["path"].startswith("source/") and x["path"].endswith(".hx"))

def hx_paths(data):
    s = set(x.decode("latin1") for x in re.findall(rb"[\x20-\x7e]{4,}", data))
    out = set()
    for x in s:
        for m in re.finditer(r"(?:[A-Za-z0-9_@\-]+/)*[A-Za-z0-9_@\-]+\.hx", x):
            p = m.group(0).replace("\\", "/")
            if "HaxeToolkit" not in p:
                out.add(re.sub(r"^source/", "", p))
    return out

LIBS = ("flixel/", "openfl/", "lime/", "haxe/", "flxanimate/", "sys/", "std/",
        "cpp/", "hscript/", "tjson/", "hxvlc/", "grig/", "funkin/vis/")

def analyze(apk):
    r = {"apk": os.path.basename(apk), "size": os.path.getsize(apk), "sha256": sha256(apk)}
    z = zipfile.ZipFile(apk)
    names = z.namelist()

    # ---- assets
    a = [n for n in names if n.startswith("assets/")]
    r["assets_files"] = len(a)
    r["assets_bytes"] = sum(i.file_size for i in z.infolist() if i.filename.startswith("assets/"))
    r["assets_root_files"] = sorted(n[len("assets/"):] for n in a
                                    if n[len("assets/"):].count("/") == 0)
    r["weekend1"] = any(n.startswith("assets/assets/weekend1/") or n.startswith("assets/weekend1/") for n in a)
    r["voices_split"] = sum(1 for n in a if "Voices-Player" in n or "Voices-Opponent" in n)
    r["zh_cn"] = any(n.endswith("zh-CN.lang") for n in a)
    r["js_scripts"] = sorted(n for n in a if n.endswith(".js"))

    # ---- dex
    dex = [n for n in names if re.match(r"classes\d*\.dex$", n)]
    r["dex"] = sorted(dex)
    r["dex_bytes"] = sum(z.getinfo(n).file_size for n in dex)
    blob = b"".join(z.read(n) for n in dex)
    r["pkg_DingLing"] = blob.count(b"LDingLing/pe/QuickJs/Engine/")
    r["pkg_shadowmario"] = blob.count(b"Lcom/shadowmario/psychengine/")
    r["has_Qz7"] = b"LDingLing/pe/QuickJs/Engine/Qz7;" in blob or b"Lcom/shadowmario/psychengine/Qz7;" in blob
    r["has_VulkanSurfaceHelper"] = b"VulkanSurfaceHelper" in blob

    # ---- so
    sos = {}
    for n in names:
        if n.startswith("lib/arm64-v8a/") and n.endswith(".so"):
            data = z.read(n)
            key = n.split("/")[-1]
            info = {"size": len(data)}
            if key == "libApplicationMain.so":
                s = set(x.decode("latin1") for x in re.findall(rb"[\x20-\x7e]{4,}", data))
                info["lua_syms"] = sum(1 for x in s if re.match(r"^lua_?[A-Za-z]?_", x) or x.startswith("luaL_"))
                info["lua_runtime"] = any(re.match(r"^(lua_pcall|lua_newstate|luaL_newstate)$", x) for x in s)
                info["luaJIT"] = any("LuaJIT" in x for x in s)
                info["quickjs"] = sum(1 for x in s if re.search(r"JS_(NewRuntime2?|Eval|Call)\b", x))
                info["vk_funcs"] = len({m.group(0) for x in s for m in re.finditer(r"\bvk[A-Z][A-Za-z0-9]+", x)})
                hx = hx_paths(data)
                proj = {p for p in hx if not p.startswith(LIBS)}
                v073, v10 = tree_hx(T073), tree_hx(T10)
                info["hx_all"] = len(hx)
                info["hx_proj"] = len(proj)
                info["inter_073"] = len(proj & v073)
                info["inter_10"] = len(proj & v10)
                info["only_10"] = sorted((proj & v10) - v073)
                info["only_073"] = sorted((proj & v073) - v10)
                info["files"] = sorted(proj)
                for k in ["FunkinLua", "FunkinJS", "QuickJS.hx", "VulkanAndroid", "Qz7r",
                          "MobileControls", "Language.hx", "CustomMenuState"]:
                    info["has_" + k.replace(".hx", "")] = any(k in p for p in proj)
                info["vulkan_720"] = b"1280, 0, 720" in data
            sos[key] = info
    r["so"] = sos

    # ---- manifest via apktool
    tmp = "D:/FNF/job/_re/_tmp_" + re.sub(r"\W", "_", os.path.basename(apk))
    shutil.rmtree(tmp, ignore_errors=True)
    subprocess.run(["java", "-jar", AXML_JAR, "d", "-f", "-s", "--no-assets", "-o", tmp, apk],
                   capture_output=True)
    mf = os.path.join(tmp, "AndroidManifest.xml")
    yml = os.path.join(tmp, "apktool.yml")
    if os.path.exists(mf):
        m = open(mf, encoding="utf8", errors="replace").read()
        for k, pat in [("package", r'package="([^"]+)"'),
                       ("versionName", r'android:versionName="([^"]+)"'),
                       ("debuggable", r'android:debuggable="([^"]+)"'),
                       ("minSdk", r'android:minSdkVersion="([^"]+)"'),
                       ("targetSdk", r'android:targetSdkVersion="([^"]+)"')]:
            mm = re.search(pat, m)
            r[k] = mm.group(1) if mm else None
        r["permissions"] = sorted(set(re.findall(r'android:name="(android\.permission\.[A-Z_]+)"', m)))
    if os.path.exists(yml):
        y = open(yml, encoding="utf8", errors="replace").read()
        for k, pat in [("versionCode", r"versionCode:\s*(\S+)"),
                       ("versionName", r"versionName:\s*(\S+)"),
                       ("minSdk", r"minSdkVersion:\s*(\S+)"),
                       ("targetSdk", r"targetSdkVersion:\s*(\S+)")]:
            mv = re.search(pat, y)
            r[k] = r.get(k) or (mv.group(1) if mv else None)
    shutil.rmtree(tmp, ignore_errors=True)
    return r

if __name__ == "__main__":
    apk, out = sys.argv[1], sys.argv[2]
    res = analyze(apk)
    json.dump(res, open(out, "w"), ensure_ascii=False, indent=1)
    s = res.get("so", {}).get("libApplicationMain.so", {})
    print(f"{res['apk']}  {res['size']}  {res['sha256'][:16]}")
    print(f"  pkg={res.get('package')} v={res.get('versionName')}({res.get('versionCode')}) "
          f"deb={res.get('debuggable')} sdk={res.get('minSdk')}/{res.get('targetSdk')}")
    print(f"  dex={len(res['dex'])} assets={res['assets_files']}files/{res['assets_bytes']//1048576}MB "
          f"weekend1={res['weekend1']} voices={res['voices_split']} zhCN={res['zh_cn']}")
    print(f"  hx_proj={s.get('hx_proj')} ∩0.7.3={s.get('inter_073')} ∩1.0={s.get('inter_10')} "
          f"only10={len(s.get('only_10', []))} only073={len(s.get('only_073', []))}")
    print(f"  lua_runtime={s.get('lua_runtime')} luaJIT={s.get('luaJIT')} quickjs={s.get('quickjs')} "
          f"vk={s.get('vk_funcs')} 720={s.get('vulkan_720')}")
    print(f"  Qz7={res['has_Qz7']} VulkanHelper={res['has_VulkanSurfaceHelper']} "
          f"DingLing={res['pkg_DingLing']} shadowmario={res['pkg_shadowmario']}")
