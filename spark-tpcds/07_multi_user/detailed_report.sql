select query_id, 
sum(session_1) as session_1,
sum(session_2) as session_2,
sum(session_3) as session_3,
sum(session_4) as session_4,
sum(session_5) as session_5
from	(
	select substring(description, instr(description, '.') + 1) as query_id, 
	case when substring(description, 1, instr(description, '.') - 1) = '1' then unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) - unix_timestamp(cast('1970-01-01 00:00:00' as timestamp)) else 0 end as session_1,
	case when substring(description, 1, instr(description, '.') - 1) = '2' then unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) - unix_timestamp(cast('1970-01-01 00:00:00' as timestamp)) else 0 end as session_2,
	case when substring(description, 1, instr(description, '.') - 1) = '3' then unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) - unix_timestamp(cast('1970-01-01 00:00:00' as timestamp)) else 0 end as session_3,
	case when substring(description, 1, instr(description, '.') - 1) = '4' then unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) - unix_timestamp(cast('1970-01-01 00:00:00' as timestamp)) else 0 end as session_4,
	case when substring(description, 1, instr(description, '.') - 1) = '5' then unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) - unix_timestamp(cast('1970-01-01 00:00:00' as timestamp)) else 0 end as session_5
	from testing.sql_queries
	) as sub
group by query_id
order by 1;
