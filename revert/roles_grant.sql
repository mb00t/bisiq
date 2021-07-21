-- Revert sqitch-postgrest-elm:roles_grant from pg

BEGIN;
	
	REVOKE SELECT ON api.todos  FROM web_anon;
	REVOKE USAGE ON SCHEMA api FROM web_anon;
	DROP ROLE web_anon ;

COMMIT;
