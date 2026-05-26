k/*PGR-GNU*****************************************************************
File: maximumWeightedMatching.sql

Copyright (c) 2007-2026 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2026 Mayur Galhate
Mail: galhatemayur@gmail.com

------
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License for more details.
********************************************************************PGR-GNU*/

-------------------------
-- pgr_maximumWeightedMatching
-------------------------

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
