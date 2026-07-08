select
    {{ dbt_utils.generate_surrogate_key(['id']) }} as dim_project_sk
    , nullif(trim(cast(id as text)),'') as project_id
    , nullif(trim(cast(name as text)),'') as project_name
    , nullif(trim(cast(state as text)),'') as status
from {{ source('staging', 'x_project') }}