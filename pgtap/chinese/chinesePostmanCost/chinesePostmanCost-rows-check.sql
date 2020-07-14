\i setup.sql

SELECT plan(5);

SET extra_float_digits = -3;

-- Check whether the same set of rows are returned always

PREPARE expectedOutput AS
SELECT * FROM pgr_chinesePostmanCost(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    WHERE id < 17
    ORDER BY id'
);

PREPARE descendingOrder AS
SELECT * FROM pgr_chinesePostmanCost(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    WHERE id < 17
    ORDER BY id DESC'
);

PREPARE randomOrder AS
SELECT * FROM pgr_chinesePostmanCost(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    WHERE id < 17
    ORDER BY RANDOM()'
);

SELECT SETSEED(1);

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
