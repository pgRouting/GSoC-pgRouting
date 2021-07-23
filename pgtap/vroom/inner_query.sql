BEGIN;

SELECT plan(166);

/*
SELECT * FROM vrp_vroom(
  $$SELECT id, location_index, service, delivery, pickup, skills, priority, time_windows_sql FROM vroom_jobs$$,
  $$SELECT p_id, p_location_index, p_service, p_time_windows_sql, d_id, d_location_index, d_service, d_time_windows_sql, amount, skills, priority FROM vroom_shipments$$,
  $$SELECT id, start_index, end_index, capacity, skills, tw_open, tw_close, breaks_sql FROM vroom_vehicles$$,
  $$SELECT start_vid, end_vid, agg_cost FROM vroom_matrix$$
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


CREATE OR REPLACE FUNCTION inner_query_jobs()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  fn TEXT := 'vrp_vroom';
  inner_query_table TEXT := 'vroom_jobs';
  start_sql TEXT := '';
  rest_sql TEXT := ', $$SELECT * FROM vroom_shipments$$, $$SELECT * FROM vroom_vehicles$$, $$SELECT * FROM vroom_matrix$$)';
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


CREATE OR REPLACE FUNCTION inner_query_shipments()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  fn TEXT := 'vrp_vroom';
  inner_query_table TEXT := 'vroom_shipments';
  start_sql TEXT := '$$SELECT * FROM vroom_jobs$$, ';
  rest_sql TEXT := ', $$SELECT * FROM vroom_vehicles$$, $$SELECT * FROM vroom_matrix$$)';
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


CREATE OR REPLACE FUNCTION inner_query_vehicles()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  fn TEXT := 'vrp_vroom';
  inner_query_table TEXT := 'vroom_vehicles';
  start_sql TEXT := '$$SELECT * FROM vroom_jobs$$, $$SELECT * FROM vroom_shipments$$, ';
  rest_sql TEXT := ', $$SELECT * FROM vroom_matrix$$)';
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


CREATE OR REPLACE FUNCTION inner_query_matrix()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  fn TEXT := 'vrp_vroom';
  inner_query_table TEXT := 'vroom_matrix';
  start_sql TEXT := '$$SELECT * FROM vroom_jobs$$, $$SELECT * FROM vroom_shipments$$, $$SELECT * FROM vroom_vehicles$$, ';
  rest_sql TEXT := ')';
  params TEXT[] := ARRAY['start_vid', 'end_vid', 'agg_cost'];
BEGIN
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'start_vid');
  RETURN QUERY SELECT test_anyInteger(fn, inner_query_table, start_sql, rest_sql, params, 'end_vid');
  RETURN QUERY SELECT test_Integer(fn, inner_query_table, start_sql, rest_sql, params, 'agg_cost');
END;
$BODY$
LANGUAGE plpgsql;


SELECT inner_query_jobs();
SELECT inner_query_shipments();
SELECT inner_query_vehicles();
SELECT inner_query_matrix();

SELECT finish();
ROLLBACK;
