/*PGR-GNU*****************************************************************
File: pgr_edgeColoring.cpp

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

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/edge_coloring.hpp>
#include <boost/graph/graph_utility.hpp>
#include <boost/graph/iteration_macros.hpp>

#include <sstream>
#include <string>
#include <vector>
#include <algorithm>

#include "drivers/coloring/edgeColoring_driver.h"
#include "coloring/pgr_edgeColoring.hpp"

#include "cpp_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.h"

namespace {

typedef typename boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS, pgrouting::Basic_vertex, size_t,
                                       pgrouting::Basic_edge>
    EdgeColoring_Graph;
typedef typename boost::graph_traits<EdgeColoring_Graph>::vertex_descriptor V;
typedef typename boost::graph_traits<EdgeColoring_Graph>::edge_descriptor E;
typedef typename boost::graph_traits<EdgeColoring_Graph>::vertex_iterator V_it;
typedef typename boost::graph_traits<EdgeColoring_Graph>::edge_iterator E_it;

}  // namespace

namespace pgrouting {
namespace functions {

std::vector<pgr_vertex_color_rt>
Pgr_edgeColoring::edgeColoring(EdgeColoring_Graph &graph) {
    std::vector<pgr_vertex_color_rt> results;

    auto i_map = boost::get(boost::edge_bundle, graph);

    std::vector<size_t> colors(boost::num_edges(graph));

    auto color_map = boost::make_iterator_property_map(colors.begin(), i_map);

#if 0
    CHECK_FOR_INTERRUPTS();
#endif

    try {
        boost::edge_coloring(graph, color_map);
    } catch (boost::exception const &ex) {
        (void)ex;
        throw;
    } catch (std::exception &e) {
        (void)e;
        throw;
    } catch (...) {
        throw;
    }

    for (auto e_i : boost::make_iterator_range(boost::edges(graph))) {
        int64_t edge = E_to_id[e_i];
        int64_t color = colors[edge];
        results.push_back({edge, (color + 1)});
    }
    return results;
}

void Pgr_edgeColoring::insert_edges(EdgeColoring_Graph &graph, pgr_edge_t *edges, size_t count) {
    for (size_t i = 0; i < count; i++)
        add_edge(edges[i].source, edges[i].target, graph);
}

}  // namespace functions
}  // namespace pgrouting
