/*PGR-GNU*****************************************************************
File: _makeBiconnectedPlanar.sql

Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

base: sakirr-2026-face-extraction
compare: week1-face-extraction-demo

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
-------------------------
-------------------------
-- _planarFaces
-------------------------
-------------------------

--v4.1

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
