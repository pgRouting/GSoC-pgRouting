/*PGR-GNU*****************************************************************
File: knapsack_0-1.sql

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2022 Manas Sivakumar


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


CREATE OR REPLACE FUNCTION vrp_knapsack(
  TEXT, -- weights_values SQL
  
  INTEGER, -- bin capacity

  OUT total_value INTEGER,
  OUT total_weight INTEGER,
  OUT packed_items INTEGER[],
  OUT packed_weights INTEGER[]
)
RETURNS SETOF RECORD AS
$BODY$
    SELECT *
    FROM vrp_knapsack(_pgr_get_statement($1), $2);
$BODY$
LANGUAGE SQL VOLATILE STRICT;

-- COMMENTS

COMMENT ON FUNCTION vrp_knapsack(TEXT, INTEGER)
IS 'vrp_knapsack';