/*PGR-GNU*****************************************************************
File: knapsack_rt.h

Copyright (c) 2022 Manas Sivakumar
Mail: vicky_vergara@hotmail.com

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
/*! @file */

#ifndef INCLUDE_C_TYPES_KNAPSACK_RT_H_
#define INCLUDE_C_TYPES_KNAPSACK_RT_H_
#pragma once

/* for int64_t */
#ifdef __cplusplus
#   include <cstdint>
#else
#   include <stdint.h>
#endif

/** @brief

@note C/C++/postgreSQL connecting structure for output
name | description
:----- | :-------
Index       | Position of the item in the order in which the input was given
item_weight  | Weight of the item
item_cost   | Value of the item
*/

struct Knapsack_rt {
    int64_t item_weight;
    int64_t item_calue;
};

/*************************************************************************/

#endif  // INCLUDE_C_TYPES_KNAPSACK_RT_H_
