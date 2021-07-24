BEGIN;

SELECT plan(15);

CREATE OR REPLACE FUNCTION types_check()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

  RETURN QUERY
  SELECT has_function('vrp_vroom');
  RETURN QUERY
  SELECT has_function('vrp_vroom', ARRAY['text', 'text', 'text', 'text']);
  RETURN QUERY
  SELECT function_returns('vrp_vroom', ARRAY['text', 'text', 'text', 'text'], 'setof record');

  -- parameter names
  RETURN QUERY
  SELECT bag_has(
      $$SELECT proargnames from pg_proc where proname = 'vrp_vroom'$$,
      $$SELECT '{"","","","","seq","vehicle_seq","vehicle_id","step_seq","step_type",'
               '"task_id","arrival","travel_time","service_time","waiting_time","load"}'::TEXT[]$$
  );

  -- parameter types
  RETURN QUERY
  SELECT set_eq(
      $$SELECT  proallargtypes from pg_proc where proname = 'vrp_vroom'$$,
      $$VALUES
          ('{25,25,25,25,20,20,20,20,23,20,23,23,23,23,1016}'::OID[])
      $$
  );

  RETURN QUERY
  SELECT has_function('vrp_vroomjobs');
  RETURN QUERY
  SELECT has_function('vrp_vroomjobs', ARRAY['text', 'text', 'text']);
  RETURN QUERY
  SELECT function_returns('vrp_vroomjobs', ARRAY['text', 'text', 'text'], 'setof record');

  -- parameter names
  RETURN QUERY
  SELECT bag_has(
      $$SELECT proargnames from pg_proc where proname = 'vrp_vroomjobs'$$,
      $$SELECT '{"","","","seq","vehicle_seq","vehicle_id","step_seq","step_type",'
               '"task_id","arrival","travel_time","service_time","waiting_time","load"}'::TEXT[]$$
  );

  -- parameter types
  RETURN QUERY
  SELECT set_eq(
      $$SELECT  proallargtypes from pg_proc where proname = 'vrp_vroomjobs'$$,
      $$VALUES
          ('{25,25,25,20,20,20,20,23,20,23,23,23,23,1016}'::OID[])
      $$
  );

  RETURN QUERY
  SELECT has_function('vrp_vroomshipments');
  RETURN QUERY
  SELECT has_function('vrp_vroomshipments', ARRAY['text', 'text', 'text']);
  RETURN QUERY
  SELECT function_returns('vrp_vroomshipments', ARRAY['text', 'text', 'text'], 'setof record');

  -- parameter names
  RETURN QUERY
  SELECT bag_has(
      $$SELECT proargnames from pg_proc where proname = 'vrp_vroomshipments'$$,
      $$SELECT '{"","","","seq","vehicle_seq","vehicle_id","step_seq","step_type",'
               '"task_id","arrival","travel_time","service_time","waiting_time","load"}'::TEXT[]$$
  );

  -- parameter types
  RETURN QUERY
  SELECT set_eq(
      $$SELECT  proallargtypes from pg_proc where proname = 'vrp_vroomshipments'$$,
      $$VALUES
          ('{25,25,25,20,20,20,20,23,20,23,23,23,23,1016}'::OID[])
      $$
  );
END;
$BODY$
LANGUAGE plpgsql;

SELECT types_check();

SELECT * FROM finish();
ROLLBACK;
