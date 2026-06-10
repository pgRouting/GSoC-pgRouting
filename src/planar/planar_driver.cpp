/*PGR-GNU*****************************************************************
File: planar_driver.cpp

Copyright (c) 2026-2026 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
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

#include "drivers/planar_driver.hpp"

#include <string>
#include <sstream>

#include "drivers/planarFaces_driver.hpp"

namespace pgrouting {
namespace drivers {

void
do_planar(
        const std::string &edges_sql,
        Which which,

        PlanarFace_rt *&return_tuples,
        size_t &return_count,

        std::ostringstream &log,
        std::ostringstream &notice,
        std::ostringstream &err) {
    switch (which) {
        case PLANARFACES:
            do_planarFaces(edges_sql, return_tuples, return_count, log, notice, err);
            break;
        default:
            break;
    }
}

}  // namespace drivers
}  // namespace pgrouting
