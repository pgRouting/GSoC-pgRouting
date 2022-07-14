/*PGR-GNU*****************************************************************
File: knapsack_driver.h

Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2022 Manas Sivakumar
Mail:

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

/*! @file knapsack_driver.h */

#ifndef INCLUDE_DRIVERS_OR_TOOLS_KNAPSACK_DRIVER_H_
#define INCLUDE_DRIVERS_OR_TOOLS_KNAPSACK_DRIVER_H_
#pragma once

/* for size-t */
#ifdef __cplusplus
#   include <cstddef>
#else
#   include <stddef.h>
#endif

typedef struct Knapsack_rt Knapsack_rt;

#ifdef __cplusplus
extern "C" {
#endif

  /*********************************************************
    weights_cost_sql TEXT,
    capacity INTEGER,
   ********************************************************/
  void do_knapsack(
      Knapsack_rt *knapsack_items, size_t total_knapsack_items,
      
      int capacity,
      
      Knapsack_rt **return_tuples,
      size_t *return_count,

      char **log_msg,
      char **notice_msg,
      char **err_msg);


#ifdef __cplusplus
}
#endif

#endif  // INCLUDE_DRIVERS_OR_TOOLS_KNAPSACK_DRIVER_H_

