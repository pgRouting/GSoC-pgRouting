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
#include <deque>

#include "cpp_common/basePath_SSEC.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/interruption.h"
#include "cpp_common/pgr_assert.h"
#include "c_types/circuits_rt.h"


namespace pgrouting {
namespace functions {

#if 1
template <typename G>
class circuit_detector{
 public:
    circuit_detector(
        G &graph,
        std::deque<circuits_rt> &data) :
    m_graph(graph),
    m_data(data) {}
    template <typename P, typename Gr>
    void cycle(P const &p, Gr const&) {
        if (p.empty()) {
        return;
        }
        int seq = 0;
        typename P::const_iterator i;
        auto start_vid = m_graph[*p.begin()].id;
        auto end_vid = start_vid;

        for (i = p.begin(); i != p.end(); ++i, ++seq) {
            // To Do: Fillup the columns that are 0 marked
            auto node = m_graph[*i].id;
            m_data.push_back({circuit_No, seq, start_vid, end_vid, node, 0, 0, 0});
        }
        m_data.push_back({circuit_No, seq, start_vid, end_vid, start_vid, 0, 0, 0});  // Adding up the starting vertex
        circuit_No++;
    }

 private:
    G &m_graph;
    std::deque<circuits_rt> &m_data;
    int circuit_No = 1;
};
#endif

template <class G>
class pgr_hawickCircuits{
 public:
      std::deque<circuits_rt> hawickCircuits(G & graph) {
      std::deque<circuits_rt> results;
      circuit_detector <G> detector(graph, results);
        CHECK_FOR_INTERRUPTS();
         try {
             boost::hawick_circuits(graph.graph, detector);
         } catch (boost::exception const& ex) {
             (void)ex;
             throw;
         } catch (std::exception &e) {
             (void)e;
             throw;
         } catch (...) {
             throw;
         }
    return results;
}
};
}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_CIRCUITS_HAWICKCIRCUITS_HPP_
