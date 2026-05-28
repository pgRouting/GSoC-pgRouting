/*PGR-GNU*****************************************************************

File: pgr_planarFaces.c

Copyright (c) 2015-2026 pgRouting developers
Mail: project@pgrouting.org

Copyright (c) 2026 Sakir Ahmed
Mail: sakirahmed75531 at gmail.com

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
Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/

/* postgres.h MUST be first — PostgreSQL mandates this for all extensions */
#include <postgres.h>
#include <funcapi.h>
#include <utils/array.h>
#include <catalog/pg_type.h>
#include <fmgr.h>
#include <utils/lsyscache.h>
#include <utils/builtins.h>

#include "c_types/planar_face_rt.h"
#include "process/planarFaces_process.h"

PG_FUNCTION_INFO_V1(_pgr_planarFaces);

PGDLLEXPORT Datum
_pgr_planarFaces(PG_FUNCTION_ARGS) {
    FuncCallContext  *funcctx;
    uint32_t          call_cntr;
    uint32_t          max_calls;
    TupleDesc         tuple_desc;

    if (SRF_IS_FIRSTCALL()) {
        MemoryContext    oldcontext;
        Planar_face_rt  *result_tuples = NULL;
        size_t           result_count  = 0;

        funcctx = SRF_FIRSTCALL_INIT();
        oldcontext = MemoryContextSwitchTo(funcctx->multi_call_memory_ctx);

        pgr_process_planarFaces(
                text_to_cstring(PG_GETARG_TEXT_PP(0)),
                &result_tuples,
                &result_count);

        funcctx->max_calls = (uint32_t)result_count;
        funcctx->user_fctx = result_tuples;

        if (get_call_result_type(fcinfo, NULL, &tuple_desc)
                != TYPEFUNC_COMPOSITE) {
            ereport(ERROR,
                    (errcode(ERRCODE_FEATURE_NOT_SUPPORTED),
                     errmsg("function returning record called in context "
                            "that cannot accept type record")));
        }
        funcctx->tuple_desc = BlessTupleDesc(tuple_desc);

        MemoryContextSwitchTo(oldcontext);
    }

    funcctx   = SRF_PERCALL_SETUP();
    call_cntr = funcctx->call_cntr;
    max_calls = funcctx->max_calls;

    if (call_cntr < max_calls) {
        Planar_face_rt *result_tuples =
            (Planar_face_rt *) funcctx->user_fctx;

        HeapTuple  tuple;
        Datum      result;
        Datum      values[3];
        bool       nulls[3] = {false, false, false};

        /*
         * Column order MUST match OUT params in _pgr_planarFaces(TEXT):
         *   0: seq      BIGINT
         *   1: face_id  BIGINT
         *   2: edge     BIGINT
         */
        values[0] = Int64GetDatum(result_tuples[call_cntr].seq);
        values[1] = Int64GetDatum(result_tuples[call_cntr].face_id);
        values[2] = Int64GetDatum(result_tuples[call_cntr].edge);

        tuple  = heap_form_tuple(funcctx->tuple_desc, values, nulls);
        result = HeapTupleGetDatum(tuple);

        SRF_RETURN_NEXT(funcctx, result);
    } else {
        SRF_RETURN_DONE(funcctx);
    }
}
