..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. index::
   single: Ordering Family ; pgr_sloanOrdering
   single: pgr_sloanOrdering - Experimental on v4.0

|

``pgr_sloanOrdering`` - Experimental
===============================================================================

``pgr_sloanOrdering`` — Returns the sloan ordering of an undirected
graph

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.0.0

  * New experimental function.


Description
-------------------------------------------------------------------------------

TBD

Signatures
------------------------------------------------------------------------------

.. index::
    single: sloanOrdering - Experimental on v4.0

.. admonition:: \ \
   :class: signatures

   | pgr_sloanOrdering(`Edges SQL`_)

   | Returns set of |result_node_order|
   | OR EMPTY SET

:Example: Graph ordering of pgRouting :doc:`sampledata`

.. literalinclude:: sloanOrdering.queries
   :start-after: -- q1
   :end-before: -- q2

.. Parameters, Inner Queries & result columns

Parameters
-------------------------------------------------------------------------------

.. include:: pgRouting-concepts.rst
   :start-after: only_edge_param_start
   :end-before: only_edge_param_end

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. include:: pgRouting-concepts.rst
   :start-after: basic_edges_sql_start
   :end-before: basic_edges_sql_end

Result columns
-------------------------------------------------------------------------------

Returns set of ``(seq, node)``

===============  =========== ======================================
Column           Type        Description
===============  =========== ======================================
``seq``           ``BIGINT``  Sequence of the order starting from 1.
``node``          ``BIGINT``  New ordering in reverse order.
===============  =========== ======================================

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: Sloan Ordering
  <https://www.boost.org/libs/graph/doc/sloan_ordering.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`


