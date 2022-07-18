CREATE TABLE knapsack_data(
  weight INTEGER,
  cost INTEGER);

INSERT INTO knapsack_data (weight,  cost)
VALUES
(12, 4),
(2, 2),
(1, 1),
(4, 10),
(1, 2);

SELECT *
FROM knapsack_data;

SELECT *
FROM vrp_knapsack($$SELECT weight, cost FROM knapsack_data$$, 3);
