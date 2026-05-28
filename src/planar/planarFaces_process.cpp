/*PGR-GNU*****************************************************************

File: planarFaces_process.cpp

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

/* postgres.h must be first when PostgreSQL headers are used */
#include <postgres.h>

#include "process/planarFaces_process.h"
#include "drivers/planarFaces_driver.hpp"

void
pgr_process_planarFaces(
        const char* edges_sql,
        Planar_face_rt** result_tuples,
        size_t* result_count) {
    char* log_msg    = nullptr;
    char* notice_msg = nullptr;
    char* err_msg    = nullptr;

    do_planarFaces(
            std::string(edges_sql),
            result_tuples,
            result_count,
            &log_msg,
            &notice_msg,
            &err_msg);

    if (err_msg) {
        ereport(ERROR,
                (errcode(ERRCODE_INTERNAL_ERROR),
                 errmsg("%s", err_msg)));
    }

    if (log_msg)    pfree(log_msg);
    if (notice_msg) pfree(notice_msg);
}
