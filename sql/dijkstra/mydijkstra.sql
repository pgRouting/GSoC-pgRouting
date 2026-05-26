/*PGR-GNU*****************************************************************
File: mydijkstra.sql

Copyright (c) 2026-2026 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2026 Celia Virginia Vergara Castillo
Mail: vicky at erosion.dev

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

-- ONE to ONE
--v4.1
CREATE FUNCTION pgr_mydijkstra(
    TEXT,   -- edges_sql (required)
    BIGINT, -- start_vid (required)
    BIGINT, -- end_vid (required)

    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT path_seq INTEGER,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
    FROM _pgr_mydijkstra(_pgr_get_statement($1), ARRAY[$2]::BIGINT[], ARRAY[$3]::BIGINT[],
        $4, false, true, 0, false);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST ${COST_HIGH} ROWS ${ROWS_HIGH};

-- ONE TO MANY
--v3.0
CREATE FUNCTION pgr_mydijkstra(
    TEXT,     -- edges_sql (required)
    BIGINT,   -- start_vid (required)
    ANYARRAY, -- end_vid (required)

    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT path_seq INTEGER,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
    FROM _pgr_mydijkstra(_pgr_get_statement($1), ARRAY[$2]::BIGINT[], $3::BIGINT[],
       $4, false, true, 0, false);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST ${COST_HIGH} ROWS ${ROWS_HIGH};

-- MANY TO ONE
--v3.0
CREATE FUNCTION pgr_mydijkstra(
    TEXT,     -- edges_sql (required)
    ANYARRAY, -- start_vid (required)
    BIGINT,   -- end_vid (required)

    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT path_seq INTEGER,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
    FROM _pgr_mydijkstra(_pgr_get_statement($1), $2::BIGINT[], ARRAY[$3]::BIGINT[],
$4, false, false, 0, false);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST ${COST_HIGH} ROWS ${ROWS_HIGH};

-- MANY TO MANY
--v3.0
CREATE FUNCTION pgr_mydijkstra(
    TEXT,     -- edges_sql (required)
    ANYARRAY, -- start_vid (required)
    ANYARRAY, -- end_vid (required)

    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT path_seq INTEGER,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
    FROM _pgr_mydijkstra(_pgr_get_statement($1), $2::BIGINT[], $3::BIGINT[],
      $4, false, true, 0, false);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST ${COST_HIGH} ROWS ${ROWS_HIGH};

-- Combinations SQL signature
--v3.1
CREATE FUNCTION pgr_mydijkstra(
    TEXT,     -- edges_sql (required)
    TEXT,     -- combinations_sql (required)

    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT path_seq INTEGER,
    OUT start_vid BIGINT,
    OUT end_vid BIGINT,
    OUT node BIGINT,
    OUT edge BIGINT,
    OUT cost FLOAT,
    OUT agg_cost FLOAT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT seq, path_seq, start_vid, end_vid, node, edge, cost, agg_cost
    FROM _pgr_mydijkstra(_pgr_get_statement($1), _pgr_get_statement($2),
      $3, false, 0, false);
$BODY$
LANGUAGE SQL VOLATILE STRICT
COST ${COST_HIGH} ROWS ${ROWS_HIGH};



COMMENT ON FUNCTION pgr_mydijkstra(TEXT, BIGINT, BIGINT, BOOLEAN)
IS 'pgr_mydijkstra(One to One)
- Parameters:
   - Edges SQL with columns: id, source, target, cost [,reverse_cost]
   - From vertex identifier
   - To vertex identifier
- Optional Parameters
   - directed := true
- Documentation:
   - ${PROJECT_DOC_LINK}/pgr_mydijkstra.html
';

COMMENT ON FUNCTION pgr_mydijkstra(TEXT, BIGINT, ANYARRAY, BOOLEAN)
IS 'pgr_mydijkstra(One to Many)
- Parameters:
   - Edges SQL with columns: id, source, target, cost [,reverse_cost]
   - From vertex identifier
   - To ARRAY[vertices identifiers]
- Optional Parameters
   - directed := true
- Documentation:
   - ${PROJECT_DOC_LINK}/pgr_mydijkstra.html
';

COMMENT ON FUNCTION pgr_mydijkstra(TEXT, ANYARRAY, BIGINT, BOOLEAN)
IS 'pgr_mydijkstra(Many to One)
- Parameters:
   - Edges SQL with columns: id, source, target, cost [,reverse_cost]
   - From ARRAY[vertices identifiers]
   - To vertex identifier
- Optional Parameters
   - directed := true
- Documentation:
   - ${PROJECT_DOC_LINK}/pgr_mydijkstra.html
';

COMMENT ON FUNCTION pgr_mydijkstra(TEXT, ANYARRAY, ANYARRAY, BOOLEAN)
IS 'pgr_mydijkstra(Many to Many)
- Parameters:
   - Edges SQL with columns: id, source, target, cost [,reverse_cost]
   - From ARRAY[vertices identifiers]
   - To ARRAY[vertices identifiers]
- Optional Parameters
   - directed := true
- Documentation:
   - ${PROJECT_DOC_LINK}/pgr_mydijkstra.html
';

COMMENT ON FUNCTION pgr_mydijkstra(TEXT, TEXT, BOOLEAN)
IS 'pgr_mydijkstra(Combinations)
- Parameters:
   - Edges SQL with columns: id, source, target, cost [,reverse_cost]
   - Combinations SQL with columns: source, target
- Optional Parameters
   - directed := true
- Documentation:
   - ${PROJECT_DOC_LINK}/pgr_mydijkstra.html
';
