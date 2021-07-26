-- Deploy sqitch-postgrest-elm:astercdr to pg
-- requires: appshema
BEGIN;

CREATE TABLE api.astercdr (
    accountcode TEXT,
    src TEXT,
    dst TEXT,
    dcontext TEXT,
    clid TEXT,
    channel TEXT,
    dstchannel TEXT,
    lastapp TEXT,
    lastdata TEXT,
    tstart TIMESTAMPTZ,
    answer TIMESTAMPTZ,
    tend TIMESTAMPTZ,
    duration TEXT,
    bilsec TEXT,
    dispisition TEXT,
    amaflags TEXT,
    data17 TEXT
);

GRANT SELECT ON api.astercdr TO web_anon;

COMMIT;

