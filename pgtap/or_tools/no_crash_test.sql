BEGIN;
SET search_path TO 'ortools', 'public';
SET client_min_messages TO ERROR;

SELECT CASE WHEN min_version('0.3.0') THEN plan (116) ELSE plan(1) END;

-- DEALLOCATE knapsack_test;
-- DEALLOCATE multiple_knapsack_test;
-- DEALLOCATE bin_packing_test;

-- PREPARE knapsack_test AS
-- SELECT * FROM ortools.knapsack_data;

-- PREPARE multiple_knapsack_test AS
-- SELECT * FROM ortools.multiple_knapsack_data;

-- PREPARE bin_packing_test AS
-- SELECT * FROM ortools.bin_packing_data;


-- SELECT isnt_empty('knapsack_test', 'Should be not empty to tests be meaningful');
-- SELECT isnt_empty('multiple_test', 'Should be not empty to tests be meaningful');
-- SELECT isnt_empty('bin_packing_test', 'Should be not empty to tests be meaningful');


CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
BEGIN
    -- vrp_knapsack
    params = ARRAY[
    '$$SELECT * FROM ortools.knapsack_data$$',
    'capacity => 15',
    'max_rows => 100000'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    'NULL'
    ]::TEXT[];
    
    RETURN QUERY SELECT * FROM no_crash_test('vrp_knapsack', params, subs);

    --vrp_multiple_knapsack
    params = ARRAY[
    '$$SELECT * FROM ortools.multiple_knapsack_data$$',
    'capacities => ARRAY[100,100,100,100,100]',
    'max_rows => 100000'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    'NULL',
    'NULL'
    ]::TEXT[];
    
    RETURN QUERY SELECT * FROM no_crash_test('vrp_multiple_knapsack', params, subs);

    -- bin_packing
    params = ARRAY[
    '$$SELECT * FROM ortools.bin_packing_data$$',
    'bin_capacity => 100'
    'max_rows => 100000'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    'NULL',
    'NULL'
    ]::TEXT[];
    
    RETURN QUERY SELECT * FROM no_crash_test('vrp_bin_packing', params, subs);
END
$BODY$
LANGUAGE plpgsql VOLATILE;


SELECT * FROM no_crash();

ROLLBACK;
