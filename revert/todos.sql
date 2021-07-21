-- Revert sqitch-postgrest-elm:todos from pg

BEGIN;

	DROP TABLE api.todos;

COMMIT;
