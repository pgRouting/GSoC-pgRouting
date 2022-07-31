DROP FUNCTION IF EXISTS vrp_bin_packing CASCADE;
DROP TABLE IF EXISTS bin_packing_data CASCADE;

CREATE TABLE bin_packing_data(
  weight INTEGER);

INSERT INTO bin_packing_data (weight)
VALUES
(48), (30), (19), (36), (36), (27), (42), (42), (36), (24), (30);


CREATE FUNCTION vrp_bin_packing(inner_query text, bin_capacity integer)
  RETURNS integer
AS $$
  from ortools.linear_solver import pywraplp
  inner_query_result = plpy.execute(inner_query, 11)
  data = {}
  weights = []
  for i in range(11):
    weights.append(inner_query_result[i]["weight"])
  data['weights'] = weights
  data['items'] = list(range(len(weights)))
  data['bins'] = data['items']
  data['bin_capacity'] = bin_capacity
    
  solver = pywraplp.Solver.CreateSolver('SCIP')  
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
    solver.Add(sum(x[(i, j)] * data['weights'][i] for i in data['items']) <= y[j] * data['bin_capacity'])

  solver.Minimize(solver.Sum([y[j] for j in data['bins']]))

  status = solver.Solve()

  if status == pywraplp.Solver.OPTIMAL:
    num_bins = 0.
    for j in data['bins']:
      if y[j].solution_value() == 1:
        bin_items = []
        bin_weight = 0
        for i in data['items']:
          if x[i, j].solution_value() > 0:
            bin_items.append(i)
            bin_weight += data['weights'][i]
        if bin_weight > 0:
          num_bins += 1
          plpy.warning('Bin number', j)
          plpy.warning('  Items packed', bin_items)
          plpy.warning('  Total weight', bin_weight)
    plpy.warning('Number of bins used', num_bins)
  else:
    plpy.error('The problem does not have an optimal solution')
  return 1
$$ LANGUAGE plpython3u;

SELECT * from vrp_bin_packing('SELECT * from bin_packing_data', 100);