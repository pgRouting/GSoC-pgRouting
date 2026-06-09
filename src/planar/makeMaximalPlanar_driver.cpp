/*PGR-GNU*****************************************************************
File: makeMaximalPlanar_driver.cpp

Generated with Template by:
Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

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

#include "drivers/makeMaximalPlanar_driver.hpp"

#include <vector>
#include <algorithm>
#include <string>
#include <sstream>
#include <utility>
#include <cstdint>

#include "c_types/ii_t_rt.h"
#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/utilities.hpp"
#include "cpp_common/to_postgres.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"

#include "planar/makeMaximalPlanar.hpp"
#include "cpp_common/base_graph.hpp"

namespace pgrouting {
namespace drivers {

void do_makeMaximalPlanar(
        const std::string &edges_sql,
        II_t_rt* &return_tuples,
        size_t &return_count,
        std::ostringstream &log,
        std::ostringstream &notice,
        std::ostringstream &err) {
    using pgrouting::pgr_alloc;
    using pgrouting::pgget::get_edges;

    std::string hint = "";
    return_tuples = nullptr;
    return_count = 0;

    try {
        if (edges_sql.empty()) {
            err << "Empty edges SQL";
            return;
        }

        std::vector<II_t_rt> results;
        std::string logstr;

        hint = edges_sql;
        auto edges = get_edges(edges_sql, true, false);
        if (edges.empty()) {
            notice << "No edges found";
            log << edges_sql;
            return;
        }
        hint = "";

        pgrouting::UndirectedGraph undigraph;
        undigraph.insert_edges(edges);

        pgrouting::functions::Pgr_makeMaximalPlanar<pgrouting::UndirectedGraph>
            fn_makeMaximalPlanar;
        results = fn_makeMaximalPlanar.makeMaximalPlanar(undigraph);
        logstr += fn_makeMaximalPlanar.get_log();
        log << logstr;

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
