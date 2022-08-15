BEGIN;
SET search_path TO 'ortools', 'public';
SET client_min_messages TO ERROR;
SELECT plan(13);

CREATE OR REPLACE FUNCTION no_crash()
RETURNS SETOF TEXT AS
$BODY$
DECLARE
params TEXT[];
subs TEXT[];
error_messages TEXT[];
non_empty_args INTEGER[];
BEGIN
    -- DEALLOCATE knapsack_test;
    -- DEALLOCATE multiple_knapsack_test;
    -- DEALLOCATE bin_packing_test;

    -- PREPARE knapsack_test AS SELECT * FROM ortools.knapsack_data;
    -- PREPARE multiple_knapsack_test AS SELECT * FROM ortools.multiple_knapsack_data;
    -- PREPARE bin_packing_test AS SELECT * FROM ortools.bin_packing_data;
    
    -- RETURN QUERY
    -- SELECT isnt_empty('knapsack_test', 'Should be not empty to tests be meaningful');
    -- RETURN QUERY
    -- SELECT isnt_empty('multiple_test', 'Should be not empty to tests be meaningful');
    -- RETURN QUERY
    -- SELECT isnt_empty('bin_packing_test', 'Should be not empty to tests be meaningful');

    -- vrp_knapsack
    params = ARRAY[
    '$$SELECT * FROM ortools.knapsack_data$$',
    'capacity => 15',
    'max_rows => 100000'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    'capacity => 15',
    'NULL'
    ]::TEXT[];
    error_messages = ARRAY[
    '',
    '',
    ''
    ]::TEXT[];
    non_empty_args = ARRAY[0, 1, 2]::INTEGER[];
    
    RETURN QUERY SELECT * FROM no_crash_test('vrp_knapsack', params, subs, error_messages, non_empty_args);

    --vrp_multiple_knapsack
    params = ARRAY[
    '$$multiple_knapsack_test$$',
    'capacities => ARRAY[100,100,100,100,100]',
    'max_rows => 100000'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    'capacities => ARRAY[100,100,100,100,100]',
    'NULL'
    ]::TEXT[];
    
    RETURN QUERY SELECT * FROM no_crash_test('vrp_multiple_knapsack', params, subs);

    -- bin_packing
    params = ARRAY[
    '$$bin_packing_test$$',
    'bin_capacity => 100'
    'max_rows => 100000'
    ]::TEXT[];
    subs = ARRAY[
    'NULL',
    'bin_capacity => 100',
    'NULL'
    ]::TEXT[];
    
    RETURN QUERY SELECT * FROM no_crash_test('vrp_bin_packing', params, subs);
END
$BODY$
LANGUAGE plpgsql VOLATILE;

SELECT * FROM no_crash();

ROLLBACK;
