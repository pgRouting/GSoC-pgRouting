BEGIN;
SET search_path TO 'vroom', 'public';

SELECT CASE WHEN min_version('0.2.0') THEN plan (19) ELSE plan(1) END;

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

  -- one job/shipment tests

  -- Column Names:
  -- seq, vehicle_seq, vehicle_id, step_seq, step_type, task_id,
  -- arrival, travel_time, service_time, waiting_time, load

  PREPARE one_job_q1 AS
  SELECT * FROM vrp_vroom(
    'SELECT * FROM jobs WHERE id = 1',
    'empty_shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT set_eq('one_job_q1',
    $$
      VALUES
      (1, 1, 1, 1, 1, -1, 300, 0, 0, 0, ARRAY[20]),
      (2, 1, 1, 2, 5, -1, 300, 0, 0, 0, ARRAY[20]),
      (3, 1, 1, 3, 2, 1, 300, 0, 250, 3325, ARRAY[20]),
      (4, 1, 1, 4, 6, -1, 3875, 0, 0, 0, ARRAY[20])
    $$,
    'Problem with only one job having id 1'
  );

  PREPARE one_job_q2 AS
  SELECT * FROM vrp_vroom(
    'SELECT * FROM jobs WHERE id = 5',
    'empty_shipments',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT set_eq('one_job_q2',
    $$
      VALUES
      (1, 1, 4, 1, 1, -1, 250, 0, 0, 0, ARRAY[20]),
      (2, 1, 4, 2, 5, -1, 250, 0, 0, 0, ARRAY[20]),
      (3, 1, 4, 3, 2, 5, 300, 50, 250, 725, ARRAY[20]),
      (4, 1, 4, 4, 6, -1, 1325, 100, 0, 0, ARRAY[20])
    $$,
    'Problem with only one job having id 5'
  );

  PREPARE one_shipment_q1 AS
  SELECT * FROM vrp_vroom(
    'empty_jobs',
    'SELECT * FROM shipments WHERE id = 1',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT set_eq('one_shipment_q1',
    $$
      VALUES
      (1, 1, 4, 1, 1, -1, 250, 0, 0, 0, ARRAY[0]),
      (2, 1, 4, 2, 5, -1, 250, 0, 0, 0, ARRAY[0]),
      (3, 1, 4, 3, 3, 6, 250, 0, 2250, 1375, ARRAY[10]),
      (4, 1, 4, 4, 4, 7, 3900, 25, 2250, 21025, ARRAY[0]),
      (5, 1, 4, 5, 6, -1, 27200, 50, 0, 0, ARRAY[0])
    $$,
    'Problem with only one shipment having id 1'
  );

  PREPARE one_shipment_q2 AS
  SELECT * FROM vrp_vroom(
    'empty_jobs',
    'SELECT * FROM shipments WHERE id = 5',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT set_eq('one_shipment_q2',
    $$
      VALUES
      (1, 1, 1, 1, 1, -1, 300, 0, 0, 0, ARRAY[0]),
      (2, 1, 1, 2, 5, -1, 300, 0, 0, 0, ARRAY[0]),
      (3, 1, 1, 3, 3, 14, 350, 50, 2250, 13000, ARRAY[10]),
      (4, 1, 1, 4, 4, 15, 15600, 50, 2250, 2575, ARRAY[0]),
      (5, 1, 1, 5, 6, -1, 20475, 100, 0, 0, ARRAY[0])
    $$,
    'Problem with only one shipment having id 5'
  );

  PREPARE one_job_shipment AS
  SELECT * FROM vrp_vroom(
    'SELECT * FROM jobs WHERE id = 2',
    'SELECT * FROM shipments WHERE id = 2',
    'vehicles',
    'matrix'
  );
  RETURN QUERY
  SELECT set_eq('one_job_shipment',
    $$
      VALUES
      (1, 1, 1, 1, 1, -1, 300, 0, 0, 0, ARRAY[30]),
      (2, 1, 1, 2, 5, -1, 300, 0, 0, 0, ARRAY[30]),
      (3, 1, 1, 3, 2, 2, 350, 50, 250, 900, ARRAY[30]),
      (4, 1, 1, 4, 6, -1, 1550, 100, 0, 0, ARRAY[30]),
      (5, 2, 4, 1, 1, -1, 250, 0, 0, 0, ARRAY[0]),
      (6, 2, 4, 2, 5, -1, 250, 0, 0, 0, ARRAY[0]),
      (7, 2, 4, 3, 3, 8, 275, 25, 2250, 100, ARRAY[10]),
      (8, 2, 4, 4, 4, 9, 2736, 136, 2250, 1514, ARRAY[0]),
      (9, 2, 4, 5, 6, -1, 6590, 226, 0, 0, ARRAY[0])
    $$,
    'Problem with one job and one shipment having id 2'
  );

END;
$BODY$
LANGUAGE plpgsql;


SELECT edge_cases();

SELECT * FROM finish();
ROLLBACK;
