SELECT substring(description, instr(description, '.') + 1) as table_name,
tuples, 
unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) as seconds
extract('epoch' from duration) AS seconds 
FROM reports.load 
WHERE tuples = 0
ORDER BY 1;
