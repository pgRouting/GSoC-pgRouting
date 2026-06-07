/*PGR-GNU*****************************************************************
File: makeMaximalPlanar.hpp

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

#ifndef INCLUDE_PLANAR_MAKEMAXIMALPLANAR_HPP_
#define INCLUDE_PLANAR_MAKEMAXIMALPLANAR_HPP_
#pragma once

#include <map>
#include <vector>
#include <cstdint>

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/properties.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/boyer_myrvold_planar_test.hpp>
#include <boost/graph/make_biconnected_planar.hpp>
#include <boost/graph/make_maximal_planar.hpp>
#include <boost/graph/connected_components.hpp>

#include "c_types/ii_t_rt.h"
#include "cpp_common/messages.hpp"
#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"

namespace pgrouting {
namespace functions {

template <class G>
class Pgr_makeMaximalPlanar : public pgrouting::Pgr_messages {
 public:
     typedef typename G::V V;
     typedef typename G::E E;
     typedef typename G::E_i E_i;

     std::vector<II_t_rt> makeMaximalPlanar(G &graph) {
         return generateMakeMaximalPlanar(graph);
     }

 private:
     struct planar_visitor {
         std::vector<II_t_rt>& m_results;
         G& m_graph;

         planar_visitor(std::vector<II_t_rt>& results, G& graph)
             : m_results(results), m_graph(graph) {}

         template <typename Vertex, typename BGraph>
         void visit_vertex_pair(Vertex u, Vertex v, BGraph& g) {
             boost::add_edge(u, v, g);
             m_results.push_back({m_graph[u].id, m_graph[v].id});
         }
     };

     std::vector<II_t_rt> generateMakeMaximalPlanar(G &graph) {
         log << "Number of edges before: " << boost::num_edges(graph.graph) << "\n";

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

         if (boost::num_vertices(graph.graph) < 3) {
             return std::vector<II_t_rt>();
         }

         std::vector<size_t> component(boost::num_vertices(graph.graph));
         auto num_components = boost::connected_components(graph.graph, &component[0]);
         if (num_components > 1) {
             throw std::invalid_argument("Graph is not connected. Please run pgr_makeConnected first.");
         }

         std::vector<II_t_rt> results;
         planar_visitor vis(results, graph);

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();
         try {
             boost::make_biconnected_planar(graph.graph, &embedding[0], e_index, vis);
         } catch (boost::exception const& ex) {
             (void)ex;
             throw;
         } catch (std::exception &e) {
             (void)e;
             throw;
         } catch (...) {
             throw;
         }

         edge_id_map.clear();
         edge_count = 0;
         for (boost::tie(ei, ei_end) = edges(graph.graph); ei != ei_end; ++ei) {
             edge_id_map[*ei] = edge_count++;
         }

         embedding.resize(boost::num_vertices(graph.graph));
         is_planar = boost::boyer_myrvold_planarity_test(
             boost::boyer_myrvold_params::graph = graph.graph,
             boost::boyer_myrvold_params::embedding = &embedding[0]);

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();
         try {
             boost::make_maximal_planar(graph.graph, &embedding[0],
                 boost::get(boost::vertex_index, graph.graph), e_index, vis);
         } catch (boost::exception const& ex) {
             (void)ex;
             throw;
         } catch (std::exception &e) {
             (void)e;
             throw;
         } catch (...) {
             throw;
         }

         log << "Number of edges after: " << boost::num_edges(graph.graph) << "\n";
         for (const auto& r : results) {
             log << "src:" << r.d1 << " tgt:" << r.d2 << "\n";
         }

         return results;
     }
};

}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_PLANAR_MAKEMAXIMALPLANAR_HPP_
