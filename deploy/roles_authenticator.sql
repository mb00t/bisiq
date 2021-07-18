-- Deploy sqitch-postgrest-elm:roles_authenticator to pg
-- requires: appshema

BEGIN;

	CREATE ROLE authenticator noinherit login password 'postgres';
	GRANT web_anon TO authenticator;

COMMIT;
