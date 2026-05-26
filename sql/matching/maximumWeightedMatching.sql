--v4.1

CREATE FUNCTION pgr_maximumWeightedMatching(
    TEXT,   -- edges_sql (required)

    OUT seq BIGINT,
    OUT node_u BIGINT,
    OUT node_v BIGINT,
    OUT weight FLOAT
)

RETURNS SETOF RECORD AS
$BODY$
    SELECT seq, node_u, node_v, weight
    FROM _pgr_maximumWeightedMatching(
        _pgr_get_statement($1)
    );
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST ${COST_HIGH} ROWS ${ROWS_HIGH};


COMMENT ON FUNCTION pgr_maximumWeightedMatching(TEXT)
IS 'pgr_maximumWeightedMatching
- EXPERIMENTAL
- Undirected graph
- Parameters:
  - edges SQL with columns: id, source, target, cost [,reverse_cost]
';
