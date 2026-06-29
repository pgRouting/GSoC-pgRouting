:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2026-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Metrics Family ; pgr_coreNumbers - Experimental
   single: coreNumbers - Experimental on v4.1

|

``pgr_coreNumbers`` - Experimental
===============================================================================

``pgr_coreNumbers`` — Computes the core number of each vertex in an undirected
graph using k-core decomposition.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.1.0

  * New experimental function.

Description
-------------------------------------------------------------------------------

The **core number** of a vertex is the largest value :math:`k` such that the
vertex belongs to the :math:`k`-core of the graph.

The :math:`k`-core of a graph is the maximal subgraph in which every vertex has
degree at least :math:`k`. K-core decomposition assigns one core number to each
vertex and is widely used in network analysis to identify densely connected
regions and hierarchical structure.

This implementation works for **undirected** graphs. Each vertex has exactly one
core number, all vertices in the graph are returned, and the number of result
rows is :math:`|V|`. Two or more vertices can share the same core number. The
result is ordered by ``node`` ascending.

- Running time: :math:`O(m)`

|Boost| Boost Graph Inside

.. rubric:: References

* Batagelj, V. and Zaversnik, M. (2003). An O(m) Algorithm for Cores Decomposition
  of Networks. arXiv:cs/0310049.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_coreNumbers(`Edges SQL`_)

   | Returns set of ``(seq, node, core)``

:Example: Core numbers on a subgraph of :doc:`sampledata`

.. literalinclude:: coreNumbers.queries
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
	* - ``node``
	  - ``BIGINT``
	  - Identifier of the vertex.
	* - ``core``
	  - ``BIGINT``
	  - Core number of the vertex.

See Also
-------------------------------------------------------------------------------

* :doc:`sampledata`
* :doc:`pgr_betweennessCentrality`
* :doc:`metrics-family`

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
