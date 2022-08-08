/*PGR-GNU*****************************************************************
File: cuthillMckeeOrdering.hpp

Generated with Template by:
Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2022 Shobhit Chaurasia
Mail: 000shobhitchaurasia at gmail.com

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

#ifndef INCLUDE_ORDERING_CUTHILLMCKEEORDERING_HPP_
#define INCLUDE_ORDERING_CUTHILLMCKEEORDERING_HPP_
#pragma once

/* TODO remove unnecessary includes */
#include <boost/config.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/vector_property_map.hpp>
#include <boost/type_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/properties.hpp>
#include <boost/graph/cuthill_mckee_ordering.hpp>

#include <algorithm>
#include <vector>
#include <map>

#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/interruption.h"
#include "cpp_common/pgr_messages.h"

#include "c_types/ii_t_rt.h"

/** @file cuthillMckeeOrdering.hpp
 * @brief The main file which calls the respective boost function.
 *
 * Contains actual implementation of the function and the calling
 * of the respective boost function.
 */


namespace pgrouting {
namespace functions {

//*************************************************************
#if 1
template <class G>
#endif
class CuthillMckeeOrdering : public Pgr_messages{
 public:

#if 1
    
    typedef boost::adjacency_list<boost::vecS,boost::vecS,boost::undirectedS,
        boost::property<boost::vertex_color_t,boost::default_color_type,
        boost::property<boost::vertex_degree_t, int>>>
        Graph;
    typedef boost::graph_traits<Graph>::vertices_size_type size_type;
    typedef boost::graph_traits<Graph>::vertex_descriptor Vertex;

    // documentation todo

        std::vector<II_t_rt>
        cuthillMckeeOrdering(G &graph, uint64_t start_vid) {
        std::vector<II_t_rt>results;

        Vertex s = boost::vertex(start_vid, graph.graph);
        std::vector <size_type> ordering(boost::num_vertices(graph.graph));
        std::vector<Vertex> inv_perm(boost::num_vertices(graph.graph));
        std::vector<size_type> perm(boost::num_vertices(graph.graph));

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();

         try {
             boost::cuthill_mckee_ordering(graph.graph, s);
         } catch (boost::exception const& ex) {
             (void)ex;
             throw;
         } catch (std::exception &e) {
             (void)e;
             throw;
         } catch (...) {
             throw;
         }

         results = get_results(ordering, graph);

         return results;
     }
#endif

 private:
     /** @brief to get the results
      *
      * Uses the `ordering` vector to get the results i.e. the ordering.
      *
      * @param ordering    vector which contains the new ordering
      * @param graph       the graph containing the edges
      *
      * @returns `results` vector
      */
     std::vector <II_t_rt> get_results(
            std::vector <size_type> & ordering,
            const G & graph) {
            std::vector <II_t_rt> results;

#if 0
         typename boost::graph_traits <Graph> ::vertex_iterator v, vend;

         for (std::vector<Vertex>::const_iterator i = inv_perm.begin();
             i != inv_perm.end(); ++i) {
            log << index_map[*i] << " ";
            results.push_back({index_map[*i], index_map[*i]});
            }
 
         for (boost::tie(v, vend) = vertices(graph.graph); v != vend; ++v) {
             int64_t node = graph[*v].id;
             auto orderings = ordering[*v];
             results.push_back({{node}, {static_cast<int64_t>(orderings + 1)}});
         }
          for (size_type c = 0; c != inv_perm.size(); ++c)
            perm[index_map[inv_perm[c]]] = c;
        }
         
#endif
            return results;
        }
};
}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_ORDERING_CUTHILLMCKEEORDERING_HPP_
