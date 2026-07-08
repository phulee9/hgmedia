with base as (
    select
        nullif(trim(cast("ResourceFileId" as text)),'') as hg_stock_id
        , "Title" as name
        , nullif(trim("ISRC"),'') as isrc
        , "CreatedDate" as created
    from "hgmediadb"."staging"."resource_file_info"
    where
        nullif(trim(cast("ResourceFileId" as text)),'') is not null
),

dedup_by_stock as (
    select distinct on (hg_stock_id)
        hg_stock_id, name, isrc, created
    from base
    order by
        hg_stock_id,
        case when name not ilike '%.wav' then 0 else 1 end,
        created asc
),

vid as (
    select
        f.hg_stock_id,
        max(cast(v.published_date as date)) as last_published
    from "hgmediadb"."silver"."fact_editing" f
    join "hgmediadb"."silver"."bridge_bt_vid" b on f.editing_code = b.editing_code
    join "hgmediadb"."silver"."dim_video" v on b.video_id = v.video_id
    where v.published_date is not null
    group by f.hg_stock_id
),

edited as (
    select distinct hg_stock_id
    from "hgmediadb"."silver"."fact_editing"
),

archived as (
    select hg_stock_id
    from (
        select distinct on ("ResourceFileInfoId")
            "ResourceFileInfoId" as hg_stock_id,
            "ToStatus"
        from "hgmediadb"."staging"."resource_storage_history"
        order by "ResourceFileInfoId", "CreatedDate" desc
    ) latest
    where "ToStatus" = 'Archived'
)

select
    md5(cast(coalesce(cast(s.hg_stock_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_stock_sk
    , s.hg_stock_id
    , nullif(trim(cast(s.name as text)),'') as name
    , s.isrc
    , cast(s.created as timestamp) as stock_stored_date
    , (current_date - cast(s.created as date)) as resource_age_days
    , case
        when a.hg_stock_id is not null then 'Lưu kho'
        when e.hg_stock_id is null or v.hg_stock_id is null then 'Tồn kho'
        when v.last_published < current_date - 30 then 'Hàng nguội'
        else 'Sử dụng'
      end as status
from dedup_by_stock s
left join edited e on s.hg_stock_id = e.hg_stock_id
left join vid v on s.hg_stock_id = v.hg_stock_id
left join archived a on s.hg_stock_id = a.hg_stock_id