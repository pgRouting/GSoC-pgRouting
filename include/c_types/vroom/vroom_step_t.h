/*PGR-GNU*****************************************************************
File: vroom_step_t.h

Copyright (c) 2021 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Ashish Kumar
Mail: ashishkr23438@gmail.com

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

#ifndef INCLUDE_C_TYPES_VROOM_VROOM_STEPS_T_H_
#define INCLUDE_C_TYPES_VROOM_VROOM_STEPS_T_H_
#pragma once

#include "c_types/typedefs.h"

/** @brief Vehicle step's attributes

@note C/C++/postgreSQL connecting structure for input
name | description
:----- | :-------
id | Step's identifier
type | Type of the step
service_at | Hard constraint on service time
service_after | Hard constraint on service time lower bound
service_before | Hard constraint on service time upper bound
*/
struct Vroom_step_t {
  Idx id; /** Step's identifier */

  // TODO(ashish): Change to enum
  uint64_t type; /** Type of the step */

  Duration service_at; /** Hard constraint on service time */
  Duration service_after; /** Hard constraint on service time lower bound */
  Duration service_before; /** Hard constraint on service time upper bound */
};


#endif  // INCLUDE_C_TYPES_VROOM_VROOM_STEPS_T_H_
