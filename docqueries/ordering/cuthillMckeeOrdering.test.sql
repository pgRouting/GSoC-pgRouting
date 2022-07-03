/* -- q1 */
SELECT * FROM pgr_cuthillMckeeOrdering(
    'SELECT id, source, target, cost, reverse_cost FROM edges',
    1
);
/* -- q2 */