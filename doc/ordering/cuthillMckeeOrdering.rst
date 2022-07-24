..
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

|

* **Supported versions:**
  `Latest <https://docs.pgrouting.org/latest/en/cuthillMckeeOrdering.html>`__
  (`3.4 <https://docs.pgrouting.org/3.4/en/cuthillMckeeOrdering.html>`__)

cuthillMckeeOrdering - Experimental
===============================================================================

``cuthillMckeeOrdering`` — Returns the reverse Cuthill-Mckee ordering of undirected
graphs

.. figure:: images/boost-inside.jpeg
   :target: https://www.boost.org/libs/graph/doc/cuthill_mckee_ordering.html

   Boost Graph Inside

.. include:: experimental.rst
   :start-after: begin-warn-expr
   :end-before: end-warn-exp

.. rubric:: Availability

* Version 3.4.0

  * New **experimental** signature:


Description
-------------------------------------------------------------------------------

In numerical linear algebra, the Cuthill-McKee algorithm (CM), named after
Elizabeth Cuthill and James McKee, is an algorithm to permute a sparse
matrix that has a symmetric sparsity pattern into a band matrix form with a
small bandwidth. The reverse Cuthill-McKee algorithm (RCM) due to Alan George
and Joseph Liu is the same algorithm but with the resulting index numbers reversed.
In practice this generally results in less fill-in than the CM ordering when
Gaussian elimination is applied.

The vertices are basically assigned a breadth-first search order, except that at
each step, the adjacent vertices are placed in the queue in order of increasing degree.

**The main Characteristics are:**

- The implementation is for **undirected** graphs.
- The running time complexity is: :math: `O(m log(m)|V|)` where m = max{degree(v)|v in V}.

Signatures
------------------------------------------------------------------------------

.. index::
    single: cuthillMckeeOrdering - Experimental on v3.4

.. parsed-literal::

    cuthillMckeeOrdering(`Edges SQL`_, **start vid**)

    RETURNS SET OF (seq, node)
    OR EMPTY SET

:Example:

.. literalinclude:: cuthillMckeeOrdering.queries
   :start-after: -- q1
   :end-before: -- q2

.. Parameters, Inner Queries & result columns

Parameters
-------------------------------------------------------------------------------

.. include:: ordering-family.rst
   :start-after: parameters_start
   :end-before: parameters_end

Inner Queries
-------------------------------------------------------------------------------

Edges SQL
...............................................................................

.. include:: pgRouting-concepts.rst
   :start-after: basic_edges_sql_start
   :end-before: basic_edges_sql_end 

Return columns
-------------------------------------------------------------------------------

.. include:: ordering-family.rst
    :start-after: result_columns_start
    :end-before: result_columns_end

See Also
-------------------------------------------------------------------------------

* The queries use the :doc:`sampledata` network.

.. see also start

* `Boost: Cuthill-McKee Ordering
  <https://www.boost.org/libs/graph/doc/cuthill_mckee_ordering.html>`__

.. see also end

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`     
  
      