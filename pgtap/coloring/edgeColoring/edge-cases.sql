\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT CASE WHEN NOT min_version('3.3.0') THEN plan(1) ELSE plan(16) END;

CREATE OR REPLACE FUNCTION edge_cases()
RETURNS SETOF TEXT AS
$BODY$
BEGIN

IF NOT min_version('3.3.0') THEN
  RETURN QUERY
  SELECT skip(1, 'Function is new on 3.3.0');
  RETURN;
END IF;

-- 0 edge, 0 vertex test

PREPARE q1 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE id > 18;

RETURN QUERY
SELECT is_empty('q1', '1: Graph with 0 edge and 0 vertex');

PREPARE edgeColoring1 AS
SELECT *
FROM pgr_edgeColoring(
    'q1'
);

RETURN QUERY
SELECT is_empty('edgeColoring1', '2: Graph with 0 edge and 0 vertex -> Empty row is returned');


-- 1 vertex test

PREPARE q2 AS
SELECT id, source, 2 AS target, cost, reverse_cost
FROM edge_table
WHERE id = 2;

RETURN QUERY
SELECT set_eq('q2', $$VALUES (2, 2, 2, -1, 1)$$, '3: Graph with only vertex 2');

PREPARE edgeColoring2 AS
SELECT *
FROM pgr_edgeColoring(
    'q2'
);

RETURN QUERY
SELECT is_empty('edgeColoring2', '4: One vertex graph can not be edgeColored-> Empty row is returned');


-- 2 vertices test (connected)

PREPARE q3 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE id = 7;

RETURN QUERY
SELECT set_eq('q3', $$VALUES (7, 8, 5, 1, 1)$$, '5: Graph with two connected vertices 8 and 5');

PREPARE edgeColoring3 AS
SELECT *
FROM pgr_edgeColoring(
    'q3'
);

RETURN QUERY
SELECT set_eq('edgeColoring3', $$VALUES (7, 1)$$, '6: Edge formed by connecting vertices 8 and 5, is colored with color 1');


-- linear tests

-- 3 vertices test

PREPARE q4 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE id <= 2;

RETURN QUERY
SELECT set_eq('q4', $$VALUES (1, 1, 2, 1, 1), (2, 2, 3, -1, 1)$$, '7: Graph with three vertices 1, 2 and 3');

PREPARE edgeColoring4 AS
SELECT *
FROM pgr_edgeColoring(
    'q4'
);

RETURN QUERY
SELECT set_eq('edgeColoring4', $$VALUES (1, 1), (2, 2)$$,
    '8: Edge (1, 2) is colored with color 1 and Edge (2, 3) is colored with color 2');


-- 4 vertices test

PREPARE q5 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE id <= 3;

RETURN QUERY
SELECT set_eq('q5',
    $$VALUES
        (1, 1, 2, 1, 1),
        (2, 2, 3, -1, 1),
        (3, 3, 4, -1, 1)
    $$,
    '9: Graph with four vertices 1, 2, 3 and 4'
);

PREPARE edgeColoring5 AS
SELECT *
FROM pgr_edgeColoring(
    'q5'
);

RETURN QUERY
SELECT set_eq('edgeColoring5', $$VALUES (1, 1), (2, 2), (3, 3)$$,
    '10: Edge (1, 2) is colored with color 1, Edge (2, 3) is colored with color 2 and Edge (3, 4) is colored with color 3');


-- even length cycle test

-- 4 vertices length

PREPARE q6 AS
SELECT id, source, target, cost, reverse_cost
FROM edge_table
WHERE id IN (8, 10, 11, 12);

RETURN QUERY
SELECT set_eq('q6',
    $$VALUES
        (8, 5, 6, 1, 1),
        (10, 5, 10, 1, 1),
        (11, 6, 11, 1, -1),
        (12, 10, 11, 1, -1)
    $$,
    '11: Graph with four vertices 5, 6, 10 and 11 (cyclic)'
);

PREPARE edgeColoring6 AS
SELECT *
FROM pgr_edgeColoring(
    'q6'
);

RETURN QUERY
SELECT set_eq('edgeColoring6', $$VALUES (8, 1), (10, 3), (11, 3), (12, 2)$$,
    '12: Edge (5, 6) is colored with color 1, Edge (5, 10) is colored with color 3, Edge (6, 11) is colored with color 3 and Edge (10, 11) is colored with color 2');


-- odd length cycle test

-- 3 vertices cyclic

CREATE TABLE three_vertices_table (
    id BIGSERIAL,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    reverse_cost FLOAT
);

INSERT INTO three_vertices_table (source, target, cost, reverse_cost) VALUES
    (3, 6, 20, 15),
    (3, 8, 10, -10),
    (6, 8, -1, 12);

PREPARE q7 AS
SELECT id, source, target, cost, reverse_cost
FROM three_vertices_table;

RETURN QUERY
SELECT set_eq('q7',
    $$VALUES
        (1, 3, 6, 20, 15),
        (2, 3, 8, 10, -10),
        (3, 6, 8, -1, 12)
    $$,
    '13: Cyclic Graph with three vertices 3, 6 and 8'
);

PREPARE edgeColoring7 AS
SELECT *
FROM pgr_edgeColoring(
    'q7'
);

RETURN QUERY
SELECT set_eq('edgeColoring7', $$VALUES (1, 1), (2, 2), (3, 3)$$,
    '14: Edge (3, 6) is colored with color 1, Edge (3, 8) is colored with color 2 and Edge (6, 8) is colored with color 3');


-- 5 vertices cyclic

CREATE TABLE five_vertices_table (
    id BIGSERIAL,
    source BIGINT,
    target BIGINT,
    cost FLOAT,
    reverse_cost FLOAT
);

INSERT INTO five_vertices_table (source, target, cost, reverse_cost) VALUES
    (1, 2, 1, 1),
    (2, 3, 1, 1),
    (3, 4, 1, -1),
    (4, 5, 1, 1),
    (5, 1, 1, -1);
    
PREPARE q8 AS
SELECT id, source, target, cost, reverse_cost
FROM five_vertices_table;

RETURN QUERY
SELECT set_eq('q8',
    $$VALUES
        (1, 1, 2, 1, 1),
        (2, 2, 3, 1, 1),
        (3, 3, 4, 1, -1),
        (4, 4, 5, 1, 1),
        (5, 5, 1, 1, -1);
    $$,
    '15: Cyclic Graph with 5 vertices 3, 6 and 8'
);

PREPARE edgeColoring8 AS
SELECT *
FROM pgr_edgeColoring(
    'q8'
);

RETURN QUERY
SELECT set_eq('edgeColoring8', $$VALUES (1, 1), (2, 2), (3, 3), (4, 1), (5, 2)$$,
    '16: Edge (1, 2) is colored with color 1, Edge (2, 3) is colored with color 2, Edge (3, 4) is colored with color 3, Edge (4, 5) is colored with color 1 and Edge (5, 1) is colored with color 2');


END;
$BODY$
LANGUAGE plpgsql;

SELECT edge_cases();


SELECT * FROM finish();
ROLLBACK;
