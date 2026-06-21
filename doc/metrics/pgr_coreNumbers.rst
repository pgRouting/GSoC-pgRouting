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

.. rubric:: Version 4.1.0

* New experimental function.

Description
-------------------------------------------------------------------------------

The **core number** of a vertex is the largest value :math:`k` such that the
vertex belongs to the :math:`k`-core of the graph.

**The main characteristics are:**

- Works for **undirected** graphs.
- Each vertex has **exactly one** core number.
- **All vertices** in the graph are returned.
- The number of result rows is :math:`|V|`.
- Two or more vertices can share the same core number.
- The result is ordered by ``node`` ascending.

- Running time: :math:`O(m)`

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
* :doc:`metrics-family`

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
