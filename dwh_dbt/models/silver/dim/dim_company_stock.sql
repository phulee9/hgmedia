-- silver.dim_company_stock  (target theo Data Dictionary)
select
    {{ dbt_utils.generate_surrogate_key(['"Id"']) }} as dim_company_stock_sk
    , nullif(trim(cast("Id" as text)),'') as company_id
    , nullif(trim(cast("Name" as text)),'') as company_name
from {{ source('staging', 'company') }}
