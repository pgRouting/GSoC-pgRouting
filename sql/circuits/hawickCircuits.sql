/*PGR-GNU*****************************************************************
File: hawickCircuits.sql

Generated with Template by:
Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2022 Nitish Chauhan
Mail: nitishchauhan0022 at gmail.com

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
---------------
-- pgr_hawickCircuits
---------------

CREATE FUNCTION pgr_hawickCircuits(
    TEXT, -- edges_sql (required)

    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT circuits BIGINT[])
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT *
    FROM _pgr_hawickCircuits(_pgr_get_statement($1));
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT;

CREATE FUNCTION pgr_hawickCircuits_Unique(
    TEXT, -- edges_sql (required)

    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT circuits BIGINT[])
RETURNS SETOF RECORD AS
$BODY$
BEGIN
    RETURN QUERY
    SELECT *
    FROM _pgr_hawickCircuits_Unique(_pgr_get_statement($1));
END;
$BODY$
LANGUAGE plpgsql VOLATILE STRICT;

-- COMMENTS

COMMENT ON FUNCTION pgr_hawickCircuits(TEXT, BOOLEAN)
IS 'pgr_hawickCircuits
- EXPERIMENTAL
- Parameters:
    - Edges SQL with columns: id, source, target, cost [,reverse_cost]
- Optional Parameters
   - directed := true
- Documentation:
    - ${PROJECT_DOC_LINK}/pgr_hawickCircuits.html
';


COMMENT ON FUNCTION pgr_hawickCircuits_Unique(TEXT, BOOLEAN)
IS 'pgr_hawickCircuits_unique
- EXPERIMENTAL
- Parameters:
    - Edges SQL with columns: id, source, target, cost [,reverse_cost]
- Optional Parameters
   - directed := true
- Documentation:
    - ${PROJECT_DOC_LINK}/pgr_hawickCircuits.html
';