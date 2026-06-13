/*PGR-GNU*****************************************************************
File: planar_driver.cpp

Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

Design of one process & driver file by
Copyright (c) 2025 Celia Virginia Vergara Castillo
Mail: vicky at erosion.dev

Function's developer:
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

#include "drivers/planar_driver.hpp"

#include <sstream>
#include <vector>
#include <string>
#include <utility>
#include <cstdint>

#include "c_types/ii_t_rt.h"
#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/utilities.hpp"
#include "cpp_common/to_postgres.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"

#include "planar/makeBiconnectedPlanar.hpp"
#include "cpp_common/base_graph.hpp"
#include <boost/graph/connected_components.hpp>

namespace pgrouting {
namespace drivers {

void do_planar(
        const std::string &edges_sql,

        Which which,

        II_t_rt* &return_tuples,
        size_t &return_count,
        std::ostringstream &log,
        std::ostringstream &notice,
        std::ostringstream &err) {
    std::string hint = "";

    try {
        if (edges_sql.empty()) {
            err << "Empty edges SQL";
            return;
        }

        using pgrouting::pgget::get_edges;
        using pgrouting::UndirectedGraph;

        hint = edges_sql;
        auto edges = get_edges(edges_sql, true, false);

        if (edges.empty()) {
            notice << "No edges found";
            log << edges_sql;
            return;
        }

        hint = "";

        UndirectedGraph undigraph;
        undigraph.insert_edges(edges);

        std::vector<size_t> component(boost::num_vertices(undigraph.graph));
        auto num_components = boost::connected_components(undigraph.graph, &component[0]);

        std::vector<II_t_rt> results;

        auto execute_planar = [&](UndirectedGraph& g) {
            std::vector<II_t_rt> sub_results;
            switch (which) {
                case BICONNECTEDPLANAR:
                    {
                        pgrouting::functions::Pgr_makeBiconnectedPlanar<UndirectedGraph>
                            fn_makeBiconnectedPlanar;
                        sub_results = fn_makeBiconnectedPlanar.makeBiconnectedPlanar(g);
                        log << fn_makeBiconnectedPlanar.get_log();
                    }
                    break;
                default:
                    throw std::string("Unknown planar function ") + get_name(which);
            }
            return sub_results;
        };

        if (num_components == 1) {
            results = execute_planar(undigraph);
        } else {
            std::vector<std::vector<Edge_t>> comp_edges(num_components);
            for (const auto& edge : edges) {
                auto v_desc = undigraph.get_V(edge.source);
                size_t c = component[v_desc];
                comp_edges[c].push_back(edge);
            }

            for (size_t c = 0; c < num_components; ++c) {
                if (comp_edges[c].empty()) continue;
                UndirectedGraph sub_graph;
                sub_graph.insert_edges(comp_edges[c]);
                auto sub_results = execute_planar(sub_graph);
                results.insert(results.end(), sub_results.begin(), sub_results.end());
            }
        }

        auto count = results.size();

        if (count == 0) {
            log << "No results found";
            return;
        }

        return_tuples = pgr_alloc(count, return_tuples);
        for (size_t i = 0; i < count; i++) {
            return_tuples[i] = results[i];
        }
        return_count = count;
    } catch (AssertFailedException &except) {
        err << except.what();
    } catch (const std::pair<std::string, std::string>& ex) {
        err << ex.first;
        log << ex.second;
    } catch (const std::string &ex) {
        err << ex;
        log << hint;
    } catch (std::exception &except) {
        err << except.what();
    } catch (...) {
        err << "Caught unknown exception!";
    }
}

}  // namespace drivers
}  // namespace pgrouting
