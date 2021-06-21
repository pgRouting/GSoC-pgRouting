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

#include <sstream>
#include <vector>
#include <algorithm>
#include <string>

#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.h"

#include "coloring/edgeColoring.hpp"

//new file


#include <boost/graph/iteration_macros.hpp>
#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/graph_utility.hpp>

#include <deque>
#include <vector>
#include <set>
#include <map>
#include <limits>

#include "c_types/graph_enum.h"

#include "cpp_common/basic_vertex.h"
#include "cpp_common/xy_vertex.h"
#include "cpp_common/basic_edge.h"

#include "cpp_common/pgr_assert.h"

namespace pgrouting {
namespace functions {


std::vector<pgr_vertex_color_rt>
EDGECOLORING::edgeColoring() {

    std::vector<pgr_vertex_color_rt> results;

    auto i_map = boost::get(boost::edge_bundle, graph);

    // vector which will store the color of all the edges in the graph
    std::vector<size_t> colors(boost::num_edges(graph));

    // An iterator property map which records the color of each edge
    auto color_map = boost::make_iterator_property_map(colors.begin(), i_map);

#if 0
    CHECK_FOR_INTERRUPTS();
#endif

    try {
        boost::edge_coloring(graph, color_map);
    } catch (boost::exception const& ex) {
        (void)ex;
        throw;
    } catch (std::exception &e) {
        (void)e;
        throw;
    } catch (...) {
        throw;
    }

    E_it e_i, e_end;

    for (boost::tie(e_i, e_end) = edges(graph); e_i != e_end; ++e_i) {
        int64_t edge = E_to_id[*e_i];

        int64_t color = colors[edge];
        results.push_back({edge, (color + 1)});
    }
    return results;
}

typedef boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS, Basic_vertex, size_t,
        Basic_edge> EDGECOLORING_Graph;

#if 0
//adding edges
EDGECOLORING::graph_add_edge(const T &edge, bool normal) {
    bool inserted;
    typename Pgr_base_graph< G, T_V, T_E >::E e;
    if ((edge.cost < 0) && (edge.reverse_cost < 0))
        return;

    /*
     * true: for source
     * false: for target
     */
    auto vm_s = get_V(T_V(edge, true));
    auto vm_t = get_V(T_V(edge, false));

    pgassert(vertices_map.find(edge.source) != vertices_map.end());
    pgassert(vertices_map.find(edge.target) != vertices_map.end());
    if (edge.cost >= 0) {
        boost::tie(e, inserted) =
            boost::add_edge(vm_s, vm_t, graph);
        graph[e].cost = edge.cost;
        graph[e].id = edge.id;
    }

    if (edge.reverse_cost >= 0
            && (m_gType == DIRECTED
                || (m_gType == UNDIRECTED && edge.cost != edge.reverse_cost))) {
        boost::tie(e, inserted) =
            boost::add_edge(vm_t, vm_s, graph);

        graph[e].cost = edge.reverse_cost;
        graph[e].id = normal ? edge.id : -edge.id;
    }
}
#endif

bool
EDGECOLORING::has_vertex(int64_t id) const {
    return id_to_V.find(id) != id_to_V.end();
}

EDGECOLORING::V
EDGECOLORING::get_boost_vertex(int64_t id) const {
    try {
        return id_to_V.at(id);
    } catch (...) {
        pgassert(false);
        throw;
    }
}

int64_t
EDGECOLORING::get_vertex_id(V v) const {
    try {
        return V_to_id.at(v);
    } catch (...) {
        pgassert(false);
        throw;
    }
}

int64_t
EDGECOLORING::get_edge_id(E e) const {
    try {
        return E_to_id.at(e);
    } catch (...) {
        pgassert(false);
        throw;
    }
}

}  // namespace functions
}  // namespace pgrouting

//new file ends

/** @file edgeColoring_driver.cpp
 * @brief Handles actual calling of function in the `pgr_edgeColoring.hpp` file.
 *
 */

/***********************************************************************
 *
 *   pgr_edgeColoring(edges_sql TEXT);
 *
 ***********************************************************************/

/** @brief Calls the main function defined in the C++ Header file.
 *
 * @param graph      the graph containing the edges
 * @param log        stores the log message
 *
 * @returns results, when results are found
 */

// std::vector<pgr_vertex_color_rt>
// pgr_edgeColoring(EDGECOLORING_Graph &graph) {
//     pgrouting::functions::Pgr_edgeColoring<EDGECOLORING_Graph> fn_edgeColoring;
//     auto results = fn_edgeColoring.edgeColoring(graph);
//     return results;
// }

/** @brief Performs exception handling and converts the results to postgres.
 *
 * @pre log_msg is empty
 * @pre notice_msg is empty
 * @pre err_msg is empty
 * @pre return_tuples is empty
 * @pre return_count is 0
 *
 * It builds the undirected graph using the `data_edges` variable.
 * Then, it passes the required variables to the template function
 * `pgr_edgeColoring` which calls the main function
 * defined in the C++ Header file. It also does exception handling.
 *
 * @param data_edges     the set of edges from the SQL query
 * @param total_edges    the total number of edges in the SQL query
 * @param return_tuples  the rows in the result
 * @param return_count   the count of rows in the result
 * @param log_msg        stores the log message
 * @param notice_msg     stores the notice message
 * @param err_msg        stores the error message
 *
 * @returns void
 */

void
do_pgr_edgeColoring(
    pgr_edge_t  *data_edges,
    size_t total_edges,

    pgr_vertex_color_rt **return_tuples,
    size_t *return_count,

    char ** log_msg,
    char ** notice_msg,
    char ** err_msg) {
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

        typedef  boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS, boost::no_property, size_t,
                 boost::no_property> Graph;

        EDGECOLORING_Graph undigraph(gType);

        undigraph.insert_edges(data_edges, total_edges);

        results = edgeColoring(undigraph);

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
        *log_msg = log.str().empty() ?
                   *log_msg :
                   pgr_msg(log.str().c_str());
        *notice_msg = notice.str().empty() ?
                      *notice_msg :
                      pgr_msg(notice.str().c_str());
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
