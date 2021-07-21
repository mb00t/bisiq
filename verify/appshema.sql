-- Verify sqitch-postgrest-elm:appshema on pg

BEGIN;

	SELECT pg_catalog.has_schema_privilege('api','usage');

ROLLBACK;
