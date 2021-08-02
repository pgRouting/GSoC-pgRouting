\echo -- q1
SELECT *
FROM vrp_vroomShipments(
  $shipments$
    SELECT * FROM (
      VALUES (100, 1, 200, 4)
    ) AS C(p_id, p_location_index, d_id, d_location_index)
  $shipments$,
  $p_tw$
    SELECT * FROM vroom.p_time_windows WHERE id = -1
  $p_tw$,
  $d_tw$
    SELECT * FROM vroom.d_time_windows WHERE id = -1
  $d_tw$,
  $vehicles$
    SELECT * FROM (
      VALUES (1, 1, 4)
    ) AS C(id, start_index, end_index)
  $vehicles$,
  $breaks$
    SELECT * FROM vroom.breaks WHERE id = -1
  $breaks$,
  $breaks_tw$
    SELECT * FROM vroom.breaks_time_windows WHERE id = -1
  $breaks_tw$,
  $matrix$
    SELECT * FROM (
      VALUES (1, 2, 2104), (1, 3, 197), (1, 4, 1299),
             (2, 1, 2103), (2, 3, 2255), (2, 4, 3152),
             (3, 1, 197), (3, 2, 2256), (3, 4, 1102),
             (4, 1, 1299), (4, 2, 3153), (4, 3, 1102)
    ) AS C(start_vid, end_vid, agg_cost)
  $matrix$
);
\echo -- q2
SELECT *
FROM vrp_vroomShipments(
  'SELECT * FROM vroom.shipments',
  'SELECT * FROM vroom.p_time_windows',
  'SELECT * FROM vroom.d_time_windows',
  'SELECT * FROM vroom.vehicles',
  'SELECT * FROM vroom.breaks',
  'SELECT * FROM vroom.breaks_time_windows',
  'SELECT * FROM vroom.matrix'
);
\echo -- q3