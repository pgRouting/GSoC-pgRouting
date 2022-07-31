DROP FUNCTION IF EXISTS vrp_multiple_knapsack CASCADE;
DROP TYPE IF EXISTS multiple_knapsack_items CASCADE;
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

create type multiple_knapsack_items as(
  index integer,
  weight integer,
  cost integer
);

CREATE FUNCTION vrp_multiple_knapsack(inner_query text, capacities integer[])
  RETURNS SETOF multiple_knapsack_items
AS $$
  from ortools.linear_solver import pywraplp

  data = {}
  data['values'] = []
  data['weights'] = []
  inner_query_result = plpy.execute(inner_query, 15)
  for i in range(15):
    data['values'].append(inner_query_result[i]["cost"])
    data['weights'].append(inner_query_result[i]["weight"])

  data['num_items'] = len(data['weights'])
  data['all_items'] = range(data['num_items'])
    
  data['bin_capacities'] = capacities
  data['num_bins'] = len(data['bin_capacities'])
  data['all_bins'] = range(data['num_bins'])

  solver = pywraplp.Solver.CreateSolver('SCIP')
  if solver is None:
    plpy.error('SCIP solver unavailable.')

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
    plpy.warning('Total value =', objective.Value())
    total_weight = 0
    for b in data['all_bins']:
        plpy.warning('Bin :', b)
        bin_weight = 0
        bin_value = 0
        for i in data['all_items']:
            if x[i, b].solution_value() > 0:
                yield(i, data['weights'][i], data['values'][i])
                bin_weight += data['weights'][i]
                bin_value += data['values'][i]
        plpy.warning('Packed bin weight', bin_weight)
        plpy.warning('Packed bin value', bin_value)
        total_weight += bin_weight
    plpy.warning('Total packed weight', total_weight)
  else:
    plpy.error('The problem does not have an optimal solution.')
$$ LANGUAGE plpython3u;

SELECT * from vrp_multiple_knapsack('SELECT * from multiple_knapsack_data', ARRAY[100,100,100,100,100]);

--Have to learn how to leave space