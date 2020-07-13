\i setup.sql

SELECT plan(60);


-- Check whether the same set of rows are returned always

PREPARE expectedOutputCostDirected AS
SELECT * FROM pgr_astarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE descendingOrderCostDirected AS
SELECT * FROM pgr_astarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE randomOrderCostDirected AS
SELECT * FROM pgr_astarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE expectedOutputCostUndirected AS
SELECT * FROM pgr_astarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

PREPARE descendingOrderCostUndirected AS
SELECT * FROM pgr_astarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

PREPARE randomOrderCostUndirected AS
SELECT * FROM pgr_astarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

SELECT SETSEED(1);

SELECT set_eq('expectedOutputCostDirected', 'descendingOrderCostDirected', '1: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '2: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '3: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '4: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '5: Should return same set of rows');

SELECT set_eq('expectedOutputCostUndirected', 'descendingOrderCostUndirected', '6: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '7: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '8: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '9: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '10: Should return same set of rows');

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

SELECT set_eq('expectedOutputCostDirected', 'descendingOrderCostDirected', '11: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '12: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '13: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '14: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '15: Should return same set of rows');

SELECT set_eq('expectedOutputCostUndirected', 'descendingOrderCostUndirected', '16: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '17: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '18: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '19: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '20: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
