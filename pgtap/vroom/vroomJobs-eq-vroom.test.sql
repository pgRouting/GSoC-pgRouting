BEGIN;
SET search_path TO 'vroom', 'public';

SELECT CASE WHEN min_version('0.2.0') THEN plan (22) ELSE plan(1) END;

CREATE or REPLACE FUNCTION vroomJobs_eq_vroom()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
  ids BIGINT[] := ARRAY[1, 2, 3, 4, 5];
  jobs_sql TEXT;
  rest_sql TEXT := ', $$SELECT * FROM vehicles$$, $$SELECT * FROM matrix$$)';
  vroom_sql TEXT;
  vroomJobs_sql TEXT;
data TEXT;
BEGIN
  IF NOT min_version('0.2.0') THEN
    RETURN QUERY
    SELECT skip(1, 'Function is new on 0.2.0');
    RETURN;
  END IF;

  -- Two jobs
  FOR i in 1..array_length(ids, 1) LOOP
    FOR j in (i+1)..array_length(ids, 1) LOOP
      jobs_sql := '$$SELECT * FROM jobs WHERE id in (' || i || ', ' || j || ')$$';
      vroom_sql := 'SELECT * FROM vrp_vroom(' || jobs_sql || ', $$SELECT * FROM shipments WHERE id = -1$$' || rest_sql;
      vroomJobs_sql := 'SELECT * FROM vrp_vroomJobs(' || jobs_sql || rest_sql;
      RETURN query SELECT set_eq(vroom_sql, vroomJobs_sql);
    END LOOP;
  END LOOP;

  -- Three jobs
  FOR i in 1..array_length(ids, 1) LOOP
    FOR j in (i+1)..array_length(ids, 1) LOOP
      FOR k in (j+1)..array_length(ids, 1) LOOP
        jobs_sql := '$$SELECT * FROM jobs WHERE id in (' || i || ', ' || j || ', ' || k || ')$$';
        vroom_sql := 'SELECT * FROM vrp_vroom(' || jobs_sql || ', $$SELECT * FROM shipments WHERE id = -1$$' || rest_sql;
        vroomJobs_sql := 'SELECT * FROM vrp_vroomJobs(' || jobs_sql || rest_sql;
        RETURN query SELECT set_eq(vroom_sql, vroomJobs_sql);
      END LOOP;
    END LOOP;
  END LOOP;

  -- All the five jobs
  jobs_sql := '$$SELECT * FROM jobs$$';
  vroom_sql := 'SELECT * FROM vrp_vroom(' || jobs_sql || ', $$SELECT * FROM shipments WHERE id = -1$$' || rest_sql;
  vroomJobs_sql := 'SELECT * FROM vrp_vroomJobs(' || jobs_sql || rest_sql;
  RETURN query SELECT set_eq(vroom_sql, vroomJobs_sql);

  -- No jobs
  jobs_sql := '$$SELECT * FROM jobs WHERE id = -1$$';
  vroom_sql := 'SELECT * FROM vrp_vroom(' || jobs_sql || ', $$SELECT * FROM shipments WHERE id = -1$$' || rest_sql;
  vroomJobs_sql := 'SELECT * FROM vrp_vroomJobs(' || jobs_sql || rest_sql;
  RETURN query SELECT set_eq(vroom_sql, vroomJobs_sql);
END
$BODY$
language plpgsql;

SELECT vroomJobs_eq_vroom();

SELECT * FROM finish();
ROLLBACK;
