-- CopyRight(c) pgRouting developers
-- Creative Commons Attribution-Share Alike 3.0 License : https://creativecommons.org/licenses/by-sa/3.0/
/* -- q1 */
SELECT * FROM pgr_sequentialVertexColoring(
    'SELECT id, source, target, cost, reverse_cost FROM edges
    ORDER BY id'
);
/* -- q2 */
