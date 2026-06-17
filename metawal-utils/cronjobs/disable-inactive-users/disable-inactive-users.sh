#!/usr/bin/env bash
source /home/sites/metawal/sources/cronjobs/database-credentials
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

output=$(PGPASSWORD="$DB_PASSWORD" psql --host="$DB_HOST" --port="$DB_PORT" --username="$DB_USER" --dbname="$DB_NAME"  --file="$SCRIPT_DIR/disable-inactive-users.sql")

rows=$(echo "$output" | grep -o 'UPDATE [0-9]*' | grep -o '[0-9]*' || echo "0")
echo "$(date '+%Y-%m-%d %H:%M:%S') - Disabled inactive users: $rows row(s) affected."
