-- silver.dim_po  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_po_sk
    , nullif(trim(cast(id as text)),'') as po_id
    , cast(nullif(trim(cast(create_date as text)),'') as timestamp) as po_created_date
    , nullif(trim(cast(x_employee_id as text)),'') as order_employee_id
    , nullif(trim(cast(company_id as text)),'') as ordering_company
    , nullif(trim(cast(state as text)),'') as status
    , cast(nullif(trim(cast(date_approve as text)),'') as timestamp) as po_confirmed_date
from "hgmediadb"."staging"."purchase_order"