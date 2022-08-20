
/*PGR-GNU*****************************************************************
File: knapsack.sql

Copyright (c) 2022 GSoC-2022 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Manas Sivakumar

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/
DROP FUNCTION IF EXISTS vrp_knapsack CASCADE;
DROP TABLE IF EXISTS knapsack_data;

CREATE TABLE knapsack_data(
  weight NUMERIC,
  cost INTEGER);

INSERT INTO knapsack_data (weight,  cost)
VALUES
(12, 4),
(2, 2),
(1, 1),
(4, 10),
(1, 2);

CREATE OR REPLACE FUNCTION vrp_knapsack(
  inner_query TEXT, -- weights_cost SQL
  capacity INTEGER, -- Knapsack Capacity
  max_rows INTEGER = 100000 -- Maximum number of rows to be fetched. Default is 100000.
)
RETURNS TEXT
AS $$
  try:
    from ortools.algorithms import pywrapknapsack_solver
  except Exception as err:
    plpy.error(err)
    return "Failed"
  
  global max_rows
  if inner_query == None:
    raise Exception('Inner Query Cannot be NULL')
  if capacity == None:
    raise Exception('Capacity Cannot be NULL')
  if max_rows == None:
    max_rows = 100000
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
  if all(item in [20, 21, 23] for item in coltypes):
    plpy.notice("SQL query returned expected column types")
  else:
    raise Exception("Returned columns of different type. Expected Integer, Integer")

  plpy.notice('Finished Execution of inner query')

  values = []
  weight1 = []
  weights =[]
  for i in range(num_of_rows):
    values.append(inner_query_result[i]["cost"])
    weight1.append(inner_query_result[i]["weight"])
  weights.append(weight1)
  
  try:
    solver.Init(values, weights, capacities)
  except Exception as error_msg:
    plpy.error(error_msg)
    return "Failed"
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
$$ LANGUAGE plpython3u VOLATILE;

-- SELECT * FROM vrp_knapsack('SELECT * FROM knapsack_data' , 15);

-- COMMENTS

COMMENT ON FUNCTION vrp_knapsack(TEXT, INTEGER, INTEGER)
IS 'vrp_knapsack
- Documentation:
  - ${PROJECT_DOC_LINK}/vrp_knapsack.html
';
