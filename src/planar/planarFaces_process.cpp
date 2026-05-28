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

#include "process/planarFaces_process.h"

extern "C" {
#include "c_common/postgres_connection.h"
#include "c_common/e_report.h"
#include "c_common/time_msg.h"
}

#include <string>

#include "cpp_common/assert.hpp"
#include "drivers/planarFaces_driver.hpp"

void pgr_process_planarFaces(
        const char *edges_sql,
        Planar_face_rt **result_tuples,
        size_t *result_count) {
    pgassert(edges_sql);
    pgassert(!(*result_tuples));
    pgassert(*result_count == 0);

    pgr_SPI_connect();
    char *log_msg = NULL;
    char *notice_msg = NULL;
    char *err_msg = NULL;

    clock_t start_t = clock();
    do_planarFaces(
            std::string(edges_sql),
            result_tuples, result_count,
            &log_msg, &notice_msg, &err_msg);

    time_msg(" processing pgr_planarFaces", start_t, clock());

    if (err_msg && (*result_tuples)) {
        pfree(*result_tuples);
        (*result_tuples) = NULL;
        (*result_count) = 0;
    }

    pgr_global_report(&log_msg, &notice_msg, &err_msg);

    pgr_SPI_finish();
}
