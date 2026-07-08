-- silver.fact_artist_assignment  (target theo Data Dictionary)


select
    md5(cast(coalesce(cast(x.id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as fact_artist_assignment_sk
    , nullif(trim(cast(x.detail_id as text)),'') as production_plan_detail_id
    , nullif(trim(cast(x.partner_id as text)),'') as artist_id
    , nullif(trim(rp.name),'') as artist_name
from "hgmediadb"."staging"."x_music_plan_detail_price" x
left join "hgmediadb"."staging"."res_partner" rp on x.partner_id = rp.id

-- left join "hgmediadb"."staging"."res_partner" on ...  -- JOIN qua partner_id