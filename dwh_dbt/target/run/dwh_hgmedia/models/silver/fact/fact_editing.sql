
      
  
    

  create  table "hgmediadb"."silver"."fact_editing__dbt_tmp"
  
  
    as
  
  (
    -- silver.fact_editing
select
    md5(cast(coalesce(cast(re."Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as fact_editing_sk
    , e."Id" as editing_id
    , e."EditingFileId" as editing_code
    , r."ResourceFileId" as hg_stock_id
    , row_number() over (partition by re."EditingId" order by re."StartTime") as position
    , cast(re."EndTime" as numeric) - cast(re."StartTime" as numeric) as duration
from "hgmediadb"."staging"."resource_editings" re
join "hgmediadb"."staging"."editings" e on re."EditingId" = e."Id"
join "hgmediadb"."staging"."resource" r on re."ResourcesId" = r."Id"
where r."ResourceType" = 0 and r."ResourceFileId" like 'HGFA%'
  );
  
  