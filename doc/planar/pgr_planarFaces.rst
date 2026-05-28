:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Planar Family ; pgr_planarFaces
   single: planarFaces - Experimental on v4.0

|

``pgr_planarFaces`` - Experimental
===============================================================================

``pgr_planarFaces`` — Extracts faces from a planar graph.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.0.0

  * New experimental function.

Description
-------------------------------------------------------------------------------

Extracts faces from a planar graph represented by an edges SQL query.

The main characteristics are:

* Returns one row per edge in each face with ``seq``, ``face_id``, and ``edge``.
* Applicable only for **undirected** planar graphs.
* Running time: to be determined.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_planarFaces(`Edges SQL`)

   | RETURNS ``(seq, face_id, edge)``

.. literalinclude:: planarFaces.queries
   :start-after: -- q1
   :end-before: -- q2

Parameters
-------------------------------------------------------------------------------

.. include:: edges_sql.rst

Result columns
-------------------------------------------------------------------------------

=========== ========== =================================================
Column      Type       Description
=========== ========== =================================================
``seq``     ``BIGINT`` Sequential value starting from 1.
``face_id`` ``BIGINT`` Face identifier.
``edge``    ``BIGINT`` Edge identifier.
=========== ========== =================================================

See Also
-------------------------------------------------------------------------------

* :doc:`pgr_isPlanar`

.. rubric:: Indices and tables

* :ref:`search`
