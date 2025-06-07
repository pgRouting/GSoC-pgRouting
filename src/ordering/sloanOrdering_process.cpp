/*PGR-GNU*****************************************************************
File: sloanOrdering_process.cpp

Copyright (c) 2025 pgRouting developers
Mail: project@pgrouting.org

Design of one process & driver file by
Copyright (c) 2025 Bipasha Gayary
Mail: bipashagayary at gmail.com

Copying this file (or a derivative) within pgRouting code add the following:

Generated with Template by:
Copyright (c) 2025 pgRouting developers
Mail: project@pgrouting.org

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

#include "process/sloanOrdering_process.h"

#include <string>

extern "C" {
#include "c_common/postgres_connection.h"
#include "c_common/e_report.h"
#include "c_common/time_msg.h"
}

#include "c_types/ii_t_rt.h"
#include "cpp_common/assert.hpp"
#include "drivers/ordering/sloanOrdering_driver.hpp"

/**
 which = 0 -> sloan

 This is c++ code, linked as C code, because pgr_process_sloanOrdering is called from C code
 */
void pgr_process_sloanOrdering(
        const Edge_t* edges_sql,
        size_t total_edges,
        int64_t start_vid,
	int64_t end_vid,
        II_t_rt **result_tuples,
        size_t *result_count) {
    pgassert(edges_sql);
    pgassert(!(*result_tuples));
    pgassert(*result_count == 0);
    pgr_SPI_connect();
    char* log_msg = NULL;
    char* notice_msg = NULL;
    char* err_msg = NULL;

    clock_t start_t = clock();
    do_sloanOrdering(
            edges_sql,
            total_edges,
	    start_vid,
	    end_vid,
            result_tuples, result_count,
            &log_msg, &err_msg);

    time_msg(std::string(" processing pgr_johnson").c_str(), start_t, clock());

    if (err_msg && (*result_tuples)) {
        pfree(*result_tuples);
        (*result_tuples) = NULL;
        (*result_count) = 0;
    }

    pgr_global_report(&log_msg, &notice_msg, &err_msg);

    pgr_SPI_finish();
}
