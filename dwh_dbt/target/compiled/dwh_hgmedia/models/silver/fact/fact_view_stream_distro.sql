with sd as (
    select isrc, "dailyStream", "reportingDate", "idArtist"
    from "hgmediadb"."staging"."stream_distro"
    where nullif(trim(isrc),'') is not null
),
plat as (
    select distinct "iSRC" as isrc, retailer
    from "hgmediadb"."staging"."sale"
    where nullif(trim("iSRC"),'') is not null
)
select
    md5(cast(coalesce(cast(sd.isrc as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(sd."reportingDate" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(sd."idArtist" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as fact_view_stream_distro_sk
    , replace(cast("dailyStream" as text),',','')::numeric as stream_count
    , cast(nullif(trim(sd."reportingDate"),'') as date) as recorded_date
    , nullif(trim(p.retailer),'') as platform
    , nullif(trim(sd.isrc),'') as isrc
    , nullif(trim(sd."idArtist"),'') as artist
from sd
left join plat p on trim(sd.isrc) = trim(p.isrc)