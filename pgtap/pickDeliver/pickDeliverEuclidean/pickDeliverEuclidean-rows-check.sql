\i setup.sql

SELECT plan(5);


-- Check whether the same set of rows are returned always

PREPARE expectedOutput AS
SELECT * FROM pgr_pickDeliverEuclidean(
    'SELECT * FROM orders ORDER BY id',
    'SELECT * from vehicles'
);

PREPARE descendingOrder AS
SELECT * FROM pgr_pickDeliverEuclidean(
    'SELECT * FROM orders ORDER BY id DESC',
    'SELECT * from vehicles'
);

PREPARE randomOrder AS
SELECT * FROM pgr_pickDeliverEuclidean(
    'SELECT * FROM orders ORDER BY RANDOM()',
    'SELECT * from vehicles'
);

SELECT SETSEED(1);

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
