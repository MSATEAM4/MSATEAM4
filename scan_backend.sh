#!/usr/bin/env bash
set -euo pipefail

BASE=studify-msa
INCLUDES=(--include='*.java' --include='*.yml' --include='*.yaml' --include='*.properties')

echo "== [BACK] URL/포트 하드코딩 및 호출 패턴 점검 =="
grep -RIn "${INCLUDES[@]}" -E 'https?://|localhost(:[0-9]+)?|:(8081|8082|8761)\b' "$BASE" || true

echo
echo "== [BACK] Feign/RestTemplate/WebClient 직접 URL 사용 흔적 =="
grep -RIn "${INCLUDES[@]}" -E '@FeignClient\([^)]*url\s*=|\bRestTemplate\b|\bWebClient\b|baseUrl\(' "$BASE" || true
