\i setup.sql

UPDATE edge_table SET cost = sign(cost), reverse_cost = sign(reverse_cost);
SELECT plan(54);

SELECT todo_start('needs checking');

SELECT style_dijkstra('pgr_mycoloring', ')');

SELECT todo_end();

SELECT finish();
ROLLBACK;
