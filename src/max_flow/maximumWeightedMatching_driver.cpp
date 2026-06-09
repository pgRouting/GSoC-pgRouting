/*PGR-GNU*****************************************************************
File: maximumWeighted_matching_driver.cpp

Generated with Template by:
Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2026 Mayur Galhate
Mail: galhatemayur at gmail.com

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
#include <vector>
#include <string>

#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "c_types/iid_t_rt.h"
#include "max_flow/maximumWeightedMatching.hpp"

void pgr_do_maximum_weighted_matching(
    const char *edges_sql,
    int64_t **return_tuples,
    size_t *return_count,
    char** log_msg,
    char** notice_msg,
    char **err_msg) {
    using pgrouting::pgr_alloc;
    using pgrouting::to_pg_msg;
    using pgrouting::pgr_free;
    std::ostringstream log;
    std::ostringstream notice;
    std::ostringstream err;
    const char *hint = nullptr;
    try {
        hint = edges_sql;
        auto raw_edges = pgrouting::pgget::get_edges(
                std::string(edges_sql), false, false);
        if (raw_edges.empty()) {
            *notice_msg = to_pg_msg("No edges found");
            *log_msg = hint ? to_pg_msg(hint) : to_pg_msg(log);
            return;
        }
        hint = nullptr;
        std::vector<IID_t_rt> edges;
        edges.reserve(raw_edges.size());
        for (const auto& e : raw_edges) {
            edges.push_back({e.source, e.target, e.cost});
        }
        pgrouting::graph::UndirectedHasCostBG graph(edges);
        auto matched_edges = pgrouting::flow::maxWeightMatch(graph);
        (*return_tuples) = pgr_alloc(matched_edges.size(), (*return_tuples));
        size_t i = 0;
        for (const auto &e : matched_edges) {
            (*return_tuples)[i++] = e;
        }
        *return_count = matched_edges.size();
        *log_msg = to_pg_msg(log);
        *notice_msg = to_pg_msg(notice);
    } catch (AssertFailedException &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        *return_count = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (const std::string &ex) {
        *err_msg = to_pg_msg(ex);
        *log_msg = hint ? to_pg_msg(hint) : to_pg_msg(log);
    } catch (std::exception &except) {
        (*return_tuples) = pgr_free(*return_tuples);
        *return_count = 0;
        err << except.what();
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    } catch (...) {
        (*return_tuples) = pgr_free(*return_tuples);
        *return_count = 0;
        err << "Caught unknown exception!";
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    }
}
