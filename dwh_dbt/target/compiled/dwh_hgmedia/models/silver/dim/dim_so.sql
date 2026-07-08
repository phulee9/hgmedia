-- silver.dim_so  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_so_sk
    , nullif(trim(cast(id as text)),'') as so_id
    , nullif(trim(cast(x_purchase_line_id as text)),'') as po_id  -- TODO: xác nhận có phải trỏ tới purchase_order_line.id không
    , cast(nullif(trim(cast(create_date as text)),'') as timestamp) as so_created_date
    , cast(nullif(trim(cast(write_date as text)),'') as timestamp) as so_confirmed_date
    , nullif(trim(cast(state as text)),'') as status
from "hgmediadb"."staging"."sale_order_line"