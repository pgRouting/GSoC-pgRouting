/*PGR-GNU*****************************************************************
File: weights_costs_input.c
Copyright (c) 2022 pgRouting developers
Mail: project@pgrouting.org
Developer:
Copyright (c) 2022 Manas Sivakumar
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

#include "c_common/weights_costs_input.h"

#include "c_types/column_info_t.h"
#include "c_types/knapsack_rt.h"

#include "c_common/get_check_data.h"

#ifdef PROFILE
#include "c_common/time_msg.h"
#include "c_common/debug_macro.h"
#endif

static
void fetch_weights(
        HeapTuple *tuple,
        TupleDesc *tupdesc,
        Column_info_t info[2],
        Weight_t *row) {
    row->weight = get_Id(tuple, tupdesc,  info[0], -1);
    row->cost = get_Id(tuple, tupdesc,  info[1], -1);
}

static
void
get_weights_general(
    char *sql,
    Column_info_t *info,
    Weight_t **rows,
    size_t *total_rows) {
#ifdef 1
  clock_t start_t = clock();
  PGR_DBG("%s", sql);
#endif

  const int tuple_limit = 1000000;
  size_t total_tuples = 0;
  const int column_count = 3;

  void *SPIplan;
  SPIplan = pgr_SPI_prepare(sql);

  Portal SPIportal;
  SPIportal = pgr_SPI_cursor_open(SPIplan);


  bool moredata = true;
  (*total_rows) = total_tuples;

  while (moredata == true) {
    SPI_cursor_fetch(SPIportal, true, tuple_limit);
    if (total_tuples == 0)
      pgr_fetch_column_info(info, column_count);

    size_t ntuples = SPI_processed;
    total_tuples += ntuples;

    if (ntuples > 0) {
      if ((*rows) == NULL)
        (*rows) = (Weight_t *)palloc0(
            total_tuples * sizeof(Weight_t));
      else
        (*rows) = (Weight_t *)repalloc(
            (*rows), total_tuples * sizeof(Weight_t));

      if ((*rows) == NULL) {
        elog(ERROR, "Out of memory");
      }

      SPITupleTable *tuptable = SPI_tuptable;
      TupleDesc tupdesc = SPI_tuptable->tupdesc;

      size_t t;
      for (t = 0; t < ntuples; t++) {
        HeapTuple tuple = tuptable->vals[t];
          fetch_weights(&tuple, &tupdesc, info,
                       &(*rows)[total_tuples - ntuples + t]);
      }
      SPI_freetuptable(tuptable);
    } else {
      moredata = false;
    }
  }

  SPI_cursor_close(SPIportal);


  if (total_tuples == 0) {
    (*total_rows) = 0;
    return;
  }

  (*total_rows) = total_tuples;
#ifdef PROFILE
  time_msg(" reading weights", start_t, clock());
#endif
}

/**
 * @param [in] sql SQL query that has the following columns: start_vid, end_vid, agg_cost
 * @param [out] rows C Container that holds all the matrix rows
 * @param [out] total_rows Total rows recieved
 */
void
get_weights_costs(
    char *sql,
    Weight_t **rows,
    size_t *total_rows) {
  Column_info_t info[2];

  int i;
  for (i = 0; i < 2; ++i) {
    info[i].colNumber = -1;
    info[i].type = 0;
    info[i].strict = true;
    info[i].eType = ANY_INTEGER;
  }
  info[0].name = "weight";
  info[1].name = "cost";

  info[2].eType = INTERVAL;
  get_weights_general(sql, info, rows, total_rows);
}