-- silver.dim_partners
select distinct on ("Tên đối tác")
    md5(cast(coalesce(cast("Tên đối tác" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as partner_id
    , nullif(trim("Tên đối tác"), '') as partner_name
from "hgmediadb"."staging"."partners"
where nullif(trim("Tên đối tác"), '') is not null
order by "Tên đối tác"