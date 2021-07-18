/*PGR-GNU*****************************************************************
File: vrp_vroom.sql

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

    vrp_vroom(Jobs SQL, Shipments SQL, Vehicles SQL, Matrix SQL)  -- Experimental on v0.2

    RETURNS SET OF
    (seq, vehicle_seq, vehicle_id, step_seq, step_type, task_id,
     arrival, travel_time, service_time, waiting_time, load)

signature end

parameters start

=================== ======================== =================================================
Parameter           Type                     Description
=================== ======================== =================================================
**Jobs SQL**        ``TEXT``                 `Jobs SQL`_ query describing the places to visit.
**Shipments SQL**   ``TEXT``                 `Shipments SQL`_ query describing pickup and delivery tasks.
**Vehicles SQL**    ``TEXT``                 `Vehicles SQL`_ query describing the available vehicles.
**Matrix SQL**      ``TEXT``                 `Time Matrix SQL`_ query containing the distance or
                                             travel times between the locations.
=================== ======================== =================================================

parameters end

result start

=================== ============= =================================================
Column              Type           Description
=================== ============= =================================================
**seq**              ``BIGINT``   Sequential value starting from **1**.

**vehicle_seq**      ``BIGINT``   Sequential value starting from **1** for current vehicles.
                                  The :math:`n^{th}` vehicle in the solution.

**vehicle_id**       ``BIGINT``   Current vehicle identifier.

**step_seq**         ``BIGINT``   Sequential value starting from **1** for the stops
                                  made by the current vehicle. The :math:`m^{th}` stop
                                  of the current vehicle.

**step_type**        ``INTEGER``  Kind of the step location the vehicle is at:

                                  - ``1``: Starting location
                                  - ``2``: Job location
                                  - ``3``: Pickup location
                                  - ``4``: Delivery location
                                  - ``5``: Break location
                                  - ``6``: Ending location

**task_id**          ``BIGINT``   Identifier of the task performed at this step.

**arrival**          ``INTEGER``  Estimated time of arrival at this step, in seconds.

**travel_time**      ``INTEGER``  Cumulated travel time upon arrival at this step, in seconds

**service_time**     ``INTEGER``  Service time at this step, in seconds

**waiting_time**     ``INTEGER``  Waiting time upon arrival at this step, in seconds.

**load**             ``BIGINT``   Vehicle load after step completion (with capacity constraints)
=================== ============= =================================================

result end
*/

-- v0.2
CREATE FUNCTION vrp_vroom(
    TEXT,  -- jobs_sql (required)
    TEXT,  -- shipments_sql (required)
    TEXT,  -- vehicles_sql (required)
    TEXT,  -- matrix_sql (required)

    OUT seq BIGINT,
    OUT vehicle_seq BIGINT,
    OUT vehicle_id BIGINT,
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
    FROM _vrp_vroom(_pgr_get_statement($1), _pgr_get_statement($2), _pgr_get_statement($3),
                    _pgr_get_statement($4));
$BODY$
LANGUAGE SQL VOLATILE STRICT;


-- COMMENTS

COMMENT ON FUNCTION vrp_vroom(TEXT, TEXT, TEXT, TEXT)
IS 'vrp_vroom
 - EXPERIMENTAL
 - Parameters:
   - Jobs SQL with columns:
       id, location_index [, service, delivery, pickup, skills, priority, time_windows]
   - Shipments SQL with columns:
       p_id, p_location_index [, p_service, p_time_windows],
       d_id, d_location_index [, d_service, d_time_windows] [, amount, skills, priority]
   - Vehicles SQL with columns:
       id, start_index, end_index
       [, service, delivery, pickup, skills, priority, time_window, breaks_sql, steps_sql]
   - Matrix SQL with columns:
        start_vid, end_vid, agg_cost
- Documentation:
   - ${PROJECT_DOC_LINK}/vrp_vroom.html
';
