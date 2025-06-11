/*PGR-GNU*****************************************************************
File: ordering_driver.cpp
Generated with Template by:
Copyright (c) 2025 pgRouting developers
Mail: project@pgrouting.org

Developer:
Copyright (c) 2025 Bipasha Gayary
Mail: bipashagayary at gmail.com
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

#include "drivers/ordering/ordering_driver.hpp"

#include <sstream>
#include <vector>
#include <algorithm>
#include <string>


#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "c_types/ii_t_rt.h"

#if 0
#include "ordering/sloanOrdering.hpp"
#endif

namespace {

	template <class G>
	std::vector <II_t_rt>
	ordering(G &graph, int64_t start_vid, int64_t end_vid) {
		pgrouting::functions::SloanOrdering <G> fn_sloanOrdering;
		auto results = fn_sloanOrdering.sloanOrdering(graph, start_vid, end_vid);
	return results;
	}

}


void 
pgr_do_ordering(
    const char *edges_sql,
    int64_t start_vid,
    int64_t end_vid,
    II_t_rt **return_tuples,
    size_t *return_count,

    char **log_msg,
    char **notice_msg,
    char **err_msg) {
    using pgrouting::pgr_alloc;
    using pgrouting::to_pg_msg;
    using pgrouting::pgr_free;

    std::ostringstream log;
    std::ostringstream err;
    std::ostringstream notice;
    const char *hint = nullptr;

    try {
#if 0
        pgassert(!(*log_msg));
        pgassert(!(*notice_msg));
        pgassert(!(*err_msg));
        pgassert(!(*return_tuples));
        pgassert(*return_count == 0);

        hint = edges_sql;
        auto edges = pgrouting::pgget::get_edges(std::string(edges_sql), true, false);
        if (edges.empty()) {
            *notice_msg = to_pg_msg("No edges found");
            *log_msg = hint? to_pg_msg(hint) : to_pg_msg(log);
            return;
        }
        hint = nullptr;

        std::vector<II_t_rt> results;
        pgrouting::UndirectedGraph undigraph;
        undigraph.insert_edges(edges);

        if (start_vid != 0 && !undigraph.has_vertex(start_vid)){
		err << "Start vertex" << start_vid << "not found in graph";
		*err_msg = to_pg_msg(err);
		*log_msg = to_pg_msg(log);
		return;
	}

	if (end_vid != 0 && !undigraph.has_vertex(end_vid)) {
		err << "End vertex" << end_vid << "not found in graph";
		*err_msg = to_pg_msg(err);
		*log_msg = to_pg_msg(log);
		return;
	}

        results = ordering(undigraph);

        auto count = results.size();

        if (count == 0) {
            (*return_tuples) = NULL;
            (*return_count) = 0;
            notice << "No results found";
            *log_msg = to_pg_msg(log);
	    *notice_msg = to_pg_msg(notice);
	    return;
        }

        (*return_tuples) = pgr_alloc(count, (*return_tuples));
        for (size_t i = 0; i < count; i++) {
            *((*return_tuples) + i) = results[i];
        }
        (*return_count) = count;

        pgassert(*err_msg == NULL);
        *log_msg = log.str().empty() ?
        *log_msg :
        to_pg_msg(log);
        *notice_msg = notice.str().empty() ?
        *notice_msg :
        to_pg_msg(notice);

#endif
    } catch (AssertFailedException &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (const std::string &ex) {
        *err_msg = to_pg_msg(ex);
        *log_msg = hint? to_pg_msg(hint) : to_pg_msg(log);
    } catch (std::exception &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (...) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << "Caught unknown exception!";
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    }
}
