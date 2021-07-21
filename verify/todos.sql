-- Verify sqitch-postgrest-elm:todos on pg

BEGIN;

	SELECT task 
  	  FROM api.todos
	WHERE FALSE;

ROLLBACK;
