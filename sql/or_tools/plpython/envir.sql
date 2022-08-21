CREATE OR REPLACE FUNCTION blah(varchar) RETURNS integer AS $$
    import sys
    import ortools
    plpy.notice("python exec = '%s'" % sys.executable)
    plpy.notice("python version = '%s'" % sys.version)
    plpy.notice("python path = '%s'" % sys.path)
    return 1
$$ LANGUAGE plpython3u;