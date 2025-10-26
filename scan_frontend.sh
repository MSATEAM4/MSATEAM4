#!/usr/bin/env bash
set -euo pipefail

cd studify-fe-main

INCLUDES=(--include='*.js' --include='*.jsx' --include='*.ts' --include='*.tsx')
DIR=src

echo "== [FRONT] axios를 직접 import 한 곳 (공용 인스턴스 우회) =="
grep -RIn "${INCLUDES[@]}" -F 'import axios from ' "$DIR" || true

echo
echo "== [FRONT] 전체 URL(http/https, localhost) 하드코딩 =="
grep -RIn "${INCLUDES[@]}" -E 'https?://|localhost:8080' "$DIR" || true

echo
echo "== [FRONT] axios로 전체 URL 호출한 곳 =="
grep -RIn "${INCLUDES[@]}" -E 'axios\.(get|post|put|delete|patch)\s*\([^)]*https?://' "$DIR" || true

echo
echo "== [FRONT] fetch로 전체 URL 호출한 곳 =="
grep -RIn "${INCLUDES[@]}" -E 'fetch\s*\([^)]*https?://' "$DIR" || true

echo
echo "== [FRONT] 잘못된 상대경로 (\"/api/\"로 시작하지 않음) - axios =="
for m in get post put delete patch; do
  grep -RIn "${INCLUDES[@]}" -F "axios.${m}('/" "$DIR" | grep -v '/api/' || true
  grep -RIn "${INCLUDES[@]}" -F "axios.${m}(\"/" "$DIR" | grep -v '/api/' || true
done

echo
echo "== [FRONT] 잘못된 상대경로 (\"/api/\"로 시작하지 않음) - fetch =="
grep -RIn "${INCLUDES[@]}" -F "fetch('/" "$DIR" | grep -v '/api/' || true
grep -RIn "${INCLUDES[@]}" -F "fetch(\"/" "$DIR" | grep -v '/api/' || true
