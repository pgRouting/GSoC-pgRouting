/*PGR-GNU*****************************************************************
File: bellman_ford_neg_driver.cpp

Generated with Template by:
Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2018 Sourabh Garg
Mail: sourabh.garg.mat@gmail.com

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

#include "drivers/bellman_ford/bellman_ford_neg_driver.h"

#include <sstream>
#include <deque>
#include <vector>
#include <algorithm>
#include <string>
#include <map>
#include <set>

#include "bellman_ford/bellman_ford.hpp"

#include "cpp_common/combinations.hpp"
#include "cpp_common/pgdata_getters.hpp"
#include "cpp_common/alloc.hpp"
#include "cpp_common/assert.hpp"

#include "c_types/ii_t_rt.h"

namespace {


template <class G>
std::deque<pgrouting::Path>
bellman_ford(
        G &graph,
        const std::map<int64_t, std::set<int64_t>> &combinations,
        bool only_cost = false) {
    pgrouting::Pgr_bellman_ford<G> fn_bellman_ford;
    auto paths = fn_bellman_ford.bellman_ford(graph, combinations, only_cost);
    for (auto &p : paths) p.recalculate_agg_cost();
    return paths;
}

}  // namespace

void
pgr_do_bellman_ford_neg(
                const char *edges_sql,
                const char *neg_edges_sql,
                const char *combinations_sql,
                ArrayType *starts,
                ArrayType *ends,

                bool directed,
                bool only_cost,

                Path_rt **return_tuples,
                size_t *return_count,
                char ** log_msg,
                char ** notice_msg,
                char ** err_msg) {
    using pgrouting::Path;
    using pgrouting::pgr_alloc;
    using pgrouting::to_pg_msg;
    using pgrouting::pgr_free;
    using pgrouting::utilities::get_combinations;
    using pgrouting::pgget::get_edges;

    std::ostringstream log;
    std::ostringstream err;
    std::ostringstream notice;
    const char *hint = nullptr;

    try {
        pgassert(!(*log_msg));
        pgassert(!(*notice_msg));
        pgassert(!(*err_msg));
        pgassert(!(*return_tuples));
        pgassert(*return_count == 0);



        hint = combinations_sql;
        auto combinations = get_combinations(combinations_sql, starts, ends, true);
        hint = nullptr;

        if (combinations.empty() && combinations_sql) {
            *notice_msg = to_pg_msg("No (source, target) pairs found");
            *log_msg = to_pg_msg(combinations_sql);
            return;
        }

        hint = edges_sql;
        auto edges = get_edges(std::string(edges_sql), true, false);

        hint = neg_edges_sql;
        auto neg_edges = get_edges(std::string(neg_edges_sql), true, false);

        if (edges.size() + neg_edges.empty()) {
            *notice_msg = to_pg_msg("No edges found");
            *log_msg = hint? to_pg_msg(hint) : to_pg_msg(log);
            return;
        }
        hint = nullptr;

        std::deque<Path> paths;
        if (directed) {
            pgrouting::DirectedGraph digraph;
            digraph.insert_edges(edges);
            digraph.insert_negative_edges(neg_edges);
            paths = bellman_ford(digraph, combinations, only_cost);
        } else {
            pgrouting::UndirectedGraph undigraph;
            undigraph.insert_edges(edges);
            undigraph.insert_negative_edges(neg_edges);
            paths = bellman_ford(undigraph, combinations, only_cost);
        }

        size_t count(0);
        count = count_tuples(paths);

        if (count == 0) {
            (*return_tuples) = NULL;
            (*return_count) = 0;
            notice << "No paths found";
            *log_msg = to_pg_msg(notice);
            return;
        }

        (*return_tuples) = pgr_alloc(count, (*return_tuples));
        (*return_count) = (collapse_paths(return_tuples, paths));

        *log_msg = to_pg_msg(log);
        *notice_msg = to_pg_msg(notice);
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
    } catch(...) {
        (*return_tuples) = pgr_free(*return_tuples);
        (*return_count) = 0;
        err << "Caught unknown exception!";
        *err_msg = to_pg_msg(err);
        *log_msg = to_pg_msg(log);
    }
}
