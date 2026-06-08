/*PGR-GNU*****************************************************************
File: maximumWeightedMatching_process.cpp

Generated with Template by:
Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2026 Mayur Galhate
Mail: galhatemayur at gmail.com

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

#include <vector>
#include <set>
#include <cstdint>
#include <boost/graph/adjacency_list.hpp>
#include <boost/version.hpp>
#if BOOST_VERSION >= 107600
#include <boost/graph/maximum_weighted_matching.hpp>
#else
#error "pgr_maximumWeightedMatching requires Boost >= 1.76.0"
#endif
#include "max_flow/maximumWeightedMatching.hpp"
#include "cpp_common/undirectedHasCostBG.hpp"

namespace pgrouting {
namespace flow {

std::set<int64_t>
maxWeightMatch(pgrouting::graph::UndirectedHasCostBG& graph) {
    using Graph = pgrouting::graph::UndirectedHasCostBG::TSP_Graph;
    using V     = boost::graph_traits<Graph>::vertex_descriptor;

    auto& g = graph.graph();
    size_t n = boost::num_vertices(g);

    std::vector<V> mate(n);
    boost::maximum_weighted_matching(g, &mate[0]);

    std::set<int64_t> result;
    for (size_t i = 0; i < mate.size(); ++i) {
        if (mate[i] != boost::graph_traits<Graph>::null_vertex()
                && i < static_cast<size_t>(mate[i])) {
            result.insert(graph.get_vertex_id(static_cast<V>(i)));
            result.insert(graph.get_vertex_id(mate[i]));
        }
    }
    return result;
}

}  // namespace flow
}  // namespace pgrouting
