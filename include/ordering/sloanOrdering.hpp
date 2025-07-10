/*PGR-GNU*****************************************************************
File: sloanOrdering.hpp

Generated with Template by:
Copyright (c) 2022 pgRouting developers
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

#ifndef INCLUDE_ORDERING_SLOANORDERING_HPP_
#define INCLUDE_ORDERING_SLOANORDERING_HPP_
#pragma once

#include <algorithm>
#include <vector>
#include <map>
#include <cstdint>
#include <iterator>

#include <boost/property_map/property_map.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/vector_property_map.hpp>
#include <boost/type_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/sloan_ordering.hpp>

#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"
#include "cpp_common/messages.hpp"

namespace pgrouting {
namespace functions {

template <class G>
class sloanOrdering : public Pgr_messages {
 public:
    typedef typename G::V V;
    typedef typename G::E E;

        std::vector<int64_t>
        sloanOrdering(G &graph) {
		using namespace boost;
		typedef adjacency_list< vecS, vecS, undirectedS, property< vertex_color_t, default_color_type, property< vertex_degree_t, int, property< vertex_priority_t, int > > > > Graph;
                typedef graph_traits< Graph >::vertex_descriptor Vertex;
                std::vector<int64_t>results;

        auto i_map = boost::get(boost::vertex_index, graph.graph);

        auto color_map = get(boost::vertex_color, graph.graph);

        auto degree_map = make_degree_map(graph.graph);

        auto priority_map = get(boost::vertex_priority, graph.graph);
	
        std::vector<Vertex> inv_perm(num_vertices(graph.graph));

        CHECK_FOR_INTERRUPTS();

             boost::sloan_ordering(graph.graph, inv_perm.rbegin(), color_map, degree_map, priority_map);
         for (std::vector<Vertex>::const_iterator i = inv_perm.begin(); i != inv_perm.end(); ++i) {
                auto seq = graph[*i].id;
                results.push_back(static_cast<int64_t>(graph[*i].id));
                seq++;}

         return results;
     }
};
}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_ORDERING_SLOANORDERING_HPP_
