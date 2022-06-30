/*PGR-GNU*****************************************************************

Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2022 Nitish Chauhan
Mail: nitishchauhan0022 at gmail.com

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

#ifndef INCLUDE_CIRCUIT_PGR_HAWICKCIRCUITS_HPP_
#define INCLUDE_CIRCUIT_PGR_HAWICKCIRCUITS_HPP_
#pragma once

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/graph/hawick_circuits.hpp>
#include <boost/property_map/property_map.hpp>
#include <iostream>
#include <iterator>

#include "cpp_common/basePath_SSEC.hpp"
#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/pgr_assert.h"

#include "c_types/circuits_rt.h"

struct circuit_detector
{
    std::vector < circuits_rt > results;
    template <typename Path, typename Graph>
    void cycle(Path const &p, Graph const &g)
    {
       if (p.empty())
            return;
        // Iterate over path printing each vertex that forms the circuit.
        typename Path::const_iterator i=p.begin(), before_end = p.end();

        int64_t* circuit = nullptr;
        size_t adj_siz = static_cast<size_t>(before_end - i);
        circuit = pgr_alloc(adj_siz , circuit);
        int number=0;
        for (; i != before_end; ++i)
        {
            circuit[number++]=i;

        }
        results.push_back({{circuit}, {(adj_siz)}});

    }

    std::vector < circuits_rt > result()
    {
        return results;
    }

};

std::vector <circuits_rt> pgr_hawickCircuits(G &graph)
{

    circuit_detector visitor;
    boost::hawick_circuits(G, visitor);

    return visitor.result();

}