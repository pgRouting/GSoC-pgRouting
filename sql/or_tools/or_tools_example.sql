-- https://developers.google.com/optimization/introduction/python

DROP FUNCTION IF EXISTS pymax;

CREATE FUNCTION pymax (a integer, b integer)
  RETURNS float
AS $$
    from ortools.linear_solver import pywraplp
    solver = pywraplp.Solver.CreateSolver('GLOP')
    x = solver.NumVar(0, 1, 'x')
    y = solver.NumVar(0, 2, 'y')
    
    ct = solver.Constraint(0, 2, 'ct')
    ct.SetCoefficient(x, 1)
    ct.SetCoefficient(y, 1)

    objective = solver.Objective()
    objective.SetCoefficient(x, 3)
    objective.SetCoefficient(y, 1)
    objective.SetMaximization()

    solver.Solve()

$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION python_version()
    RETURNS pg_catalog.text AS $BODY$

    import sys
    plpy.info(sys.version)    
    return 'finish'
    $BODY$
LANGUAGE plpython3u VOLATILE SECURITY DEFINER