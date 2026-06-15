/*PGR-GNU*****************************************************************
File: coreNumbers.cpp

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

#include "metrics/coreNumbers.hpp"

#include <vector>

#include "cpp_common/base_graph.hpp"
#include "cpp_common/interruption.hpp"

namespace pgrouting {
namespace metrics {

std::vector<II_t_rt>
coreNumbers(const pgrouting::UndirectedGraph &graph) {
    CHECK_FOR_INTERRUPTS();

    /* TODO: implement k-core decomposition algorithm */
    std::vector<II_t_rt> results;
    (void)graph;
    return results;
}

}  // namespace metrics
}  // namespace pgrouting
