\i setup.sql

SELECT plan(5);

SET extra_float_digits = -3;

-- Check whether the same set of rows are returned always

PREPARE expectedOutput AS
SELECT seq, node, cost::TEXT, agg_cost::TEXT FROM pgr_TSPeuclidean(
    'SELECT id, st_X(the_geom) AS x, st_Y(the_geom)AS y
    FROM edge_table_vertices_pgr
    ORDER BY id',
    randomize := false);

PREPARE descendingOrder AS
SELECT seq, node, cost::TEXT, agg_cost::TEXT FROM pgr_TSPeuclidean(
    'SELECT id, st_X(the_geom) AS x, st_Y(the_geom)AS y
    FROM edge_table_vertices_pgr
    ORDER BY id DESC',
    randomize := false);

PREPARE randomOrder AS
SELECT seq, node, cost::TEXT, agg_cost::TEXT FROM pgr_TSPeuclidean(
    'SELECT id, st_X(the_geom) AS x, st_Y(the_geom)AS y
    FROM edge_table_vertices_pgr
    ORDER BY RANDOM()',
    randomize := false);

SELECT set_eq('expectedOutput', 'descendingOrder', '1: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '2: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '3: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '4: Should return same set of rows');
SELECT set_eq('expectedOutput', 'randomOrder', '5: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
