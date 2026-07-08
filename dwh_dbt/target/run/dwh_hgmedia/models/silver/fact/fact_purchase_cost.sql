
      
  
    

  create  table "hgmediadb"."silver"."fact_purchase_cost"
  
  
    as
  
  (
    with cost as (
    select *, "_year" as year_no from "hgmediadb"."staging"."purchase_cost"
),
kho as (
    select distinct trim("Tên đối tác") as partner_name, trim("Tên kho trên HG Stock") as repo_name
    from "hgmediadb"."staging"."partners"
    where nullif(trim("Tên kho trên HG Stock"), '') is not null
),
res_count as (
    select repository, count(*) as n_res
    from "hgmediadb"."silver"."dim_purchased_resource"
    group by repository
),
res as (
    select hg_stock_id, repository from "hgmediadb"."silver"."dim_purchased_resource"
),
unpivoted as (
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 1 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 1" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 2 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 2" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 3 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 3" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 4 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 4" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 5 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 5" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 6 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 6" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 7 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 7" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 8 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 8" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 9 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 9" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 10 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 10" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 11 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 11" as add_raw
    from cost c
    union all
    
    select trim(c."Tên đối tác") as partner_name, c.year_no, 12 as month_no
         , c."Total năm" as total_year_raw, c."CP tháng 12" as add_raw
    from cost c
    
    
)
select
    md5(cast(coalesce(cast(res.hg_stock_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(u.year_no as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(u.month_no as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as cost_id
    , res.hg_stock_id as resource_id
    , cast(nullif(regexp_replace(u.total_year_raw,'[^0-9]','','g'),'') as numeric) / nullif(rc.n_res,0) as total_cost
    , cast(nullif(regexp_replace(u.add_raw,'[^0-9]','','g'),'') as numeric)       / nullif(rc.n_res,0) as additional_cost
    , (date_trunc('month', make_date(u.year_no::int, u.month_no, 1)) + interval '1 month - 1 day')::date as incurred_datetime
from unpivoted u
join kho k       on u.partner_name = k.partner_name
join res_count rc on rc.repository = k.repo_name
join res          on res.repository = k.repo_name
where nullif(regexp_replace(u.add_raw,'[^0-9]','','g'),'') is not null
  );
  
  