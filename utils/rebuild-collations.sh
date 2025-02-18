#!/usr/bin/env bash
set -euo pipefail

for db in $(psql -Atc 'select datname from pg_database;' postgres); do
	echo "Updating database ${db}"
	psql -e -c "reindex (verbose) database ${db};" -c "alter database ${db} refresh collation version;" ${db} &
done

wait
