/*PGR-GNU*****************************************************************
File: _planarFaces.sql

Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2026 Sakir Ahmed
Mail: sakirahmed75531 at gmail.com

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
-- _planarFaces
-------------------------

--v4.1

CREATE FUNCTION _pgr_planarFaces(
    TEXT,  -- edges_sql

    OUT face_id BIGINT,
    OUT source BIGINT,
    OUT target BIGINT
)
RETURNS SETOF RECORD AS
$BODY$
    SELECT
        NULL::BIGINT,
        NULL::BIGINT,
        NULL::BIGINT
    WHERE false;
$BODY$
LANGUAGE SQL VOLATILE STRICT;

COMMENT ON FUNCTION _pgr_planarFaces(TEXT)
IS
'_pgr_planarFaces
- Experimental internal planar face traversal helper
- Parameters:
    - Edges SQL with columns: id, source, target, cost [,reverse_cost]
';
