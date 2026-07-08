
  
    

  create  table "hgmediadb"."silver"."dim_net__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_net  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast("Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_net_sk
    , nullif(trim(cast("Id" as text)),'') as net_id
    , nullif(trim(cast("Name" as text)),'') as net_name
from "hgmediadb"."staging"."network"
  );
  