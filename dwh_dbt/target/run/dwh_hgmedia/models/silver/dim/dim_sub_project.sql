
  
    

  create  table "hgmediadb"."silver"."dim_sub_project__dbt_tmp"
  
  
    as
  
  (
    select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_sub_project_sk
    , nullif(trim(cast(id as text)),'') as sub_project_id
    , nullif(trim(cast(project_id as text)),'') as project_id
    , nullif(trim(cast(name as text)),'') as sub_project_name
    , nullif(trim(cast(description as text)),'') as description
from "hgmediadb"."staging"."x_product_genre"
  );
  