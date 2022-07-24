/* -- q1 */
SELECT * FROM pgr_cuthillMckeeOrdering(
  'SELECT id, source, target, cost, reverse_cost FROM edges',
  1);
/* -- q2 */
-- below this line are for becoming pgTap tests
SELECT * FROM pgr_cuthillMckeeOrdering(
  'SELECT id, source, target, cost, reverse_cost FROM edges',
  6);

CREATE TABLE expected_result (
  seq INTEGER,
  node BIGINT);

INSERT INTO expected_result (seq, node) VALUES
(1, 8),
(2, 3),
(3, 0), 
(4, 9),
(5, 2),
(6, 5),
(7, 1),
(8, 4),
(9, 7),
(10, 6);