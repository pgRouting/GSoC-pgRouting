\echo -- q1
SELECT *
FROM vrp_vroom(
  $jobs$
    SELECT * FROM (
      VALUES (1414, 1::SMALLINT), (1515, 2::SMALLINT)
    ) AS C(id, location_index)
  $jobs$,
  NULL,
  $vehicles$
    SELECT * FROM (
      VALUES (0, 0::SMALLINT, 3::SMALLINT)
    ) AS C(id, start_index, end_index)
  $vehicles$,
  $matrix$
    SELECT * FROM (
      VALUES (0, 1, 2104), (0, 2, 197), (0, 3, 1299),
             (1, 0, 2103), (1, 2, 2255), (1, 3, 3152),
             (2, 0, 197), (2, 1, 2256), (2, 3, 1102),
             (3, 0, 1299), (3, 1, 3153), (3, 2, 1102)
    ) AS C(start_vid, end_vid, agg_cost)
  $matrix$
);
\echo -- q2
