\i setup.sql

SELECT plan(40);

SET extra_float_digits = -3;

-- Check whether the same set of rows is always returned

-- DIRECTED

-- Not strict, Allowed U turn

PREPARE expectedOutputDirected1 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7]
);

PREPARE descendingOrderDirected1 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7]
);

PREPARE randomOrderDirected1 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7]
);

-- Not strict, Not Allowed U turn

PREPARE expectedOutputDirected2 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7], U_turn_on_edge => false
);

PREPARE descendingOrderDirected2 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7], U_turn_on_edge => false
);

PREPARE randomOrderDirected2 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7], U_turn_on_edge => false
);

-- Strict, Allowed U turn

PREPARE expectedOutputDirected3 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7], strict => false
);

PREPARE descendingOrderDirected3 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7], strict => false
);

PREPARE randomOrderDirected3 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7], strict => false
);

-- Strict, Not allowed U turn

PREPARE expectedOutputDirected4 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7], strict => false, U_turn_on_edge => false
);

PREPARE descendingOrderDirected4 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7], strict => false, U_turn_on_edge => false
);

PREPARE randomOrderDirected4 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7], strict => false, U_turn_on_edge => false
);

-- UNDIRECTED

-- Not strict, Allowed U turn

PREPARE expectedOutputUndirected1 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7],
    directed => false
);

PREPARE descendingOrderUndirected1 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7],
    directed => false
);

PREPARE randomOrderUndirected1 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7],
    directed => false
);

-- Not strict, Not Allowed U turn

PREPARE expectedOutputUndirected2 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7], U_turn_on_edge => false,
    directed => false
);

PREPARE descendingOrderUndirected2 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7], U_turn_on_edge => false,
    directed => false
);

PREPARE randomOrderUndirected2 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7], U_turn_on_edge => false,
    directed => false
);

-- Strict, Allowed U turn

PREPARE expectedOutputUndirected3 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7], strict => false,
    directed => false
);

PREPARE descendingOrderUndirected3 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7], strict => false,
    directed => false
);

PREPARE randomOrderUndirected3 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7], strict => false,
    directed => false
);

-- Strict, Not allowed U turn

PREPARE expectedOutputUndirected4 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id',
    ARRAY[7, 3, 2, 12, 7], strict => false, U_turn_on_edge => false,
    directed => false
);

PREPARE descendingOrderUndirected4 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY id DESC',
    ARRAY[7, 3, 2, 12, 7], strict => false, U_turn_on_edge => false,
    directed => false
);

PREPARE randomOrderUndirected4 AS
SELECT * FROM pgr_dijkstraVia(
    'SELECT id, source, target, cost, reverse_cost
    FROM edge_table
    ORDER BY RANDOM()',
    ARRAY[7, 3, 2, 12, 7], strict => false, U_turn_on_edge => false,
    directed => false
);

-- Directed


SELECT set_eq('expectedOutputDirected1', 'descendingOrderDirected1', '1: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '2: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '3: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '4: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '5: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputDirected2', 'descendingOrderDirected2', '6: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '7: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '8: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '9: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '10: Should return same set of rows');

SELECT set_eq('expectedOutputDirected3', 'descendingOrderDirected3', '11: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '12: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '13: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '14: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '15: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputDirected4', 'descendingOrderDirected4', '16: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '17: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '18: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '19: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '20: Should return same set of rows');

-- Undirected

SELECT set_eq('expectedOutputUndirected1', 'descendingOrderUndirected1', '21: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '22: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '23: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '24: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '25: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputUndirected2', 'descendingOrderUndirected2', '26: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '27: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '28: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '29: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '30: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected3', 'descendingOrderUndirected3', '31: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '32: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '33: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '34: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '35: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputUndirected4', 'descendingOrderUndirected4', '36: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '37: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '38: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '39: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '40: Should return same set of rows');

UPDATE edge_table SET cost = cost + 0.001 * id * id, reverse_cost = reverse_cost + 0.001 * id * id;

-- Directed

SELECT set_eq('expectedOutputDirected1', 'descendingOrderDirected1', '41: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '42: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '43: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '44: Should return same set of rows');
SELECT set_eq('expectedOutputDirected1', 'randomOrderDirected1', '45: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputDirected2', 'descendingOrderDirected2', '46: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '47: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '48: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '49: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected2', 'randomOrderDirected2', '50: Should return same set of rows');

SELECT set_eq('expectedOutputDirected3', 'descendingOrderDirected3', '51: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '52: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '53: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '54: Should return same set of rows');
SELECT set_eq('expectedOutputDirected3', 'randomOrderDirected3', '55: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputDirected4', 'descendingOrderDirected4', '56: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '57: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '58: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '59: Should return same set of rows');
-- SELECT set_eq('expectedOutputDirected4', 'randomOrderDirected4', '60: Should return same set of rows');

-- Undirected

SELECT set_eq('expectedOutputUndirected1', 'descendingOrderUndirected1', '61: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '62: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '63: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '64: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected1', 'randomOrderUndirected1', '65: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputUndirected2', 'descendingOrderUndirected2', '66: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '67: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '68: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '69: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected2', 'randomOrderUndirected2', '70: Should return same set of rows');

SELECT set_eq('expectedOutputUndirected3', 'descendingOrderUndirected3', '71: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '72: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '73: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '74: Should return same set of rows');
SELECT set_eq('expectedOutputUndirected3', 'randomOrderUndirected3', '75: Should return same set of rows');

-- SERVER CRASH
-- SELECT set_eq('expectedOutputUndirected4', 'descendingOrderUndirected4', '76: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '77: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '78: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '79: Should return same set of rows');
-- SELECT set_eq('expectedOutputUndirected4', 'randomOrderUndirected4', '80: Should return same set of rows');

SELECT * FROM finish();
ROLLBACK;
