/*PGR-GNU*****************************************************************

File: planarFaces_driver.cpp

Copyright (c) 2015-2026 pgRouting developers
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
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

#include "drivers/planar/planarFaces_driver.h"

#include <sstream>
#include <string>

#include "c_types/planar_face_rt.h"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"

void
pgr_do_planarFaces(
        const char* edges_sql,
        Planar_face_rt** result_tuples,
        size_t* result_count,
        char** log_msg,
        char** notice_msg,
        char** err_msg) {
    using pgrouting::to_pg_msg;

    std::ostringstream log;
    std::ostringstream err;
    std::ostringstream notice;

    try {
        pgassert(!(*log_msg));
        pgassert(!(*notice_msg));
        pgassert(!(*err_msg));
        pgassert(!(*result_tuples));
        pgassert(*result_count == 0);

        *result_tuples = nullptr;
        *result_count = 0;

        /* TODO(week-2): implement planar face traversal algorithm here */
        (void)edges_sql;

        pgassert(*err_msg == NULL);
        *log_msg = to_pg_msg(log);
        *notice_msg = to_pg_msg(notice);
    } catch (AssertFailedException &except) {
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (const std::string &ex) {
        *err_msg = to_pg_msg(ex);
        *log_msg = to_pg_msg(log);
    } catch (std::exception &except) {
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (...) {
        err << "Caught unknown exception!";
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    }
}
