DROP FUNCTION IF EXISTS vrp_knapsack;
DROP TYPE IF EXISTS knapsack_items;
DROP TABLE IF EXISTS knapsack_data;

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

CREATE FUNCTION vrp_knapsack(inner_query text, capacity integer, max_rows integer = 100000)
  RETURNS SETOF knapsack_items
AS $$
  try:
    from ortools.algorithms import pywrapknapsack_solver
  except Error as err:
    plpy.error(err)
    return
  
  try:
    solver = pywrapknapsack_solver.KnapsackSolver(
    pywrapknapsack_solver.KnapsackSolver.
    KNAPSACK_MULTIDIMENSION_BRANCH_AND_BOUND_SOLVER, 'KnapsackExample')
  except:
    plpy.error('Unable to Initialize Knapsack Solver')
    return

 
  capacities = []
  capacities.append(capacity)

  plpy.notice('Entering Mulitple Knapsack program')
  plpy.notice('Starting Execution of inner query')

  try:
    inner_query_result = plpy.execute(inner_query, max_rows)
    num_of_rows = inner_query_result.nrows()
    plpy.info("Number of rows processed : ", num_of_rows)
  except plpy.SPIError as error_msg:
    plpy.info("Details: ",error_msg)
    plpy.error("Error Processing Inner Query. The given query is not a valid SQL command")
    return

  values = []
  weight1 = []
  weights =[]
  for i in range(num_of_rows):
    values.append(inner_query_result[i]["cost"])
    weight1.append(inner_query_result[i]["weight"])
  weights.append(weight1)

  solver.Init(values, weights, capacities)
  computed_value = solver.Solve()

  packed_items = []
  packed_weights = []
  packed_values = []
  total_weight = 0

  plpy.info('Total value =', computed_value)
  for i in range(len(values)):
    if solver.BestSolutionContains(i):
      packed_items.append(i)
      packed_weights.append(weights[0][i])
      packed_values.append(values[i])
      total_weight += weights[0][i]
      yield (i, weights[0][i], values[i])
  plpy.info('Total weight:', total_weight)
$$ LANGUAGE plpython3u;

-- SELECT * from vrp_knapsack('SELECT * from knapsack_data' , 15);