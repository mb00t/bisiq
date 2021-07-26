-- Revert sqitch-postgrest-elm:astercdr from pg

BEGIN;

DROP TABLE api.astercdr;

COMMIT;

