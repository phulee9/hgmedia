-- silver.dim_video  (target theo Data Dictionary)
select
    {{ dbt_utils.generate_surrogate_key(['"YoutubeVideoId"']) }} as dim_video_sk
    , nullif(trim("YoutubeVideoId"),'') as video_id
    , nullif(trim("YoutubeChannelId"),'') as channel_id
    , 'https://www.youtube.com/watch?v=' || "YoutubeVideoId" as video_url
    , cast(nullif(trim("PublishedAt"),'') as timestamp) as published_date
    , nullif(trim("Title"),'') as video_name
from {{ source('staging','channel_video_info') }}
where nullif(trim("YoutubeVideoId"),'') is not null
