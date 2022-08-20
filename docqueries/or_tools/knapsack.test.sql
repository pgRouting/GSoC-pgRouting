DROP TABLE IF EXISTS knapsack_query;
CREATE TABLE knapsack_query(
  weight INTEGER,
  cost INTEGER);

INSERT INTO knapsack_query(weight,  cost)
VALUES
(12, 4),
(2, 2),
(1, 1),
(4, 10),
(1, 2);

SELECT *
FROM knapsack_query;

SELECT *
FROM vrp_knapsack($$SELECT * FROM knapsack_query$$, 15);
