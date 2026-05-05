#!/usr/bin/env bash
set -euo pipefail

ES="http://localhost:9200"
AUTH=""
SRC="gn-records"

WEEK_ID=$(TZ="Europe/Brussels" date -d "today 00:00 last monday" +"%Y%m%d")
SNAP_TS_UTC=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
#WEEK_ID=$(TZ="Europe/Brussels" date -d "last monday -7 days 00:00" +"%Y%m%d")
#SNAP_TS_UTC=$(date -u -d "-7 days" +"%Y-%m-%dT%H:%M:%SZ")

RESP=$(curl  -H 'Content-Type: application/json' \
  -X POST "$ES/${SRC}/_search/template" \
  -d '{"id":"open_data_weekly_counts"}')

TRUE=$(echo "$RESP" | jq '.aggregations.true_values.doc_count')
FALSE=$(echo "$RESP" | jq '.aggregations.false_values.doc_count')
TOTAL=$((TRUE + FALSE))

curl  -H 'Content-Type: application/json' \
  -X PUT "$ES/weekly_open_data_snapshot/_doc/open_data_snapshot_${WEEK_ID}" \
  -d "{
    \"snapshot_timestamp\": \"${SNAP_TS_UTC}\",
    \"true_count\": ${TRUE},
    \"false_count\": ${FALSE},
    \"total\": ${TOTAL}
  }"
