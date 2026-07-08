-- silver.fact_youtube_operation  (target theo Data Dictionary)

with base as (
    select
        nullif(trim(cast(hg_code as text)),'') as hg_stock_id
        , nullif(trim(cast(isrc as text)),'') as isrc
        , nullif(trim(cast(cid_state as text)),'') as cid
        , nullif(trim(cast(net_cid as text)),'') as net
        , nullif(trim(cast(hg_link as text)),'') as stock_url
        , cast(nullif(trim(cast(ytb_sent_date as text)),'') as timestamp) as submitted_date
    from "hgmediadb"."staging"."x_music_song"
    where nullif(trim(cast(isrc as text)),'') is not null
),

enriched as (
    select
        coalesce(b.hg_stock_id, nullif(trim(cast(r."ResourceFileId" as text)),'')) as hg_stock_id
        , b.isrc
        , b.cid
        , b.net
        , b.stock_url
        , b.submitted_date
    from base b
    left join "hgmediadb"."staging"."resource_file_info" r
        on b.isrc = nullif(trim(r."ISRC"),'')
    where coalesce(b.hg_stock_id, nullif(trim(cast(r."ResourceFileId" as text)),'')) is not null
)

select distinct on (hg_stock_id)
    md5(cast(coalesce(cast(hg_stock_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as fact_youtube_operation_sk
    , hg_stock_id
    , isrc
    , cid
    , net
    , stock_url
    , submitted_date
from enriched
order by hg_stock_id