with base as (
    select
        retailer,
        "iSRC" as isrc,
        nullif(trim(artist),'') as artist,
        to_char(cast("reportingPeriod" as date),'YYYY-MM') as revenue_month
        , cast("reportingPeriod" as date) as reporting_date
        , replace(earnings,',','')::numeric as earning
    from "hgmediadb"."staging"."sale"
    where nullif(trim("iSRC"),'') is not null
),

aggregated as (
    select
        retailer
        , isrc
        , artist
        , revenue_month
        , min(reporting_date) as first_date
        , sum(earning) as revenue_amount
    from base
    group by retailer, isrc, artist, revenue_month
),

usd as (
    select distinct on (record_date)
        record_date
        , exchange_rate
    from "hgmediadb"."silver"."dim_usd"
    order by record_date
)

select
    md5(cast(coalesce(cast(retailer as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(isrc as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(revenue_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as fact_revenue_distro_sk
    , revenue_amount
    , revenue_month
    , nullif(trim(retailer),'') as platform
    , isrc
    , artist
    , u.exchange_rate
from aggregated a
left join usd u on a.first_date = u.record_date