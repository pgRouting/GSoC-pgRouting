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
(3, 12), 
(4, 15),
(5, 7),
(6, 11),
(7, 9),
(8, 10),
(9, 8),
(10, 6),
(11, 4),
(12, 5),
(13, 3),
(14, 2),
(15, 1),
(16, 16),
(17, 17);