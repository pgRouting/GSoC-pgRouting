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

``pgr_betweennessCentrality`` - Calculates the relative betweeness centrality
using Brandes Algorithm

.. figure:: images/boost-inside.jpeg
   :target: https://www.boost.org/doc/libs/1_84_0/libs/graph/doc/betweenness_centrality.html

   Boost Graph Inside

.. rubric:: Availability
.. TODO: Add availability

Description
-------------------------------------------------------------------------------

The Brandes Algorithm takes advantage of the sparse graphs for evaluating the
betweenness centrality score of all vertices.

This implementation work for both directed and undirected graphs.

- Running time: :math:`\Theta(VE)` time and uses :math:`\Theta(VE)` space.

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   pgr_betweennessCentrality(`Edges SQL`_, [``directed``])

   | Returns set of ```(seq, vid, centrality)``` 
   | OR EMPTY SET

.. TODO: Fix this when docqueries are made 

:Example: For a directed subgraph with edges :math:`\{1, 2, 3, 4\}`.

.. literalinclude:: betweennessCentrality.queries
   :start-after: -- q1
   :end-before: Implicit Cases (directed)

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
	* - ``vid``
	  - ``BIGINT``
	  - Identifier of the vertex
	* - ``centrality``
	  - ``FLOAT``	
	  - Relative betweenness centrality score of the vertex (will be in range [0,1])

See Also
-------------------------------------------------------------------------------

* Boost `centrality
  <https://www.boost.org/doc/libs/1_84_0/libs/graph/doc/betweenness_centrality.html>`_
* Queries uses the :doc:`sampledata` network.

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
