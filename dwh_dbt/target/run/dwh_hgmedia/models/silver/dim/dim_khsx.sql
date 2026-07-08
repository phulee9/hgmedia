
  
    

  create  table "hgmediadb"."silver"."dim_khsx__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_khsx  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_khsx_sk
    , nullif(trim(cast(id as text)),'') as production_plan_id
    , nullif(trim(cast(name as text)),'') as plan_name
    , nullif(trim(cast(create_date as text)),'') as created_date
    , nullif(trim(cast(date as text)),'') as production_month
    , nullif(trim(cast(state as text)),'') as status
    , nullif(trim(cast(create_uid as text)),'') as created_by
from "hgmediadb"."staging"."x_music_plan"
  );
  