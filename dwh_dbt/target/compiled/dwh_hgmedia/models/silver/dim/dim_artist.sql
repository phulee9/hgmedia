-- silver.dim_artist  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_artist_sk
    , nullif(trim(cast(id as text)),'') as platform_id
    , nullif(trim(cast(name as text)),'') as platform_name
from "hgmediadb"."staging"."res_partner"