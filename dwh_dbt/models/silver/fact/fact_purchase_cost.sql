with cost as (
    select *, "_year" as year_no from {{ source('staging', 'purchase_cost') }}
),
kho as (
    select distinct trim("Tên đối tác") as partner_name, trim("Tên kho trên HG Stock") as repo_name
    from {{ source('staging', 'partners') }}
    where nullif(trim("Tên kho trên HG Stock"), '') is not null
),
res_count as (
    select repository, count(*) as n_res
    from {{ ref('dim_purchased_resource') }}
    group by repository
),
res as (
    select hg_stock_id, repository from {{ ref('dim_purchased_resource') }}
),
unpivoted as (
    {% for m in range(1, 13) %}
    select trim(c."Tên đối tác") as partner_name, c.year_no, {{ m }} as month_no
         , c."Total năm" as total_year_raw, c."CP tháng {{ m }}" as add_raw
    from cost c
    {% if not loop.last %}union all{% endif %}
    {% endfor %}
)
select
    {{ dbt_utils.generate_surrogate_key(['res.hg_stock_id','u.year_no','u.month_no']) }} as cost_id
    , res.hg_stock_id as resource_id
    , cast(nullif(regexp_replace(u.total_year_raw,'[^0-9]','','g'),'') as numeric) / nullif(rc.n_res,0) as total_cost
    , cast(nullif(regexp_replace(u.add_raw,'[^0-9]','','g'),'') as numeric)       / nullif(rc.n_res,0) as additional_cost
    , (date_trunc('month', make_date(u.year_no::int, u.month_no, 1)) + interval '1 month - 1 day')::date as incurred_datetime
from unpivoted u
join kho k       on u.partner_name = k.partner_name
join res_count rc on rc.repository = k.repo_name
join res          on res.repository = k.repo_name
where nullif(regexp_replace(u.add_raw,'[^0-9]','','g'),'') is not null