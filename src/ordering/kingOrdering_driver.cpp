/*PGR-GNU*****************************************************************
File: kingOrdering_driver.cpp
Generated with Template by:
Copyright (c) 2025 pgRouting developers
Mail: project@pgrouting.org
Function's developer:
Copyright (c) 2025 Fan Wu
Mail: wifiblack0131@gmail.com
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

#include "drivers/ordering/kingOrdering_driver.h"

#include <sstream>
#include <vector>
#include <algorithm>
#include <string>

#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "c_types/ii_t_rt.h"

#include "ordering/kingOrdering.hpp"

/** @file kingOrdering_driver.cpp
 * @brief Handles actual calling of function in the `kingOrdering.hpp` file.
 *
 */

/***********************************************************************
 *
 *   pgr_kingOrdering(edges_sql TEXT);
 *
 ***********************************************************************/

namespace {

/** @brief Calls the main function defined in the C++ Header file.
 *
 * @param graph      the graph containing the edges
 *
 * @returns results, when results are found
 */

template <class G>
/**
 * @brief Executes the king ordering algorithm on the provided graph.
 *
 * @tparam G Type of the graph object.
 * @param graph Reference to the graph on which to perform king ordering.
 * @return std::vector<II_t_rt> Results of the king ordering algorithm.
 */
std::vector <II_t_rt>
kingOrdering(G &graph) {
    pgrouting::functions::kingOrdering <G> fn_kingOrdering;
    auto results = fn_kingOrdering.kingOrdering(graph);
    return results;
}

}  /**
 * @brief Executes the king ordering algorithm on a graph defined by an SQL edges query.
 *
 * Fetches edges from the database using the provided SQL query, constructs an undirected graph, and computes the king ordering. Results are returned as an array of II_t_rt structures, with the count updated accordingly. Logging, notice, and error messages are set via the provided pointers. If no edges or results are found, appropriate notice messages are set and the function returns early.
 */


void 
pgr_do_kingOrdering(
    const char *edges_sql,

    II_t_rt **return_tuples,
    size_t *return_count,

    char **log_msg,
    char **notice_msg,
    char **err_msg) {
        using pgrouting::pgr_alloc;
        using pgrouting::to_pg_msg;
        using pgrouting::pgr_free;

        std::ostringstream log;
        std::ostringstream err;
        std::ostringstream notice;
        const char *hint = nullptr;

        try {
            pgassert(!(*log_msg));
            pgassert(!(*notice_msg));
            pgassert(!(*err_msg));
            pgassert(!(*return_tuples));
            pgassert(*return_count == 0);

            hint = edges_sql;
            auto edges = pgrouting::pgget::get_edges(std::string(edges_sql), true, false);
            if (edges.empty()) {
                *notice_msg = to_pg_msg("No edges found");
                *log_msg = hint? to_pg_msg(hint) : to_pg_msg(log);
                return;
            }
            hint = nullptr;

            std::vector<II_t_rt>results;
            pgrouting::UndirectedGraph undigraph;
            undigraph.insert_edges(edges);
            results = kingOrdering(undigraph);

            auto count = results.size();

            if (count == 0) {
                (*return_tuples) = NULL;
                (*return_count) = 0;
                notice << "No results found";
                *log_msg = to_pg_msg(log);
            }

            (*return_tuples) = pgr_alloc(count, (*return_tuples));
            for (size_t i = 0; i < count; i++) {
                *((*return_tuples) + i) = results[i];
            }
            (*return_count) = count;

            pgassert(*err_msg == NULL);
            *log_msg = log.str().empty() ?
            *log_msg :
            to_pg_msg(log);
            *notice_msg = notice.str().empty() ?
            *notice_msg :
            to_pg_msg(notice);
        } catch (AssertFailedException &except) {
            (*return_tuples) = pgr_free(*return_tuples);
            (*return_count) = 0;
            err << except.what();
            *err_msg = to_pg_msg(err);
            *log_msg = to_pg_msg(log);
        } catch (const std::string &ex) {
            *err_msg = to_pg_msg(ex);
            *log_msg = hint? to_pg_msg(hint) : to_pg_msg(log);
        } catch (std::exception &except) {
            (*return_tuples) = pgr_free(*return_tuples);
            (*return_count) = 0;
            err << except.what();
            *err_msg = to_pg_msg(err);
            *log_msg = to_pg_msg(log);
        } catch (...) {
            (*return_tuples) = pgr_free(*return_tuples);
            (*return_count) = 0;
            err << "Caught unknown exception!";
            *err_msg = to_pg_msg(err);
            *log_msg = to_pg_msg(log);
        }
}
