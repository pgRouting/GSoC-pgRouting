/*PGR-GNU*****************************************************************
File: coreNumbers.cpp

Copyright (c) 2026-2026 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2026 Sakir Ahmed
Mail: sakirahmed75531 at gmail.com

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

#include "metrics/coreNumbers.hpp"

#include <vector>
#include <algorithm>
#include <cstddef>

#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"

namespace {

/*
 * K-core decomposition using the Batagelj-Zaversnik algorithm.
 *
 * Reference:
 * V. Batagelj and M. Zaversnik,
 * "An O(m) Algorithm for Cores Decomposition of Networks", 2003.
 *
 * The algorithm works by iteratively removing the vertex with the
 * smallest current degree. When a vertex is removed, the effective
 * degrees of its neighbors are decremented. The core number of each
 * vertex is the degree it has at the time of its removal.
 *
 * Uses bin-sort for O(m) time complexity.
 */
std::vector<II_t_rt> compute_core_numbers(
        const pgrouting::UndirectedGraph &graph) {
    size_t n = boost::num_vertices(graph.graph);
    if (n == 0) return {};

    using V = pgrouting::UndirectedGraph::V;

    std::vector<size_t> deg(n);
    size_t max_deg = 0;

    pgrouting::UndirectedGraph::V_i vi, vi_end;
    for (boost::tie(vi, vi_end) = vertices(graph.graph); vi != vi_end; ++vi) {
        size_t d = boost::out_degree(*vi, graph.graph);
        deg[*vi] = d;
        if (d > max_deg) max_deg = d;
    }

    /*
     * Bin-sort: bin[d] = starting position of vertices with degree d
     */
    std::vector<size_t> bin(max_deg + 1, 0);
    for (boost::tie(vi, vi_end) = vertices(graph.graph); vi != vi_end; ++vi) {
        ++bin[deg[*vi]];
    }

    size_t start = 0;
    for (size_t d = 0; d <= max_deg; ++d) {
        size_t num = bin[d];
        bin[d] = start;
        start += num;
    }

    /*
     * vert[i] = vertex at position i in the sorted order
     * pos[v]  = position of vertex v in the vert array
     */
    std::vector<V> vert(n);
    std::vector<size_t> pos(n);

    for (boost::tie(vi, vi_end) = vertices(graph.graph); vi != vi_end; ++vi) {
        pos[*vi] = bin[deg[*vi]];
        vert[pos[*vi]] = *vi;
        ++bin[deg[*vi]];
    }

    /* Restore bin after the sort pass */
    for (size_t d = max_deg; d > 0; --d) {
        bin[d] = bin[d - 1];
    }
    bin[0] = 0;

    /*
     * Process vertices in order of increasing degree.
     * For each vertex v, its current deg[v] becomes its core number.
     * Then for each neighbor u with deg[u] > deg[v], decrement deg[u]
     * and re-sort by swapping u with the first vertex of its bin.
     */
    for (size_t i = 0; i < n; ++i) {
        V v = vert[i];
        pgrouting::UndirectedGraph::EO_i ei, ei_end;
        for (boost::tie(ei, ei_end) = out_edges(v, graph.graph);
                ei != ei_end; ++ei) {
            V u = target(*ei, graph.graph);
            if (deg[u] > deg[v]) {
                size_t du = deg[u];
                size_t pu = pos[u];
                size_t pw = bin[du];
                V w = vert[pw];
                if (u != w) {
                    pos[u] = pw;
                    pos[w] = pu;
                    vert[pu] = w;
                    vert[pw] = u;
                }
                ++bin[du];
                --deg[u];
            }
        }
    }

    /* Build results: d1 = node id, d2 = core number */
    std::vector<II_t_rt> results;
    for (boost::tie(vi, vi_end) = vertices(graph.graph); vi != vi_end; ++vi) {
        int64_t node = graph[*vi].id;
        int64_t core = static_cast<int64_t>(deg[*vi]);
        results.push_back({node, core});
    }

    std::sort(results.begin(), results.end(),
            [](const II_t_rt row1, const II_t_rt row2) {
            return row1.d1 < row2.d1;
            });

    return results;
}

}  //  namespace

namespace pgrouting {
namespace metrics {

std::vector<II_t_rt>
coreNumbers(const pgrouting::UndirectedGraph &graph) {
    CHECK_FOR_INTERRUPTS();
    return compute_core_numbers(graph);
}

}  // namespace metrics
}  // namespace pgrouting
