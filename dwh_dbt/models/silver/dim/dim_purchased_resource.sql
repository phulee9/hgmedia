-- silver.dim_purchased_resource
select distinct on (pr."Mã")
    {{ dbt_utils.generate_surrogate_key(['pr."Mã"']) }} as dim_purchased_resource_sk
    , nullif(trim(pr."Mã"), '') as hg_stock_id
    , nullif(trim(pr."Tiêu đề"), '') as resources_name
    , nullif(trim(pr."Repository"), '') as repository
    , {{ dbt_utils.generate_surrogate_key(['pr."Nghệ sĩ bài hát"']) }} as partner_id
    , nullif(trim(p."Ngày ký HĐ"), '') as buy_date
    , nullif(trim(p."Cách tính giá"), '') as repository_type
from {{ source('staging', 'purchased_resource') }} pr
left join {{ source('staging', 'partners') }} p
    on trim(pr."Repository") = trim(p."Tên kho trên HG Stock")
where trim(pr."Mã") ~ '^HG[A-F0-9]+$'
order by pr."Mã"