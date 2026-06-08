/*PGR-GNU*****************************************************************
File: maximumWeightedMatching.hpp

Copyright (c) 2016-2026 pgRouting developers
Mail: project@pgrouting.org

Ignoring directed flag & works only for undirected graph
Copyright (c) 2022 Celia Virginia Vergara Castillo
Mail: vicky at erosion.dev

Function's developer:
Copyright (c) 2026 Mayur Galhate
Mail: galhatemayur at gmail.com

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
********************************************************************PGR-GNU*/

#ifndef INCLUDE_MAX_FLOW_MAXIMUMWEIGHTEDMATCHING_HPP_
#define INCLUDE_MAX_FLOW_MAXIMUMWEIGHTEDMATCHING_HPP_

#include <set>
#include "cpp_common/undirectedHasCostBG.hpp"
namespace pgrouting {
namespace flow {

std::set<int64_t> maxWeightMatch(pgrouting::graph::UndirectedHasCostBG& graph);

}  // namespace flow
}  // namespace pgrouting

#endif  // INCLUDE_MAX_FLOW_MAXIMUMWEIGHTEDMATCHING_HPP_
