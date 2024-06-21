/*PGR-GNU*****************************************************************
File: centrality.hpp

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


#ifndef INCLUDE_METRICS_CENTRALITY_HPP_
#define INCLUDE_METRICS_CENTRALITY_HPP_
#pragma once

#include <deque>
#include <vector>
#include <set>
#include <limits>

#include <boost/config.hpp>
#include <boost/graph/adjacency_list.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/betweenness_centrality.hpp>
#include <boost/graph/johnson_all_pairs_shortest.hpp>
#include <boost/graph/floyd_warshall_shortest.hpp>

#include "c_types/iid_t_rt.h"
#include "cpp_common/basePath_SSEC.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/interruption.hpp"

// TODO(vicky) don't keep it here
#include "cpp_common/pgr_alloc.hpp"

namespace pgrouting  {
template < class G > class Pgr_metrics;

// user's functions
template < class G >
void
pgr_centrality(G &graph, std::vector< IID_t_rt> &rows) {
    Pgr_metrics< G > fn_centrality;
    fn_centrality.centrality(graph, rows);
}

// for postgres
template < class G >
void
pgr_centrality(
        G &graph,
        size_t &result_tuple_count,
        IID_t_rt **postgres_rows) {
    Pgr_metrics< G > fn_centrality;
    fn_centrality.centrality(graph, result_tuple_count, postgres_rows);
}


// template class
template < class G >
class Pgr_metrics {
 public:
	 typedef typename G::V V;
     typedef typename G::E E;
     typedef boost::adjacency_list<boost::vecS, boost::vecS, boost::undirectedS> Graph;
     typedef boost::graph_traits<Graph>::vertices_size_type size_type;
     typedef boost::graph_traits<Graph>::vertex_descriptor Vertex;	 

	 void centrality(
             G &graph,
             size_t &result_tuple_count,
             IID_t_rt **postgres_rows) {
         std::vector< std::vector<double>> matrix;
         make_matrix(graph.num_vertices(), matrix);
         inf_plus<double> combine;

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();

         boost::floyd_warshall_all_pairs_shortest_paths(
                 graph.graph,
                 matrix,
                 weight_map(get(&pgrouting::Basic_edge::cost, graph.graph)).
                 distance_combine(combine).
                 distance_inf((std::numeric_limits<double>::max)()).
                 distance_zero(0));

         make_result(graph, matrix, result_tuple_count, postgres_rows);
     }

     void centrality(
             G &graph,
             std::vector< IID_t_rt> &rows) {
         std::vector< std::vector<double>> matrix;
         make_matrix(graph.num_vertices(), matrix);
         inf_plus<double> combine;

         /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
         CHECK_FOR_INTERRUPTS();

         boost::floyd_warshall_all_pairs_shortest_paths(
                 graph.graph,
                 matrix,
                 weight_map(get(&pgrouting::Basic_edge::cost, graph.graph)).
                 distance_combine(combine).
                 distance_inf((std::numeric_limits<double>::max)()).
                 distance_zero(0));

         make_result(graph, matrix, rows);
     }
	 void betweennessCentrality (
			 const G &graph,
			 size_t &result_tuple_count,
			 IID_t_rt **postgres_rows ){
		 std::map<V,double> centrality_score;
		 boost::associative_property_map<std::map<Vertex,double>> centrality_map(centrality_score);
		 /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
		 CHECK_FOR_INTERRUPTS();

		 boost::brandes_betweenness_centrality(graph, centrality_map);
		 std::map<int64_t,double> centrality_results;
		 boost::graph_traits<Graph>::vertex_iterator vi, vi_end;
		 for(boost::tie(vi, vi_end) = vertices(graph); vi != vi_end; ++vi) {
		 	centrality_results[graph[*vi].id] = centrality_map[*vi];	
		 }
	 }

 private:
	 void generate_results(
			 const G &graph,
			 const std::map<int64_t, double> centrality_results,
			 size_t &result_tuple_count,
			 IID_t_rt **postgres_rows) const {
		 result_tuple_count = centrality_results.size();
		 *postgres_rows = pgr_alloc(result_tuple_count, (*postgres_rows));


		 size_t seq = 0;
		 for(auto results : centrality_results) {
		 	(*postgres_rows)[seq].from_vid = results.first;
			(*postgres_rows)[seq].to_vid = 0;
			(*postgres_rows)[seq].cost = results.second;
			seq++;		
		 }
	 }
     void make_matrix(
             size_t v_size,
             std::vector< std::vector<double>> &matrix) const {
         // TODO(vicky) in one step
         matrix.resize(v_size);
         for (size_t i=0; i < v_size; i++)
             matrix[i].resize(v_size);
     }

     void make_result(
             const G &graph,
             const std::vector< std::vector<double> > &matrix,
             size_t &result_tuple_count,
             IID_t_rt **postgres_rows) const {
         result_tuple_count = count_rows(graph, matrix);
         *postgres_rows = pgr_alloc(result_tuple_count, (*postgres_rows));


         size_t seq = 0;
         for (typename G::V v_i = 0; v_i < graph.num_vertices(); v_i++) {
             for (typename G::V v_j = 0; v_j < graph.num_vertices(); v_j++) {
                 if (v_i == v_j) continue;
                 if (matrix[v_i][v_j] != (std::numeric_limits<double>::max)()) {
                     (*postgres_rows)[seq].from_vid = graph[v_i].id;
                     (*postgres_rows)[seq].to_vid = graph[v_j].id;
                     (*postgres_rows)[seq].cost =  matrix[v_i][v_j];
                     seq++;
                 }  // if
             }  // for j
         }  // for i
     }


     size_t count_rows(
             const G &graph,
             const std::vector< std::vector<double> > &matrix) const {
         size_t result_tuple_count = 0;
         for (size_t i = 0; i < graph.num_vertices(); i++) {
             for (size_t j = 0; j < graph.num_vertices(); j++) {
                 if (i == j) continue;
                 if (matrix[i][j] != (std::numeric_limits<double>::max)()) {
                     result_tuple_count++;
                 }  // if
             }  // for j
         }  // for i
         return result_tuple_count;
     }

     void make_result(
             G &graph,
             std::vector< std::vector<double> > &matrix,
             std::vector< IID_t_rt> &rows) {
         size_t count = count_rows(graph, matrix);
         rows.resize(count);
         size_t seq = 0;

         for (typename G::V v_i = 0; v_i < graph.num_vertices(); v_i++) {
             for (typename G::V v_j = 0; v_j < graph.num_vertices(); v_j++) {
                 if (matrix[v_i][v_j] != (std::numeric_limits<double>::max)()) {
                     rows[seq] =
                     {graph[v_i].id, graph[v_j].id, matrix[v_i][v_j]};
                     seq++;
                 }  // if
             }  // for j
         }  // for i
     }

     template <typename T>
     struct inf_plus {
         T operator()(const T& a, const T& b) const {
             T inf = (std::numeric_limits<T>::max)();
             if (a == inf || b == inf)
                 return inf;
             return a + b;
         }
     };
};

}  // namespace pgrouting

#endif  // INCLUDE_METRICS_CENTRALITY_HPP_
