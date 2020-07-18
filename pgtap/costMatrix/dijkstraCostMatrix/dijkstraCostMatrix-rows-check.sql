\i setup.sql

SELECT plan(20);

SET extra_float_digits = -3;

-- Check whether the same set of rows are returned always

PREPARE expectedOutputDirected AS
SELECT * FROM pgr_dijkstraCostMatrix(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr)
);

PREPARE descendingOrderDirected AS
SELECT * FROM pgr_dijkstraCostMatrix(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr)
);

PREPARE randomOrderDirected AS
SELECT * FROM pgr_dijkstraCostMatrix(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr)
);

PREPARE expectedOutputUndirected AS
SELECT * FROM pgr_dijkstraCostMatrix(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr),
    directed => false
);

PREPARE descendingOrderUndirected AS
SELECT * FROM pgr_dijkstraCostMatrix(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr),
    directed => false
);

PREPARE randomOrderUndirected AS
SELECT * FROM pgr_dijkstraCostMatrix(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr),
    directed => false
);

SELECT set_eq('expectedOutputDirected', 'descendingOrderDirected', '1: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '2: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '3: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '4: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '5: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected', 'descendingOrderUndirected', '6: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '7: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '8: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '9: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '10: Should return same set of rows');

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

SELECT set_eq('expectedOutputDirected', 'descendingOrderDirected', '11: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '12: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '13: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '14: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '15: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected', 'descendingOrderUndirected', '16: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '17: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '18: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '19: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '20: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
