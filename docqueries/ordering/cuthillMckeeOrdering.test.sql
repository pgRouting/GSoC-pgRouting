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
(1, 1),
(2, 3),
(3, 7), 
(4, 6),
(5, 8),
(6, 11),
(7, 5),
(8, 12),
(9, 4),
(10, 10),
(11, 16),
(12, 17),
(13, 2),
(14, 9),
(15, 15),
(16, 13),
(17, 14);