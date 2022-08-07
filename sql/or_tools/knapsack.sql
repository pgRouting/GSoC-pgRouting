DROP FUNCTION IF EXISTS vrp_knapsack;
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

CREATE FUNCTION vrp_knapsack(inner_query text, capacity integer, max_rows integer = 100000)
  RETURNS text
AS $$
  try:
    from ortools.algorithms import pywrapknapsack_solver
  except Error as err:
    plpy.error(err)
    return "Failed"
  
  try:
    solver = pywrapknapsack_solver.KnapsackSolver(
    pywrapknapsack_solver.KnapsackSolver.
    KNAPSACK_MULTIDIMENSION_BRANCH_AND_BOUND_SOLVER, 'KnapsackExample')
  except:
    plpy.error('Unable to Initialize Knapsack Solver')
    return "Failed"

 
  capacities = []
  capacities.append(capacity)

  plpy.notice('Entering Knapsack program')
  plpy.notice('Starting Execution of inner query')

  try:
    inner_query_result = plpy.execute(inner_query, max_rows)
    num_of_rows = inner_query_result.nrows()
    colnames = inner_query_result.colnames()
    coltypes = inner_query_result.coltypes()
    plpy.info("Number of rows processed : ", num_of_rows)
  except plpy.SPIError as error_msg:
    plpy.info("Details: ",error_msg)
    plpy.error("Error Processing Inner Query. The given query is not a valid SQL command")
    return "Failed"
  
  if len(colnames) != 2:
    plpy.error("Expected 2 columns, Got ", len(colnames))
    return "Failed"
  if ('weight' in colnames) and ('cost' in colnames):
    plpy.notice("SQL query returned expected column names")
  else:
    plpy.error("Expected columns weight and cost, Got ", colnames)
    return "Failed"  
  if coltypes == [23, 23]:
    plpy.notice("SQL query returned expected column types")
  else:
    plpy.error("Returned columns of different type. Expected Integer, Integer")

  plpy.notice('Finished Execution of inner query')

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
  plpy.info('Total weight:', total_weight)
  plpy.info("Packed items: ", packed_items)
  plpy.info("Packed weights: ", packed_weights)
  plpy.info("Packed values: ", packed_values)
  plpy.notice("Exiting program")
  return "Success"
$$ LANGUAGE plpython3u;

-- SELECT * FROM vrp_knapsack('SELECT * FROM knapsack_data' , 15);