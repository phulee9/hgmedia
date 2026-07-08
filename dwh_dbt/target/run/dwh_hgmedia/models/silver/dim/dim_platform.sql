
  
    

  create  table "hgmediadb"."silver"."dim_platform__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_platform  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast(retailer as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_platform_sk
    , md5(cast(coalesce(cast(retailer as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as artist_id
    , nullif(trim(retailer),'') as artist_name
from "hgmediadb"."staging"."sale"
where nullif(trim(retailer),'') is not null
group by retailer
  );
  