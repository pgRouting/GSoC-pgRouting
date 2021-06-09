/*PGR-GNU*****************************************************************
File: vroom.c

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

/** @file vroom.c
 * @brief Connecting code with postgres.
 *
 */

#include <assert.h>
#include <stdbool.h>
#include "c_common/postgres_connection.h"

#include "c_common/debug_macro.h"
#include "c_common/e_report.h"
#include "c_common/time_msg.h"

#include "c_types/vroom/vroom_rt.h"
#include "c_types/vroom/vroom_job_t.h"
#include "c_types/vroom/vroom_shipment_t.h"
#include "c_types/vroom/vroom_vehicle_t.h"

#include "c_common/vroom/jobs_input.h"
#include "c_common/vroom/shipments_input.h"
#include "c_common/vroom/vehicles_input.h"
#include "c_common/vroom/matrix_input.h"

#include "drivers/vroom/vroom_driver.h"

PGDLLEXPORT Datum _vrp_vroom(PG_FUNCTION_ARGS);
PG_FUNCTION_INFO_V1(_vrp_vroom);

/** @brief Static function, loads the data from postgres to C types for further processing.
 *
 * It first connects the C function to the SPI manager. Then converts
 * the postgres array to C array and loads the edges belonging to the graph
 * in C types. Then it calls the function `do_vrp_vroom` defined
 * in the `vroom_driver.h` file for further processing.
 * Finally, it frees the memory and disconnects the C function to the SPI manager.
 *
 * @returns void
 */
static
void
process(
    char *jobs_sql,
    char *shipments_sql,
    char *vehicles_sql,
    char *matrix_sql,
    bool plan,

    Vroom_rt **result_tuples,
    size_t *result_count) {
  pgr_SPI_connect();

  (*result_tuples) = NULL;
  (*result_count) = 0;



  pgr_SPI_finish();
}


/** @brief Helps in converting postgres variables to C variables, and returns the result.
 *
 */

PGDLLEXPORT Datum _vrp_vroom(PG_FUNCTION_ARGS) {
  FuncCallContext   *funcctx;
  TupleDesc       tuple_desc;

  /**********************************************************************/
  Vroom_rt *result_tuples = NULL;
  size_t result_count = 0;
  /**********************************************************************/

  if (SRF_IS_FIRSTCALL()) {
    MemoryContext   oldcontext;
    funcctx = SRF_FIRSTCALL_INIT();
    oldcontext = MemoryContextSwitchTo(funcctx->multi_call_memory_ctx);

    /***********************************************************************
     *
     *   vrp_vroom(
     *     jobs_sql TEXT,
     *     shipments_sql TEXT,
     *     vehicles_sql TEXT,
     *     matrix ARRAY[ARRAY[INTEGER],
     *     plan BOOLEAN DEFAULT FALSE
     *   );
     *
     **********************************************************************/

    process(
        text_to_cstring(PG_GETARG_TEXT_P(0)),
        text_to_cstring(PG_GETARG_TEXT_P(1)),
        text_to_cstring(PG_GETARG_TEXT_P(2)),
        text_to_cstring(PG_GETARG_TEXT_P(3)),
        PG_GETARG_BOOL(4),
        &result_tuples,
        &result_count);

    /**********************************************************************/


#if PGSQL_VERSION > 95
    funcctx->max_calls = result_count;
#else
    funcctx->max_calls = (uint32_t)result_count;
#endif
    funcctx->user_fctx = result_tuples;
    if (get_call_result_type(fcinfo, NULL, &tuple_desc)
        != TYPEFUNC_COMPOSITE) {
      ereport(ERROR,
          (errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
           errmsg("function returning record called in context "
             "that cannot accept type record")));
    }

    funcctx->tuple_desc = tuple_desc;
    MemoryContextSwitchTo(oldcontext);
  }

  funcctx = SRF_PERCALL_SETUP();
  tuple_desc = funcctx->tuple_desc;
  result_tuples = (Vroom_rt*) funcctx->user_fctx;

  if (funcctx->call_cntr < funcctx->max_calls) {
    HeapTuple  tuple;
    Datum    result;
    Datum    *values;
    bool*    nulls;

    /***********************************************************************
     *
     *   OUT seq BIGINT,
     *   OUT vehicles_seq BIGINT,
     *   OUT vehicles_id BIGINT,
     *   OUT step_seq BIGINT,
     *   OUT step_type INTEGER,
     *   OUT task_id BIGINT,
     *   OUT arrival INTEGER,
     *   OUT duration INTEGER,
     *   OUT service_time INTEGER,
     *   OUT waiting_time INTEGER,
     *   OUT load BIGINT
     *
     **********************************************************************/

    size_t num  = 11;
    values = palloc(num * sizeof(Datum));
    nulls = palloc(num * sizeof(bool));


    size_t i;
    for (i = 0; i < num; ++i) {
      nulls[i] = false;
    }

    values[0] = Int64GetDatum(funcctx->call_cntr + 1);
    values[1] = Int64GetDatum(funcctx->call_cntr + 1);
    values[2] = Int64GetDatum(funcctx->call_cntr + 1);
    values[3] = Int64GetDatum(funcctx->call_cntr + 1);
    values[4] = Int64GetDatum(funcctx->call_cntr + 1);
    values[5] = Int64GetDatum(funcctx->call_cntr + 1);
    values[6] = Int64GetDatum(funcctx->call_cntr + 1);
    values[7] = Int64GetDatum(funcctx->call_cntr + 1);
    values[8] = Int64GetDatum(funcctx->call_cntr + 1);
    values[9] = Int64GetDatum(funcctx->call_cntr + 1);
    values[10] = Int64GetDatum(funcctx->call_cntr + 1);

    /**********************************************************************/

    tuple = heap_form_tuple(tuple_desc, values, nulls);
    result = HeapTupleGetDatum(tuple);
    SRF_RETURN_NEXT(funcctx, result);
  } else {
    SRF_RETURN_DONE(funcctx);
  }
}
