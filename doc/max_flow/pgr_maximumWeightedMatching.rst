:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2016-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index::
single: Flow Family ; pgr_maximumWeightedMatching
single: maximumWeightedMatching

|

# `pgr_maximumWeightedMatching`

`pgr_maximumWeightedMatching` — Calculates a maximum weighted matching in a graph.

.. rubric:: Availability

.. rubric:: Version 4.0.0

* New proposed function.

## Description

The main characteristics are:

* Works for **undirected** graphs.

* A matching is a set of edges without common vertices.

* A maximum weighted matching is a matching whose total edge weight is maximum.

  * There may be many maximum weighted matchings.
  * Calculates one possible maximum weighted matching in a graph.

* Uses the Blossom algorithm implementation from Boost Graph Library.

* Running time: :math:`O(V^3)`

|Boost| Boost Graph Inside

## Signatures

.. index::
single: MaximumWeightedMatching

.. admonition:: \ 
:class: signatures

| pgr_maximumWeightedMatching(`Edges SQL`_)

| Returns set of |result-edge|
| OR EMPTY SET

## Parameters

.. include:: pgRouting-concepts.rst
:start-after: only_edge_param_start
:end-before: only_edge_param_end

## Inner Queries

Edges SQL
...............................................................................

SQL query, which should return a set of rows with the following columns:

.. list-table::
:width: 81
:widths: 14 14 7 44
:header-rows: 1

* * Column
  * Type
  * Default
  * Description
* * `id`
  * **ANY-INTEGER**
  *
  * Identifier of the edge.
* * `source`
  * **ANY-INTEGER**
  *
  * Identifier of the first end point vertex of the edge.
* * `target`
  * **ANY-INTEGER**
  *
  * Identifier of the second end point vertex of the edge.
* * `cost`
  * **ANY-NUMERICAL**
  *
  * Weight of the edge.
* * `reverse_cost`
  * **ANY-NUMERICAL**
  * -1
  * Weight of the reverse edge.

Where:

:ANY-INTEGER: `SMALLINT`, `INTEGER`, `BIGINT`
:ANY-NUMERICAL: `SMALLINT`, `INTEGER`, `BIGINT`, `REAL`, `FLOAT`

## Result columns

========== ========== =================================================
Column     Type       Description
========== ========== =================================================
`edge`   `BIGINT` Identifier of the edge in the original query.
========== ========== =================================================

## See Also

* :doc:`flow-family`
* :doc:`migration`
* https://en.wikipedia.org/wiki/Maximum_weight_matching
* https://en.wikipedia.org/wiki/Blossom_algorithm

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`

