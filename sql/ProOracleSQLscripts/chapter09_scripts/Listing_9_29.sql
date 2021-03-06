PROMPT 
PROMPT Model and materialized view
PROMPT
  col product format A30
  col country format A10
  col region format A10
  col year format 9999
  col week format 99
  col sale format 999999.99
  col receipts format 999999.99
  set lines 120 pages 100
drop materialized view mv_model_inventory;
create materialized view mv_model_inventory
enable query rewrite as
  select product, country, year, week, inventory, sale, receipts
  from sales_fact
  model return updated rows
  partition by (product, country)
  dimension by (year, week)
  measures ( 0 inventory , sale, receipts)
  rules sequential order(
       inventory [year, week ] order by year, week =
                                 nvl(inventory [cv(year), cv(week)-1 ] ,0)
                                  - sale[cv(year), cv(week) ] +
                                  + receipts [cv(year), cv(week) ]
   )
/

set lines 120 pages 100
select * from (
 select product, country, year, week, inventory, sale, receipts
  from sales_fact
  model return updated rows
  partition by (product, country)
  dimension by (year, week)
  measures ( 0 inventory , sale, receipts)
  rules sequential order(
       inventory [year, week ] order by year, week =
                                 nvl(inventory [cv(year), cv(week)-1 ] ,0)
                                  - sale[cv(year), cv(week) ] +
                                  + receipts [cv(year), cv(week) ]
   )
 )
where country in ('Australia') and product='Xtend Memory' 
order by product, country,year, week
/
select * from table (dbms_xplan.display_cursor('','','ALLSTATS LAST'));
