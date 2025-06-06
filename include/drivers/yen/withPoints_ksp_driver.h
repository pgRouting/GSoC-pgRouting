/*PGR-GNU*****************************************************************
File: withPoints_driver.h

Copyright (c) 2015 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2015 Celia Virginia Vergara Castillo
Mail: vicky at erosion.dev

Copyright (c) 2023 Abhinav Jain
Mail: this.abhinav at gmail.com

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

#ifndef INCLUDE_DRIVERS_YEN_WITHPOINTS_KSP_DRIVER_H_
#define INCLUDE_DRIVERS_YEN_WITHPOINTS_KSP_DRIVER_H_
#pragma once


#ifdef __cplusplus
extern "C" {
#endif

#include <postgres.h>
#include <utils/array.h>

#ifdef __cplusplus
}
#endif

#include "cpp_common/undefPostgresDefine.hpp"

#ifdef __cplusplus
#   include <cstddef>
#   include <cstdint>
using Path_rt = struct Path_rt;
#else
#   include <stddef.h>
#   include <stdint.h>
typedef struct Path_rt Path_rt;
#endif

#ifdef __cplusplus
extern "C" {
#endif


void pgr_do_withPointsKsp(
        const char*,
        const char*,
        const char*,
        const char*,
        ArrayType*, ArrayType*,
        int64_t*, int64_t*,
        size_t,

bool, bool, char, bool,

        Path_rt**, size_t*,
        char**, char**, char**);

#ifdef __cplusplus
}
#endif

#endif  // INCLUDE_DRIVERS_YEN_WITHPOINTS_KSP_DRIVER_H_
