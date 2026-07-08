-- silver.dim_subproject_stock  (target theo Data Dictionary)
select
    -- dim_subproject_stock.sql
md5(cast(coalesce(cast("Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_subproject_stock_sk
, nullif(trim(cast("Id" as text)),'') as sub_project_id
, nullif(trim(cast("ProjectName" as text)),'') as sub_project_name
from "hgmediadb"."staging"."project"
where "ParentId" is not null   -- Sub-project = có ParentId