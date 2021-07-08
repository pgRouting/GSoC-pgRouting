/*PGR-GNU*****************************************************************
File: vroom_driver.cpp

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

#include "drivers/vroom/vroom_driver.h"

#include <sstream>
#include <vector>
#include <algorithm>
#include <string>

#include "c_common/pgr_alloc.hpp"
#include "cpp_common/pgr_assert.h"

/** @file vroom_driver.cpp
 * @brief Handles actual calling of function in the `vrp_vroom.hpp` file.
 *
 */

/***********************************************************************
 *
 *   vrp_vroom(
 *    vrp_json JSON,
 *    osrm_host TEXT DEFAULT 'car:0.0.0.0',
 *    osrm_port TEXT DEFAULT 'car:5000',
 *    plan BOOLEAN DEFAULT FALSE,
 *    geometry BOOLEAN DEFAULT FALSE
 *   );
 *
 ***********************************************************************/

/** @brief Calls the main function defined in the C++ Header file.
 *
 * @param problem_instance_json string describing problem instance
 * @param server_host       OSRM routing server host in the form of PROFILE:HOST
 * @param server_port       OSRM routing server port in the form of PROFILE:PORT
 * @param plan          whether the mode is plan mode
 * @param geometry        whether to add detailed route geometry and indicators
 *
 * @returns results, when results are found
 */

char*
vrp_vroom(
    std::string problem_instance_json,
    std::string server_host,
    std::string server_port,
    bool plan,
    bool geometry) {
  char *result;
#if 0
  pgrouting::functions::Vrp_vroom fn_vroom;
  result = fn_vroom.vroom(problem_instance_json, server_host, server_port, plan, geometry);
  log += fn_vroom.get_log();
#endif
  return result;
}

/** @brief Performs exception handling and converts the results to postgres.
 *
 * @pre log_msg is empty
 * @pre notice_msg is empty
 * @pre err_msg is empty
 * @pre return_tuples is empty
 * @pre return_count is 0
 *
 * It converts the C types to the C++ types, and passes these variables to the
 * function `vrp_vroom` which calls the main function defined in the
 * C++ Header file. It also does exception handling.
 *
 * @param vrp_json     JSON object describing the problem instance
 * @param osrm_host    OSRM routing server host in the form of PROFILE:HOST
 * @param osrm_port    OSRM routing server port in the form of PROFILE:PORT.
 * @param plan       whether the mode is plan mode
 * @param geometry     whether to add detailed route geometry and indicators
 * @param return_tuples  the rows in the result
 * @param return_count   the count of rows in the result
 * @param log_msg    stores the log message
 * @param notice_msg   stores the notice message
 * @param err_msg    stores the error message
 *
 * @returns void
 */
void
do_vrp_vroom(
    char *vrp_json,
    char *osrm_host,
    char *osrm_port,
    bool plan,
    bool geometry,

    char **result,

    char ** log_msg,
    char ** notice_msg,
    char ** err_msg) {
  std::ostringstream log;
  std::ostringstream err;
  std::ostringstream notice;
  try {
    pgassert(!(*log_msg));
    pgassert(!(*notice_msg));
    pgassert(!(*err_msg));
    pgassert(!(*result));

    std::string problem_instance_json(vrp_json);
    std::string server_host(osrm_host);
    std::string server_port(osrm_port);

    std::string logstr;
    (*result) = vrp_vroom(problem_instance_json, server_host, server_port, plan, geometry);
    log << logstr;

    pgassert(*err_msg == NULL);
    *log_msg = log.str().empty()?
      *log_msg :
      pgr_msg(log.str().c_str());
    *notice_msg = notice.str().empty()?
      *notice_msg :
      pgr_msg(notice.str().c_str());
  } catch (AssertFailedException &except) {
    result = pgr_free(result);
    err << except.what();
    *err_msg = pgr_msg(err.str().c_str());
    *log_msg = pgr_msg(log.str().c_str());
  } catch (std::exception &except) {
    result = pgr_free(result);
    err << except.what();
    *err_msg = pgr_msg(err.str().c_str());
    *log_msg = pgr_msg(log.str().c_str());
  } catch(...) {
    result = pgr_free(result);
    err << "Caught unknown exception!";
    *err_msg = pgr_msg(err.str().c_str());
    *log_msg = pgr_msg(log.str().c_str());
  }
}
