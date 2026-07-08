-- silver.dim_ar  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_ar_sk
    , nullif(trim(cast(id as text)),'') as "mã a&r"
    , nullif(trim(cast(name as text)),'') as "tên a&r"
from "hgmediadb"."staging"."hr_employee"