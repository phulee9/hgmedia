-- silver.dim_isrc
with distro_isrc as (
    select distinct isrc
    from "hgmediadb"."silver"."fact_revenue_distro"
    where isrc is not null
),

base as (
    select
        md5(cast(coalesce(cast("ResourceFileId" as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast("ISRC" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_isrc_sk
        , nullif(trim(cast("ResourceFileId" as text)), '') as hg_stock_id
        , nullif(trim("ISRC"), '') as isrc
        , row_number() over (partition by "ResourceFileId" order by "ISRC") as rn_stock
        , row_number() over (partition by "ISRC" order by "ResourceFileId") as rn_isrc
    from "hgmediadb"."staging"."resource_file_info"
    where nullif(trim("ISRC"), '') is not null
)

select
    b.dim_isrc_sk
    , b.hg_stock_id
    , b.isrc
from base b
inner join distro_isrc d on b.isrc = d.isrc
where b.rn_stock = 1 and b.rn_isrc = 1