\i setup.sql

SELECT plan(5);

SET extra_float_digits = -3;

-- Check whether the same set of rows is always returned

PREPARE expectedOutput AS
SELECT * FROM pgr_maxFlowMinCost_Cost(
    'SELECT id, source, target, capacity, reverse_capacity, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE descendingOrder AS
SELECT * FROM pgr_maxFlowMinCost_Cost(
    'SELECT id, source, target, capacity, reverse_capacity, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE randomOrder AS
SELECT * FROM pgr_maxFlowMinCost_Cost(
    'SELECT id, source, target, capacity, reverse_capacity, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 2], ARRAY[3, 12]
);

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
