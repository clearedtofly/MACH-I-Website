#!/bin/bash
# Submit all pages to IndexNow (Bing, Yandex, etc.)
# Run after any content deploy

KEY="340b389484807c06242a8461b02bbab5"
HOST="mach1cardiology.com"

URLS=(
  "https://$HOST/"
  "https://$HOST/about"
  "https://$HOST/services"
  "https://$HOST/special-issuance"
  "https://$HOST/publications"
  "https://$HOST/contact"
)

for url in "${URLS[@]}"; do
  echo "Submitting: $url"
  curl -s -X POST "https://api.indexnow.org/indexnow" \
    -H "Content-Type: application/json" \
    -d "{\"host\":\"$HOST\",\"key\":\"$KEY\",\"keyLocation\":\"https://$HOST/$KEY.txt\",\"urlList\":[\"$url\"]}"
  echo ""
done

echo "Done. All pages submitted to IndexNow."
