
/*PGR-GNU*****************************************************************
File: multiple_rows.sql

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
DROP FUNCTION IF EXISTS greet_same_cols CASCADE;
DROP FUNCTION IF EXISTS greet_separate_cols CASCADE;
DROP FUNCTION IF EXISTS greet CASCADE;
DROP FUNCTION IF EXISTS greet2 CASCADE;
DROP FUNCTION IF EXISTS multiout_simple_setof CASCADE;
DROP TYPE IF EXISTS greeting CASCADE;

CREATE TYPE greeting AS (
  how text,
  who text
);

CREATE FUNCTION greet_separate_cols (how text)
  RETURNS SETOF greeting
AS $$
  # return tuple containing lists as composite types
  # all other combinations work also
  return ( [ how, "World" ], [ how, "PostgreSQL" ], [ how, "PL/Python" ] )
$$ LANGUAGE plpython3u;

CREATE FUNCTION greet_same_cols (how text)
  RETURNS SETOF text
AS $$
  return ( [ how, "World" ], [ how, "PostgreSQL" ], [ how, "PL/Python" ] )
$$ LANGUAGE plpython3u;

--return variable number of outputs
CREATE FUNCTION greet (how text)
  RETURNS SETOF greeting
AS $$
  for who in [ "World", "PostgreSQL", "PL/Python" ]:
    yield ( how, who )
  for i in range(10):
    yield (how, 'World')
$$ LANGUAGE plpython3u;

-- Not working
CREATE FUNCTION greet2 (how text)
  RETURNS SETOF greeting
AS $$
  class producer:
    def __init__ (self, how, who):
      self.how = how
      self.who = who
      self.ndx = -1

    def __iter__ (self):
      return self

    def next (self):
      self.ndx += 1
      if self.ndx == len(self.who):
        raise StopIteration
      return ( self.how, self.who[self.ndx] )

  return producer(how, [ "World", "PostgreSQL", "PL/Python" ])
$$ LANGUAGE plpython3u;

--returns set of records
--need to figure out how to change column name
CREATE FUNCTION multiout_simple_setof(n integer, OUT integer, OUT integer) 
  RETURNS SETOF record
AS $$
  return [(1, 2)] * n
$$ LANGUAGE plpython3u;
