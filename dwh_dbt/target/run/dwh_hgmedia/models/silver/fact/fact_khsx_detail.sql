
  
    

  create  table "hgmediadb"."silver"."fact_khsx_detail__dbt_tmp"
  
  
    as
  
  (
    -- silver.fact_khsx_detail  (target theo Data Dictionary)


select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as fact_khsx_detail_sk
    , nullif(trim(cast(id as text)),'') as production_plan_detail_id
    , nullif(trim(cast(plan_id as text)),'') as production_plan_id
    , nullif(trim(cast(produce_manager as text)),'') as production_manager
    , nullif(trim(cast(ar_id as text)),'') as ar_manager
    , nullif(trim(cast(state as text)),'') as status
from "hgmediadb"."staging"."x_music_plan_detail"
  );
  