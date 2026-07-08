-- silver.dim_project_stock  (target theo Data Dictionary)
select
    -- dim_project_stock.sql
md5(cast(coalesce(cast("Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_project_stock_sk
, nullif(trim(cast("Id" as text)),'') as project_id
, nullif(trim(cast("ProjectName" as text)),'') as project_name
from "hgmediadb"."staging"."project"
where "ParentId" is null   -- theo dictionary: Project chính = ParentId IS NULL