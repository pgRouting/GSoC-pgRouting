/*PGR-GNU*****************************************************************
File: ordering.hpp

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Developer:
Copyright (c) 2025 Fan Wu
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

#ifndef INCLUDE_ORDERING_ORDERING_HPP_
#define INCLUDE_ORDERING_ORDERING_HPP_
#pragma once

#include <vector>
#include <limits>
#include <iterator>


#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/king_ordering.hpp>
#include <boost/graph/minimum_degree_ordering.hpp>

#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"


namespace pgrouting  {

template <class G>
std::vector<int64_t>
kingOrdering(G &graph) {
    using boost;
    typedef adjacency_list< vecS, vecS, undirectedS,
        property< vertex_color_t, default_color_type,
            property< vertex_degree_t, int > > >
        Graph;
    typedef graph_traits< Graph >::vertex_descriptor Vertex;

    std::vector <int64_t>results;

    auto index_map = get(boost::vertex_index, graph.graph);
    auto color_map = get(boost::vertex_color, graph.graph);
    auto degree_map = make_degree_map(graph.graph);

    std::vector< Vertex > inv_perm(num_vertices(graph.graph));
    CHECK_FOR_INTERRUPTS();

    boost::king_ordering(graph.graph, inv_perm.rbegin(), color_map, degree_map, index_map);
    for (std::vector<Vertex>::const_iterator i = inv_perm.begin(); i != inv_perm.end(); ++i) {
        auto seq = graph[*i].id;
        results.push_back({{seq}, {static_cast<int64_t>(graph.graph[*i].id)}});
        seq++;
    }
    return results;
}

template <class G>
std::vector<std::vector<int64_t>>
minDegreeOrdering(G &graph) {
    CHECK_FOR_INTERRUPTS();
}

}  // namespace pgrouting

#endif  // INCLUDE_ORDERING_ORDERING_HPP_
