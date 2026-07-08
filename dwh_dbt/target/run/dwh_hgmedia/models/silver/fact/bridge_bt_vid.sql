
      
  
    

  create  table "hgmediadb"."silver"."bridge_bt_vid__dbt_tmp"
  
  
    as
  
  (
    -- silver.bridge_bt_vid
select
    md5(cast(coalesce(cast("YoutubeVideoId" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(editing_code as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as bridge_bt_vid_sk
    , editing_code
    , nullif(trim("YoutubeVideoId"),'') as video_id
from (
    select
        "YoutubeVideoId",
        (regexp_match("Description", '(HG[A-Z0-9]{30,34})'))[1] as editing_code
    from "hgmediadb"."staging"."channel_video_info"
    where "Description" ~ 'HG[A-Z0-9]{30,34}'
) sub
where nullif(trim(editing_code),'') is not null
  );
  
  