SELECT sum(unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) - unix_timestamp(cast('1970-01-01 00:00:00' as timestamp)))
FROM load_data
WHERE tuples = 0;
