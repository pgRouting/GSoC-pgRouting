..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.2 License: http://creativecommons.org/licenses/by-sa/3.2/
   ****************************************************************************

pgr_makeConnected - Experimental
===============================================================================

``pgr_makeConnected`` — Returns the set of node_from and node_to of edges. This set of edges are those edges
which will make the graph connected. In particular, the boost::make_connected( ) is implemented by Boost.Graph.

.. figure:: images/boost-inside.jpeg
   :target: https://www.boost.org/libs/graph/doc/make_connected.html

   Boost Graph Inside

.. include:: experimental.rst
   :start-after: begin-warn-expr
   :end-before: end-warn-expr

.. rubric:: Availability

* Version 3.2.0

  * New **experimental** function

.. rubric:: Support

* **Supported versions:**
  current(`3.2 <https://docs.pgrouting.org/dev/en/pgr_boyerMyrvold.html>`__) and above

* **TBD**

Description
-------------------------------------------------------------------------------

A graph is planar if it can be drawn in two-dimensional space with no two of its edges crossing. Such a drawing of a planar graph is called a plane drawing. Every planar graph also admits a straight-line drawing, which is a plane drawing where each edge is represented by a line segment.

The main characteristics are:
  - It works with any undirected graph.

  - The returned values are the set of source and target of edges with their costs.

  - **Running time:** Assuming that both the vertex index and edge index supplied take time O(1) to return an index and there are O(n) total self-loops and parallel edges in the graph, most combinations of arguments given to boyer_myrvold_planarity_test result in an algorithm that runs in time O(n) for a graph with n vertices and m edges


Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. code-block:: none

    pgr_boyerMyrvold(edges_sql)

    RETURNS SET OF (seq, source, target, cost)
    OR EMPTY SET

:Example: Query done on :doc:`sampledata` network gives.

.. literalinclude:: doc-pgr_boyerMyrvold.queries
   :start-after: -- q1
   :end-before: -- q2

Parameters
-------------------------------------------------------------------------------

=================== ====================== ========= =================================================
Parameter           Type                   Default   Description
=================== ====================== ========= =================================================
**edges_sql**       ``TEXT``                         SQL query as described above.
=================== ====================== ========= =================================================

Inner query
-------------------------------------------------------------------------------

:edges_sql: an SQL query, which should return a set of rows with the following columns:

================= =================== ======== =================================================
Column            Type                 Default  Description
================= =================== ======== =================================================
**id**            ``ANY-INTEGER``                Identifier of the edge.
**source**        ``ANY-INTEGER``                Identifier of the first end point vertex of the edge.
**target**        ``ANY-INTEGER``                Identifier of the second end point vertex of the edge.
**cost**          ``ANY-NUMERICAL``              Weight of the edge  `(source, target)`

                                                 - When negative: edge `(source, target)` does not exist, therefore it's not part of the graph.

**reverse_cost**  ``ANY-NUMERICAL``       -1     Weight of the edge `(target, source)`,

                                                 - When negative: edge `(target, source)` does not exist, therefore it's not part of the graph.

================= =================== ======== =================================================

Where:

:ANY-INTEGER: SMALLINT, INTEGER, BIGINT
:ANY-NUMERICAL: SMALLINT, INTEGER, BIGINT, REAL, FLOAT

Result Columns
-------------------------------------------------------------------------------

Returns set of ``(seq, source, target, cost)``

===============  =========== ============================================================
Column           Type        Description
===============  =========== ============================================================
**seq**          ``INT``     Sequential value starting from **1**.
**source**       ``BIGINT``  Identifier of the first end point vertex of the edge.
**target**       ``BIGINT``  Identifier of the second end point vertex of the edge.
**cost**         ``FLOAT``   Weight of the edge  `(source, target)`

                             - When negative: edge `(source, target)` does not exist, therefore it's not part of the graph.
===============  =========== ============================================================

Additional Example:
-------------------------------------------------------------------------------


Now, let's add some edges to make the graph non-planar. We will be adding edges between every pair in this list of vertices **1**, **2**, **3**, **4**, **5**.


.. literalinclude:: doc-pgr_boyerMyrvold.queries
   :start-after: -- q2
   :end-before: -- q3


Now, let's check our graph is planar or not. If it is non-planar then it will return an empty set of rows.


.. literalinclude:: doc-pgr_boyerMyrvold.queries
   :start-after: -- q3
   :end-before: -- q4

There can be some cases where we only want to check whether a particular connected component of a graph is planar or not. So the below example
will illustrate the way to do it.

  - Use pgr_connectedComponents( ) function in query:


.. literalinclude:: doc-pgr_boyerMyrvold.queries
   :start-after: -- q4
   :end-before: -- q5

See Also
-------------------------------------------------------------------------------

* https://en.wikipedia.org/wiki/Planarity_testing
* https://www.boost.org/libs/graph/doc/boyer_myrvold.html
* The queries use the :doc:`sampledata` network.

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
