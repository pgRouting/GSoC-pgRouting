..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

|


``pgr_betweennessCentrality``
===============================================================================

``pgr_betweennessCentrality`` - Returns the relative betweeness centrality of 
all edges in a graph using Brandes Algorithm.

.. figure:: images/boost-inside.jpeg
   :target: https://www.boost.org/doc/libs/1_84_0/libs/graph/doc/betweenness_centrality.html

   Boost Graph Inside

.. rubric:: Availability
.. TODO: Add availability

Description
-------------------------------------------------------------------------------

The Brandes Algorithm for utilises the sparse nature of graphs to evaluating the
betweenness centrality score of all edges/vertices.
We use Boost's implementation which runs in :math:`\Theta(VE)` for unweighted 
graphs and :math:`Theta(VE + V(V+E)log(V))` for weighted graphs and uses
:math:`\Theta(VE)` space.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   pgr_betweennessCentrality(`Edges SQL`_, [``directed``])

   | Returns set of ```(seq, edge_id, betweenness_centrality)``` 
   | OR EMPTY SET

.. TODO: Fix this when docqueries are made 
:Example: For a directed subgraph with edges :math:`\{1, 2, 3, 4\}`.

.. literalinclude:: floydWarshall.queries
   :start-after: -- q1
   :end-before: -- q2

Parameters
-------------------------------------------------------------------------------

.. include:: allpairs-family.rst
    :start-after: edges_start
    :end-before: edges_end

Optional parameters
...............................................................................

.. include:: dijkstra-family.rst
    :start-after: dijkstra_optionals_start
    :end-before: dijkstra_optionals_end

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. include:: pgRouting-concepts.rst
    :start-after: no_id_edges_sql_start
    :end-before: no_id_edges_sql_end

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
	  - ``INTEGER``
	  - Sequential Value starting from ``1``
	* - ``edge_id``
	  - ``BIGINT``
	  - Identifier of the edge
	* - ``centrality``
	  - ``FLOAT``	
	  - relative betweenness centrality score of the edge (will be in range [0,1])

See Also
-------------------------------------------------------------------------------

* Boost `centrality
  <https://www.boost.org/doc/libs/1_84_0/libs/graph/doc/betweenness_centrality.html>`_
* Queries uses the :doc:`sampledata` network.

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
