select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_project_sk
    , nullif(trim(cast(id as text)),'') as project_id
    , nullif(trim(cast(name as text)),'') as project_name
    , nullif(trim(cast(state as text)),'') as status
from "hgmediadb"."staging"."x_project"