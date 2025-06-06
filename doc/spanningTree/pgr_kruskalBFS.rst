..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. index::
   single: Kruskal Family ; pgr_kruskalBFS
   single: Spanning Tree Category ; pgr_kruskalBFS
   single: Breadth First Search Category ; pgr_kruskalBFS
   single: kruskalBFS

|

``pgr_kruskalBFS``
===============================================================================

``pgr_kruskalBFS`` — Kruskal's algorithm for Minimum Spanning Tree with breadth
First Search ordering.

.. rubric:: Availability

:Version 3.7.0:

* Standardizing output columns to |result-spantree|

  * Added ``pred`` result columns.

:Version 3.0.0:

  * New official function.

Description
-------------------------------------------------------------------------------

Visits and extracts the nodes information in Breath First Search ordering
of the Minimum Spanning Tree created using Kruskal's algorithm.

**The main Characteristics are:**

.. include:: kruskal-family.rst
   :start-after: kruskal-description-start
   :end-before: kruskal-description-end

- Returned tree nodes from a root vertex are on Breath First Search order
- Breath First Search Running time: :math:`O(E + V)`

Signatures
-------------------------------------------------------------------------------

.. admonition:: \ \
   :class: signatures

   | pgr_kruskalBFS(`Edges SQL`_, **root vid**, [``max_depth``])
   | pgr_kruskalBFS(`Edges SQL`_, **root vids**, [``max_depth``])

   | Returns set of |result-spantree|

.. index::
    single: kruskalBFS ; Single vertex

Single vertex
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_kruskalBFS(`Edges SQL`_, **root vid**, [``max_depth``])

   | Returns set of |result-spantree|

:Example: The Minimum Spanning Tree having as root vertex :math:`6`

.. literalinclude:: kruskalBFS.queries
   :start-after: -- q1
   :end-before: -- q2

.. index::
    single: kruskalBFS ; Multiple vertices

Multiple vertices
...............................................................................

.. admonition:: \ \
   :class: signatures

   | pgr_kruskalBFS(`Edges SQL`_, **root vids**, [``max_depth``])

   | Returns set of |result-spantree|

:Example: The Minimum Spanning Tree starting on vertices :math:`\{9, 6\}` with
          :math:`depth \leq 3`

.. literalinclude:: kruskalBFS.queries
   :start-after: -- q2
   :end-before: -- q3

Parameters
-------------------------------------------------------------------------------

.. include:: drivingDistance-category.rst
    :start-after: spantree-params_start
    :end-before: spantree-params_end

BFS optional parameters
...............................................................................

.. include:: BFS-category.rst
   :start-after: max-depth-optional-start
   :end-before: max-depth-optional-end

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
..............................................................................

.. include:: pgRouting-concepts.rst
   :start-after: basic_edges_sql_start
   :end-before: basic_edges_sql_end

Result columns
-------------------------------------------------------------------------------

.. include:: drivingDistance-category.rst
   :start-after: spantree-result-columns-start
   :end-before: spantree-result-columns-end

See Also
-------------------------------------------------------------------------------

* :doc:`spanningTree-category`
* :doc:`kruskal-family`
* :doc:`sampledata`
* `Boost: Kruskal's algorithm
  <https://www.boost.org/libs/graph/doc/kruskal_min_spanning_tree.html>`__
* `Wikipedia: Kruskal's algorithm
  <https://en.wikipedia.org/wiki/Kruskal's_algorithm>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
