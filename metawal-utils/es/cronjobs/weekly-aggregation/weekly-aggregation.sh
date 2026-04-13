#!/usr/bin/env bash
set -euo pipefail

ES="http://localhost:9200"
AUTH=""
SRC="gn-records"
DEST="categorized_weekly_open_data_snapshot"

WEEK_ID=$(TZ="Europe/Brussels" date -d "today 00:00 last monday" +"%Y%m%d")
SNAP_TS_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
#WEEK_ID=$(TZ="Europe/Brussels" date -d "last monday -7 days 00:00" +"%Y%m%d")
#SNAP_TS_UTC=$(date -u -d "-7 days" +"%Y-%m-%dT%H:%M:%SZ")

RESP=$(curl \
  -H 'Content-Type: application/json' \
  -X POST "$ES/${SRC}/_search/template" \
  -d '{"id":"categorized_open_data_weekly_counts"}')

BULK_FILE=$(mktemp)

echo "$RESP" | jq -c '.aggregations.category.buckets[]' | while read -r bucket; do
  CATEGORY=$(echo "$bucket" | jq -r '.key')
  TOTAL=$(echo "$bucket" | jq '.doc_count')
  TRUE=$(echo "$bucket" | jq '.true_values.doc_count')
  FALSE=$(echo "$bucket" | jq '.false_values.doc_count')

  DOC_ID="open_data_snapshot_${WEEK_ID}_$(echo "$CATEGORY" | tr ' /' '__')"

  cat >> "$BULK_FILE" <<EOF
{ "index": { "_index": "${DEST}", "_id": "${DOC_ID}" } }
{ "snapshot_timestamp": "${SNAP_TS_UTC}", "category": $(jq -Rn --arg v "$CATEGORY" '$v'), "total_count": ${TOTAL}, "true_count": ${TRUE}, "false_count": ${FALSE} }
EOF
done

curl \
  -H 'Content-Type: application/x-ndjson' \
  -X POST "$ES/_bulk" \
  --data-binary @"$BULK_FILE"

rm -f "$BULK_FILE"
