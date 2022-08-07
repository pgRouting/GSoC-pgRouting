
/*PGR-GNU*****************************************************************
File: example.sql

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
DROP FUNCTION IF EXISTS pyadd;
DROP FUNCTION IF EXISTS pystrip;
DROP FUNCTION IF EXISTS return_arr;
DROP FUNCTION IF EXISTS md_array;
DROP FUNCTION IF EXISTS return_str_arr;
DROP FUNCTION IF EXISTS return_str;

-- function that adds two numbers
CREATE FUNCTION pyadd (a integer, b integer)
  RETURNS integer
AS $$
  if (a is None) or (b is None):
    return None
  x = a+b
  return x
$$ LANGUAGE plpython3u;

-- The input parameters should be treated as read only
CREATE FUNCTION pystrip(x text)
  RETURNS text
AS $$
  global x
  x = x.strip() 
  return x
$$ LANGUAGE plpython3u;

CREATE FUNCTION return_arr()
  RETURNS int[]
AS $$
    return [1, 2, 3, 4, 5]
$$ LANGUAGE plpython3u;

CREATE FUNCTION md_array(x int4[]) 
    RETURNS int4[] 
AS $$
    plpy.info(x, type(x))
    return x
$$ LANGUAGE plpython3u;

CREATE FUNCTION return_str()
  RETURNS text
AS $$
    return "hello"
$$ LANGUAGE plpython3u;

CREATE FUNCTION return_str_arr()
  RETURNS varchar[]
AS $$
    return "hello"
$$ LANGUAGE plpython3u;