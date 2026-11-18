#!/usr/bin/env bash
# 用法: GITHUB_TOKEN=xxx ./upload-release.sh
# 上传 D:/FNF/job/apks 下 6 个包到 Wqawa/FuckYou_PE-QuickJs-Engine 的 release
set -euo pipefail
: "${GITHUB_TOKEN:?需要 GITHUB_TOKEN}"
API=https://api.github.com/repos/Wqawa/FuckYou_PE-QuickJs-Engine
TAG=archive-all-versions
APKDIR="D:/FNF/job/apks"

# 创建 release（已存在则复用）
code=$(curl --ssl-no-revoke -sS -o /tmp/rel.json -w '%{http_code}' \
  -X POST "$API/releases" \
  -H "Authorization: Bearer $GITHUB_TOKEN" -H 'Accept: application/vnd.github+json' \
  -d "{\"tag_name\":\"$TAG\",\"name\":\"PE-QuickJs-Engine 全版本 APK 归档\",\"body\":\"按时间顺序：1.0debug / 1.0release / 1.1debug / 1.1debug-reupload / r-1.1 / r-1.2。1.1debug 为原版(476)，1.1debug-reupload 为换包版(484)。\",\"draft\":false,\"prerelease\":false}")
echo "create release: HTTP $code"
UPLOAD_URL=$(python -c "import json;d=json.load(open('/tmp/rel.json'));print(d.get('upload_url','').split('{')[0])")
[ -n "$UPLOAD_URL" ] || { cat /tmp/rel.json; exit 1; }

upload() {
  local src="$1" dst="$2"
  echo "uploading $dst ..."
  curl --ssl-no-revoke -fLsS -X POST "$UPLOAD_URL?name=$dst" \
    -H "Authorization: Bearer $GITHUB_TOKEN" -H 'Content-Type: application/vnd.android.package-archive' \
    --data-binary "@$APKDIR/$src" -o /tmp/up.json
  python -c "import json;d=json.load(open('/tmp/up.json'));print('  ok:',d.get('name'),d.get('size'))"
}

upload PsychEngine-debug.apk          1.0debug.apk
upload PEQuickJsEngine-release.apk    1.0release.apk
upload PEQuickJsEngine-debug-test.apk 1.1debug.apk
upload 1.1-reupload.apk               1.1debug-reupload.apk
upload r-1.1-encrypted.apk            r-1.1.apk
upload r-1.2-encrypted.apk            r-1.2.apk
