#!/usr/bin/env bash
# automate.sh – run every mini-task in one go
# Usage: ./automate.sh [BASE_DIR]

set -euo pipefail

BASE_DIR="$(realpath "${1:-$(pwd)}")"
OUT_DIR="$BASE_DIR/automated_output"
mkdir -p "$OUT_DIR"

echo "Working directory : $BASE_DIR"
echo "Output directory  : $OUT_DIR"
echo "──────────────────────────────────────────────────────────"

# 1. Three largest files
find "$BASE_DIR" -type f -printf '%s %p\n' | sort -nr | head -n 3 > "$OUT_DIR/top3.txt"
echo "[1/5] Three largest files:"
cat "$OUT_DIR/top3.txt"

# 2. 404 requests
grep ' 404 ' "$BASE_DIR/logs/web_access.log" > "$OUT_DIR/404_requests.log"
echo "[2/5] 404 lines: $(wc -l < "$OUT_DIR/404_requests.log") saved to 404_requests.log"

# 3. sshd ERROR counts per PID (placeholder format)
grep 'sshd' "$BASE_DIR/logs/syslog.log" | grep 'ERROR' \
 | awk -F'[][]' '{c[$2]++} END {for(p in c) printf "%-3d %s\n", c[p], p}' \
 | sort -nr > "$OUT_DIR/sshd_error_counts.txt"
echo "[3/5] sshd ERROR counts saved to sshd_error_counts.txt"

# 4. Run backup script
echo "[4/5] Running backup.sh …"
bash "$BASE_DIR/scripts/backup.sh" | tee "$OUT_DIR/backup_run.log"

# 5. CSV → SQLite import & city counts
echo "[5/5] Importing CSV into SQLite …"
DB="$OUT_DIR/customers.db"
sqlite3 "$DB" <<SQL
.mode csv
.import '$BASE_DIR/data/customers.csv' customers
.headers on
.output $OUT_DIR/city_counts.csv
SELECT city, COUNT(*) AS num_customers
FROM customers
GROUP BY city
ORDER BY num_customers DESC;
.output stdout
SQL
echo "City counts saved to city_counts.csv:"
cat "$OUT_DIR/city_counts.csv"

echo "──────────────────────────────────────────────────────────"
echo "All tasks complete. Results are in: $OUT_DIR"
