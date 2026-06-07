:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2016-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

.. index:: pgr_maximumWeightedMatching

.. _pgr_maximumWeightedMatching:

pgr_maximumWeightedMatching
===============================

``pgr_maximumWeightedMatching`` — Calculates a maximum weighted matching in a graph.

.. include:: experimental.rst
   :start-after: warning-begin
   :end-before: end-warning

Signature
---------

.. code-block:: sql

    pgr_maximumWeightedMatching(edges_sql)
    RETURNS SET OF (edge_id bigint)

Description
-----------

A matching is a set of edges without common vertices.
A maximum weighted matching is a matching whose total edge weight is maximum.

This function uses the Blossom algorithm implementation from Boost Graph Library.

Parameters
----------

:edges_sql: SQL query to get edges
:returns: SET OF (edge_id)

See Also
--------

* https://en.wikipedia.org/wiki/Maximum_weight_matching
* https://en.wikipedia.org/wiki/Blossom_algorithm
