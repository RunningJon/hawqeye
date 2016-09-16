select sub2.query_id, 
sum(session_1) as session_1,
max(log_status_1) as log_status_1,
sum(session_2) as session_2,
max(log_status_2) as log_status_2,
sum(session_3) as session_3,
max(log_status_3) as log_status_3,
sum(session_4) as session_4,
max(log_status_4) as log_status_4,
sum(session_5) as session_5,
max(log_status_5) as log_status_5,
sum(session_6) as session_6,
max(log_status_6) as log_status_6,
sum(session_7) as session_7,
max(log_status_7) as log_status_7,
sum(session_8) as session_8,
max(log_status_8) as log_status_8,
sum(session_9) as session_9,
max(log_status_9) as log_status_9,
sum(session_10) as session_10,
max(log_status_10) as log_status_10
from (
	select query_id, 
	case when session_id = '1' then duration else 0 end as session_1, case when session_id = '1' then log_status else '' end as log_status_1,
	case when session_id = '2' then duration else 0 end as session_2, case when session_id = '2' then log_status else '' end as log_status_2,
	case when session_id = '3' then duration else 0 end as session_3, case when session_id = '3' then log_status else '' end as log_status_3,
	case when session_id = '4' then duration else 0 end as session_4, case when session_id = '4' then log_status else '' end as log_status_4,
	case when session_id = '5' then duration else 0 end as session_5, case when session_id = '5' then log_status else '' end as log_status_5,
	case when session_id = '6' then duration else 0 end as session_6, case when session_id = '6' then log_status else '' end as log_status_6,
	case when session_id = '7' then duration else 0 end as session_7, case when session_id = '7' then log_status else '' end as log_status_7,
	case when session_id = '8' then duration else 0 end as session_8, case when session_id = '8' then log_status else '' end as log_status_8,
	case when session_id = '9' then duration else 0 end as session_9, case when session_id = '9' then log_status else '' end as log_status_9,
	case when session_id = '10' then duration else 0 end as session_10, case when session_id = '10' then log_status else '' end as log_status_10
	from	(
		select substring(description, instr(description, '.') + 1) as query_id, 
		substring(description, 1, instr(description, '.') - 1) as session_id,
		log_status,
		unix_timestamp(cast(concat('1970-01-01 ', cast(duration as string)) as timestamp)) as duration
		from testing.sql_queries
		) as sub1
	) as sub2
group by sub2.query_id
order by 1;
