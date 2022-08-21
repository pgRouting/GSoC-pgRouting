DROP SCHEMA IF EXISTS ortools CASCADE;
CREATE SCHEMA ortools;

DROP TABLE IF EXISTS ortools.knapsack_data CASCADE;
DROP TABLE IF EXISTS ortools.multiple_knapsack_data CASCADE;
DROP TABLE IF EXISTS ortools.bin_packing_data CASCADE;

--Bin Packing Start
CREATE TABLE ortools.bin_packing_data(
  weight INTEGER);

INSERT INTO ortools.bin_packing_data (weight)
VALUES
(48), (30), (19), (36), (36), (27), (42), (42), (36), (24), (30);
--Bin Packing End

-- Multiple Knapsack Start
CREATE TABLE ortools.multiple_knapsack_data(
  weight INTEGER,
  cost INTEGER);

INSERT INTO ortools.multiple_knapsack_data (weight,  cost)
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
--Multiple Knapsack End

--Knapsack Start
CREATE TABLE ortools.knapsack_data(
  weight INTEGER,
  cost INTEGER);

INSERT INTO ortools.knapsack_data (weight,  cost)
VALUES
(12, 4),
(2, 2),
(1, 1),
(4, 10),
(1, 2);
--Knapsack End
