\i setup.sql

SELECT plan(40);

SET extra_float_digits = -3;

-- Check whether the same set of rows is always returned

-- DIRECTED

-- Without heap paths

PREPARE expectedOutputDirected1 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2
);

PREPARE descendingOrderDirected1 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2
);

PREPARE randomOrderDirected1 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2
);

-- With heap paths

PREPARE expectedOutputDirected2 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2, heap_paths => true
);

PREPARE descendingOrderDirected2 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2, heap_paths => true
);

PREPARE randomOrderDirected2 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2, heap_paths => true
);

-- UNDIRECTED

-- Without heap paths

PREPARE expectedOutputUndirected1 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2,
    directed => false
);

PREPARE descendingOrderUndirected1 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2,
    directed => false
);

PREPARE randomOrderUndirected1 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2,
    directed => false
);

-- With heap paths

PREPARE expectedOutputUndirected2 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2,
    directed => false, heap_paths => true
);

PREPARE descendingOrderUndirected2 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2,
    directed => false, heap_paths => true
);

PREPARE randomOrderUndirected2 AS
SELECT  seq, path_id, path_seq, node, edge, cost::TEXT, agg_cost::TEXT FROM pgr_withPointsKSP(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    'SELECT pid, edge_id, fraction, side
    FROM pointsOfInterest',
    -1, 6, 2,
    directed => false, heap_paths => true
);

SELECT todo_start('Tests pass or fail arbitrarily, tests left pending');

SELECT set_eq('expectedOutputDirected1', 'descendingOrderDirected1', '1: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '2: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '3: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '4: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '5: Should return same set of rows');

SELECT set_eq('expectedOutputDirected2', 'descendingOrderDirected2', '6: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '7: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '8: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '9: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '10: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected1', 'descendingOrderUndirected1', '11: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '12: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '13: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '14: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '15: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected2', 'descendingOrderUndirected2', '16: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '17: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '18: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '19: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '20: Should return same set of rows');

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

SELECT set_eq('expectedOutputDirected1', 'descendingOrderDirected1', '21: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '22: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '23: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '24: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '25: Should return same set of rows');

SELECT set_eq('expectedOutputDirected2', 'descendingOrderDirected2', '26: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '27: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '28: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '29: Should return same set of rows');
SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '30: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected1', 'descendingOrderUndirected1', '31: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '32: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '33: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '34: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '35: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected2', 'descendingOrderUndirected2', '36: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '37: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '38: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '39: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '40: Should return same set of rows');

SELECT todo_end();

SELECT * FROM finish();
ROLLBACK;
