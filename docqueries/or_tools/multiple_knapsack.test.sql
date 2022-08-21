DROP TABLE IF EXISTS multiple_knapsack_query CASCADE;

CREATE TABLE multiple_knapsack_query(
  weight INTEGER,
  cost INTEGER);

INSERT INTO multiple_knapsack_query (weight,  cost)
VALUES
(48, 10),
(30, 30),
(42, 25),
(36, 50),
(36, 35),
(48, 30), 
(42, 15), 
(42, 40),
(36, 30),
(24, 35), 
(30, 45), 
(30, 10), 
(42, 20), 
(36, 30), 
(36, 25);

SELECT * 
FROM multiple_knapsack_query;

SELECT * 
FROM vrp_multiple_knapsack('SELECT * FROM multiple_knapsack_query', ARRAY[100,100,100,100,100]);