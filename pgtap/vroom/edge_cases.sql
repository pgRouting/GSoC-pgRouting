BEGIN;
SET search_path TO 'vroom', 'public';

SELECT CASE WHEN min_version('0.2.0') THEN plan (14) ELSE plan(1) END;

CREATE OR REPLACE FUNCTION edge_cases()
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

  PREPARE jobs AS SELECT * FROM jobs;
  PREPARE empty_jobs AS SELECT * FROM jobs WHERE id = -1;

  PREPARE shipments AS SELECT * FROM shipments;
  PREPARE empty_shipments AS SELECT * FROM shipments WHERE id = -1;

  PREPARE vehicles AS SELECT * FROM vehicles;
  PREPARE empty_vehicles AS SELECT * FROM vehicles WHERE id = -1;

  PREPARE matrix AS SELECT * FROM matrix;
  PREPARE empty_matrix AS SELECT * FROM matrix WHERE start_vid = -1;

  PREPARE vroom_sql AS SELECT * FROM vrp_vroom('jobs', 'shipments', 'vehicles', 'matrix');


  -- tests for no jobs/shipments, no vehicles, or no matrix

  PREPARE no_jobs_and_shipments AS
  SELECT * FROM vrp_vroom(
    'empty_jobs',
    'empty_shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT is_empty('no_jobs_and_shipments', 'Problem with no jobs and shipments');

  PREPARE no_vehicles AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'shipments',
    'empty_vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT is_empty('no_vehicles', 'Problem with no vehicles');

  PREPARE no_matrix AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'shipments',
    'vehicles',
    'empty_matrix'
  );
  RETURN QUERY
  SELECT throws_ok(
    'no_matrix',
    'XX000',
    'An Infinity value was found on the Matrix. Might be missing information of a node',
    'Problem with no cost matrix'
  );


  -- priority range test (jobs)

  PREPARE jobs_neg_priority AS
  SELECT * FROM vrp_vroom(
    'SELECT id, location_index, service, delivery, pickup, skills, -1 AS priority, time_windows_sql FROM jobs',
    'shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT throws_ok(
    'jobs_neg_priority',
    'XX000',
    'Unexpected Negative value in column priority',
    'Problem with negative priority jobs'
  );

  PREPARE jobs_101_priority AS
  SELECT * FROM vrp_vroom(
    'SELECT id, location_index, service, delivery, pickup, skills, 101 AS priority, time_windows_sql FROM jobs',
    'shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT throws_ok(
    'jobs_101_priority',
    'XX000',
    'Priority exceeds the max priority 100',
    'Problem with > 100 priority jobs'
  );

  PREPARE jobs_zero_priority AS
  SELECT * FROM vrp_vroom(
    'SELECT id, location_index, service, delivery, pickup, skills, 0 AS priority, time_windows_sql FROM jobs',
    'shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT lives_ok('jobs_zero_priority', 'Problem with 0 priority jobs');

  PREPARE jobs_100_priority AS
  SELECT * FROM vrp_vroom(
    'SELECT id, location_index, service, delivery, pickup, skills, 0 AS priority, time_windows_sql FROM jobs',
    'shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT lives_ok('jobs_100_priority', 'Problem with 100 priority jobs');


  -- priority range tests (shipments)

  PREPARE shipments_neg_priority AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'SELECT p_id, p_location_index, p_service, p_time_windows_sql,
    d_id, d_location_index, d_service, d_time_windows_sql,
    amount, skills, -1 AS priority FROM shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT throws_ok(
    'shipments_neg_priority',
    'XX000',
    'Unexpected Negative value in column priority',
    'Problem with negative priority shipments'
  );

  PREPARE shipments_101_priority AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'SELECT p_id, p_location_index, p_service, p_time_windows_sql,
    d_id, d_location_index, d_service, d_time_windows_sql,
    amount, skills, 101 AS priority FROM shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT throws_ok(
    'shipments_101_priority',
    'XX000',
    'Priority exceeds the max priority 100',
    'Problem with > 100 priority shipments'
  );

  PREPARE shipments_zero_priority AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'SELECT p_id, p_location_index, p_service, p_time_windows_sql,
    d_id, d_location_index, d_service, d_time_windows_sql,
    amount, skills, 0 AS priority FROM shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT lives_ok('shipments_zero_priority', 'Problem with 0 priority shipments');

  PREPARE shipments_100_priority AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'SELECT p_id, p_location_index, p_service, p_time_windows_sql,
    d_id, d_location_index, d_service, d_time_windows_sql,
    amount, skills, 100 AS priority FROM shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT lives_ok('shipments_100_priority', 'Problem with 100 priority shipments');


  -- Missing id on matrix test

  PREPARE missing_id_on_matrix AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'shipments',
    'vehicles',
    'SELECT * FROM matrix WHERE start_vid != 5 AND end_vid != 5'
  );
  RETURN QUERY
  SELECT throws_ok(
    'missing_id_on_matrix',
    'XX000',
    'An Infinity value was found on the Matrix. Might be missing information of a node',
    'Problem with missing node 5 on the cost matrix'
  );

  PREPARE missing_same_vid_on_matrix AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'shipments',
    'vehicles',
    'SELECT * FROM matrix WHERE start_vid != end_vid'
  );
  RETURN QUERY
  SELECT set_eq('missing_same_vid_on_matrix', 'vroom_sql', 'Cost between same vertex is always 0');

  PREPARE missing_reverse_cost_on_matrix AS
  SELECT * FROM vrp_vroom(
    'jobs',
    'shipments',
    'vehicles',
    'SELECT * FROM matrix WHERE start_vid < end_vid'
  );
  RETURN QUERY
  SELECT set_eq('missing_reverse_cost_on_matrix', 'vroom_sql', 'Reverse cost is equal to the cost, if not specified');


END;
$BODY$
LANGUAGE plpgsql;


SELECT edge_cases();

SELECT * FROM finish();
ROLLBACK;
