#!/bin/bash
source .env

DUMP_DIR="${DUMP_DIRECTORY:-schema_dumps}"

mkdir -p "$DUMP_DIR"

SCHEMAS="public"

for SCHEMA in $SCHEMAS; do
    echo "Exporting schema: $SCHEMA"
    docker compose exec -T -e PGPASSWORD="$POSTGRES_PASSWORD" db pg_dump -U postgres -h localhost -d "$POSTGRES_DB" --schema-only --clean --no-owner --no-privileges -n "$SCHEMA" > "$DUMP_DIR/$SCHEMA.sql"
done

echo "All schemas dumped successfully in $DUMP_DIR directory."

chown -R $SUDO_USER:$SUDO_USER "$DUMP_DIR"
chmod -R 755 "$DUMP_DIR"

echo "Directory permissions and ownership set to $SUDO_USER:$SUDO_USER with 755." 


