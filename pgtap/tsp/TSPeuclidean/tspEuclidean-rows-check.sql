\i setup.sql

SELECT plan(10);


-- Check whether the same set of rows are returned always

PREPARE expectedOutput AS
SELECT * FROM pgr_TSPeuclidean(
    'SELECT id, st_X(the_geom) AS x, st_Y(the_geom)AS y
    FROM edge_table_vertices_pgr
    ORDER BY id',
    randomize := false);

PREPARE descendingOrder AS
SELECT * FROM pgr_TSPeuclidean(
    'SELECT id, st_X(the_geom) AS x, st_Y(the_geom)AS y
    FROM edge_table_vertices_pgr
    ORDER BY id DESC',
    randomize := false);

PREPARE randomOrder AS
SELECT * FROM pgr_TSPeuclidean(
    'SELECT id, st_X(the_geom) AS x, st_Y(the_geom)AS y
    FROM edge_table_vertices_pgr
    ORDER BY RANDOM()',
    randomize := false);

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

SELECT set_eq('expectedOutput', 'descendingOrder', '6: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '7: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '8: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '9: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '10: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
