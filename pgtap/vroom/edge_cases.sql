BEGIN;

SELECT plan(1);

SELECT pass('Sample test');

SELECT * FROM finish();
ROLLBACK;
