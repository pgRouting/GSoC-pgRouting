/*PGR-GNU*****************************************************************

Copyright (c) 2025  pgRouting developers
Mail: project@pgrouting.org

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

-- checks the minimum version version for C++ code
CREATE OR REPLACE FUNCTION min_lib_version(min_version TEXT)
RETURNS BOOLEAN AS
$BODY$
DECLARE val BOOLEAN;
BEGIN
WITH
  current_version AS (SELECT string_to_array(regexp_replace((SELECT library FROM pgr_full_version()), '.*-', '', 'g'),'.')::int[] AS version),
  asked_version AS (SELECT string_to_array(min_version, '.')::int[] AS version)
  SELECT (current_version.version >= asked_version.version) FROM current_version, asked_version INTO val;
  RETURN val;
END;
$BODY$
LANGUAGE plpgsql;

-- checks the minimum version version for SQL code
CREATE OR REPLACE FUNCTION min_version(min_version TEXT)
RETURNS BOOLEAN AS
$BODY$
DECLARE val BOOLEAN;
BEGIN
WITH
  current_version AS (SELECT string_to_array(regexp_replace(pgr_version(), '-.*', '', 'g'),'.')::int[] AS version),
  asked_version AS (SELECT string_to_array(min_version, '.')::int[] AS version)
  SELECT (current_version.version >= asked_version.version) FROM current_version, asked_version INTO val;
  RETURN val;
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION column_missing(TEXT, TEXT)
RETURNS TEXT AS
$BODY$
  SELECT CASE WHEN min_version('3.8.0') THEN
    collect_tap(throws_ok($1, '42703','column "' || $2 || '" does not exist'))
  ELSE
    collect_tap(throws_ok($1, 'P0001', 'Missing column'))
  END;
$BODY$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION wrong_relation(TEXT, TEXT)
RETURNS TEXT AS
$BODY$
  SELECT CASE WHEN min_version('3.8.0') THEN
    collect_tap(throws_ok($1, '42P01', 'relation "' || $2 || '" does not exist'))
  ELSE
    collect_tap(throws_ok($1, 'P0001', 'relation "' || $2 || '" does not exist'))
  END;
$BODY$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION function_types_eq(TEXT, TEXT)
RETURNS TEXT AS
$BODY$
    SELECT set_eq(format($$
      WITH
      a AS (
        SELECT oid, u.name, u.idx
        FROM pg_catalog.pg_proc p CROSS JOIN unnest(coalesce(p.proallargtypes, p.proargtypes))
        WITH ordinality as u(name, idx)
        WHERE p.proname = '%1$s'),
      b AS (
        SELECT a.*, t.typname FROM a JOIN pg_catalog.pg_type As t on (t.oid = a.name))
      SELECT array_agg(typname ORDER BY idx)  FROM b GROUP BY oid
      $$, $1), $2, $1 || ': Function types');
$BODY$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION function_types_has(TEXT, TEXT)
RETURNS TEXT AS
$BODY$
SELECT set_has(format($$
  WITH
  a AS (
    SELECT oid, u.name, u.idx
    FROM pg_catalog.pg_proc p CROSS JOIN unnest(coalesce(p.proallargtypes, p.proargtypes))
    WITH ordinality as u(name, idx)
    WHERE p.proname = '%1$s'),
  b AS (
    SELECT a.*, t.typname FROM a JOIN pg_catalog.pg_type As t on (t.oid = a.name))
  SELECT array_agg(typname ORDER BY idx)  FROM b GROUP BY oid
  $$, $1), $2, $1 || ': Function types');
$BODY$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION function_args_eq(TEXT, TEXT)
RETURNS TEXT AS
$BODY$
    SELECT set_eq(format($$
      SELECT proargnames from pg_catalog.pg_proc where proname = '%1$s'
      $$, $1), $2, $1 || ': Function args names');
$BODY$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION function_args_has(TEXT, TEXT)
RETURNS TEXT AS
$BODY$
    SELECT set_has(format($$
      SELECT proargnames from pg_catalog.pg_proc where proname = '%1$s'
      $$, $1), $2, $1 || ': Function args names');
$BODY$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION function_returns_geom(TEXT)
RETURNS TEXT AS
$BODY$
SELECT set_eq(format($$
  WITH a AS (SELECT prorettype FROM pg_proc WHERE proname = '%1$s')
  SELECT typname from a JOIN pg_type ON(oid = prorettype)$$, $1),
  $$VALUES ('geometry') $$);
$BODY$ LANGUAGE SQL;

CREATE FUNCTION has_total_edges_vertices(tbl TEXT,ne INTEGER, nv INTEGER)
RETURNS SETOF TEXT AS
$BODY$
BEGIN
  CREATE TEMP TABLE tmp_rv ON COMMIT DROP AS
  SELECT id, geom
  FROM pgr_extractVertices($$ SELECT * FROM $$ || $1);

  RETURN QUERY EXECUTE format($$
    SELECT is((SELECT count(*)::INTEGER FROM %1$s),  %2$s, '%1$s has %2$s edges');
    $$, $1, $2);

  RETURN QUERY EXECUTE format($$
    SELECT is((SELECT count(*)::INTEGER FROM tmp_rv),  %2$s, '%1$s has %2$s vertices');
    $$, $1, $3);
END
$BODY$ LANGUAGE plpgsql;
