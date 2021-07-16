DROP TABLE IF EXISTS public.vroom_jobs;
DROP TABLE IF EXISTS public.vroom_shipments;
DROP TABLE IF EXISTS public.vroom_vehicles;
DROP TABLE IF EXISTS public.vroom_matrix;

-- VROOM JOBS TABLE CREATE start
CREATE TABLE public.vroom_jobs (
  id BIGINT,
  location_index BIGINT,
  service INTEGER,
  delivery ARRAY[BIGINT],
  pickup ARRAY[BIGINT],
  skills ARRAY[INTEGER],
  priority INTEGER,
  time_windows_sql TEXT
);
-- VROOM JOBS TABLE CREATE end
-- VROOM JOBS TABLE ADD DATA start
INSERT INTO public.vroom_jobs (
  id, location_index, service, delivery, pickup, skills, priority, time_windows_sql)
  VALUES
(1, 1, 10000, [20], [20], [0], 0, $$SELECT * FROM (VALUES(145000, 175000)) AS c(start_time, end_time)$$),
(2, 2, 10000, [30], [30], [0], 0, $$SELECT * FROM (VALUES(50000, 80000)) AS c(start_time, end_time)$$),
(3, 3, 10000, [10], [10], [0], 0, $$SELECT * FROM (VALUES(109000, 139000)) AS c(start_time, end_time)$$),
(4, 4, 10000, [40], [40], [0], 0, $$SELECT * FROM (VALUES(141000, 171000)) AS c(start_time, end_time)$$),
(5, 5, 10000, [20], [20], [0], 0, $$SELECT * FROM (VALUES(41000, 71000)) AS c(start_time, end_time)$$);
-- VROOM JOBS TABLE ADD DATA end

-- VROOM SHIPMENTS TABLE CREATE start
CREATE TABLE public.vroom_jobs (
  id BIGSERIAL PRIMARY KEY,
  p_id BIGINT,
  p_location_index BIGINT,
  p_service INTEGER,
  p_time_windows_sql TEXT,
  d_id BIGINT,
  d_location_index BIGINT,
  d_service INTEGER,
  d_time_windows_sql TEXT,
  amount ARRAY[BIGINT],
  skills ARRAY[INTEGER],
  priority INTEGER
);
-- VROOM SHIPMENTS TABLE CREATE end
-- VROOM SHIPMENTS TABLE ADD DATA start
INSERT INTO public.vroom_jobs (
  p_id, p_location_index, p_service, p_time_windows_sql,
  d_id, d_location_index, d_service, d_time_windows_sql,
  amount, skills, priority)
  VALUES
(3, 3, 90000, $$SELECT * FROM (VALUES(65000, 146000)) AS c(start_time, end_time)$$,
  75, 75, 90000, $$SELECT * FROM (VALUES(997000, 1068000)) AS c(start_time, end_time)$$,
  [10], [0], 0),
(5, 5, 90000, $$SELECT * FROM (VALUES(15000, 67000)) AS c(start_time, end_time)$$,
  7, 7, 90000, $$SELECT * FROM (VALUES(170000, 225000)) AS c(start_time, end_time)$$,
  [10], [0], 0),
(6, 6, 90000, $$SELECT * FROM (VALUES(621000, 702000)) AS c(start_time, end_time)$$,
  2, 2, 90000, $$SELECT * FROM (VALUES(825000, 870000)) AS c(start_time, end_time)$$,
  [20], [0], 0),
(8, 8, 90000, $$SELECT * FROM (VALUES(255000, 324000)) AS c(start_time, end_time)$$,
  10, 10, 90000, $$SELECT * FROM (VALUES(357000, 410000)) AS c(start_time, end_time)$$,
  [20], [0], 0),
(9, 9, 90000, $$SELECT * FROM (VALUES(534000, 605000)) AS c(start_time, end_time)$$,
  4, 4, 90000, $$SELECT * FROM (VALUES(727000, 782000)) AS c(start_time, end_time)$$,
  [10], [0], 0);
-- VROOM SHIPMENTS TABLE ADD DATA end

