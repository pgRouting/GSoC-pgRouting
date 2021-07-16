DROP TABLE IF EXISTS public.vroom_jobs;
DROP TABLE IF EXISTS public.vroom_shipments;
DROP TABLE IF EXISTS public.vroom_vehicles;
DROP TABLE IF EXISTS public.vroom_matrix;

-- VROOM JOBS TABLE CREATE start
CREATE TABLE public.vroom_jobs (
  id BIGSERIAL,
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
  location_index, service, delivery, pickup, skills, priority, time_windows_sql)
  VALUES
(1, 10000, [20], [20], [0], 0, $$SELECT * FROM (VALUES(145000, 175000)) AS c(start_time, end_time)$$),
(2, 10000, [30], [30], [0], 0, $$SELECT * FROM (VALUES(50000, 80000)) AS c(start_time, end_time)$$),
(3, 10000, [10], [10], [0], 0, $$SELECT * FROM (VALUES(109000, 139000)) AS c(start_time, end_time)$$),
(4, 10000, [40], [40], [0], 0, $$SELECT * FROM (VALUES(141000, 171000)) AS c(start_time, end_time)$$),
(5, 10000, [20], [20], [0], 0, $$SELECT * FROM (VALUES(41000, 71000)) AS c(start_time, end_time)$$)
-- VROOM JOBS TABLE ADD DATA end

