WITH x AS (SELECT unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) as duration FROM gen_data)
SELECT 'Seconds' as time, duration AS value
FROM x
UNION ALL
SELECT 'Minutes', duration/60 AS minutes
FROM x
UNION ALL
SELECT 'Hours', duration/(60*60) AS hours 
FROM x;
