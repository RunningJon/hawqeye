SELECT sum(unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp))) as seconds
FROM load_data
WHERE tuples = 0;
