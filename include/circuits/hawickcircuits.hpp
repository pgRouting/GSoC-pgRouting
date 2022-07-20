/*PGR-GNU*****************************************************************

Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2022 Nitish Chauhan
Mail: nitishchauhan0022 at gmail.com

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

#ifndef INCLUDE_CIRCUITS_HAWICKCIRCUITS_HPP_
#define INCLUDE_CIRCUITS_HAWICKCIRCUITS_HPP_
#pragma once

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/graph/hawick_circuits.hpp>
#include <boost/property_map/property_map.hpp>

#include <iostream>
#include <iterator>
#include <vector>

#include "cpp_common/basePath_SSEC.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/pgr_assert.h"
#include "c_types/circuits_rt.h"

namespace pgrouting {
    std::vector<circuits_rt> results;
#if 1
struct circuit_detector{
template <typename Path, typename Graph>
void cycle(Path const &p, Graph const &g){
        if (p.empty())
        return;

        // Get the property map containing the vertex indices so we can store them for output.

        typedef typename boost::property_map<Graph, boost::vertex_index_t>::const_type IndexMap;
        IndexMap indices = get(boost::vertex_index, g);

        // Iterate over path iterator adding each vertex that forms the circuit.

        typename Path::const_iterator i, before_end = boost::prior(p.end());
        for (i = p.begin(); i != before_end; ++i) {
            // add the  current vertex to the circuit storage container
            auto vertex = get(indices, *i);
        }
    }
};
#endif

    template <typename G>
    std::vector<circuits_rt> hawickCircuits(G & /*graph*/) {
#if 0
    circuit_detector visitor;
    boost::hawick_circuits(graph, visitor);
#endif
        return results;
    }

}  // namespace pgrouting

#endif  // INCLUDE_CIRCUITS_HAWICKCIRCUITS_HPP_
