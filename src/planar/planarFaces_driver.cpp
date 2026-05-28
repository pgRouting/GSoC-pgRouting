/*PGR-GNU*****************************************************************

File: planarFaces_driver.cpp

Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2026 Sakir Ahmed
Mail: sakirahmed75531 at gmail.com

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
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

#include "drivers/planar/planarFaces_driver.h"

#include <string>

#include "c_types/planar_face_rt.h"

void
pgr_do_planarFaces(
        const char* edges_sql,
        Planar_face_rt** result_tuples,
        size_t* result_count,
        char** log_msg,
        char** notice_msg,
        char** err_msg) {
    *result_tuples = nullptr;
    *result_count  = 0;
    if (log_msg)    *log_msg    = nullptr;
    if (notice_msg) *notice_msg = nullptr;
    if (err_msg)    *err_msg    = nullptr;

    /* TODO(week-2): implement planar face traversal algorithm here */
    (void)edges_sql;
}
