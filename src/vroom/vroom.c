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
#include <utils/array.h>  // NOLINT [build/include_order]

// #include "utils/array.h"

#include "catalog/pg_type.h"
#include "utils/lsyscache.h"

#ifndef INT8ARRAYOID
#define INT8ARRAYOID    1016
#endif

#include "c_common/debug_macro.h"
#include "c_common/e_report.h"
#include "c_common/time_msg.h"

#include "c_types/vroom/vroom_rt.h"
#include "c_types/vroom/vroom_job_t.h"
#include "c_types/vroom/vroom_shipment_t.h"
#include "c_types/vroom/vroom_vehicle_t.h"

// #include "c_common/edges_input.h"
// #include "c_common/arrays_input.h"
#include "c_common/vroom/jobs_input.h"
#include "c_common/vroom/shipments_input.h"
#include "c_common/vroom/vehicles_input.h"
#include "c_common/matrixRows_input.h"

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
 * @param jobs_sql       SQL query describing the jobs
 * @param shipments_sql  SQL query describing the shipments
 * @param vehicles_sql   SQL query describing the vehicles
 * @param matrix_sql     SQL query describing the cells of the cost matrix
 * @param plan           whether the mode is plan mode
 * @param result_tuples  the rows in the result
 * @param result_count   the count of rows in the result
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

#if 0
  PGR_DBG("---------------JOBS INPUT------------------");
  Vroom_job_t *jobs = NULL;
  size_t total_jobs = 0;
  get_vroom_jobs(jobs_sql, &jobs, &total_jobs);
  PGR_DBG("Total jobs found: %lu", total_jobs);

  PGR_DBG("id: %ld", jobs->id);
  PGR_DBG("location_index: %d", jobs->location_index);
  PGR_DBG("service: %u", jobs->service);
  PGR_DBG("delivery: %ld", *(jobs->delivery));
  PGR_DBG("pickup: %ld", *(jobs->pickup));
  PGR_DBG("skills: %u", *(jobs->skills));
  PGR_DBG("priority: %u", jobs->priority);

  for (size_t i = 0; i < jobs->time_windows_size; i++) {
    PGR_DBG("(%lu) time_windows start: %u", i, (*(jobs->time_windows + i)).start_time);
    PGR_DBG("(%lu) time_windows end: %u", i, (*(jobs->time_windows + i)).end_time);
  }
#endif

#if 0
  PGR_DBG("---------------SHIPMENTS INPUT------------------");
  Vroom_shipment_t *shipments = NULL;
  size_t total_shipments = 0;
  get_vroom_shipments(shipments_sql, &shipments, &total_shipments);

  PGR_DBG("Total shipments found: %lu", total_shipments);

  PGR_DBG("p_id: %ld", shipments->p_id);
  PGR_DBG("p_location_index: %d", shipments->p_location_index);
  PGR_DBG("p_service: %u", shipments->p_service);
  for (size_t i = 0; i < shipments->p_time_windows_size; i++) {
    PGR_DBG("(%lu) p_time_windows start: %u", i, (*(shipments->p_time_windows + i)).start_time);
    PGR_DBG("(%lu) p_time_windows end: %u", i, (*(shipments->p_time_windows + i)).end_time);
  }
  PGR_DBG("d_id: %ld", shipments->d_id);
  PGR_DBG("d_location_index: %d", shipments->d_location_index);
  PGR_DBG("d_service: %u", shipments->d_service);
  for (size_t i = 0; i < shipments->d_time_windows_size; i++) {
    PGR_DBG("(%lu) d_time_windows start: %u", i, (*(shipments->d_time_windows + i)).start_time);
    PGR_DBG("(%lu) d_time_windows end: %u", i, (*(shipments->d_time_windows + i)).end_time);
  }
  PGR_DBG("amount: %ld", *(shipments->amount));
  PGR_DBG("skills: %u", *(shipments->skills));
  PGR_DBG("priority: %u", shipments->priority);
#endif

#if 0
  PGR_DBG("---------------VEHICLES INPUT------------------");
  Vroom_vehicle_t *vehicles = NULL;
  size_t total_vehicles = 0;
  get_vroom_vehicles(vehicles_sql, &vehicles, &total_vehicles);

  PGR_DBG("Total vehicles found: %lu", total_vehicles);

  PGR_DBG("id: %ld", vehicles->id);
  PGR_DBG("start_index: %d", vehicles->start_index);
  PGR_DBG("end_index: %d", vehicles->end_index);
  for (size_t i = 0; i < vehicles->capacity_size; i++) {
    PGR_DBG("capacity (%lu): %lu", i, *(vehicles->capacity + i));
  }
  for (size_t i = 0; i < vehicles->skills_size; i++) {
    PGR_DBG("skills (%lu): %u", i, *(vehicles->skills + i));
  }
  PGR_DBG("time_window_start: %u", vehicles->time_window_start);
  PGR_DBG("time_window_end: %u", vehicles->time_window_end);

  PGR_DBG("breaks size: %ld", vehicles->breaks_size);
  for (size_t i = 0; i < vehicles->breaks_size; i++) {
    Vroom_break_t *breaks = vehicles->breaks + i;
    PGR_DBG("breaks (%lu): %ld, %u", i, breaks->id, breaks->service);

    PGR_DBG("breaks tw size (%lu): %ld", i, breaks->time_windows_size);
    for (size_t j = 0; j < breaks->time_windows_size; j++) {
      Vroom_time_window_t *tw = breaks->time_windows + j;
      PGR_DBG("breaks tw (%lu)(%lu): %u, %u", i, j, tw->start_time, tw->end_time);
    }
  }

  PGR_DBG("steps size: %ld", vehicles->steps_size);
  for (size_t i = 0; i < vehicles->steps_size; i++) {
    Vroom_step_t *steps = vehicles->steps + i;
    PGR_DBG("steps (%lu): %ld, %lu, %u, %u, %u", i, steps->id,
        steps->type, steps->service_at, steps->service_after,
        steps->service_before);
  }
#endif

#if 0
  PGR_DBG("---------------MATRIX INPUT------------------");
  Vroom_matrix_cell_t *distances = NULL;
  size_t total_distances = 0;
  get_vroom_matrix_cell(matrix_sql, &distances, &total_distances);
  PGR_DBG("total distances: %ld", total_distances);
  for (size_t i = 0; i < total_distances; i++) {
    PGR_DBG("distance from %d to %d: %u", (distances + i)->start_index,
      (distances + i)->end_index, (distances + i)->cost);
  }
#endif



#if 1
  Vroom_job_t *jobs = NULL;
  size_t total_jobs = 0;
  if (jobs_sql) {
    get_vroom_jobs(jobs_sql, &jobs, &total_jobs);
  }

  Vroom_shipment_t *shipments = NULL;
  size_t total_shipments = 0;
  if (shipments_sql) {
    get_vroom_shipments(shipments_sql, &shipments, &total_shipments);
  }

  Vroom_vehicle_t *vehicles = NULL;
  size_t total_vehicles = 0;
  get_vroom_vehicles(vehicles_sql, &vehicles, &total_vehicles);

  Matrix_cell_t *matrix_cells_arr = NULL;
  size_t total_cells = 0;
  get_matrixRows_vroom_plain(matrix_sql, &matrix_cells_arr, &total_cells);

  clock_t start_t = clock();
  char *log_msg = NULL;
  char *notice_msg = NULL;
  char *err_msg = NULL;

  do_vrp_vroom(
      jobs, total_jobs,
      shipments, total_shipments,
      vehicles, total_vehicles,
      matrix_cells_arr, total_cells,

      plan,

      result_tuples,
      result_count,

      &log_msg,
      &notice_msg,
      &err_msg);

  time_msg("processing vrp_vroom", start_t, clock());

  if (err_msg && (*result_tuples)) {
    pfree(*result_tuples);
    (*result_tuples) = NULL;
    (*result_count) = 0;
  }

  pgr_global_report(log_msg, notice_msg, err_msg);

  if (log_msg) pfree(log_msg);
  if (notice_msg) pfree(notice_msg);
  if (err_msg) pfree(err_msg);

  if (jobs) pfree(jobs);
  if (shipments) pfree(shipments);
  if (vehicles) pfree(vehicles);
  if (matrix_cells_arr) pfree(matrix_cells_arr);
#endif

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
     *     matrix_sql TEXT,
     *     plan BOOLEAN DEFAULT FALSE
     *   );
     *
     **********************************************************************/

    // Verify that the last 3 args (vehicles_sql, matrix_sql, plan) are not NULL
    for (int i = 2; i < 5; i++) {
      if (PG_ARGISNULL(i)) {
        elog(ERROR, "Argument %i must not be NULL", i + 1);
      }
    }

    char *jobs_sql = NULL;
    char *shipments_sql = NULL;

    if (!PG_ARGISNULL(0)) {
      jobs_sql = text_to_cstring(PG_GETARG_TEXT_P(0));
    }
    if (!PG_ARGISNULL(1)) {
      shipments_sql = text_to_cstring(PG_GETARG_TEXT_P(1));
    }

    // Verify that both the first 2 args (jobs_sql and shipments_sql) are not NULL
    if (!(jobs_sql || shipments_sql)) {
      elog(ERROR, "Both Argument 1 and Argument 2 must not be NULL");
    }

    process(
        jobs_sql,
        shipments_sql,
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
    Datum      result;
    Datum      *values;
    bool*      nulls;
    int16      typlen;
    size_t     call_cntr = funcctx->call_cntr;

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

    size_t load_size = (size_t)result_tuples[call_cntr].load_size;
    Datum* load = (Datum*) palloc(sizeof(Datum) * (size_t)load_size);

    for (i = 0; i < load_size; ++i) {
        PGR_DBG("Storing load %ld", result_tuples[call_cntr].load[i]);
        load[i] = Int64GetDatum(result_tuples[call_cntr].load[i]);
    }

    bool typbyval;
    char typalign;
    get_typlenbyvalalign(INT8OID, &typlen, &typbyval, &typalign);
    ArrayType* arrayType;
    /*
      https://doxygen.postgresql.org/arrayfuncs_8c.html
      ArrayType* construct_array(
        Datum*      elems,
        int         nelems,
        Oid         elmtype, int elmlen, bool elmbyval, char elmalign
      )
    */
    arrayType =  construct_array(load, (int)load_size, INT8OID,  typlen,
                                typbyval, typalign);
    /*
      void TupleDescInitEntry(
        TupleDesc       desc,
        AttrNumber      attributeNumber,
        const char *    attributeName,
        Oid             oidtypeid,
        int32           typmod,
        int             attdim
      )
    */
    TupleDescInitEntry(tuple_desc, (AttrNumber) 11, "load", INT8ARRAYOID, -1, 0);

    values[0] = Int64GetDatum(funcctx->call_cntr + 1);
    values[1] = Int32GetDatum(result_tuples[call_cntr].vehicle_seq);
    values[2] = Int32GetDatum(result_tuples[call_cntr].vehicle_id);
    values[3] = Int32GetDatum(result_tuples[call_cntr].step_seq);
    values[4] = Int32GetDatum(result_tuples[call_cntr].step_type);
    values[5] = Int32GetDatum(result_tuples[call_cntr].task_id);
    values[6] = Int32GetDatum(result_tuples[call_cntr].arrival_time);
    values[7] = Int32GetDatum(result_tuples[call_cntr].travel_time);
    values[8] = Int32GetDatum(result_tuples[call_cntr].service_time);
    values[9] = Int32GetDatum(result_tuples[call_cntr].waiting_time);
    values[10] = PointerGetDatum(arrayType);

    /**********************************************************************/

    tuple = heap_form_tuple(tuple_desc, values, nulls);
    result = HeapTupleGetDatum(tuple);
    SRF_RETURN_NEXT(funcctx, result);
  } else {
    SRF_RETURN_DONE(funcctx);
  }
}
