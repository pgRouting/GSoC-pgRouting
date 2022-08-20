/*PGR-GNU*****************************************************************
File: bin_packing.sql

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
DROP FUNCTION IF EXISTS vrp_bin_packing CASCADE;
-- DROP TABLE IF EXISTS bin_packing_data CASCADE;

-- CREATE TABLE bin_packing_data(
--   weight INTEGER);

-- INSERT INTO bin_packing_data (weight)
-- VALUES
-- (48), (30), (19), (36), (36), (27), (42), (42), (36), (24), (30);


CREATE OR REPLACE FUNCTION vrp_bin_packing(
  inner_query TEXT, -- weights SQL
  bin_capacity INTEGER, -- Bin Capacity
  max_rows INTEGER = 100000 -- Maximum number of rows to be fetched. Default is value = 100000.
)
RETURNS TEXT
AS $$
  try:
    from ortools.linear_solver import pywraplp
  except Exception as err:
    plpy.error(err)
    return "Failed"
  
  global max_rows
  if inner_query == None:
    raise Exception('Inner Query Cannot be NULL')
  if bin_capacity == None:
    raise Exception('Capacity Cannot be NULL')
  if max_rows == None:
    max_rows = 100000
  
  plpy.notice('Entering Bin Packing program')
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

  if len(colnames) != 1:
    plpy.error("Expected 1 column, Got ", len(colnames))
    return "Failed"
  if ('weight' in colnames):
    plpy.notice("SQL query returned expected column names")
  else:
    plpy.error("Expected column weight, Got ", colnames)
    return "Failed"  
  if all(item in [20, 21, 23] for item in coltypes):
    plpy.notice("SQL query returned expected column types")
  else:
    raise Exception("Returned columns of different type. Expected Integer")
  
  plpy.notice('Finished Execution of inner query')
  data = {}
  weights = []

  for i in range(num_of_rows):
    if type(inner_query_result[i]["weight"]) == int:
      weights.append(inner_query_result[i]["weight"])
    else:
      plpy.error("Type Mismatch. Check Table Data")
      return "Failed"

  data['weights'] = weights
  data['items'] = list(range(len(weights)))
  data['bins'] = data['items']
  data['bin_capacity'] = bin_capacity
  
  try:
    solver = pywraplp.Solver.CreateSolver('SCIP')  
  except:
    plpy.error("Unable to Initialize solver")
  
  if solver is None:
    plpy.error('SCIP solver unavailable.')
    return "Failed"
  
  plpy.notice('SCIP solver ready!')

  x = {}
  for i in data['items']:
    for j in data['bins']:
      x[(i, j)] = solver.IntVar(0, 1, 'x_%i_%i' % (i, j))

  y = {}
  for j in data['bins']:
     y[j] = solver.IntVar(0, 1, 'y[%i]' % j)

  for i in data['items']:
    solver.Add(sum(x[i, j] for j in data['bins']) == 1)

  for j in data['bins']:
    solver.Add(sum(x[(i, j)] * data['weights'][i] 
    for i in data['items']) <= y[j] * data['bin_capacity'])

  solver.Minimize(solver.Sum([y[j] for j in data['bins']]))

  status = solver.Solve()

  if status == pywraplp.Solver.OPTIMAL:
    num_bins = 0.
    for j in data['bins']:
      if y[j].solution_value() == 1:
        bin_items = []
        bin_weights = []
        bin_values = []
        bin_weight = 0
        bin_value = 0
        for i in data['items']:
          if x[i, j].solution_value() > 0:
            bin_items.append(i)
            bin_weights.append(data['weights'][i])
            bin_weight += data['weights'][i]
        if bin_weight > 0:
          num_bins += 1
          plpy.info('Bin number', j)
          plpy.info('  Items packed', bin_items)
          plpy.info('  Item weights', bin_weights)
          plpy.info('  Total weight', bin_weight)
    plpy.info('Number of bins used', num_bins)
  else:
    plpy.notice('The problem does not have an optimal solution')
  plpy.notice('Exiting Bin Packing program')
  return "Success"
$$ LANGUAGE plpython3u VOLATILE;

-- SELECT * FROM vrp_bin_packing('SELECT * FROM bin_packing_data', 100);

-- COMMENTS

COMMENT ON FUNCTION vrp_bin_packing(TEXT, INTEGER, INTEGER)
IS 'vrp_bin_packing
- Documentation:
  - ${PROJECT_DOC_LINK}/vrp_bin_packing.html
';