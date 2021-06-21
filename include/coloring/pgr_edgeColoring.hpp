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

#include <boost/property_map/property_map.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/vector_property_map.hpp>
#include <boost/type_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/edge_coloring.hpp>
#include <boost/graph/iteration_macros.hpp>
#include <boost/graph/properties.hpp>
#include <boost/config.hpp>

#include <limits>
#include <iostream>
#include <algorithm>
#include <vector>
#include <map>

#include "cpp_common/interruption.h"

#include "cpp_common/pgr_messages.h"
#include "cpp_common/pgr_assert.h"


namespace pgrouting {
namespace functions {

class EDGECOLORING : public Pgr_messages {

    using EDGECOLORING_Graph =
        boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS, boost::no_property, size_t,
        boost::no_property>;


    using V       = boost::graph_traits<EDGECOLORING_Graph>::vertex_descriptor;
    using E       = boost::graph_traits<EDGECOLORING_Graph>::edge_descriptor;
    using V_it    = boost::graph_traits<EDGECOLORING_Graph>::vertex_iterator;
    using E_it    = boost::graph_traits<EDGECOLORING_Graph>::edge_iterator;
    using Eout_it = boost::graph_traits<EDGECOLORING_Graph>::out_edge_iterator;

public:
    /** @brief just a EDGECOLORING value **/
    //std::deque<std::pair<int64_t, double>> tsp();

    std::vector<pgr_vertex_color_rt> edgeColoring();

#if 0

    EDGECOLORING() = delete;
#endif

#if 0
#if Boost_VERSION_MACRO >= 106800
    friend std::ostream& operator<<(std::ostream &, const EDGECOLORING&);
#endif

#endif

    bool has_vertex(int64_t id) const;

private:
    V get_boost_vertex(int64_t id) const;
    int64_t get_vertex_id(V v) const;
    int64_t get_edge_id(E e) const;


private:
    EDGECOLORING_Graph graph;
    std::map<int64_t, V> id_to_V;
    std::map<V, int64_t> V_to_id;
    std::map<E, int64_t> E_to_id;
};

}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_COLORING_PGR_EDGECOLORING_HPP_
