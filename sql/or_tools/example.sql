DROP FUNCTION IF EXISTS pyadd;
DROP FUNCTION IF EXISTS pystrip;
DROP FUNCTION IF EXISTS return_arr;
DROP FUNCTION IF EXISTS md_array;
DROP FUNCTION IF EXISTS return_str_arr;
DROP FUNCTION IF EXISTS return_str;

-- function that adds two numbers
CREATE FUNCTION pyadd (a integer, b integer)
  RETURNS integer
AS $$
  if (a is None) or (b is None):
    return None
  x = a+b
  return x
$$ LANGUAGE plpython3u;

-- The input parameters should be treated as read only
CREATE FUNCTION pystrip(x text)
  RETURNS text
AS $$
  global x
  x = x.strip() 
  return x
$$ LANGUAGE plpython3u;

CREATE FUNCTION return_arr()
  RETURNS int[]
AS $$
    return [1, 2, 3, 4, 5]
$$ LANGUAGE plpython3u;

CREATE FUNCTION md_array(x int4[]) 
    RETURNS int4[] 
AS $$
    plpy.info(x, type(x))
    return x
$$ LANGUAGE plpython3u;

CREATE FUNCTION return_str()
  RETURNS text
AS $$
    return "hello"
$$ LANGUAGE plpython3u;

CREATE FUNCTION return_str_arr()
  RETURNS varchar[]
AS $$
    return "hello"
$$ LANGUAGE plpython3u;