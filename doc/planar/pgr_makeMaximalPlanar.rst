:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2020-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Planar Family ; pgr_makeMaximalPlanar - Experimental
   single: makeMaximalPlanar - Experimental on v4.1

|

``pgr_makeMaximalPlanar`` - Experimental
===============================================================================

``pgr_makeMaximalPlanar`` — Returns the set of edges needed to make a planar graph maximal planar.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

.. rubric:: Version 4.1.0

* New experimental function.


Description
-------------------------------------------------------------------------------

A graph is planar if it can be drawn in two-dimensional space with no two of its
edges crossing. A planar graph is considered **maximal planar** (or fully triangulated) 
if no additional edges can be added to it without violating its planarity. In a 
maximal planar graph, every face (including the outer face) is a triangle.

``pgr_makeMaximalPlanar`` identifies the missing edges that need to be added to an 
existing planar graph to make it maximal planar.

The main characteristics are:

* Works for **undirected** graphs.
* Returns a list of all new edges which are needed to triangulate the graph and make it maximal planar.
* If the input graph is not planar, it returns an empty set.
* The algorithm does not consider traversal costs in the calculations.
* The algorithm does not consider geometric topology in the calculations.
* Running time: :math:`O(|V| + |E|)`

|Boost| Boost Graph Inside

Signatures
-------------------------------------------------------------------------------

.. admonition:: \ \
   :class: signatures

   | pgr_makeMaximalPlanar(`Edges SQL`_)

   | Returns set of |result-component-make|
   | OR EMPTY SET

:Example: List of edges that are needed to make the graph maximal planar.

.. literalinclude:: makeMaximalPlanar.queries
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

Returns set of |result-component-make|

.. list-table::
   :width: 81
   :widths: auto
   :header-rows: 1

   * - Column
     - Type
     - Description
   * - ``seq``
     - ``BIGINT``
     - Sequential value starting from **1**.
   * - ``start_vid``
     - ``BIGINT``
     - Identifier of the first end point vertex of the edge.
   * - ``end_vid``
     - ``BIGINT``
     - Identifier of the second end point vertex of the edge.

See Also
-------------------------------------------------------------------------------

* `Boost: make_maximal_planar
  <https://www.boost.org/libs/graph/doc/make_maximal_planar.html>`__
* :doc:`sampledata`

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
