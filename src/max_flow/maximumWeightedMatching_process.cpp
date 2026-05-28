```cpp
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

#include <algorithm>
#include <vector>

#include "max_flow/maximumWeightedMatching_process.hpp"

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/maximum_weighted_matching.hpp>

using boost::adjacency_list;
using boost::vecS;
using boost::undirectedS;

typedef adjacency_list<
    vecS,
    vecS,
    undirectedS,
    boost::no_property,
    boost::property<boost::edge_weight_t, double>
> Graph;

std::vector<int64_t>
maximumWeightedMatching_process(
        const std::vector<Basic_edge> &edges) {
    Graph graph;

    size_t max_vertex = 0;

    for (const auto &edge : edges) {
        max_vertex = std::max(
                max_vertex,
                static_cast<size_t>(
                    std::max(edge.source, edge.target)));
    }

    for (size_t i = 0; i <= max_vertex; ++i) {
        boost::add_vertex(graph);
    }

    for (const auto &edge : edges) {
        boost::add_edge(
                edge.source,
                edge.target,
                edge.cost,
                graph);
    }

    std::vector<
        boost::graph_traits<Graph>::vertex_descriptor> mate(
                boost::num_vertices(graph));

    boost::maximum_weighted_matching(
            graph,
            &mate[0]);

    std::vector<int64_t> result;

    for (size_t i = 0; i < mate.size(); ++i) {
        if (mate[i]
                != boost::graph_traits<Graph>::null_vertex()
                && i < static_cast<size_t>(mate[i])) {
            result.push_back(
                    static_cast<int64_t>(i));
            result.push_back(
                    static_cast<int64_t>(mate[i]));
        }
    }

    return result;
}
```
