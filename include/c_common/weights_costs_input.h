/*PGR-GNU*****************************************************************
 * TODO fix licence
File: matrixRows_input.h
Copyright (c) 2022 Manas Sivakumar
manas23601@gmail.com
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

#ifndef INCLUDE_C_COMMON_WEIGHTS_COSTS_INPUT_H_
#define INCLUDE_C_COMMON_WEIGHTS_COSTS_INPUT_H_
#pragma once
#include <stddef.h>

typedef struct Knapsack_rt Knapsack_rt;

/** @brief Get the weights and cost for each item */
void get_weights_costs(
    char *sql,
    Knapsack_rt **rows,
    size_t *total_rows);

#endif  // INCLUDE_C_COMMON_WEIGHTS_COSTS_INPUT_H_
