/*PGR-GNU*****************************************************************
File: pgr_makeConnected.hpp

Copyright (c) 2020 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2020 Himanshu Raj
Mail: raj.himanshu2@gmail.com

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

#ifndef INCLUDE_MAKECONNECTED_PGR_MAKECONNECTED_HPP_
#define INCLUDE_MAKECONNECTED_PGR_MAKECONNECTED_HPP_
#pragma once

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/properties.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/ref.hpp>
#include <vector>

#include <boost/graph/connected_components.hpp>
#include <boost/graph/make_connected.hpp>

#include "cpp_common/pgr_base_graph.hpp"
#include "cpp_common/pgr_messages.h"
#include "c_types/pgr_makeConnected_t.h"

//******************************************
using namespace boost;
namespace pgrouting {
namespace functions {

  template < class G >
  class Pgr_makeConnected : public pgrouting::Pgr_messages{
   public:
       typedef typename G::V V;
       typedef typename G::E E;
       typedef typename G::E_i E_i;
       std::vector<pgr_makeConnected_t> makeConnected(
                   G &graph){
                     return generatemakeConnected(
                                            graph);
                   }
   private:
     std::vector< pgr_makeConnected_t >
     generatemakeConnected(
        const G &graph ) {
       std::vector< pgr_makeConnected_t > results(num_edges(graph.graph));
      E_i ei, ei_end;
      int i=0;
            log << "here:\n"<< i;
            // std::cout << i <<" ";
           results[0].node_from = results.size();
           results[0].node_to = results.size();

       return results;
    }
  };
}
}

#endif //INCLUDE_MAKECONNECTED_PGR_MAKECONNECTED_HPP_
