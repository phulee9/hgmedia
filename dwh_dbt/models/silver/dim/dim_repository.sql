-- silver.dim_repository  (target theo Data Dictionary)
select
    {{ dbt_utils.generate_surrogate_key(['id']) }} as dim_repository_sk
    , nullif(trim(cast(id as text)),'') as repository_id
    , nullif(trim(cast(product_genre_id as text)),'') as sub_project_id
    , nullif(trim(cast(name as text)),'') as repository_name
from {{ source('staging', 'x_product_subgenre') }}
where nullif(trim(cast(product_genre_id as text)),'') is not null