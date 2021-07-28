BEGIN;
SET search_path TO 'vroom', 'public';

SELECT CASE WHEN min_version('0.2.0') THEN plan (399) ELSE plan(1) END;

/*
SELECT * FROM vrp_vroom(
  $$SELECT id, location_index, service, delivery, pickup, skills, priority, time_windows_sql FROM jobs$$,
  $$SELECT p_id, p_location_index, p_service, p_time_windows_sql, d_id, d_location_index, d_service, d_time_windows_sql, amount, skills, priority FROM shipments$$,
  $$SELECT id, start_index, end_index, capacity, skills, tw_open, tw_close, breaks_sql FROM vehicles$$,
  $$SELECT start_vid, end_vid, agg_cost FROM matrix$$
)
*/

CREATE OR REPLACE FUNCTION test_value(fn TEXT, inner_query_table TEXT, start_sql TEXT, rest_sql TEXT, params TEXT[], parameter TEXT, accept TEXT[], reject TEXT[])
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  end_sql TEXT;
  query TEXT;
  p TEXT;
  type_name TEXT;
BEGIN
  start_sql = 'SELECT * FROM ' || fn || '(' || start_sql || '$$ SELECT ';
  FOREACH p IN ARRAY params
  LOOP
    IF p = parameter THEN CONTINUE;
    END IF;
    start_sql = start_sql || p || ', ';
  END LOOP;
  end_sql = ' FROM ' || inner_query_table || '$$' || rest_sql;

  FOREACH type_name IN ARRAY accept
  LOOP
    query := start_sql || parameter || '::' || type_name || end_sql;
    RETURN query SELECT lives_ok(query);
  END LOOP;

  FOREACH type_name IN ARRAY reject
  LOOP
    query := start_sql || parameter || '::' || type_name || end_sql;
    RETURN query SELECT throws_ok(query);
  END LOOP;
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION test_anyInteger(fn TEXT, inner_query_table TEXT, start_sql TEXT, rest_sql TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  accept TEXT[] := ARRAY['SMALLINT', 'INTEGER', 'BIGINT'];
  reject TEXT[] := ARRAY['REAL', 'FLOAT8', 'NUMERIC'];
BEGIN
  RETURN query SELECT test_value(fn, inner_query_table, start_sql, rest_sql, params, parameter, accept, reject);
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION test_Integer(fn TEXT, inner_query_table TEXT, start_sql TEXT, rest_sql TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  accept TEXT[] := ARRAY['SMALLINT', 'INTEGER'];
  reject TEXT[] := ARRAY['BIGINT', 'REAL', 'FLOAT8', 'NUMERIC'];
BEGIN
  RETURN query SELECT test_value(fn, inner_query_table, start_sql, rest_sql, params, parameter, accept, reject);
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION test_anyArrayInteger(fn TEXT, inner_query_table TEXT, start_sql TEXT, rest_sql TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  accept TEXT[] := ARRAY['SMALLINT[]', 'INTEGER[]', 'BIGINT[]'];
  reject TEXT[] := ARRAY['REAL[]', 'FLOAT8[]', 'NUMERIC[]'];
BEGIN
  RETURN query SELECT test_value(fn, inner_query_table, start_sql, rest_sql, params, parameter, accept, reject);
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION test_arrayInteger(fn TEXT, inner_query_table TEXT, start_sql TEXT, rest_sql TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  accept TEXT[] := ARRAY['SMALLINT[]', 'INTEGER[]'];
  reject TEXT[] := ARRAY['BIGINT[]', 'REAL[]', 'FLOAT8[]', 'NUMERIC[]'];
BEGIN
  RETURN query SELECT test_value(fn, inner_query_table, start_sql, rest_sql, params, parameter, accept, reject);
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION test_anyNumerical(fn TEXT, inner_query_table TEXT, start_sql TEXT, rest_sql TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  accept TEXT[] := ARRAY['SMALLINT', 'INTEGER', 'BIGINT', 'REAL', 'FLOAT8', 'NUMERIC'];
  reject TEXT[] := ARRAY[]::TEXT[];
BEGIN
  RETURN query SELECT test_value(fn, inner_query_table, start_sql, rest_sql, params, parameter, accept, reject);
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION test_Text(fn TEXT, inner_query_table TEXT, start_sql TEXT, rest_sql TEXT, params TEXT[], parameter TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  accept TEXT[] := ARRAY['TEXT'];
  reject TEXT[] := ARRAY[]::TEXT[];
BEGIN
  RETURN query SELECT test_value(fn, inner_query_table, start_sql, rest_sql, params, parameter, accept, reject);
END;
$BODY$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inner_query_jobs(fn TEXT, start_sql TEXT, rest_sql TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  inner_query_table TEXT := 'jobs';
  params TEXT[] := ARRAY['id', 'location_index', 'service', 'delivery', 'pickup', 'skills', 'priority', 'time_windows_sql'];
BEGIN
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'id');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'location_index');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'service');
  RETURN QUERY SELECT test_anyArrayInteger(fn, inner_query_table, start_sql, rest_sql, params, 'delivery');
  RETURN QUERY SELECT test_anyArrayInteger(fn, inner_query_table, start_sql, rest_sql, params, 'pickup');
  RETURN QUERY SELECT test_arrayInteger(fn, inner_query_table, start_sql, rest_sql, params, 'skills');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'priority');
  RETURN QUERY SELECT test_Text(fn, inner_query_table, start_sql, rest_sql, params, 'time_windows_sql');
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inner_query_shipments(fn TEXT, start_sql TEXT, rest_sql TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  inner_query_table TEXT := 'shipments';
  params TEXT[] := ARRAY['p_id', 'p_location_index', 'p_service', 'p_time_windows_sql', 'd_id', 'd_location_index', 'd_service', 'd_time_windows_sql', 'amount', 'skills', 'priority'];
BEGIN
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'p_id');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'd_id');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'p_location_index');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'd_location_index');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'p_service');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'd_service');
  RETURN QUERY SELECT test_Text(fn, inner_query_table, start_sql, rest_sql, params, 'p_time_windows_sql');
  RETURN QUERY SELECT test_Text(fn, inner_query_table, start_sql, rest_sql, params, 'd_time_windows_sql');
  RETURN QUERY SELECT test_anyArrayInteger(fn, inner_query_table, start_sql, rest_sql, params, 'amount');
  RETURN QUERY SELECT test_arrayInteger(fn, inner_query_table, start_sql, rest_sql, params, 'skills');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'priority');
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inner_query_vehicles(fn TEXT, start_sql TEXT, rest_sql TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  inner_query_table TEXT := 'vehicles';
  params TEXT[] := ARRAY['id', 'start_index', 'end_index', 'capacity', 'skills', 'tw_open', 'tw_close', 'breaks_sql', 'speed_factor'];
BEGIN
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'id');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'start_index');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'end_index');
  RETURN QUERY SELECT test_anyArrayInteger(fn, inner_query_table, start_sql, rest_sql, params, 'capacity');
  RETURN QUERY SELECT test_arrayInteger(fn, inner_query_table, start_sql, rest_sql, params, 'skills');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'tw_open');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'tw_close');
  RETURN QUERY SELECT test_Text(fn, inner_query_table, start_sql, rest_sql, params, 'breaks_sql');
  RETURN QUERY SELECT test_anyNumerical(fn, inner_query_table, start_sql, rest_sql, params, 'speed_factor');
END;
$BODY$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION inner_query_matrix(fn TEXT, start_sql TEXT, rest_sql TEXT)
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  inner_query_table TEXT := 'matrix';
  params TEXT[] := ARRAY['start_vid', 'end_vid', 'agg_cost'];
BEGIN
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'start_vid');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'end_vid');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'agg_cost');
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION inner_query()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  fn TEXT;
  start_sql TEXT;
  rest_sql TEXT;
BEGIN

  IF NOT min_version('0.2.0') THEN
    RETURN QUERY
    SELECT skip(1, 'Function is new on 0.2.0');
    RETURN;
  END IF;

  -- vrp_vroom

  fn := 'vrp_vroom';
  start_sql := '';
  rest_sql := ', $$SELECT * FROM shipments$$, $$SELECT * FROM vehicles$$, $$SELECT * FROM matrix$$)';
  RETURN QUERY SELECT inner_query_jobs(fn, start_sql, rest_sql);

  start_sql := '$$SELECT * FROM jobs$$, ';
  rest_sql := ', $$SELECT * FROM vehicles$$, $$SELECT * FROM matrix$$)';
  RETURN QUERY SELECT inner_query_shipments(fn, start_sql, rest_sql);

  start_sql := '$$SELECT * FROM jobs$$, $$SELECT * FROM shipments$$, ';
  rest_sql := ', $$SELECT * FROM matrix$$)';
  RETURN QUERY SELECT inner_query_vehicles(fn, start_sql, rest_sql);

  start_sql := '$$SELECT * FROM jobs$$, $$SELECT * FROM shipments$$, $$SELECT * FROM vehicles$$, ';
  rest_sql := ')';
  RETURN QUERY SELECT inner_query_matrix(fn, start_sql, rest_sql);


  -- vrp_vroomJobs

  fn := 'vrp_vroomJobs';
  start_sql := '';
  rest_sql := ', $$SELECT * FROM vehicles$$, $$SELECT * FROM matrix$$)';
  RETURN QUERY SELECT inner_query_jobs(fn, start_sql, rest_sql);

  start_sql := '$$SELECT * FROM jobs$$, ';
  rest_sql := ', $$SELECT * FROM matrix$$)';
  RETURN QUERY SELECT inner_query_vehicles(fn, start_sql, rest_sql);

  start_sql := '$$SELECT * FROM jobs$$, $$SELECT * FROM vehicles$$, ';
  rest_sql := ')';
  RETURN QUERY SELECT inner_query_matrix(fn, start_sql, rest_sql);


  -- vrp_vroomShipments

  fn := 'vrp_vroomShipments';
  start_sql := '';
  rest_sql := ', $$SELECT * FROM vehicles$$, $$SELECT * FROM matrix$$)';
  RETURN QUERY SELECT inner_query_shipments(fn, start_sql, rest_sql);

  start_sql := '$$SELECT * FROM shipments$$, ';
  rest_sql := ', $$SELECT * FROM matrix$$)';
  RETURN QUERY SELECT inner_query_vehicles(fn, start_sql, rest_sql);

  start_sql := '$$SELECT * FROM shipments$$, $$SELECT * FROM vehicles$$, ';
  rest_sql := ')';
  RETURN QUERY SELECT inner_query_matrix(fn, start_sql, rest_sql);
END;
$BODY$
LANGUAGE plpgsql;


SELECT inner_query();

SELECT * FROM finish();
ROLLBACK;
