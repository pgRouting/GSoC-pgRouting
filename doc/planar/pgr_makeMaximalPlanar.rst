:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2020-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Planar Family ; pgr_makeMaximalPlanar
   single: makeMaximalPlanar - Experimental on v4.1

|

``pgr_makeMaximalPlanar`` - Experimental
===============================================================================

``pgr_makeMaximalPlanar`` — Returns the set of edges needed to make a
planar graph maximal planar (triangulated) while preserving planarity.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.1.0

  * New experimental function.


Description
-------------------------------------------------------------------------------


Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_makeMaximalPlanar(`Edges SQL`)

   | RETURNS SET OF |result-bicon|

:Example: Making a graph maximal planar

.. literalinclude:: makeMaximalPlanar.queries
   :start-after: -- q1
   :end-before: -- q2

Parameters
-------------------------------------------------------------------------------

.. include:: pgRouting-concepts.rst
    :start-after: basic_edges_sql_start
    :end-before: basic_edges_sql_end

Result columns
-------------------------------------------------------------------------------

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Column
     - Type
     - Description
   * - ``seq``
     - ``BIGINT``
     - Sequential value starting from 1.
   * - ``start_vid``
     - ``BIGINT``
     - Identifier of the source vertex of the edge to be added.
   * - ``end_vid``
     - ``BIGINT``
     - Identifier of the target vertex of the edge to be added.

See Also
-------------------------------------------------------------------------------

* :doc:`pgr_isPlanar`
* :doc:`pgr_makeBiconnectedPlanar`
* `Boost: make_maximal_planar <https://www.boost.org/doc/libs/release/libs/graph/doc/make_maximal_planar.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
