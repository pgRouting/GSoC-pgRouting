..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

|

* **Supported versions:**
  `Latest <https://docs.pgrouting.org/latest/en/hawickCircuits.html>`__
  (`3.4 <https://docs.pgrouting.org/3.4/en/hawickCircuits.html>`__)

``pgr_hawickCircuits - Experimental``
===============================================================================

``pgr_hawickCircuits`` —  Returns the list of cirucits using hawickCircuits algorithm.


.. include:: experimental.rst
   :start-after: begin-warn-expr
   :end-before: end-warn-expr

.. rubric:: Availability

* Version 3.4.0

  * New **experimental** signature:

    * ``pgr_hawickCircuits`` (`Hawick Circuits`_)


Description
-------------------------------------------------------------------------------

Hawick Circuit algorithm, is published in 2008 by Ken Hawick and Health A. James.
This algorithm solves the problem of detecting and enumerating circuits in graphs.
It is capable of circuit enumeration in graphs with directed-arcs, multiple-arcs
and self-arcs with a memory efficient and high-performance im-plementation.
It is an extension of Johnson's Algorithm of finding all the elementary circuits of
a directed graph.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. parsed-literal::

   pgr_hawickCircuits(`Edges SQL`_ [, directed])
   RETURNS (seq, path_id, path_seq, start_vid, node, edge, cost, agg_cost)
   OR EMPTY SET

.. index::
    single: Hawick Circuits - Experimental on v3.4

Hawick Circuits
...............................................................................

.. parsed-literal::

    pgr_hawickCircuits(`Edges SQL`_ [, directed]);
   RETURNS (seq, path_id, path_seq, start_vid, node, edge, cost, agg_cost)
    OR EMPTY SET

:Example:

.. literalinclude:: hawickCircuits.queries
   :start-after: -- q1
   :end-before: -- q2

Parameters
-------------------------------------------------------------------------------

.. include:: pgRouting-concepts.rst
   :start-after: basic_edges_sql_start
   :end-before: basic_edges_sql_end

Optional parameters
-------------------------------------------------------------------------------

.. include:: dijkstra-family.rst
    :start-after: dijkstra_optionals_start
    :end-before: dijkstra_optionals_end

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. include:: pgRouting-concepts.rst
    :start-after: basic_edges_sql_start
    :end-before: basic_edges_sql_end

Return columns
-------------------------------------------------------------------------------

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Column
     - Type
     - Description
   * - ``seq``
     - ``INTEGER``
     - Sequential value starting from ``1``
   * - ``path_id``
     - ``INTEGER``
     - Id of the circuit starting from ``1``
   * - ``path_seq``
     - ``INTEGER``
     - Relative postion in the path. Has value ``1`` for beginning of the path
   * - ``start_vid``
     - ``BIGINT``
     - Identifier of the starting vertex of the circuit.
   * - ``node``
     - ``BIGINT``
     - Identifier of the node in the path from a vid to next vid.
   * - ``edge``
     - ``BIGINT``
     - Identifier of the edge used to go from ``node`` to the next node in
       the path sequence. ``-1`` for the last node of the path.
   * - ``cost``
     - ``FLOAT``
     - Cost to traverse from ``node`` using ``edge`` to the next node in the
       path sequence.
   * - ``agg_cost``
     - ``FLOAT``
     - Aggregate cost from ``start_v`` to ``node``.


See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm documentation
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__
* `Link to publication
  <https://www.researchgate.net/publication/221440635_Enumerating_Circuits_and_Loops_in_Graphs_with_Self-Arcs_and_Multiple-Arcs>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`