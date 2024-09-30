#!/bin/bash
# Docker entrypoint script.
# Print environment variables for debugging
echo "Debugging environment variables:"
echo "PGUSER: $PGUSER"
echo "PGPASSWORD: $PGPASSWORD"
echo "PGDATABASE: $PGDATABASE"
echo "PGHOST: $PGHOST"
echo "PGPORT: $PGPORT"
# Wait until Postgres is ready
# while ! pg_isready -q -h $PGHOST -p 5431 -U $PGUSER
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  mix ecto.migrate
  mix run priv/repo/seeds.exs
  echo "Database $PGDATABASE created."
fi

exec mix phx.server
