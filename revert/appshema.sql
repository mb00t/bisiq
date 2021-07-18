-- Revert sqitch-postgrest-elm:appshema from pg

BEGIN;

	DROP SCHEMA api;

COMMIT;
