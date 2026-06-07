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

#include "drivers/max_flow/maximum_weighted_matching_driver.h"

#include <sstream>
#include <string>
#include <vector>

#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"
#include "cpp_common/pgdata_getters.hpp"

#include "max_flow/maximumWeightedMatching.hpp"

void
pgr_do_maximum_weighted_matching(
    const char *edges_sql,

    int64_t **return_tuples,
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

    try {
        auto edges = pgrouting::pgget::get_basic_edges(std::string(edges_sql));

        if (edges.empty()) {
            *notice_msg = to_pg_msg("No edges found");
            *log_msg = to_pg_msg(log);
            return;
        }

        pgrouting::UndirectedGraph graph;
        graph.insert_edges(edges);

        auto result = pgrouting::flow::maximumWeightedMatching(graph);

        *return_count = result.size();
        *return_tuples = pgr_alloc(result.size(), *return_tuples);

        size_t i = 0;
        for (const auto &v : result) {
            (*return_tuples)[i++] = v;
        }

        *log_msg = to_pg_msg(log);
        *notice_msg = to_pg_msg(notice);
    }
    catch (std::exception &e) {
        *err_msg = to_pg_msg(e.what());
        *return_tuples = pgr_free(*return_tuples);
        *return_count = 0;
    }
}
