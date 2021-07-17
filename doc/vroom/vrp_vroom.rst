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
  `Latest <https://vrp.pgrouting.org/latest/en/vrp_vroom.html>`__
  (`v0 <https://vrp.pgrouting.org/v0/en/vrp_vroom.html>`__)


vrp_vroom - Experimental
===============================================================================

``vrp_vroom`` - Vehicle Routing Problem with VROOM

.. include:: experimental.rst
   :start-after: begin-warn-expr
   :end-before: end-warn-expr

.. rubric:: Availability

Version 0.2.0

* New **experimental** function


Synopsis
-------------------------------------------------------------------------------

VROOM is an open-source optimization engine that aims at providing good solutions
to various real-life vehicle routing problems (VRP) within a small computing time.

VROOM can solve several well-known types of vehicle routing problems (VRP).

- TSP (travelling salesman problem)
- CVRP (capacitated VRP)
- VRPTW (VRP with time windows)
- MDHVRPTW (multi-depot heterogeneous vehicle VRPTW)
- PDPTW (pickup-and-delivery problem with TW)

VROOM can also solve any mix of the above problem types.


Characteristics
...............................................................................

VROOM models a Vehicle Routing Problem with ``vehicles``, ``jobs`` and ``shipments``.

The **vehicles** denote the resources that pick and/or deliver the jobs and shipments.
They are characterised by:

- Capacity on arbitrary number of metrics
- Skills
- Working hours
- Driver breaks
- Start and end defined on a per-vehicle basis
- Start and end can be different
- Open trip optimization (only start or only end defined)

The **jobs** denote the single-location pickup and/or delivery tasks, and the **shipments**
denote the pickup-and-delivery tasks that should happen within the same route.
They are characterised by:

- Delivery/pickup amounts on arbitrary number of metrics
- Service time windows
- Service duration
- Skills
- Priority

Terminologies
...............................................................................

- **Tasks**: Either jobs or shipments are referred to as tasks.
- **Skills**: Every task and vehicle may have some set of skills. A task can be served by only that vehicle which has all the skills of the task.
- **Priority**: Tasks may have some priority assigned, which is useful when all tasks cannot be performed due to constraints, so the tasks with low priority are left unassigned.
- **Amount (for shipment), Pickup and delivery (for job)**: They denote the multidimensional quantities such as number of items, weights, volume, etc.
- **Capacity (for vehicle)**: Every vehicle may have some capacity, denoting the multidimensional quantities. A vehicle can serve only those sets of tasks such that the total sum of the quantity does not exceed the vehicle capacity, at any point of the route.
- **Time Window**: An interval of time during which some activity can be performed, such as working hours of the vehicle, break of the vehicle, or service start time for a task.
- **Break**: Array of time windows, denoting valid slots for the break start of a vehicle.
- **Service time**: The additional time to be spent by a vehicle while serving a task.
- **Travel time**: The total time the vehicle travels during its route.
- **Waiting time**: The total time the vehicle is idle, i.e. it is neither traveling nor servicing any task. It is generally the time spent by a vehicle waiting for a task service to open.

.. index::
    single: vroom - Experimental

Signature
-------------------------------------------------------------------------------

.. rubric:: Summary

.. code-block:: none

    vrp_vroom(Jobs SQL, Shipments SQL, Vehicles SQL, Matrix SQL, [, plan])

    RETURNS SET OF
    (seq, vehicle_sql, vehicle_id, step_seq, step_type, task_id,
     arrival, duration, service_time, waiting_time, load)


Parameters
-------------------------------------------------------------------------------

=================== ======================== =================================================
Parameter           Type                     Description
=================== ======================== =================================================
**Jobs SQL**        ``TEXT``                 `Jobs SQL`_ query describing the places to visit.
**Shipments SQL**   ``TEXT``                 `Shipments SQL`_ query describing pickup and delivery tasks.
**Vehicles SQL**    ``TEXT``                 `Vehicles SQL`_ query describing the available vehicles.
**Matrix SQL**      ``TEXT``                 `Time Matrix SQL`_ query containing the distance or
                                             travel times between the locations.
=================== ======================== =================================================

**Note**:

- At least one of the jobs or shipments shall be present in the query.

Optional Parameters
...............................................................................

=================== =========== =========================== =================================================
Parameter           Type        Default                     Description
=================== =========== =========================== =================================================
**plan**            ``BOOLEAN`` ``false``                   When ``true``, plan mode is enabled. Choose ETA for
                                                            custom routes and report violations. Requires GLPK as a dependency.

                                                            - All constraints in input implicitly become soft constraints.
                                                            - The output is a set of routes matching the expected description while minimizing timing violations and reporting all constraint violations.

=================== =========== =========================== =================================================

Inner Queries
-------------------------------------------------------------------------------

Jobs SQL
................................................................................

A ``SELECT`` statement that returns the following columns:

::

    id, location_index
    [, service, delivery, pickup, skills, priority, time_windows_sql]


====================  =========================  =========== ================================================
Column                Type                       Default     Description
====================  =========================  =========== ================================================
**id**                ``ANY-INTEGER``                        Non-negative unique identifier of the job.

**location_index**    ``ANY-INTEGER``                        Non-negative index of relevant row and column
                                                             in the custom matrix, denoting job location.

                                                             - Ranges from ``[0, SIZE[matrix]-1]``

**service**           ``INTEGER``                0           Job service duration, in seconds

**delivery**          ``ARRAY[ANY-INTEGER]``                 Array of non-negative integers describing
                                                             multidimensional quantities for delivery such
                                                             as number of items, weight, volume etc.

                                                             - All jobs must have the same value of
                                                               :code:`array_length(delivery, 1)`

**pickup**            ``ARRAY[ANY-INTEGER]``                 Array of non-negative integers describing
                                                             multidimensional quantities for pickup such as
                                                             number of items, weight, volume etc.

                                                             - All jobs must have the same value of
                                                               :code:`array_length(pickup, 1)`

**skills**            ``ARRAY[INTEGER]``                     Array of non-negative integers defining
                                                             mandatory skills.

**priority**          ``INTEGER``                0           Priority level of the job

                                                             - Ranges from ``[0, 100]``

**time_windows_sql**  ``TEXT``                               `Time Windows SQL`_ query describing valid slots
                                                             for job service start.
====================  =========================  =========== ================================================

Where:

:ANY-INTEGER: SMALLINT, INTEGER, BIGINT

Shipments SQL
................................................................................

A ``SELECT`` statement that returns the following columns:

::

    p_id, p_location_index [, p_service, p_time_windows],
    d_id, d_location_index [, d_service, d_time_windows]
    [, amount, skills, priority]


======================  =========================  =========== ================================================
Column                  Type                       Default     Description
======================  =========================  =========== ================================================
**p_id**                ``ANY-INTEGER``                         Non-negative unique identifier of the pickup
                                                                shipment (unique for pickup).

**p_location_index**    ``ANY-INTEGER``                         Non-negative index of relevant row and column
                                                                in the custom matrix, denoting pickup location.

                                                                - Ranges from ``[0, SIZE[matrix]-1]``

**p_service**           ``INTEGER``                0            Pickup service duration, in seconds

**p_time_windows_sql**  ``TEXT``                                `Time Windows SQL`_ query describing valid slots
                                                                for pickup service start.

**d_id**                ``ANY-INTEGER``                         Non-negative unique identifier of the delivery
                                                                shipment (unique for delivery).

**d_location_index**    ``ANY-INTEGER``                         Non-negative index of relevant row and column
                                                                in the custom matrix, denoting delivery location.

                                                                - Ranges from ``[0, SIZE[matrix]-1]``

**d_service**           ``INTEGER``                0            Delivery service duration, in seconds

**d_time_windows_sql**  ``TEXT``                                `Time Windows SQL`_ query describing valid slots
                                                                for delivery service start.

**amount**              ``ARRAY[ANY-INTEGER]``                  Array of non-negative integers describing
                                                                multidimensional quantities such as number
                                                                of items, weight, volume etc.

                                                                - All shipments must have the same value of
                                                                  :code:`array_length(amount, 1)`

**skills**              ``ARRAY[INTEGER]``                      Array of non-negative integers defining
                                                                mandatory skills.

**priority**            ``INTEGER``                0            Priority level of the shipment.

                                                                - Ranges from ``[0, 100]``

======================  =========================  =========== ================================================

Where:

:ANY-INTEGER: SMALLINT, INTEGER, BIGINT


Vehicles SQL
.........................................................................................

A ``SELECT`` statement that returns the following columns:

::

    id, start_index, end_index
    [, service, delivery, pickup, skills, priority, time_window, breaks_sql, steps_sql]


======================  ================================= ================================================
Column                  Type                              Description
======================  ================================= ================================================
**id**                  ``ANY-INTEGER``                    Non-negative unique identifier of the job.

**start_index**         ``ANY-INTEGER``                    Non-negative index of relevant row and column
                                                           in the custom matrix, denoting vehicle start.

                                                           - Ranges from ``[0, SIZE[matrix]-1]``

**end_index**           ``ANY-INTEGER``                    Non-negative index of relevant row and column
                                                           in the custom matrix, denoting vehicle end.

                                                           - Ranges from ``[0, SIZE[matrix]-1]``

**capacity**            ``ARRAY[ANY-INTEGER]``             Array of non-negative integers describing
                                                           multidimensional quantities such as
                                                           number of items, weight, volume etc.

                                                           - All vehicles must have the same value of
                                                             :code:`array_length(capacity, 1)`

**skills**              ``ARRAY[INTEGER]``                 Array of non-negative integers defining
                                                           mandatory skills.

**time_window_start**   ``INTEGER``                        Time window start time.

**time_window_end**     ``INTEGER``                        Time window end time.

**breaks_sql**          ``TEXT``                           `Breaks SQL`_ query describing the driver breaks.

**speed_factor**        ``ANY-NUMERICAL``                  Vehicle travel time multiplier.

**steps_sql**           ``TEXT``                           `Steps SQL`_ query describing a custom route for
                                                           the vehicle

                                                           - Makes sense only when the ``plan`` flag is ``true``.
======================  ================================= ================================================

.. TODO(ashish): Move documentation in the code

.. TODO(ashish): At the end, match this documentation with VROOM API documentation.

**Note**:

- At least one of the start_index or end_index shall be present.
- If end_index is omitted, the resulting route will stop at the last visited task, whose choice is determined by the optimization process
- If start_index is omitted, the resulting route will start at the first visited task, whose choice is determined by the optimization process
- To request a round trip, specify both start_index and end_index with the same index.
- A vehicle is only allowed to serve a set of tasks if the resulting load at each route step is lower than the matching value in capacity for each metric. When using multiple components for amounts, it is recommended to put the most important/limiting metrics first.
- It is assumed that all delivery-related amounts for jobs are loaded at vehicle start, while all pickup-related amounts for jobs are brought back at vehicle end.
- :code:`time_window_start ≤ time_window_end`


Breaks SQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A ``SELECT`` statement that returns the following columns:

::

    id, time_windows [, service]

====================  =========================  =========== ================================================
Column                Type                       Default     Description
====================  =========================  =========== ================================================
**id**                ``ANY-INTEGER``                         Non-negative unique identifier of the break
                                                              (unique for the same vehicle).

**time_windows_sql**  ``TEXT``                                `Time Windows SQL`_ query describing valid slots
                                                              for break start.

**service**           ``INTEGER``                0            The break duration, in seconds
====================  =========================  =========== ================================================


Steps SQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A ``SELECT`` statement that returns the following columns:

::

    id, type [, service_at, service_before, service_after]

====================  ====================================== ================================================
Column                Type                                   Description
====================  ====================================== ================================================
**id**                ``ANY-INTEGER``                         Unique identifier of the task to be performed
                                                              at this step.

                                                              - For ``start`` and ``end`` task, id is ``-1``.

**type**              ``INTEGER``                             Kind of the step of the vehicle:

                                                              - ``1``: Starting location.
                                                              - ``2``: Job location.
                                                              - ``3``: Pickup location.
                                                              - ``4``: Delivery location.
                                                              - ``5``: Break location.
                                                              - ``6``: Ending location.

**service_at**        ``INTEGER``                             Hard constraint on service time, in seconds

**service_after**     ``INTEGER``                             Hard constraint on service time lower bound,
                                                              in seconds

**service_before**    ``INTEGER``                             Hard constraint on service time upper bound,
                                                              in seconds
====================  ====================================== ================================================

Where:

:ANY-INTEGER: SMALLINT, INTEGER, BIGINT


Time Windows SQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A ``SELECT`` statement that returns the following columns:

::

    start_time, end_time

====================  ====================================== ================================================
Column                Type                                   Description
====================  ====================================== ================================================
**start_time**        ``INTEGER``                             Start time of the time window.

**end_time**          ``INTEGER``                             End time of the time window.
====================  ====================================== ================================================

**Note**:

- All timing are in seconds.
- Every row must satisfy the condition: :code:`start_time ≤ end_time`.
- It is up to users to decide how to describe time windows:

  - **Relative values**, e.g. [0, 14400] for a 4 hours time window starting at the beginning of the planning horizon. In that case all times reported in output with the arrival column are relative to the start of the planning horizon.
  - **Absolute values**, "real" timestamps. In that case all times reported in output with the arrival column can be interpreted as timestamps.


Time Matrix SQL
.........................................................................................

A ``SELECT`` statement that returns the following columns:

::

    start_index, end_index, agg_cost

=============== ================= ==================================================
Column          Type              Description
=============== ================= ==================================================
**start_index** ``ANY-INTEGER``   Identifier of the start node.
**end_index**   ``ANY-INTEGER``   Identifier of the end node.
**agg_cost**    ``INTEGER``       Time to travel from ``start_index`` to ``end_index``
=============== ================= ==================================================

.. TODO: Add Vehicle Profiles

Result Columns
-------------------------------------------------------------------------------


=================== ============= =================================================
Column              Type           Description
=================== ============= =================================================
**seq**              ``BIGINT``   Sequential value starting from **1**.

**vehicle_seq**      ``BIGINT``   Sequential value starting from **1** for current vehicles.
                                  The :math:`n^{th}` vehicle in the solution.

**vehicle_id**       ``BIGINT``   Current vehicle identifier.

**step_seq**         ``BIGINT``   Sequential value starting from **1** for the stops
                                  made by the current vehicle. The :math:`m^{th}` stop
                                  of the current vehicle.

**step_type**        ``INTEGER``  Kind of the step location the vehicle is at:

                                  - ``1``: Starting location
                                  - ``2``: Job location
                                  - ``3``: Pickup location
                                  - ``4``: Delivery location
                                  - ``5``: Break location
                                  - ``6``: Ending location

**task_id**          ``BIGINT``   Identifier of the task performed at this step.

**arrival**          ``INTEGER``  Estimated time of arrival at this step, in seconds.

**duration**         ``INTEGER``  Cumulated travel time upon arrival at this step, in seconds

**service_time**     ``INTEGER``  Service time at this step, in seconds

**waiting_time**     ``INTEGER``  Waiting time upon arrival at this step, in seconds.

**load**             ``BIGINT``   Vehicle load after step completion (with capacity constraints)
=================== ============= =================================================

.. TODO: Violation, and more argument for different results.

Example
-------------------------------------------------------------------------------

.. TODO put link

This example use the following data:



See Also
-------------------------------------------------------------------------------

* :doc:`pgr-category`
* The queries use the :doc:`sampledata` network.

.. rubric:: Indices and tables

* :ref:`genindex`
* :ref:`search`
