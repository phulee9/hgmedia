
  
    

  create  table "hgmediadb"."silver"."dim_repository__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_repository  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_repository_sk
    , nullif(trim(cast(id as text)),'') as repository_id
    , nullif(trim(cast(product_genre_id as text)),'') as sub_project_id
    , nullif(trim(cast(name as text)),'') as repository_name
from "hgmediadb"."staging"."x_product_subgenre"
where nullif(trim(cast(product_genre_id as text)),'') is not null
  );
  