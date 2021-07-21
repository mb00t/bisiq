-- Revert sqitch-postgrest-elm:roles_authenticator from pg

BEGIN;

	REVOKE web_anon FROM authenticator;
	DROP ROLE authenticator;

COMMIT;
