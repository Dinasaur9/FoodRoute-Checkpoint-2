#!/bin/sh
# Builds a throwaway test DB from Dina's files (plus the FoodBank stub) and runs
# the statements the same way graders will:  sqlite3 <db>  then  .read <script>
set -e
cd "$(dirname "$0")"
DB=test-dina.sqlite3
rm -f "$DB"
sqlite3 -bail "$DB" ".read test_stub_foodbank.sql" ".read schema_dina.sql" ".read seed_dina.sql"
printf '.read queries_dina.sql\n' | sqlite3 "$DB"
