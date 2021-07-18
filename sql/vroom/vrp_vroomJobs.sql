/*PGR-GNU*****************************************************************
File: vrp_vroomJobs.sql

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Ashish Kumar
Mail: ashishkr23438@gmail.com

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

/*
signature start

.. code-block:: none

    vrp_vroom(Jobs SQL, Vehicles SQL, Matrix SQL)

    RETURNS SET OF
    (seq, vehicle_sql, vehicle_id, step_seq, step_type, task_id,
     arrival, duration, service_time, waiting_time, load)

signature end

parameters start

=================== ======================== =================================================
Parameter           Type                     Description
=================== ======================== =================================================
**Jobs SQL**        ``TEXT``                 `Jobs SQL`_ query describing the places to visit.
**Vehicles SQL**    ``TEXT``                 `Vehicles SQL`_ query describing the available vehicles.
**Matrix SQL**      ``TEXT``                 `Time Matrix SQL`_ query containing the distance or
                                             travel times between the locations.
=================== ======================== =================================================

parameters end

*/

-- v0.2
CREATE FUNCTION vrp_vroomJobs(
    TEXT,  -- jobs_sql (required)
    TEXT,  -- vehicles_sql (required)
    TEXT,  -- matrix_sql (required)

    OUT seq BIGINT,
    OUT vehicles_seq BIGINT,
    OUT vehicles_id BIGINT,
    OUT step_seq BIGINT,
    OUT step_type INTEGER,
    OUT task_id BIGINT,
    OUT arrival INTEGER,
    OUT travel_time INTEGER,
    OUT service_time INTEGER,
    OUT waiting_time INTEGER,
    OUT load BIGINT[])
RETURNS SETOF RECORD AS
$BODY$
    SELECT *
    FROM _vrp_vroom(_pgr_get_statement($1), NULL, _pgr_get_statement($2),
                    _pgr_get_statement($3));
$BODY$
LANGUAGE SQL VOLATILE STRICT;


-- COMMENTS

COMMENT ON FUNCTION vrp_vroomJobs(TEXT, TEXT, TEXT)
IS 'vrp_vroom
 - EXPERIMENTAL
 - Parameters:
   - Jobs SQL with columns:
       id, location_index [, service, delivery, pickup, skills, priority, time_windows]
   - Vehicles SQL with columns:
       id, start_index, end_index
       [, service, delivery, pickup, skills, priority, time_window, breaks_sql, steps_sql]
   - Matrix SQL with columns:
        start_vid, end_vid, agg_cost
- Documentation:
   - ${PROJECT_DOC_LINK}/vrp_vroom.html
';
