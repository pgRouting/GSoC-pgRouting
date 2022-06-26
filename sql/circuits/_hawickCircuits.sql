/*PGR-GNU*****************************************************************
File: _hawickCircuits.sql

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
-- _pgr_hawickCircuits
---------------

CREATE FUNCTION _pgr_hawickCircuits(
    edges_sql TEXT,
    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT circuits BIGINT[])

RETURNS SETOF RECORD AS
'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

CREATE FUNCTION _pgr_hawickCircuits_Unique(
    edges_sql TEXT,
    directed BOOLEAN DEFAULT true,

    OUT seq INTEGER,
    OUT circuits BIGINT[])

RETURNS SETOF RECORD AS
'MODULE_PATHNAME'
LANGUAGE C IMMUTABLE STRICT;

-- COMMENTS

COMMENT ON FUNCTION _pgr_hawickCircuits(TEXT, BOOLEAN)
IS 'pgRouting internal function';

COMMENT ON FUNCTION _pgr_hawickCircuits_Unique(TEXT, BOOLEAN)
IS 'pgRouting internal function';