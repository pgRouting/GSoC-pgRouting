/*PGR-GNU*****************************************************************

File: planarFaces.sql

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
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

--v4.0.0
CREATE FUNCTION pgr_planarFaces(
    TEXT, -- edges_sql (required)
    OUT seq BIGINT,
    OUT face_id BIGINT,
    OUT edge BIGINT)
RETURNS SETOF RECORD AS
$BODY$
    SELECT seq, face_id, edge
    FROM _pgr_planarFaces(_pgr_get_statement($1));
$BODY$
LANGUAGE SQL VOLATILE STRICT;

COMMENT ON FUNCTION pgr_planarFaces(TEXT)
IS 'pgr_planarFaces
- EXPERIMENTAL
- Parameters:
  - Edges SQL with columns: id, source, target, cost [,reverse_cost]
- Documentation:
  - ${PROJECT_DOC_LINK}/pgr_planarFaces.html
';
