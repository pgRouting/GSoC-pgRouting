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

#include "coloring/pgr_edgeColoring.hpp"


#include <boost/graph/iteration_macros.hpp>
#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/graph_utility.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/vector_property_map.hpp>
#include <boost/type_traits.hpp>
#include <boost/graph/edge_coloring.hpp>
#include <boost/graph/iteration_macros.hpp>
#include <boost/graph/properties.hpp>



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
