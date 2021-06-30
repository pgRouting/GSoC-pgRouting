/*PGR-GNU*****************************************************************
File: edgeColoring_driver.cpp

Generated with Template by:
Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Veenit Kumar
Mail: 123sveenit@gmail.com
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

#include "drivers/coloring/edgeColoring_driver.h"

#include <algorithm>
#include <sstream>
#include <string>
#include <vector>

#include "c_types/graph_enum.h"
#include "coloring/pgr_edgeColoring.hpp"
#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.h"

/************************************************************
  edges_sql TEXT
 ***********************************************************/
void do_pgr_edgeColoring(
    pgr_edge_t *data_edges,
    size_t total_edges,

    pgr_vertex_color_rt **return_tuples,
    size_t *return_count,

    char **log_msg,
    char **notice_msg,
    char **err_msg) {
    std::ostringstream log;
    std::ostringstream err;
    std::ostringstream notice;
    try {
        pgassert(!(*log_msg));
        pgassert(!(*notice_msg));
        pgassert(!(*err_msg));
        pgassert(!(*return_tuples));
        pgassert(*return_count == 0);

        std::vector<pgr_vertex_color_rt> results;

        graphType gType = UNDIRECTED;
        pgrouting::functions::Pgr_edgeColoring::EdgeColoring_Graph undigraph(gType);

        pgrouting::functions::Pgr_edgeColoring fn_edgeColoring;

        fn_edgeColoring.insert_edges(undigraph, data_edges, total_edges);

        results = fn_edgeColoring.edgeColoring(undigraph);

        auto count = results.size();

        if (count == 0) {
            (*return_tuples) = NULL;
            (*return_count) = 0;
            notice << "No traversal found";
            *log_msg = pgr_msg(notice.str().c_str());
            return;
        }

        (*return_tuples) = pgr_alloc(count, (*return_tuples));
        for (size_t i = 0; i < count; i++) {
            *((*return_tuples) + i) = results[i];
        }
        (*return_count) = count;

        pgassert(*err_msg == NULL);
        *log_msg = log.str().empty() ? *log_msg : pgr_msg(log.str().c_str());
        *notice_msg = notice.str().empty() ? *notice_msg : pgr_msg(notice.str().c_str());
    } catch (AssertFailedException &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = pgr_msg(err.str().c_str());
        *log_msg = pgr_msg(log.str().c_str());
    } catch (std::exception &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = pgr_msg(err.str().c_str());
        *log_msg = pgr_msg(log.str().c_str());
    } catch (...) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << "Caught unknown exception!";
        *err_msg = pgr_msg(err.str().c_str());
        *log_msg = pgr_msg(log.str().c_str());
    }
}