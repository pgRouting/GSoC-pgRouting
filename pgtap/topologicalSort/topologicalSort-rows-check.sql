\i setup.sql

SELECT plan(5);

SET extra_float_digits = -3;

-- Check whether the same set of rows are returned always

PREPARE expectedOutput AS
SELECT * FROM pgr_topologicalSort(
    'SELECT id, source, target, cost
    FROM edge_table
    ORDER BY id'
);

PREPARE descendingOrder AS
SELECT * FROM pgr_topologicalSort(
    'SELECT id, source, target, cost
    FROM edge_table
    ORDER BY id DESC'
);

PREPARE randomOrder AS
SELECT * FROM pgr_topologicalSort(
    'SELECT id, source, target, cost
    FROM edge_table
    ORDER BY RANDOM()'
);

SELECT SETSEED(1);

SELECT todo_start('Fix the code to return same set of rows');

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

SELECT todo_end();

SELECT * FROM finish();
ROLLBACK;
