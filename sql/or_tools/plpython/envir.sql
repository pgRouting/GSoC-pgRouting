/*PGR-GNU*****************************************************************
File: composite_types.sql

Copyright (c) 2022 GSoC-2022 pgRouting developers
Mail: project@pgrouting.org

Function's developer:
Copyright (c) 2021 Manas Sivakumar

------

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

 ********************************************************************PGR-GNU*/
CREATE OR REPLACE FUNCTION blah(varchar) RETURNS integer AS $$
    import sys
    import ortools
    plpy.notice("python exec = '%s'" % sys.executable)
    plpy.notice("python version = '%s'" % sys.version)
    plpy.notice("python path = '%s'" % sys.path)
    return 1
$$ LANGUAGE plpython3u; 