SELECT substring(description, instr(description, '.') + 1) as id,
unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) - unix_timestamp(cast('1970-01-01 00:00:00' as timestamp)) as duration
FROM sql_queries
WHERE tuples > 0
ORDER BY 1;
