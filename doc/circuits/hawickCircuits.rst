..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

|

* **Supported versions:**
  `Latest <https://docs.pgrouting.org/latest/en/pgr_hawickCircuits.html>`__
  (`3.4 <https://docs.pgrouting.org/3.4/en/pgr_hawickCircuits.html>`__)

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

TBD

**The main characteristics are:**

TBD

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. parsed-literal::

   pgr_hawickCircuits(`Edges SQL`_ [, directed])
   pgr_hawickCircuits_Unique(`Edges SQL` [, directed])
   RETURNS (seq, path_seq, path_id, start_vid, end_vid, node, edge, cost, agg_cost)
   OR EMPTY SET

.. index::
    single: Hawick Circuits - Experimental on v3.4

Hawick Circuits
...............................................................................

.. parsed-literal::

    pgr_hawickCircuits(`Edges SQL`_ [, directed]);
    RETURNS (seq, path_seq, path_id, start_vid, end_vid, node, edge, cost, agg_cost)
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

TBD


See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Hawick Circuit Algorithm documentation
  <https://www.boost.org/doc/libs/1_78_0/libs/graph/doc/hawick_circuits.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`