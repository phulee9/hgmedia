
  
    

  create  table "hgmediadb"."silver"."dim_company__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_company  (target theo Data Dictionary — nguồn odoo.res_company)
select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_company_sk
    , nullif(trim(cast(id as text)),'')   as company_id
    , nullif(trim(cast(name as text)),'') as company_name
from "hgmediadb"."staging"."res_company"
  );
  