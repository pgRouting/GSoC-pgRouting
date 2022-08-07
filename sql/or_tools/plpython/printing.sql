DROP TABLE IF EXISTS knapsack_data;
CREATE TABLE knapsack_data(
  weight INTEGER,
  cost INTEGER);

INSERT INTO knapsack_data (weight,  cost)
VALUES
(12, 4),
(2, 2),
(1, 1),
(4, 10),
(1, 2);

DROP FUNCTION IF EXISTS access_table;
CREATE FUNCTION access_table(inner_query text, capacity integer) 
    RETURNS integer
AS $$
    result = plpy.execute(inner_query, 5)
    plpy.log("Hello World")
    plpy.warning("Hello World")
    plpy.warning(result[0]["cost"], result[0]["weight"])
    return capacity
$$ LANGUAGE plpython3u;