-- silver.dim_department  (target theo Data Dictionary — nguồn odoo.hr_department)
-- select
--     md5(cast(coalesce(cast(hd.id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_department_sk
--     , nullif(trim(cast(hd.hg_code as text)),'') as department_id
--     , nullif(trim(cast(rc.id as text)),'') as company_id
--     , nullif(trim(coalesce(
--         cast(hd.name as jsonb) ->> 'vi_VN',
--         cast(hd.name as jsonb) ->> 'en_US'
--       )),'') as department_name
-- from "hgmediadb"."staging"."hr_department" hd
-- left join "hgmediadb"."staging"."res_company" rc on hd.company_id = rc.id

select
    md5(cast(coalesce(cast(hd.id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_department_sk
    , nullif(trim(cast(hd.id as text)),'')         as department_id
    , nullif(trim(cast(hd.company_id as text)),'') as company_id
, nullif(trim(coalesce(
        cast(hd.name as jsonb) ->> 'vi_VN',
        cast(hd.name as jsonb) ->> 'en_US'
      )),'') as department_name
from "hgmediadb"."staging"."hr_department" hd