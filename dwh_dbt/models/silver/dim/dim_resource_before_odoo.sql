-- silver.dim_resource_before_odoo
select distinct on (trim("ISRC"))
    {{ dbt_utils.generate_surrogate_key(['"ISRC"']) }} as dim_resource_before_odoo_sk
    , nullif(trim("ISRC"), '') as isrc
    , nullif(trim("Mã bài"), '') as resource_name
    , cast(nullif(trim("Điểm trung bình"), '') as numeric(18,2)) as aceptance_score
    , cast(nullif(trim("Chi phí đv: $"), '') as numeric(18,2)) as aceptance_price
    , nullif(trim("A&R phụ trách"), '') as ar
    , nullif(trim("Nghệ sỹ"), '') as artist
from {{ source('staging', 'resource_before_odoo') }}
where nullif(trim("ISRC"), '') is not null
  and trim("ISRC") not in ('#N/A', '#REF!')
order by trim("ISRC")