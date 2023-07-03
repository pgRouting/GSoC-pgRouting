/*PGR-GNU*****************************************************************
File: v4drivedist_driver.h

Generated with Template by:                                                                                             
Copyright (c) 2023 pgRouting developers                                                                                 
Mail: project AT pgrouting.org   

Copyright (c) 2023 Aryan Gupta
guptaaryan1010 AT gmail.com
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

#ifndef INCLUDE_DRIVERS_DRIVING_DISTANCE_V4DRIVEDIST_DRIVER_H_
#define INCLUDE_DRIVERS_DRIVING_DISTANCE_V4DRIVEDIST_DRIVER_H_

/* for size-t */
#ifdef __cplusplus
#   include <cstdint>
#   include <cstddef>
using Edge_t = struct Edge_t;
using MST_rt = struct MST_rt;
#else
#   include <stddef.h>
#   include <stdint.h>
typedef struct Edge_t Edge_t;
typedef struct MST_rt MST_rt;
#endif

#ifdef __cplusplus
extern "C" {
#endif

    void do_pgr_v4driving_many_to_dist(
            Edge_t* edges, size_t total_edges,
            int64_t* start_vertex, size_t s_len,
            double distance,
            bool directed,
            bool equicost,
            MST_rt** return_tuples, size_t* return_count,
            char **log_msg,
            char **notice_msg,
            char **err_msg);

#ifdef __cplusplus
}
#endif

#endif  //INCLUDE_DRIVERS_DRIVING_DISTANCE_V4DRIVEDIST_DRIVER_H_
