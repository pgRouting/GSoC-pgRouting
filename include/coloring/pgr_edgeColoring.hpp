/*PGR-GNU*****************************************************************
File: pgr_edgeColoring.hpp

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

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

#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/interruption.h"


/** @file pgr_edgeColoring.hpp
 * @brief The main file which calls the respective boost function.
 *
 * Contains actual implementation of the function and the calling
 * of the respective boost function.
 */

//will adjust it later;
using namespace boost;
using namespace std;

namespace pgrouting {
namespace functions {

//*************************************************************

template < class G >
class Pgr_edgeColoring {
public:
    typedef typename G::V V;
    typedef typename G::E E;

    //#new
    typedef adjacency_list< vecS, vecS, undirectedS, no_property, size_t,
            no_property >
            Graph;

    // typedef boost::adjacency_list < boost::listS, boost::vecS, boost::undirectedS > Graph;
    typedef boost::graph_traits < Graph > ::edges_size_type edges_size_type;

    /** @name EdgeColoring
     * @{
     *
     */

    /** @brief edgeColoring function
     *
     * It does all the processing and returns the results.
     *
     * @param graph      the graph containing the edges
     *
     * @returns results, when results are found
     *
     * @see [boost::edge_coloring]
     * (https://www.boost.org/libs/graph/doc/edge_coloring.html)
     */
    std::vector < pgr_vertex_color_rt > edgeColoring(G &graph) {
        std::vector < pgr_vertex_color_rt > results;

        auto i_map = boost::get(boost::edge_all, graph.graph);

        // vector which will store the color of all the edges in the graph
        std::vector < edges_size_type > colors(boost::num_edges(graph.graph));

        // An iterator property map which records the color of each edge
        auto color_map = boost::make_iterator_property_map(colors.begin(), i_map);

        /* abort in case of an interruption occurs (e.g. the query is being cancelled) */
        CHECK_FOR_INTERRUPTS();

        try {
            boost::edge_coloring(graph.graph, color_map);
        } catch (boost::exception const& ex) {
            (void)ex;
            throw;
        } catch (std::exception &e) {
            (void)e;
            throw;
        } catch (...) {
            throw;
        }

        results = get_results(colors, graph);

        return results;
    }

    //@}

private:
    /** @brief to get the results
     *
     * Uses the `colors` vector to get the results i.e. the color of every edge.
     *
     * @param colors      vector which contains the color of every edge
     * @param graph       the graph containing the edges
     *
     * @returns `results` vector
     */
    std::vector < pgr_vertex_color_rt > get_results(
        std::vector < edges_size_type > &colors,
        const G &graph) {
        std::vector < pgr_vertex_color_rt > results;

        typename boost::graph_traits < Graph > ::edge_iterator e_i, e_end;

        for (boost::tie(e_i, e_end) = edges(graph.graph); e_i != e_end; ++e_i) {
            int64_t edge = graph[*e_i].id;

            // auto src = source(*e_i, graph.graph);
            // auto tgt = target(*e_i, graph.graph);

            int64_t color = colors[edge];

            results.push_back({ edge, (color + 1) });
        }

        return results;
    }
};
}  // namespace functions
}  // namespace pgrouting

#endif  // INCLUDE_COLORING_PGR_EDGECOLORING_HPP_
