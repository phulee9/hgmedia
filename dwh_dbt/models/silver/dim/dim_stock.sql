with base as (
    select
        nullif(trim(cast("ResourceFileId" as text)),'') as hg_stock_id
        , "Title" as name
        , nullif(trim("ISRC"),'') as isrc
        , "CreatedDate" as created
    from {{ source('staging','resource_file_info') }}
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

dedup_by_isrc as (
    select distinct on (isrc)
        hg_stock_id, name, isrc, created
    from dedup_by_stock
    order by
        isrc,
        case when name not ilike '%.wav' then 0 else 1 end,
        created asc
),

vid as (
    select
        f.hg_stock_id,
        max(cast(v.published_date as date)) as last_published
    from {{ ref('fact_editing') }} f
    join {{ ref('bridge_bt_vid') }} b on f.editing_code = b.editing_code
    join {{ ref('dim_video') }} v on b.video_id = v.video_id
    group by f.hg_stock_id
),

edited as (
    select distinct hg_stock_id
    from {{ ref('fact_editing') }}
),

archived as (
    select distinct "ResourceFileInfoId" as hg_stock_id
    from {{ source('staging','resource_storage_history') }}
    where "ToStatus" = 'Archived'
)

select
    {{ dbt_utils.generate_surrogate_key(['s.hg_stock_id']) }} as dim_stock_sk
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
from dedup_by_isrc s
left join edited e on s.hg_stock_id = e.hg_stock_id
left join vid v on s.hg_stock_id = v.hg_stock_id
left join archived a on s.hg_stock_id = a.hg_stock_id