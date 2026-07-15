use role accountadmin;
use warehouse compute_wh;
use database analytics_db;
show dynamic tables;

alter dynamic table FCT_CUSTOMER_ORDERS_DT
 set target_lag = '5 minutes';


show dynamic tables;
select * from table(information_schema.dynamic_table_refresh_history());

select * from analytics_db.public.fct_customer_orders_dt;

create or replace dynamic table fct_customer_orders_dt
    target_lag=downstream
    warehouse=compute_wh
    as select
        c.customer_id,
        c.customer_name,
        o.product_id,
        o.order_price,
        o.quantity,
        o.order_date
    from stg_customers_dt c
    left join stg_orders_dt o
        on c.customer_id = o.customer_id
    where o.product_id is not null;

alter dynamic table ANALYTICS_DB.PUBLIC.FCT_CUSTOMER_ORDERS_DT suspend;

select * from analytics_db.public.fct_customer_orders_dt;
