/*PGR-GNU*****************************************************************
File: ordering_process.cpp

Copyright (c) 2025 pgRouting developers
Mail: project@pgrouting.org

Developer:
Copyright (c) 2025 pgRouting developers
Mail: wifiblack0131 at gmail.com

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

#include "process/ordering_process.h"

#include <string>

extern "C" {
#include "c_common/postgres_connection.h"
#include "c_common/e_report.h"
#include "c_common/time_msg.h"
}

#include "cpp_common/assert.hpp"
#include "drivers/ordering_driver.hpp"

/**
 * @brief Executes a graph ordering algorithm and returns the computed ordering.
 *
 * Selects and runs one of four graph ordering algorithms (Sloan, Cuthill-McKee, Minimum Degree, or King) on a graph defined by the provided SQL query. The result is an array of ordered node IDs and the count of results.
 *
 * @param edges_sql SQL query string that defines the graph edges.
 * @param which Integer selecting the algorithm: 0 = Sloan, 1 = Cuthill-McKee, 2 = Minimum Degree, 3 = King.
 * @param result_tuples Pointer to an array that will be allocated and filled with the resulting node order.
 * @param result_count Pointer to a variable that will be set to the number of results.
 */
void pgr_process_ordering(
        const char* edges_sql,
        int which,
        int64_t **result_tuples,
        size_t *result_count) {
    pgassert(edges_sql);
    pgassert(!(*result_tuples));
    pgassert(*result_count == 0);
    pgr_SPI_connect();
    char* log_msg = NULL;
    char* notice_msg = NULL;
    char* err_msg = NULL;

    clock_t start_t = clock();
    do_ordering(
            std::string(edges_sql),
            which,
            result_tuples, result_count,
            &log_msg, &notice_msg, &err_msg);
    if (which == 0) {
        time_msg(std::string(" processing pgr_sloanOrdering").c_str(), start_t, clock());
    } else if (which == 1) {
        time_msg(std::string("processing pgr_cuthillMckeeOrdering").c_str(), start_t, clock());
    } else if (which == 2) {
        time_msg(std::string("processing pgr_minDegreeOrdering").c_str(), start_t, clock());
    } else if (which == 3) {
        time_msg(std::string("processing pgr_kingOrdering").c_str(), start_t, clock());
    }


    if (err_msg && (*result_tuples)) {
        pfree(*result_tuples);
        (*result_tuples) = NULL;
        (*result_count) = 0;
    }

    pgr_global_report(&log_msg, &notice_msg, &err_msg);

    pgr_SPI_finish();
}
