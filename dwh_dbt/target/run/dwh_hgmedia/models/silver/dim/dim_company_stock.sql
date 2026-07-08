
  
    

  create  table "hgmediadb"."silver"."dim_company_stock__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_company_stock  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast("Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_company_stock_sk
    , nullif(trim(cast("Id" as text)),'') as company_id
    , nullif(trim(cast("Name" as text)),'') as company_name
from "hgmediadb"."staging"."company"
  );
  