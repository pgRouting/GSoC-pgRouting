try:
    from ortools.linear_solver import pywraplp
except Error as err:
    plpy.fatal(err)

plpy.notice('Entering Bin Packing program')
plpy.notice('Starting Execution of inner query')

try:
    inner_query_result = plpy.execute(inner_query, max_rows)
    plpy.info("Number of rows processed : ", inner_query_result.nrows())
except plpy.SPIError as error_msg:
    plpy.info("Details: ",error_msg)
    plpy.error("Error Processing Inner Query.The given query is not a valid SQL command")
    return

plpy.notice('Finished Execution of inner query')
data = {}
weights = []

for i in range(11):
    weights.append(inner_query_result[i]["weight"])
data['weights'] = weights
data['items'] = list(range(len(weights)))
data['bins'] = data['items']
data['bin_capacity'] = bin_capacity

try:
    solver = pywraplp.Solver.CreateSolver('SCIP')
except:
    plpy.fatal("Unable to Initialize solver")

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
    plpy.fatal('The problem does not have an optimal solution')
plpy.notice('Exiting Bin Packing program')
return
