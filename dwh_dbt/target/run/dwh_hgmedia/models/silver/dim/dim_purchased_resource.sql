
  
    

  create  table "hgmediadb"."silver"."dim_purchased_resource__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_purchased_resource
select distinct on (pr."Mã")
    md5(cast(coalesce(cast(pr."Mã" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_purchased_resource_sk
    , nullif(trim(pr."Mã"), '') as hg_stock_id
    , nullif(trim(pr."Tiêu đề"), '') as resources_name
    , nullif(trim(pr."Repository"), '') as repository
    , md5(cast(coalesce(cast(pr."Nghệ sĩ bài hát" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as partner_id
    , nullif(trim(p."Ngày ký HĐ"), '') as buy_date
    , nullif(trim(p."Cách tính giá"), '') as repository_type
from "hgmediadb"."staging"."purchased_resource" pr
left join "hgmediadb"."staging"."partners" p
    on trim(pr."Repository") = trim(p."Tên kho trên HG Stock")
where trim(pr."Mã") ~ '^HG[A-F0-9]+$'
order by pr."Mã"
  );
  