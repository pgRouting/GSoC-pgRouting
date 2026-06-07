/*PGR-GNU*****************************************************************
File: coreNumbers_driver.hpp

Copyright (c) 2007-2026 pgRouting developers
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

#ifndef INCLUDE_DRIVERS_CORENUMBERS_DRIVER_HPP_
#define INCLUDE_DRIVERS_CORENUMBERS_DRIVER_HPP_

#include <cstddef>
#include <cstdint>
#include <string>
#include <sstream>

using CoreNumbers_rt = struct CoreNumbers_rt;

namespace pgrouting {
namespace drivers {

void do_coreNumbers(
        const std::string&,
        CoreNumbers_rt*&, size_t&,
        std::ostringstream&, std::ostringstream&, std::ostringstream&);

}  // namespace drivers
}  // namespace pgrouting

#endif  // INCLUDE_DRIVERS_CORENUMBERS_DRIVER_HPP_
