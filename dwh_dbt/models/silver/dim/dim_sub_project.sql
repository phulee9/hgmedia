select
    {{ dbt_utils.generate_surrogate_key(['id']) }} as dim_sub_project_sk
    , nullif(trim(cast(id as text)),'') as sub_project_id
    , nullif(trim(cast(project_id as text)),'') as project_id
    , nullif(trim(cast(name as text)),'') as sub_project_name
    , nullif(trim(cast(description as text)),'') as description
from {{ source('staging', 'x_product_genre') }}