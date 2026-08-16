#!/bin/bash
# Usage: ./load_schema.sh <path_to_sql_schema_folder>

if [ ! -d "$1" ]; then
  echo "Error: '$1' is not a valid directory."
  exit 1
fi

source .env

echo "Loading SQL files from $1 into Supabase..."

for FILE in "$1"/*.sql; do
  if [ -f "$FILE" ]; then
    echo " -> Loading $FILE..."
    cat "$FILE" | docker compose exec -T -e PGPASSWORD="$POSTGRES_PASSWORD" db psql -U supabase_admin -h localhost -d "$POSTGRES_DB"
  fi
done

echo "Done! All schemas loaded successfully."