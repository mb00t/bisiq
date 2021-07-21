-- Deploy sqitch-postgrest-elm:todos to pg
-- requires: appshema

BEGIN;

	CREATE TABLE api.todos (
		id SERIAL PRIMARY KEY,
		done BOOLEAN not NULL DEFAULT FALSE,
		task TEXT NOT NULL,
		due TIMESTAMPTZ
	);

COMMIT;
