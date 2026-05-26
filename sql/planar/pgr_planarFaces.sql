/*PGR-GNU*****************************************************************

FILE: pgr_planarFaces.sql

********************************************************************PGR-GNU*/

--v4.0

CREATE FUNCTION pgr_planarFaces(
    TEXT, -- edges_sql

    directed BOOLEAN DEFAULT false,
    include_outer_face BOOLEAN DEFAULT false,

    OUT face_id BIGINT,
    OUT seq INTEGER,
    OUT edge_id BIGINT,
    OUT node_id BIGINT,
    OUT is_planar BOOLEAN
)
RETURNS SETOF RECORD AS
$BODY$
    SELECT
        NULL::BIGINT,
        NULL::INTEGER,
        NULL::BIGINT,
        NULL::BIGINT,
        NULL::BOOLEAN
    WHERE false;
$BODY$
LANGUAGE SQL VOLATILE STRICT;

COMMENT ON FUNCTION pgr_planarFaces(TEXT, BOOLEAN, BOOLEAN)
IS
'pgr_planarFaces
 - Experimental SQL skeleton for planar face traversal
 - Parameters:
    - Edges SQL with columns: id, source, target, cost [,reverse_cost]
    - directed := false
    - include_outer_face := false
';
