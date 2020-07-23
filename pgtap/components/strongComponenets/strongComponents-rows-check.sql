\i setup.sql

SELECT plan(5);

-- Check whether the same set of rows is always returned

PREPARE expectedOutput AS
SELECT * FROM pgr_strongComponents(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id'
);

PREPARE descendingOrder AS
SELECT * FROM pgr_strongComponents(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC'
);

PREPARE randomOrder AS
SELECT * FROM pgr_strongComponents(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()'
);

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
