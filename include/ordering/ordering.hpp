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
#include <utility>

#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/property_map/property_map.hpp>


#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"
#include <boost/graph/king_ordering.hpp>
#include <boost/graph/minimum_degree_ordering.hpp>


namespace pgrouting  {

template <class G>
std::vector<int64_t>
kingOrdering(G &graph) {
    using V = typename G::V;
    using B_G= typename G::B_G;
    using vertices_size_type = typename boost::graph_traits<B_G>::vertices_size_type;

    std::vector<int64_t> results(graph.num_vertices());

    auto index_map = boost::get(boost::vertex_index, graph.graph);
    std::vector<vertices_size_type> colors(boost::num_vertices(graph.graph));
    auto color_map = boost::make_iterator_property_map(colors.begin(), index_map);
    auto degree_map = boost::make_degree_map(graph.graph);
    std::vector<V> inv_perm(boost::num_vertices(graph.graph));

    CHECK_FOR_INTERRUPTS();
    boost::king_ordering(graph.graph, inv_perm. rbegin(), color_map, degree_map, index_map);
    
    size_t j = 0;
    for (auto i = inv_perm.begin(); i != inv_perm.end(); ++i, ++j) {
        results[j] = index_map[*i];
    }
    return results;
}

template <class G>
std::vector<int64_t>
minDegreeOrdering(G &graph) {
    std::vector<int64_t> results;
    CHECK_FOR_INTERRUPTS();
    return results;
}

}  // namespace pgrouting

#endif  // INCLUDE_ORDERING_ORDERING_HPP_
