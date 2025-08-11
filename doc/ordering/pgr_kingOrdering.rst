..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. index::
   single: Ordering Family ; pgr_kingOrdering
   single: kingOrdering - Experimental on v4.0

|

``pgr_kingOrdering`` - Experimental
===============================================================================

``pgr_kingOrdering`` — Returns the King ordering of an undirected graphs

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.0.0

  * New experimental function.


Description
-------------------------------------------------------------------------------

In numerical linear algebra and graph theory, the King ordering algorithm
is a heuristic designed to reorder the vertices of a graph so as to reduce
its bandwidth. 

The method follows a breadth-first search (BFS) traversal,but with a refinement:
at each step, the unvisited neighbors of the current vertex are inserted into
the queue in ascending order of their pseudo-degree, where the pseudo-degree of
a vertex is the number of edges connecting it to yet-unvisited vertices. This
prioritization often yields a smaller bandwidth compared to simpler BFS orderings.

**The main characteristics are:**

- The implementation targets undirected graphs.
- Bandwidth minimization is an NP-complete problem; King ordering provides a practical local minimization approach.
- The time complexity is: :math:`O(m^2 \log(m)|E|)`

   - where :math:`|E|` is the number of edges,
   - :math:`m` is the maximum degree among all vertices.

|Boost| Boost Graph Inside

Signatures
------------------------------------------------------------------------------

.. index::
    single: kingOrdering - Experimental on v4.0

.. admonition:: \ \
   :class: signatures

   | pgr_kingOrdering(`Edges SQL`_)

   | Returns set of |result_node_order|
   | OR EMPTY SET

:Example: Graph ordering of pgRouting :doc:`sampledata`

.. literalinclude:: kingOrdering.queries
   :start-after: -- q1
   :end-before: -- q2

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

.. include:: pgr_cuthillMckeeOrdering.rst
   :start-after: node_ordering_start
   :end-before: node_ordering_end

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* `Boost: King Ordering
  <https://www.boost.org/libs/graph/doc/king_ordering.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`


