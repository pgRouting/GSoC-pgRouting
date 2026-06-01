/*PGR-GNU*****************************************************************
File: planarFaces_driver.cpp

Copyright (c) 2026-2026 pgRouting developers
Mail: project@pgrouting.org

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

#include <sstream>
#include <vector>
#include <string>

#include "c_types/planarFaces_rt.h"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "cpp_common/pgdata_getters.hpp"

namespace pgrouting {
namespace drivers {

void
do_planarFaces(
        const std::string &edges_sql,
        PlanarFace_rt* &return_tuples, size_t &return_count,
        std::ostringstream &log,
        std::ostringstream &notice,
        std::ostringstream &err) {
    using pgrouting::pgr_alloc;
    using pgrouting::pgr_free;
    using pgrouting::pgget::get_edges;

    std::string hint = "";
    try {
        if (edges_sql.empty()) {
            err << "Empty edges SQL";
            return;
        }

        hint = edges_sql;
        auto edges = get_edges(edges_sql, true, true);
        hint = "";

        if (edges.empty()) {
            notice << "No edges found";
            return;
        }

        /* TODO: implement pgr_planarFaces algorithm */
        return_tuples = nullptr;
        return_count = 0;
    } catch (AssertFailedException &except) {
        return_tuples = pgr_free(return_tuples);
        return_count = 0;
        err << except.what();
    } catch (const std::string &ex) {
        err << ex;
        log << hint;
    } catch (std::exception &except) {
        return_tuples = pgr_free(return_tuples);
        return_count = 0;
        err << except.what();
    } catch (...) {
        return_tuples = pgr_free(return_tuples);
        return_count = 0;
        err << "Caught unknown exception!";
    }
}

}  // namespace drivers
}  // namespace pgrouting
