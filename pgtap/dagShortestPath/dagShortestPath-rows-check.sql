\i setup.sql

SELECT plan(10);


-- Check whether the same set of rows are returned always

PREPARE expectedOutput AS
SELECT * FROM pgr_dagShortestPath(
    'SELECT id, source, target, cost
    FROM edge_table
    ORDER BY id',
    ARRAY[10, 2], ARRAY[11, 12]
);

PREPARE descendingOrder AS
SELECT * FROM pgr_dagShortestPath(
    'SELECT id, source, target, cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[10, 2], ARRAY[11, 12]
);

PREPARE randomOrder AS
SELECT * FROM pgr_dagShortestPath(
    'SELECT id, source, target, cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[10, 2], ARRAY[11, 12]
);

SELECT todo_start('Fix the code to return same set of rows');

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

SELECT todo_end();

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

SELECT set_eq('expectedOutput', 'descendingOrder', '6: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '7: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '8: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '9: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '10: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
