/*PGR-GNU*****************************************************************
File: pgr_edgeColoring.hpp

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

#ifndef INCLUDE_COLORING_PGR_EDGECOLORING_HPP_
#define INCLUDE_COLORING_PGR_EDGECOLORING_HPP_
#pragma once

#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>

#include <iostream>
#include <limits>
#include <map>
#include <vector>

#include "cpp_common/basic_edge.h"
#include "cpp_common/basic_vertex.h"
#include "cpp_common/pgr_assert.h"
#include "cpp_common/pgr_messages.h"

namespace pgrouting {
namespace functions {

class Pgr_edgeColoring : public Pgr_messages {
 public:
    using EdgeColoring_Graph =
        boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS, pgrouting::Basic_vertex, size_t,
        pgrouting::Basic_edge>;

    using V       = boost::graph_traits<EdgeColoring_Graph>::vertex_descriptor;
    using E       = boost::graph_traits<EdgeColoring_Graph>::edge_descriptor;
    using V_it    = boost::graph_traits<EdgeColoring_Graph>::vertex_iterator;
    using E_it    = boost::graph_traits<EdgeColoring_Graph>::edge_iterator;

    std::vector<pgr_vertex_color_rt> edgeColoring(EdgeColoring_Graph&);

    void insert_edges(EdgeColoring_Graph&, pgr_edge_t*, size_t);

#if 0
    Pgr_edgeColoring() = delete;
#endif

#if 0
#if Boost_VERSION_MACRO >= 106800
    friend std::ostream& operator<<(std::ostream &, const Pgr_edgeColoring&);
#endif
#endif

 private:
    EdgeColoring_Graph graph;
    std::map<int64_t, V> id_to_V;
    std::map<V, int64_t> V_to_id;
    std::map<E, int64_t> E_to_id;
};

}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_COLORING_PGR_EDGECOLORING_HPP_