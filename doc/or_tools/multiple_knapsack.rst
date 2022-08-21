..
   ****************************************************************************
    vrpRouting Manual
    Copyright(c) vrpRouting Contributors
    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************
|

* `Documentation <https://vrp.pgrouting.org/>`__ → `vrpRouting v0 <https://vrp.pgrouting.org/v0>`__
* Supported Versions
  `Latest <https://vrp.pgrouting.org/latest/en/vrp_oneDepot.html>`__
  (`v0 <https://vrp.pgrouting.org/v0/en/vrp_oneDepot.html>`__)

vrp_multiple_knapsack - Experimental
===============================================================================

.. include:: experimental.rst
   :start-after: begin-warn-expr
   :end-before: end-warn-expr

.. rubric:: Availability

Version 0.0.0

* New **experimental** function

  * vrp_knapsack



Description
-------------------------------------------------------------------------------

The multiple knapsack problem is a problem in combinatorial optimization: 
it is a more general verison of the classic knapsack problem where instead of a
single knapsack, you will be given multiple knapsacks and your goal is maximise the total
value of packed items in all knapsacks.

Signatures
-------------------------------------------------------------------------------

.. include:: ../sql/or_tools/multiple_knapsack.sql
   :start-after: signature start
   :end-before: signature end

Parameters
-------------------------------------------------------------------------------

.. include:: ../sql/or_tools/multiple_knapsack.sql
   :start-after: parameters start
   :end-before: parameters end

Inner Queries
-------------------------------------------------------------------------------

* TBD

Result Columns
-------------------------------------------------------------------------------

* TBD

Example
-------------------------------------------------------------------------------

* TBD

See Also
-------------------------------------------------------------------------------

* TBD

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`