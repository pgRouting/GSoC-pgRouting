/*PGR-GNU*****************************************************************

File: planarFaces_driver.h

Copyright (c) 2015-2026 pgRouting developers
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
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/
/*! @file */

#ifndef INCLUDE_DRIVERS_PLANAR_PLANARFACES_DRIVER_H_
#define INCLUDE_DRIVERS_PLANAR_PLANARFACES_DRIVER_H_
#pragma once

#ifdef __cplusplus
# include <cstddef>
using Planar_face_rt = struct Planar_face_rt;
#else
# include <stddef.h>
typedef struct Planar_face_rt Planar_face_rt;
#endif

#ifdef __cplusplus
extern "C" {
#endif

void pgr_do_planarFaces(
        const char*,
        Planar_face_rt**, size_t*,
        char**, char**, char**);

#ifdef __cplusplus
}
#endif

#endif  // INCLUDE_DRIVERS_PLANAR_PLANARFACES_DRIVER_H_
