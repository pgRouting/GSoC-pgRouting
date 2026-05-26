--v4.1

CREATE FUNCTION _pgr_maximumWeightedMatching(
    TEXT,   -- edges_sql (required)

    OUT seq BIGINT,
    OUT node_u BIGINT,
    OUT node_v BIGINT,
    OUT weight FLOAT
)

RETURNS SETOF RECORD AS
'MODULE_PATHNAME'
LANGUAGE c IMMUTABLE STRICT;


COMMENT ON FUNCTION _pgr_maximumWeightedMatching(TEXT)
IS 'pgRouting internal function';
