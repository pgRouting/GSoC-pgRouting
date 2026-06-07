:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2020-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Flow Family ; pgr_maximumWeightedMatching
   single: maximumWeightedMatching

|

``pgr_maximumWeightedMatching``
===============================================================================

``pgr_maximumWeightedMatching`` — Calculates a maximum weighted matching in a graph.

.. rubric:: Availability

.. rubric:: Version 4.1.0

* New function introduced.

Description
-------------------------------------------------------------------------------

A **maximum weighted matching** in a graph is a matching where the sum of the
weights of selected edges is maximized.

A matching is a set of edges without common vertices.

Main characteristics:

* Works on **undirected graphs**
* Each vertex is matched with at most one other vertex
* Maximizes total edge weight
* May have multiple optimal solutions, returns one

Algorithm is based on Edmonds’ blossom algorithm with improvements similar to
Boost Graph Library implementation of maximum weighted matching.

.. rubric:: Signature

.. admonition:: \ \
   :class: signatures

   | pgr_maximumWeightedMatching(`Edges SQL`_)

   | Returns set of |result-matching|
   | OR EMPTY SET

Parameters
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

SQL query returning a set of rows:

.. list-table::
   :width: 81
   :widths: 14 14 7 44
   :header-rows: 1

   * - Column
     - Type
     - Default
     - Description
   * - ``id``
     - **ANY-INTEGER**
     -
     - Edge identifier
   * - ``source``
     - **ANY-INTEGER**
     -
     - Source vertex
   * - ``target``
     - **ANY-INTEGER**
     -
     - Target vertex
   * - ``cost``
     - **ANY-NUMERICAL**
     -
     - Weight of the edge (used for matching optimization)
   * - ``reverse_cost``
     - **ANY-NUMERICAL**
     - -1
     - Reverse direction weight (ignored if not needed)

Where:

* cost must be non-negative for meaningful results
* reverse_cost is optional depending on graph directionality

Result columns
-------------------------------------------------------------------------------

========== ========== =================================================
Column     Type       Description
========== ========== =================================================
``edge``   ``BIGINT`` Identifier of the edge included in matching
========== ========== =================================================

Algorithm
-------------------------------------------------------------------------------

The implementation follows the **Edmonds blossom algorithm** for general
graphs using a primal-dual optimization approach.

Key ideas:

* Alternating trees are built from unmatched vertices
* Blossoms are formed to handle odd cycles
* Dual variables ensure optimal weight matching
* Matching is augmented iteratively until optimal

Complexity
-------------------------------------------------------------------------------

Let:

* n = number of vertices
* m = number of edges

Time complexity:

* O(n³)

See Also
-------------------------------------------------------------------------------

* :doc:`flow-family`
* :doc:`migration`
* Boost Graph Library maximum weighted matching
* https://en.wikipedia.org/wiki/Blossom_algorithm
* https://en.wikipedia.org/wiki/Matching_(graph_theory)

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
