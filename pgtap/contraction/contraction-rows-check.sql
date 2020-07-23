\i setup.sql

SELECT plan(40);

SET extra_float_digits = -3;

-- Check whether the same set of rows is always returned

-- Without forbidden vertices

PREPARE expectedOutputDirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[1, 2]
);

PREPARE descendingOrderDirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[1, 2]
);

PREPARE randomOrderDirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[1, 2]
);

PREPARE expectedOutputUndirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[1, 2],
    directed => false
);

PREPARE descendingOrderUndirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[1, 2],
    directed => false
);

PREPARE randomOrderUndirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[1, 2],
    directed => false
);

-- With forbidden vertices

PREPARE expectedOutputForbiddenDirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[1, 2],
    forbidden_vertices => ARRAY[2]
);

PREPARE descendingOrderForbiddenDirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[1, 2],
    forbidden_vertices => ARRAY[2]
);

PREPARE randomOrderForbiddenDirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[1, 2],
    forbidden_vertices => ARRAY[2]
);

PREPARE expectedOutputForbiddenUndirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[1, 2],
    directed => false,
    forbidden_vertices => ARRAY[2]
);

PREPARE descendingOrderForbiddenUndirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[1, 2],
    directed => false,
    forbidden_vertices => ARRAY[2]
);

PREPARE randomOrderForbiddenUndirected AS
SELECT * FROM pgr_contraction(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[1, 2],
    directed => false,
    forbidden_vertices => ARRAY[2]
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

SELECT set_eq('expectedOutputForbiddenDirected', 'descendingOrderForbiddenDirected', '11: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '12: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '13: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '14: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '15: Should return same set of rows');

SELECT set_eq('expectedOutputForbiddenUndirected', 'descendingOrderForbiddenUndirected', '16: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '17: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '18: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '19: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '20: Should return same set of rows');

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

SELECT set_eq('expectedOutputDirected', 'descendingOrderDirected', '21: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '22: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '23: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '24: Should return same set of rows');
SELECT set_eq('expectedOutputDirected', 'randomOrderDirected', '25: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected', 'descendingOrderUndirected', '26: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '27: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '28: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '29: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected', 'randomOrderUndirected', '30: Should return same set of rows');

SELECT set_eq('expectedOutputForbiddenDirected', 'descendingOrderForbiddenDirected', '31: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '32: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '33: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '34: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenDirected', 'randomOrderForbiddenDirected', '35: Should return same set of rows');

SELECT set_eq('expectedOutputForbiddenUndirected', 'descendingOrderForbiddenUndirected', '36: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '37: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '38: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '39: Should return same set of rows');
SELECT set_eq('expectedOutputForbiddenUndirected', 'randomOrderForbiddenUndirected', '40: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
