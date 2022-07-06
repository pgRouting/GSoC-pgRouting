/*PGR-GNU*****************************************************************
File: pgr_cuthillMckeeOrdering_driver.hpp

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

#include <boost/property_map/property_map.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/vector_property_map.hpp>
#include <boost/type_traits.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/sequential_vertex_coloring.hpp>

#include <algorithm>
#include <vector>
#include <map>

#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/interruption.h"

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

template <class G>
class CuthillMckeeOrdering {
 public:
     using V = typename G::V;
     using E = typename G::E;
     using Graph = boost::adjacency_list<boost::listS, boost::vecS, boost::undirectedS>;
     using vertices_size_type = boost::graph_traits<Graph>::vertices_size_type;

     /** @name cuthillMckeeOrdering
      * @{
      *
      */

     /** @brief cuthillMckeeOrdering function
      *
      * It does all the processing and returns the results.
      *
      * @param graph the graph containing the edges
      *
      * @returns results, when results are found
      *
      * @see [boost::cuthill_mckee_ordering]
      * (https://www.boost.org/libs/graph/doc/cuthill_mckee_ordering.html)
      */
     std::vector <II_t_rt> cuthillMckeeOrdering(G &graph) {
         std::vector <II_t_rt> results;

        #if 0
         auto i_map = boost::get(boost::vertex_index, graph.graph);

         // vector which will store the ordering of the graph
         std::vector < vertices_size_type > ordering(boost::num_vertices(graph.graph));

         // An iterator property map which records the ordering 
         auto ordering_map = boost::make_iterator_property_map(ordering.begin(), i_map);

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();

         try {
             boost::cuthill_mckee_ordering(graph.graph, ordering_map);
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
        #endif

         return results;
     }

     //@}

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
             std::vector < vertices_size_type > &ordering,
             const G &graph) {
         std::vector <II_t_rt> results;

         typename boost::graph_traits < Graph > ::vertex_iterator v, vend;

         for (boost::tie(v, vend) = vertices(graph.graph); v != vend; ++v) {
             int64_t node = graph[*v].id;
             auto orderings = ordering[*v];
             results.push_back({{node}, {static_cast<int64_t>(orderings + 1)}});
         }

         // ordering the results in an reverse ordering 
         #if 0
         std::sort(results.begin(), results.end(),
             [](const II_t_rt row1, const II_t_rt row2) {
                 return row1.d1.id < row2.d1.id;
             });
         #endif    

         return results;
     }
};
}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_ORDERING_CUTHILLMCKEEORDERING_HPP_