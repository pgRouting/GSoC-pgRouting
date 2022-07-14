-- TODO make the single tests.

SELECT * FROM vrp_knapsack($$ SELECT * FROM knapsack_data$$, 3);