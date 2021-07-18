-- Deploy sqitch-postgrest-elm:appshema to pg

BEGIN;

	CREATE SCHEMA api;

COMMIT;
