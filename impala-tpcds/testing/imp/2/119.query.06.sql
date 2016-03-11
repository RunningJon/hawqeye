-- start query 6 in stream 0 using template query6.tpl
 select  a.ca_state state, count(*) cnt
 from customer_address a
     ,customer c
     ,store_sales s
     ,date_dim d
     ,item i
 where
        a.ca_address_sk = c.c_current_addr_sk
        and c.c_customer_sk = s.ss_customer_sk
        and s.ss_sold_date_sk = d.d_date_sk
        --removed Cloudera cheat
	--and s.ss_sold_date_sk between 2451180 and 2451210
        and s.ss_item_sk = i.i_item_sk
        -- and d.d_month_seq =
        and d.d_month_seq in
             (select distinct (d_month_seq)
              from date_dim
               where d_year = 1999
                and d_moy = 1)
        and i.i_current_price > 1.2 *
             (select avg(j.i_current_price)
             from item j
             where j.i_category = i.i_category)
 group by a.ca_state
 having count(*) >= 10
 order by cnt 
 limit 100;
