/*PGR-GNU*****************************************************************
File: _vrp_vroom.sql

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

-- v0.2
CREATE FUNCTION vrp_vroom(
    TEXT,  -- jobs_sql (required)
    TEXT,  -- shipments_sql (required)
    TEXT,  -- vehicles_sql (required)
    TEXT,  -- matrix_sql (required)

    plan BOOLEAN DEFAULT FALSE,

    OUT seq BIGINT,
    OUT vehicles_seq BIGINT,
    OUT vehicles_id BIGINT,
    OUT step_seq BIGINT,
    OUT step_type INTEGER,
    OUT task_id BIGINT,
    OUT arrival INTEGER,
    OUT duration INTEGER,
    OUT service_time INTEGER,
    OUT waiting_time INTEGER,
    OUT load BIGINT[])
RETURNS SETOF RECORD AS
$BODY$
    SELECT *
    FROM _vrp_vroom(_pgr_get_statement($1), _pgr_get_statement($2), _pgr_get_statement($3),
                    _pgr_get_statement($4), $5);
$BODY$
LANGUAGE SQL VOLATILE;

-- COMMENTS

COMMENT ON FUNCTION vrp_vroom(TEXT, TEXT, TEXT, TEXT, BOOLEAN)
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
   - 2-D Time Matrix.
 - Optional Parameters:
   - plan := FALSE
- Documentation:
   - ${PROJECT_DOC_LINK}/vrp_vroom.html
';
