/*PGR-GNU*****************************************************************
File: makeBiconnectedPlanar.hpp

Copyright (c) 2020-2026 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2026 Mohit Rawat
Mail: mohit25rawat at gmail.com

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

#ifndef INCLUDE_PLANAR_MAKEBICONNECTEDPLANAR_HPP_
#define INCLUDE_PLANAR_MAKEBICONNECTEDPLANAR_HPP_
#pragma once

#include <map>
#include <string>
#include <vector>
#include <cstdint>

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/properties.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/boyer_myrvold_planar_test.hpp>
#include <boost/graph/make_biconnected_planar.hpp>
#include <boost/graph/connected_components.hpp>

#include "c_types/ii_t_rt.h"
#include "cpp_common/edge_t.hpp"
#include "cpp_common/messages.hpp"
#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"

namespace pgrouting {
namespace functions {

template <class G>
class Pgr_makeBiconnectedPlanar : public pgrouting::Pgr_messages {
 public:
     typedef typename G::V V;
     typedef typename G::E E;
     typedef typename G::E_i E_i;

     std::vector<II_t_rt> makeBiconnectedPlanar(G &graph) {
         /* Find how many connected components this graph has */
         std::vector<size_t> component(boost::num_vertices(graph.graph));
         auto num_components = boost::connected_components(
                 graph.graph, &component[0]);

         if (num_components == 1) {
             /* Simple case: single connected graph — process directly */
             return generateMakeBiconnectedPlanar(graph);
         }

         /*
          * Multi-component case: split the graph into connected sub-graphs
          * and process each one independently. This algorithm is defined to
          * work per-component. Future algorithms (e.g. straightLineDrawing)
          * that need a single connected graph should throw instead.
          */
         log << "Graph has " << num_components
             << " connected components. Processing each independently.\n";

         /* Collect edges per component using vertex component labels */
         std::vector<std::vector<Edge_t>> comp_edges(num_components);
         E_i ei, ei_end;
         for (boost::tie(ei, ei_end) = edges(graph.graph);
                 ei != ei_end; ++ei) {
             V src_v = boost::source(*ei, graph.graph);
             size_t c = component[src_v];
             Edge_t e;
             e.id           = graph[*ei].id;
             e.source       = graph[src_v].id;
             e.target       = graph[boost::target(*ei, graph.graph)].id;
             e.cost         = graph[*ei].cost;
             e.reverse_cost = graph[*ei].reverse_cost;
             comp_edges[c].push_back(e);
         }

         std::vector<II_t_rt> all_results;
         for (size_t c = 0; c < num_components; ++c) {
             if (comp_edges[c].empty()) continue;
             G sub_graph;
             sub_graph.insert_edges(comp_edges[c]);
             auto sub_results = generateMakeBiconnectedPlanar(sub_graph);
             all_results.insert(
                     all_results.end(),
                     sub_results.begin(), sub_results.end());
         }
         return all_results;
     }

 private:
     std::vector<II_t_rt> generateMakeBiconnectedPlanar(G &graph) {
         auto originalEdgeCount = boost::num_edges(graph.graph);
         log << "Number of edges before: " << originalEdgeCount << "\n";

         E_i ei, ei_end;
         std::map<E, size_t> edge_id_map;
         size_t edge_count = 0;
         for (boost::tie(ei, ei_end) = edges(graph.graph); ei != ei_end; ++ei) {
             edge_id_map[*ei] = edge_count++;
         }
         boost::associative_property_map<std::map<E, size_t>>
             e_index(edge_id_map);

         typedef std::vector<typename boost::graph_traits<
             typename G::B_G>::edge_descriptor> vec_t;
         std::vector<vec_t> embedding(boost::num_vertices(graph.graph));

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();

         bool is_planar = false;
         try {
             is_planar = boost::boyer_myrvold_planarity_test(
                 boost::boyer_myrvold_params::graph = graph.graph,
                 boost::boyer_myrvold_params::embedding = &embedding[0]);
         } catch (boost::exception const& ex) {
             (void)ex;
             throw;
         } catch (std::exception &e) {
             (void)e;
             throw;
         } catch (...) {
             throw;
         }

         if (!is_planar) {
             log << "Graph is not planar\n";
             return std::vector<II_t_rt>();
         }

         /* Driver guarantees connectivity for single-component calls;
          * multi-component path above handles the rest. */

         CHECK_FOR_INTERRUPTS();
         try {
             boost::make_biconnected_planar(graph.graph, &embedding[0], e_index);
         } catch (boost::exception const& ex) {
             (void)ex;
             throw;
         } catch (std::exception &e) {
             (void)e;
             throw;
         } catch (...) {
             throw;
         }

         auto totalEdges = boost::num_edges(graph.graph);
         auto newEdgeCount = totalEdges - originalEdgeCount;
         log << "Number of edges after: " << totalEdges << "\n";

         std::vector<II_t_rt> results(newEdgeCount);
         size_t newEdge = 0;
         size_t i = 0;
         for (boost::tie(ei, ei_end) = edges(graph.graph); ei != ei_end; ++ei) {
             if (newEdge >= originalEdgeCount) {
                 int64_t src = graph[graph.source(*ei)].id;
                 int64_t tgt = graph[graph.target(*ei)].id;
                 log << "src:" << src << " tgt:" << tgt << "\n";
                 results[i] = {src, tgt};
                 i++;
             }
             newEdge++;
         }

         return results;
     }
};

}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_PLANAR_MAKEBICONNECTEDPLANAR_HPP_
