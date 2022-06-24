/*PGR-GNU*****************************************************************
File: cuthillMckeeOrdering.sql

Generated with Template by:
Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2022 Shobhit Chaurasia
Mail: 000shobhitchaurasia at gmail.com

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

----------------------------
-- pgr_cuthillMckeeOrdering
----------------------------

CREATE FUNCTION pgr_cuthillMckeeOrdering(
    TEXT, -- edges_sql (required)

    s_vertex INTEGER,
    OUT r_cuthillMckeeOrdering BIGINT[],
    OUT orig_bandwidth BIGINT,
    OUT new_bandwidth BIGINT)

RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT *
    FROM _pgr_cuthillMckeeOrdering(_pgr_get_statement($1));
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT;

-- COMMENTS

COMMENT ON FUNCTION pgr_cuthillMckeeOrdering(TEXT)
IS 'pgr_cuthillMckeeOrdering
- EXPERIMENTAL
- Parameters:
    - Edges SQL with columns: id, source, target, cost [,reverse_cost]
- Documentation:
    - ${PROJECT_DOC_LINK}/pgr_cuthillMckeeOrdering.html
';