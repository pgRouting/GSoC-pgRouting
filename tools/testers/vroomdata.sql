DROP TABLE IF EXISTS public.vroom_time_windows;
DROP TABLE IF EXISTS public.vroom_jobs;
DROP TABLE IF EXISTS public.vroom_shipments;
DROP TABLE IF EXISTS public.vroom_breaks;
DROP TABLE IF EXISTS public.vroom_vehicles;
DROP TABLE IF EXISTS public.vroom_matrix;

-- VROOM TWS TABLE CREATE start
CREATE TABLE public.vroom_time_windows (
  id BIGINT,
  tw_open INTEGER,
  tw_close INTEGER
);
-- VROOM TWS TABLE CREATE end

-- VROOM TWS TABLE ADD DATA start
INSERT INTO public.vroom_time_windows (
  id, tw_open, tw_close)
  VALUES
(1, 3625, 4375),
(2, 1250, 2000),
(3, 2725, 3475),
(4, 3525, 4275),
(5, 1025, 1775),
(6, 1625, 3650),
(7, 24925, 26700),
(8, 375, 1675),
(9, 4250, 5625),
(10, 15525, 17550),
(11, 20625, 21750),
(12, 6375, 8100),
(13, 8925, 10250),
(14, 13350, 15125),
(15, 18175, 19550),
(16, 250, 300),
(17, 250, 275),
(18, 0, 0),
(19, 250, 250);
-- VROOM TWS TABLE ADD DATA end


-- VROOM JOBS TABLE CREATE start
CREATE TABLE public.vroom_jobs (
  id BIGINT,
  location_index BIGINT,
  service INTEGER,
  delivery BIGINT[],
  pickup BIGINT[],
  skills INTEGER[],
  priority INTEGER,
  time_windows_sql TEXT
);
-- VROOM JOBS TABLE CREATE end

-- VROOM JOBS TABLE ADD DATA start
INSERT INTO public.vroom_jobs (
  id, location_index, service, delivery, pickup, skills, priority, time_windows_sql)
  VALUES
(1, 1, 250, ARRAY[20], ARRAY[20], ARRAY[0], 0, $$SELECT * FROM vroom_time_windows WHERE id = 1$$),
(2, 2, 250, ARRAY[30], ARRAY[30], ARRAY[0], 0, $$SELECT * FROM vroom_time_windows WHERE id = 2$$),
(3, 3, 250, ARRAY[10], ARRAY[10], ARRAY[0], 0, $$SELECT * FROM vroom_time_windows WHERE id = 3$$),
(4, 3, 250, ARRAY[40], ARRAY[40], ARRAY[0], 0, $$SELECT * FROM vroom_time_windows WHERE id = 4$$),
(5, 4, 250, ARRAY[20], ARRAY[20], ARRAY[0], 0, $$SELECT * FROM vroom_time_windows WHERE id = 5$$);
-- VROOM JOBS TABLE ADD DATA end


-- VROOM SHIPMENTS TABLE CREATE start
CREATE TABLE public.vroom_shipments (
  p_id BIGINT,
  p_location_index BIGINT,
  p_service INTEGER,
  p_time_windows_sql TEXT,
  d_id BIGINT,
  d_location_index BIGINT,
  d_service INTEGER,
  d_time_windows_sql TEXT,
  amount BIGINT[],
  skills INTEGER[],
  priority INTEGER
);
-- VROOM SHIPMENTS TABLE CREATE end

-- VROOM SHIPMENTS TABLE ADD DATA start
INSERT INTO public.vroom_shipments (
  p_id, p_location_index, p_service, p_time_windows_sql,
  d_id, d_location_index, d_service, d_time_windows_sql,
  amount, skills, priority)
  VALUES
(6, 3, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 6$$,
  7, 5, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 7$$,
  ARRAY[10], ARRAY[0], 0),
(8, 5, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 8$$,
  9, 6, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 9$$,
  ARRAY[10], ARRAY[0], 0),
(10, 1, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 10$$,
  11, 2, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 11$$,
  ARRAY[20], ARRAY[0], 0),
(12, 1, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 12$$,
  13, 4, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 13$$,
  ARRAY[20], ARRAY[0], 0),
(14, 2, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 14$$,
  15, 2, 2250, $$SELECT * FROM vroom_time_windows WHERE id = 15$$,
  ARRAY[10], ARRAY[0], 0);
-- VROOM SHIPMENTS TABLE ADD DATA end


-- VROOM BREAKS TABLE CREATE start
CREATE TABLE public.vroom_breaks (
  id BIGINT,
  time_windows_sql TEXT,
  service INTEGER
);
-- VROOM BREAKS TABLE CREATE end

-- VROOM BREAKS TABLE ADD DATA start
INSERT INTO public.vroom_breaks (
  id, time_windows_sql, service)
  VALUES
(16, $$SELECT * FROM vroom_time_windows WHERE id = 16$$, 0),
(17, $$SELECT * FROM vroom_time_windows WHERE id = 17$$, 10),
(18, $$SELECT * FROM vroom_time_windows WHERE id = 18$$, 0),
(19, $$SELECT * FROM vroom_time_windows WHERE id = 19$$, 0);
-- VROOM BREAKS TABLE ADD DATA end


-- VROOM VEHICLES TABLE CREATE start
CREATE TABLE public.vroom_vehicles (
  id BIGINT,
  start_index BIGINT,
  end_index BIGINT,
  capacity BIGINT[],
  skills INTEGER[],
  tw_open INTEGER,
  tw_close INTEGER,
  breaks_sql TEXT,
  speed_factor FLOAT
);
-- VROOM VEHICLES TABLE CREATE end

-- VROOM VEHICLES TABLE ADD DATA start
INSERT INTO public.vroom_vehicles (
  id, start_index, end_index, capacity, skills,
  tw_open, tw_close, breaks_sql, speed_factor)
  VALUES
(1, 1, 1, ARRAY[200], ARRAY[0], 0, 30900, $$SELECT * FROM vroom_breaks WHERE id = 16$$, 1.0),
(2, 1, 3, ARRAY[200], ARRAY[0], 100, 30900, $$SELECT * FROM vroom_breaks WHERE id = 17$$, 1.0),
(3, 1, 1, ARRAY[200], ARRAY[0], 0, 30900, $$SELECT * FROM vroom_breaks WHERE id = 18$$, 1.0),
(4, 3, 3, ARRAY[200], ARRAY[0], 0, 30900, $$SELECT * FROM vroom_breaks WHERE id = 19$$, 1.0);
-- VROOM VEHICLES TABLE ADD DATA end

-- VROOM MATRIX TABLE CREATE start
CREATE TABLE public.vroom_matrix (
  start_vid BIGINT,
  end_vid BIGINT,
  agg_cost INTEGER
);
-- VROOM MATRIX TABLE CREATE end

-- VROOM MATRIX TABLE ADD DATA start
INSERT INTO public.vroom_matrix (
  start_vid, end_vid, agg_cost)
  VALUES
(1, 1, 0), (1, 2, 50), (1, 3, 90), (1, 4, 75), (1, 5, 106), (1, 6, 127),
(2, 1, 50), (2, 2, 0), (2, 3, 125), (2, 4, 90), (2, 5, 145), (2, 6, 127),
(3, 1, 90), (3, 2, 125), (3, 3, 0), (3, 4, 50), (3, 5, 25), (3, 6, 90),
(4, 1, 75), (4, 2, 90), (4, 3, 50), (4, 4, 0), (4, 5, 75), (4, 6, 55),
(5, 1, 106), (5, 2, 145), (5, 3, 25), (5, 4, 75), (5, 5, 0), (5, 6, 111),
(6, 1, 127), (6, 2, 127), (6, 3, 90), (6, 4, 55), (6, 5, 111), (6, 6, 0);
-- VROOM MATRIX TABLE ADD DATA end
