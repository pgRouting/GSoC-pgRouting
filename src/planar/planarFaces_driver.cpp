/*PGR-GNU*****************************************************************
File: planarFaces_driver.cpp

Copyright (c) 2026-2026 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2026 Sakir Ahmed
Mail: sakirahmed75531 at gmail.com

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

#include "drivers/planarFaces_driver.hpp"

#include <vector>
#include <string>
#include <sstream>

#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "cpp_common/pgdata_getters.hpp"

#include "planar/planarFaces.hpp"
#include "cpp_common/base_graph.hpp"

namespace pgrouting {
namespace drivers {

void
do_planarFaces(
        const std::string &edges_sql,

        PlanarFace_rt *&return_tuples,
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

        hint = edges_sql;
        auto edges = get_edges(edges_sql, true, true);
        if (edges.empty()) {
            notice << "No edges found";
            log << hint;
            return;
        }
        hint = "";

        pgrouting::UndirectedGraph undigraph;
        undigraph.insert_edges(edges);

        pgrouting::functions::Pgr_planarFaces<pgrouting::UndirectedGraph> fn;
        auto results = fn.planarFaces(undigraph);
        log << fn.get_log();

        auto count = results.size();

        if (count == 0) {
            notice << "No results found";
            return;
        }

        return_tuples = pgr_alloc(count, return_tuples);
        for (size_t i = 0; i < count; ++i) {
            return_tuples[i] = results[i];
        }
        return_count = count;
    } catch (AssertFailedException &except) {
        err << except.what();
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
