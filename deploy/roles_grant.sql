-- Deploy sqitch-postgrest-elm:roles_grant to pg
-- requires: appshema

BEGIN;

	CREATE ROLE web_anon nologin;

	GRANT USAGE ON SCHEMA api TO web_anon;
	GRANT SELECT ON api.todos to web_anon;

COMMIT;
