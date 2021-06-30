\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(5);

SELECT has_function('pgr_edgeColoring');

SELECT has_function('pgr_edgeColoring', ARRAY['text']);
SELECT function_returns('pgr_edgeColoring', ARRAY['text'],  'setof record');

-- pgr_edgeColoring
-- parameter names
SELECT bag_has(
    $$SELECT  proargnames from pg_proc where proname = 'pgr_edgeColoring'$$,
    $$SELECT  '{"","edge_id","color_id"}'::TEXT[] $$
);

-- parameter types
SELECT set_eq(
    $$SELECT  proallargtypes from pg_proc where proname = 'pgr_edgeColoring'$$,
    $$VALUES
        ('{25,20,20}'::OID[])
    $$
);

SELECT * FROM finish();
ROLLBACK;
