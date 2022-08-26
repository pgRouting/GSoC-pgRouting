/* -- q1 */
SELECT * FROM pgr_cuthillMckeeOrdering(
  'SELECT id, source, target, cost, reverse_cost FROM edges',
  1);
/* -- q2 */



-- added to pgtap test
SELECT * FROM pgr_cuthillMckeeOrdering(
  'SELECT id, source, target, cost, reverse_cost FROM edges',
  6);

CREATE TABLE expected_result (
  seq INTEGER,
  node BIGINT);

INSERT INTO expected_result (seq, node) VALUES
(1, 13),
(2, 14),
(3, 9), 
(4, 2),
(5, 1),
(6, 4),
(7, 3),
(8, 8),
(9, 5),
(10, 7),
(11, 12),
(12, 6),
(13, 11),
(14, 17),
(15, 10),
(16, 16),
(17, 15);