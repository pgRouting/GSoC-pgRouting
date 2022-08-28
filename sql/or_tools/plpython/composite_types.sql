/*PGR-GNU*****************************************************************
File: composite_types.sql

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
DROP FUNCTION IF EXISTS overpaid CASCADE;
DROP FUNCTION IF EXISTS make_pair CASCADE;
DROP FUNCTION IF EXISTS make_pair1 CASCADE;
DROP FUNCTION IF EXISTS make_pair0 CASCADE;
DROP FUNCTION IF EXISTS make_pair_dict CASCADE;
DROP FUNCTION IF EXISTS multiout_simple CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TYPE IF EXISTS named_value CASCADE;
DROP PROCEDURE IF EXISTS python_triple CASCADE;
DROP TYPE IF EXISTS employees CASCADE;


CREATE TABLE employee (
  name text,
  salary integer,
  age integer
);

CREATE TYPE named_value AS (
  name   text,
  value  integer
);

-- Input is a composite type
CREATE FUNCTION overpaid (e employee)
  RETURNS boolean
AS $$
  if e["salary"] > 200000:
    return True
  if (e["age"] < 30) and (e["salary"] > 100000):
    return True
  return False
$$ LANGUAGE plpython3u;

--output is a composite type
CREATE FUNCTION make_pair0 (name text, value integer)
  RETURNS named_value[]
AS $$
  return (( name, value ), (name, value))
  # or alternatively, as list: return [ name, value ]
$$ LANGUAGE plpython3u;

CREATE FUNCTION make_pair_dict (name text, value integer)
  RETURNS named_value
AS $$
  return { "name": name, "value": value }
$$ LANGUAGE plpython3u;

-- Returns the result in one line

CREATE FUNCTION multiout_simple(OUT i integer, OUT j integer) 
AS $$
    return (1, 2)
$$ LANGUAGE plpython3u;


CREATE PROCEDURE python_triple(INOUT a integer, INOUT b integer) 
AS $$
    return (a * 3, b * 3)
$$ LANGUAGE plpython3u;

-- CALL python_triple(5, 10);

CREATE TYPE employees AS (
  name   text,
  salary  integer
);

CREATE FUNCTION make_pair1 (person employees)
  RETURNS setof employees
AS $$
  return person, person
  # or alternatively, as list: return [ name, value ]
$$ LANGUAGE plpython3u;

CREATE FUNCTION make_pair3 (name text, value integer)
  RETURNS named_value
AS $$
  class named_value:
    def __init__ (self, n, v):
      self.name = n
      self.value = v
  return named_value(name, value)
$$ LANGUAGE plpython3u;