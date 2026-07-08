

with net_channels as (
    select distinct c."YoutubeChannelId"
    from "hgmediadb"."staging"."channel_deal" cd
    join "hgmediadb"."staging"."channel_company" cc on cd."ChannelId" = cc."ChannelId"
    join "hgmediadb"."staging"."channel" c on cd."ChannelId" = c."Id"
    where cc."Type" is null
        and cd."IsOutNet" = false
        and cd."IsDeleted" = false
        and cd."ReceiveTimeUtc" is not null
        and c."SuspendedTimeUtc" is null
),

vid_metric as (
    select
        m."YoutubeVideoId" as video_id
        , m."Date"::date as recorded_date
        , m."EstimatedRevenue"::numeric as revenue
        , m."Views"::numeric as views
    from "hgmediadb"."staging"."channel_video_metric" m
    join "hgmediadb"."staging"."channel_video_info" cv on m."YoutubeVideoId" = cv."YoutubeVideoId"
    join net_channels nc on cv."YoutubeChannelId" = nc."YoutubeChannelId"
    where m."YoutubeVideoId" is not null
        and m."Date" is not null
),

vid_res as (
    select
        b.video_id
        , f.hg_stock_id
        , f.position
        , count(*) over (partition by b.video_id, b.editing_code) as n_res
        , row_number() over (partition by b.video_id, b.editing_code order by f.position) as rn
    from "hgmediadb"."silver"."bridge_bt_vid" b
    join "hgmediadb"."silver"."fact_editing" f on b.editing_code = f.editing_code
),

weighted as (
    select vr.*,
        case
            when n_res >= 5 then case when rn <= 5 then (array[5,2,1,1,1])[rn] else 0 end
            when n_res = 4 then (array[6,2,1,1])[rn]
            when n_res = 3 then (array[6,3,1])[rn]
            when n_res = 2 then (array[7,3])[rn]
            else 10
        end as w
    from vid_res vr
    where rn <= 5
),

usd as (
    select distinct on (record_date)
        record_date
        , exchange_rate
    from "hgmediadb"."silver"."dim_usd"
    order by record_date
)

select
    md5(cast(coalesce(cast(w.video_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(w.hg_stock_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(m.recorded_date::text as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as revenue_id
    , w.video_id
    , w.hg_stock_id as resource_id
    , m.revenue * w.w / 10.0 as revenue_amount
    , m.recorded_date::timestamp as recorded_date
    , m.views * w.w / 10.0 as view
    , u.exchange_rate
from weighted w
join vid_metric m on w.video_id = m.video_id
left join usd u on m.recorded_date = u.record_date