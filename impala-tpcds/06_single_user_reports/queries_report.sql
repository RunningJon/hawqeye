--SELECT split_part(description, '.', 2) AS id,
SELECT substring(description, instr(description, '.') + 1) as id,
tuples,
unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) as duration,
log_status
FROM sql_queries
ORDER BY id; 
