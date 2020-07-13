\i setup.sql

SELECT plan(60);


-- Check whether the same set of rows are returned always

-- DIRECTED GRAPH

-- For pgr_bdAstar

PREPARE expectedOutputDirected AS
SELECT * FROM pgr_bdAstar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE descendingOrderDirected AS
SELECT * FROM pgr_bdAstar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE randomOrderDirected AS
SELECT * FROM pgr_bdAstar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 2], ARRAY[3, 12]
);

-- For pgr_bdAstarCost

PREPARE expectedOutputCostDirected AS
SELECT * FROM pgr_bdAstarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE descendingOrderCostDirected AS
SELECT * FROM pgr_bdAstarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 2], ARRAY[3, 12]
);

PREPARE randomOrderCostDirected AS
SELECT * FROM pgr_bdAstarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 2], ARRAY[3, 12]
);

-- For pgr_bdAstarCostMatrix

PREPARE expectedOutputCostMatrixDirected AS
SELECT * FROM pgr_bdAstarCostMatrix(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr)
);

PREPARE descendingOrderCostMatrixDirected AS
SELECT * FROM pgr_bdAstarCostMatrix(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr)
);

PREPARE randomOrderCostMatrixDirected AS
SELECT * FROM pgr_bdAstarCostMatrix(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr)
);

-- UNDIRECTED GRAPH

-- For pgr_bdAstar

PREPARE expectedOutputUndirected AS
SELECT * FROM pgr_bdAstar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

PREPARE descendingOrderUndirected AS
SELECT * FROM pgr_bdAstar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

PREPARE randomOrderUndirected AS
SELECT * FROM pgr_bdAstar(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

-- For pgr_bdAstarCost

PREPARE expectedOutputCostUndirected AS
SELECT * FROM pgr_bdAstarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

PREPARE descendingOrderCostUndirected AS
SELECT * FROM pgr_bdAstarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

PREPARE randomOrderCostUndirected AS
SELECT * FROM pgr_bdAstarCost(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 2], ARRAY[3, 12],
    directed => false
);

-- For pgr_bdAstarCostMatrix

PREPARE expectedOutputCostMatrixUndirected AS
SELECT * FROM pgr_bdAstarCostMatrix(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr),
    directed => false
);

PREPARE descendingOrderCostMatrixUndirected AS
SELECT * FROM pgr_bdAstarCostMatrix(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY id DESC',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr),
    directed => false
);

PREPARE randomOrderCostMatrixUndirected AS
SELECT * FROM pgr_bdAstarCostMatrix(
    'SELECT id, source, target, cost, reverse_cost, x1, y1, x2, y2
    FROM edge_table
    ORDER BY RANDOM()',
    (SELECT array_agg(id) FROM edge_table_vertices_pgr),
    directed => false
);

SELECT SETSEED(1);

-- Directed Graph

SELECT set_eq('expectedOutputDirected', 'descendingOrderDirected', '1: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '2: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '3: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '4: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '5: Should return same set of rows');

SELECT set_eq('expectedOutputCostDirected', 'descendingOrderCostDirected', '6: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '7: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '8: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '9: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '10: Should return same set of rows');

SELECT set_eq('expectedOutputCostMatrixDirected', 'descendingOrderCostMatrixDirected', '11: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '12: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '13: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '14: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '15: Should return same set of rows');

-- Undirected Graph

SELECT set_eq('expectedOutputUndirected', 'descendingOrderUndirected', '16: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '17: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '18: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '19: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '20: Should return same set of rows');

SELECT set_eq('expectedOutputCostUndirected', 'descendingOrderCostUndirected', '21: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '22: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '23: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '24: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '25: Should return same set of rows');

SELECT set_eq('expectedOutputCostMatrixUndirected', 'descendingOrderCostMatrixUndirected', '26: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '27: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '28: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '29: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '30: Should return same set of rows');

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

-- Directed Graph

SELECT set_eq('expectedOutputDirected', 'descendingOrderDirected', '31: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '32: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '33: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '34: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '35: Should return same set of rows');

SELECT set_eq('expectedOutputCostDirected', 'descendingOrderCostDirected', '36: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '37: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '38: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '39: Should return same set of rows');
SELECT set_eq('expectedOutputCostDirected', 'randomOrderCostDirected', '40: Should return same set of rows');

SELECT set_eq('expectedOutputCostMatrixDirected', 'descendingOrderCostMatrixDirected', '41: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '42: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '43: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '44: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixDirected', 'randomOrderCostMatrixDirected', '45: Should return same set of rows');

-- Undirected Graph

SELECT set_eq('expectedOutputUndirected', 'descendingOrderUndirected', '46: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '47: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '48: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '49: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '50: Should return same set of rows');

SELECT set_eq('expectedOutputCostUndirected', 'descendingOrderCostUndirected', '51: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '52: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '53: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '54: Should return same set of rows');
SELECT set_eq('expectedOutputCostUndirected', 'randomOrderCostUndirected', '55: Should return same set of rows');

SELECT set_eq('expectedOutputCostMatrixUndirected', 'descendingOrderCostMatrixUndirected', '56: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '57: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '58: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '59: Should return same set of rows');
SELECT set_eq('expectedOutputCostMatrixUndirected', 'randomOrderCostMatrixUndirected', '60: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
