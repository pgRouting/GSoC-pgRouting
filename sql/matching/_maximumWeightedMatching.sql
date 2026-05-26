/*PGR-GNU*****************************************************************
File: _maximumWeightedMatching.sql

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
-- _pgr_maximumWeightedMatching
-------------------------

--v4.1

CREATE FUNCTION _pgr_maximumWeightedMatching(
    TEXT,   -- edges_sql (required)

    OUT seq BIGINT,
    OUT node_u BIGINT,
    OUT node_v BIGINT,
    OUT weight FLOAT
)
RETURNS SETOF RECORD AS
'MODULE_PATHNAME'
LANGUAGE c IMMUTABLE STRICT;

COMMENT ON FUNCTION _pgr_maximumWeightedMatching(TEXT)
IS 'pgRouting internal function';
