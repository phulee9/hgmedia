-- silver.bridge_bt_vid
select
    {{ dbt_utils.generate_surrogate_key(['"YoutubeVideoId"', 'editing_code']) }} as bridge_bt_vid_sk
    , editing_code
    , nullif(trim("YoutubeVideoId"),'') as video_id
from (
    select
        "YoutubeVideoId",
        (regexp_match("Description", '(HG[A-Z0-9]{30,34})'))[1] as editing_code
    from {{ source('staging','channel_video_info') }}
    where "Description" ~ 'HG[A-Z0-9]{30,34}'
) sub
where nullif(trim(editing_code),'') is not null