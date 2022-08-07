/*PGR-GNU*****************************************************************
File: or_tools_example.sql

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