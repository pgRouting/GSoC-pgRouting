/*PGR-GNU*****************************************************************
File: maximumWeightedMatching_driver.cpp

Generated with Template by:
Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2026 Mayur Galhate
Mail: mayur.galhate at gmail.com

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

#include "drivers/max_flow/maximumWeightedMatching_driver.h"

#include <sstream>
#include <string>
#include <utility>
#include <vector>

#include "c_types/iid_t_rt.h"
#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "max_flow/maximumWeightedMatching.hpp"
#include "cpp_common/undirectedHasCostBG.hpp"


void
pgr_do_maximumWeightedMatching(
        const char *edges_sql,

        IID_t_rt **return_tuples,
        size_t *return_count,

        char **log_msg,
        char **notice_msg,
        char **err_msg) {
    using pgrouting::pgr_alloc;
    using pgrouting::to_pg_msg;
    using pgrouting::pgr_free;

    std::ostringstream log;
    std::ostringstream notice;
    std::ostringstream err;
    const char *hint = nullptr;

    try {
        pgassert(!(*log_msg));
        pgassert(!(*notice_msg));
        pgassert(!(*err_msg));
        pgassert(!(*return_tuples));
        pgassert(*return_count == 0);

        hint = edges_sql;
        auto edges = pgrouting::pgget::get_edges(std::string(edges_sql), false, false);

        if (edges.empty()) {
            *notice_msg = to_pg_msg("No edges found");
            *log_msg = hint ? to_pg_msg(hint) : to_pg_msg(log);
            return;
        }
        hint = nullptr;

        std::vector<IID_t_rt> matrix;
        matrix.reserve(edges.size());
        for (const auto &e : edges) {
            IID_t_rt row;
            row.from_vid = e.source;
            row.to_vid   = e.target;
            row.cost     = e.cost;
            matrix.push_back(row);
        }

        pgrouting::graph::UndirectedHasCostBG graph(matrix);

        auto matched_pairs = pgrouting::flow::maximumWeightedMatch(graph);

        auto count = matched_pairs.size();

        if (count == 0) {
            (*return_tuples) = nullptr;
            (*return_count)  = 0;
            notice << "No matching found";
            *log_msg = to_pg_msg(notice);
            return;
        }

        double agg = 0.0;
        (*return_tuples) = pgr_alloc(count, (*return_tuples));
        for (size_t i = 0; i < count; i++) {
            agg += matched_pairs[i].cost;
            matched_pairs[i].cost = agg;
            (*return_tuples)[i]   = matched_pairs[i];
        }
        *return_count = count;

        pgassert(*err_msg == nullptr);
        *log_msg    = to_pg_msg(log);
        *notice_msg = to_pg_msg(notice);
    } catch (AssertFailedException &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count)  = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (const std::pair<std::string, std::string> &ex) {
        (*return_count) = 0;
        *err_msg = to_pg_msg(ex.first.c_str());
        *log_msg = to_pg_msg(ex.second.c_str());
    } catch (const std::string &ex) {
        *err_msg = to_pg_msg(ex);
        *log_msg = hint ? to_pg_msg(hint) : to_pg_msg(log);
    } catch (std::exception &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count)  = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (...) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count)  = 0;
        err << "Caught unknown exception!";
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    }
}
