BEGIN;
SET search_path TO 'vroom', 'public';

SELECT CASE WHEN min_version('0.2.0') THEN plan (30) ELSE plan(1) END;

PREPARE jobs AS SELECT * FROM jobs;
PREPARE shipments AS SELECT * FROM shipments;
PREPARE vehicles AS SELECT * FROM vehicles;
PREPARE matrix AS SELECT * FROM matrix;

CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  params TEXT[];
  subs TEXT[];
BEGIN
  IF NOT min_version('0.2.0') THEN
    RETURN QUERY
    SELECT skip(1, 'Function is new on 0.2.0');
    RETURN;
  END IF;

  RETURN QUERY
  SELECT isnt_empty('jobs', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('shipments', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('vehicles', 'Should be not empty to tests be meaningful');
  RETURN QUERY
  SELECT isnt_empty('matrix', 'Should be not empty to tests be meaningful');

  params = ARRAY[
    '$$jobs$$',
    '$$shipments$$',
    '$$vehicles$$',
    '$$matrix$$'
  ]::TEXT[];
  subs = ARRAY[
    'NULL',
    'NULL',
    'NULL',
    'NULL'
  ]::TEXT[];

  RETURN query SELECT * FROM no_crash_test('vrp_vroom', params, subs);

  params = ARRAY[
    '$$jobs$$',
    '$$vehicles$$',
    '$$matrix$$'
  ]::TEXT[];
  subs = ARRAY[
    'NULL',
    'NULL',
    'NULL'
  ]::TEXT[];

  RETURN query SELECT * FROM no_crash_test('vrp_vroomJobs', params, subs);

  params = ARRAY[
    '$$shipments$$',
    '$$vehicles$$',
    '$$matrix$$'
  ]::TEXT[];
  RETURN query SELECT * FROM no_crash_test('vrp_vroomShipments', params, subs);

END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT * FROM no_crash();

ROLLBACK;
