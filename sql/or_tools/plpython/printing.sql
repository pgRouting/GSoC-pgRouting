/*PGR-GNU*****************************************************************
File: printing.sql

Copyright (c) 2022 GSoC-2022 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Manas Sivakumar

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
DROP TABLE IF EXISTS knapsack_data;
CREATE TABLE knapsack_data(
  weight INTEGER,
  cost INTEGER);

INSERT INTO knapsack_data (weight,  cost)
VALUES
(12, 4),
(2, 2),
(1, 1),
(4, 10),
(1, 2);

DROP FUNCTION IF EXISTS access_table;
CREATE FUNCTION access_table(inner_query text, capacity integer) 
    RETURNS integer
AS $$
    result = plpy.execute(inner_query, 5)
    plpy.log("Hello World")
    plpy.warning("Hello World")
    plpy.warning(result[0]["cost"], result[0]["weight"])
    return capacity
$$ LANGUAGE plpython3u;