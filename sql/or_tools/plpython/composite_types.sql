DROP FUNCTION IF EXISTS overpaid;
DROP FUNCTION IF EXISTS make_pair;
DROP FUNCTION IF EXISTS make_pair_dict;
DROP FUNCTION IF EXISTS multiout_simple;
DROP TABLE IF EXISTS employee;
DROP TYPE IF EXISTS named_value;
DROP PROCEDURE IF EXISTS python_triple;

CREATE TABLE employee (
  name text,
  salary integer,
  age integer
);

CREATE TYPE named_value AS (
  name   text,
  value  integer
);

-- Input is a composite type
CREATE FUNCTION overpaid (e employee)
  RETURNS boolean
AS $$
  if e["salary"] > 200000:
    return True
  if (e["age"] < 30) and (e["salary"] > 100000):
    return True
  return False
$$ LANGUAGE plpython3u;

--output is a composite type
CREATE FUNCTION make_pair (name text, value integer)
  RETURNS named_value[]
AS $$
  return (( name, value ), (name, value))
  # or alternatively, as list: return [ name, value ]
$$ LANGUAGE plpython3u;

CREATE FUNCTION make_pair_dict (name text, value integer)
  RETURNS named_value
AS $$
  return { "name": name, "value": value }
$$ LANGUAGE plpython3u;

-- Returns the result in one line

CREATE FUNCTION multiout_simple(OUT i integer, OUT j integer) 
AS $$
    return (1, 2)
$$ LANGUAGE plpython3u;


CREATE PROCEDURE python_triple(INOUT a integer, INOUT b integer) 
AS $$
    return (a * 3, b * 3)
$$ LANGUAGE plpython3u;

-- CALL python_triple(5, 10);