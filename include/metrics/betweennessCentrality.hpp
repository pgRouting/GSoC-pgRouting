/*PGR-GNU*****************************************************************
File: betweennessCentrality.hpp

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2024 Arun Thakur
Mail: bedupako12mas@gmail.com

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


#ifndef INCLUDE_METRICS_BETWEENNESSCENTRALITY_HPP_
#define INCLUDE_METRICS_BETWEENNESSCENTRALITY_HPP_
#pragma once

#include <vector>
#include <map>
#include <type_traits>

#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/betweenness_centrality.hpp>
#include <boost/graph/graph_traits.hpp>

#include "c_types/iid_t_rt.h"
#include "cpp_common/basePath_SSEC.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/interruption.hpp"

#include "cpp_common/pgr_alloc.hpp"

/**
 * @ brief The main file which calls the respective boost function
 *
 * Contains actual implementation of the function and the calling
 * of the respective boost function
 */

namespace pgrouting  {
template <class G> class Pgr_metrics;


// for postgres
template <class G>
void
pgr_betweennesscentrality(
        G &graph,
        size_t &result_tuple_count,
        IID_t_rt **postgres_rows) {
    Pgr_metrics< G > fn_centrality;
    fn_centrality.betweennessCentrality(graph, result_tuple_count, postgres_rows);
}


// template class
template <class G>
class Pgr_metrics {
 public:
    /** @name betweennessCentrality
		 *  @{
		 *
		 */

    /** @brief betweennessCentrality function
		 *
		 * It does all the processing and returns the results.
		 *
		 * @param graph  the graph containing the edges
		 *
		 * @see [boost::brandes_betweenness_centrality]
		 * (https://www.boost.org/doc/libs/1_85_0/libs/graph/doc/betweenness_centrality.html)
		 */
     using Graph = typename G::B_G;
     using V = typename G::V;
     using E = typename G::E;
     typedef typename boost::graph_traits<Graph>::directed_category directed_category;

     void betweennessCentrality(
             const G &graph,
             size_t &result_tuple_count,
             IID_t_rt **postgres_rows ) {
         std::vector<double> centrality(boost::num_vertices(graph.graph), 0.0);
         // stores the centrality values for all vertices of the graph
         auto centrality_map = boost::make_iterator_property_map(centrality.begin(),
                                                                 boost::get(boost::vertex_index, graph.graph));

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();
         boost::brandes_betweenness_centrality(
                 graph.graph,
                 centrality_map);
         if (boost::num_vertices(graph.graph) > 2) {
             boost::relative_betweenness_centrality(
                graph.graph,
                centrality_map);
         }

         generate_results(graph, centrality, result_tuple_count, postgres_rows);
     }

 private:
     void generate_results(
             const G &graph,
             const std::vector<double> centrality_results,
             size_t &result_tuple_count,
             IID_t_rt **postgres_rows) const {
         result_tuple_count = centrality_results.size();
         *postgres_rows = pgr_alloc(result_tuple_count, (*postgres_rows));

         size_t seq = 0;
          for (typename G::V v_i = 0; v_i < graph.num_vertices(); ++v_i) {
             (*postgres_rows)[seq].from_vid = graph[v_i].id;
            (*postgres_rows)[seq].to_vid = 0;
            (*postgres_rows)[seq].cost = centrality_results[v_i];
            if (std::is_same<directed_category, boost::bidirectional_tag>::value) {
                (*postgres_rows)[seq].cost = centrality_results[v_i]/2.0;
            }
            seq++;
         }
     }
};

}  // namespace pgrouting

#endif  // INCLUDE_METRICS_BETWEENNESSCENTRALITY_HPP_
