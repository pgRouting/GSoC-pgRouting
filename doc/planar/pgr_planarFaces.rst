:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2026-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
   single: Planar Family ; pgr_planarFaces
   single: planarFaces - Experimental on v4.1

|

``pgr_planarFaces`` - Experimental
===============================================================================

``pgr_planarFaces`` — Extracts the faces of a planar graph.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

.. rubric:: Availability

* Version 4.1.0

  * New experimental function.


Description
-------------------------------------------------------------------------------

Given a planar undirected graph, ``pgr_planarFaces`` computes a planar embedding
and performs a face traversal using the Boost Graph Library. Each face of the
embedding is identified, and every edge-face incidence is returned as a row
indicating which face the edge borders, and on which side (left or right).

The main characteristics are:

* Uses Boyer-Myrvold planarity testing to compute a planar embedding.
* Uses Boost ``planar_face_traversal`` with a custom visitor.
* Returns one row per edge-face incidence: each undirected edge appears exactly
  twice (once per side).
* The graph must be planar; a non-planar graph produces an error.
* Applicable only for **undirected** graphs.
* The algorithm does not consider traversal costs in the calculations.
* Running time: :math:`O(|V| + |E|)`

|Boost| Boost Graph Inside

Signatures
-------------------------------------------------------------------------------

.. rubric:: Summary

.. admonition:: \ \
   :class: signatures

   | pgr_planarFaces(`Edges SQL`)

   | RETURNS SET OF (seq, face_id, edge_id, side)

:Example: Face extraction of the sample graph

.. literalinclude:: planarFaces.queries
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
     - Sequential value starting from **1**.
   * - ``face_id``
     - ``BIGINT``
     - Identifier of the face.
   * - ``edge_id``
     - ``BIGINT``
     - Identifier of the edge that borders the face.
   * - ``side``
     - ``TEXT``
     - | ``'l'`` when the edge borders the face on the left side.
       | ``'r'`` when the edge borders the face on the right side.

See Also
-------------------------------------------------------------------------------

* :doc:`pgr_isPlanar`
* :doc:`sampledata`
* `Boost: Planar Face Traversal
  <https://www.boost.org/libs/graph/doc/planar_face_traversal.html>`__

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
