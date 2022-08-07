/*PGR-GNU*****************************************************************
File: multiple_knapsack.sql

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
DROP FUNCTION IF EXISTS vrp_multiple_knapsack CASCADE;
DROP TABLE IF EXISTS multiple_knapsack_data CASCADE;

CREATE TABLE multiple_knapsack_data(
  weight INTEGER,
  cost INTEGER);

INSERT INTO multiple_knapsack_data (weight,  cost)
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


CREATE OR REPLACE FUNCTION vrp_multiple_knapsack(
  inner_query TEXT, -- weights_cost SQL
  capacities INTEGER[], -- ARRAY of Knapsack Capacities
  max_rows INTEGER = 100000 -- Maximum number of rows to be fetched. Default value is 100000.
)
RETURNS TEXT
AS $$
  try:
    from ortools.linear_solver import pywraplp
  except Exception as err:
    plpy.error(err)
    return "Failed"

  data = {}
  data['values'] = []
  data['weights'] = []

  plpy.notice('Entering Mulitple Knapsack program')
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

  for i in range(num_of_rows):
    if type(inner_query_result[i]["cost"]) == int:
      data['values'].append(inner_query_result[i]["cost"])
    else:
      plpy.error("Type Mismatch. Check Table Data")
      return "Failed"
    if type(inner_query_result[i]["weight"]) == int:
      data['weights'].append(inner_query_result[i]["weight"])
    else:
      plpy.error("Type Mismatch. Check Table Data")
      return "Failed"

  data['num_items'] = len(data['weights'])
  data['all_items'] = range(data['num_items'])
    
  data['bin_capacities'] = capacities
  data['num_bins'] = len(data['bin_capacities'])
  data['all_bins'] = range(data['num_bins'])
  
  try:
    solver = pywraplp.Solver.CreateSolver('SCIP')
  except:
    plpy.error("Unable to Initialize solver")

  if solver is None:
    plpy.error('SCIP solver unavailable.')
    return "Failed"
  
  plpy.notice('SCIP solver ready!')
  x = {}
  for i in data['all_items']:
    for b in data['all_bins']:
        x[i, b] = solver.BoolVar(f'x_{i}_{b}')

  for i in data['all_items']:
    solver.Add(sum(x[i, b] for b in data['all_bins']) <= 1)

  for b in data['all_bins']:
    solver.Add(sum(x[i, b] * data['weights'][i] for i in data['all_items']) <= data['bin_capacities'][b])

  objective = solver.Objective()
  for i in data['all_items']:
    for b in data['all_bins']:
        objective.SetCoefficient(x[i, b], data['values'][i])
  objective.SetMaximization()

  status = solver.Solve()

  if status == pywraplp.Solver.OPTIMAL:
    plpy.info('Total value =', objective.Value())
    total_weight = 0
    for b in data['all_bins']:
        plpy.info('Bin :', b)
        bin_weight = 0
        bin_value = 0
        for i in data['all_items']:
            if x[i, b].solution_value() > 0:
                plpy.info(f"Item {i} - weight: {data['weights'][i]} value: {data['values'][i]}")
                bin_weight += data['weights'][i]
                bin_value += data['values'][i]
        plpy.info('Packed bin weight', bin_weight)
        plpy.info('Packed bin value', bin_value)
        total_weight += bin_weight
    plpy.info('Total packed weight', total_weight)
  else:
    plpy.notice('The problem does not have an optimal solution.')
  plpy.notice('Exiting Multiple Knapsack program')
  return "Success"
$$ LANGUAGE plpython3u VOLATILE STRICT;

-- SELECT * FROM vrp_multiple_knapsack('SELECT * FROM multiple_knapsack_data', ARRAY[100,100,100,100,100]);

-- COMMENTS

COMMENT ON FUNCTION vrp_multiple_knapsack(TEXT, INTEGER[], INTEGER)
IS 'vrp_multiple_knapsack
- Documentation:
  - ${PROJECT_DOC_LINK}/vrp_multiple_knapsack.html
';