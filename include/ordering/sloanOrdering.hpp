/*PGR-GNU*****************************************************************
File: ordering.hpp

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Developer:
Copyright (c) 2025 Bipasha Gayary
Mail: bipashagayary at gmail.com

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
#include <boost/graph/sloan_ordering.hpp>

#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"


namespace pgrouting  {
namespace detail {

template <typename T>
struct inf_plus {
    T operator()(const T& a, const T& b) const {
        T inf = (std::numeric_limits<T>::max)();
        if (a == inf || b == inf) return inf;
        return a + b;
    }
};

}  // namespace detail


template <class G>
std::vector<std::vector<int64_t>>
sloan(G &graph) {
    CHECK_FOR_INTERRUPTS();

    std::pair<typename G::V, typename G::V> starting_nodes = boost::sloan_starting_nodes(graph.graph);

    std::vector<typename G::V> inv_perm(graph.num_vertices());

    boost::sloan_ordering(
            graph.graph,
            inv_perm.begin(),
            boost::get(boost::vertex_color_t(), graph.graph),
            boost::make_degree_map(graph.graph),
            starting_nodes.first,
            starting_nodes.second);

    CHECK_FOR_INTERRUPTS();

    std::vector<int64_t> result;
    result.reserve(inv_perm.size());

    for (const auto& vertex_desc : inv_perm) {
            result.push_back(graph[vertex_desc].id);
    }

    return result;
}  // namespace ordering

}  // namespace pgrouting

#endif  // INCLUDE_ORDERING_ORDERING_HPP_
