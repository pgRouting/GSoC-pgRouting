DROP FUNCTION IF EXISTS vrp_knapsack;
drop type if exists knapsack_items;
drop table if exists knapsack_data;

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

create type knapsack_items as(
  index integer,
  weight integer,
  cost integer
);

CREATE FUNCTION vrp_knapsack(inner_query text, capacity integer)
  RETURNS SETOF knapsack_items
AS $$
  from ortools.algorithms import pywrapknapsack_solver
  
  solver = pywrapknapsack_solver.KnapsackSolver(
  pywrapknapsack_solver.KnapsackSolver.
  KNAPSACK_MULTIDIMENSION_BRANCH_AND_BOUND_SOLVER, 'KnapsackExample')
 
  capacities = []
  capacities.append(capacity)
  inner_query_result = plpy.execute(inner_query, 5)
  values = []
  weight1 = []
  weights =[]
  for i in range(5):
    values.append(inner_query_result[i]["cost"])
    weight1.append(inner_query_result[i]["weight"])
  weights.append(weight1)

  solver.Init(values, weights, capacities)
  computed_value = solver.Solve()

  packed_items = []
  packed_weights = []
  packed_values = []
  total_weight = 0
  plpy.warning('Total value =', computed_value)
  for i in range(len(values)):
    if solver.BestSolutionContains(i):
      packed_items.append(i)
      packed_weights.append(weights[0][i])
      packed_values.append(values[i])
      total_weight += weights[0][i]
      yield (i, weights[0][i], values[i])
  plpy.warning('Total weight:', total_weight)
$$ LANGUAGE plpython3u;

SELECT * from vrp_knapsack('SELECT * from knapsack_data' , 15);