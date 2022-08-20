DROP TABLE IF EXISTS bin_packing_query CASCADE;

CREATE TABLE bin_packing_query(
  weight INTEGER);

INSERT INTO bin_packing_query (weight)
VALUES
(48), (30), (19), (36), (36), (27), (42), (42), (36), (24), (30);

SELECT * FROM vrp_bin_packing('SELECT * FROM bin_packing_query', 100);