select distinct on (s.isrc)
    {{ dbt_utils.generate_surrogate_key(['s.id']) }} as fact_label_operation_sk
    , nullif(trim(cast(s.id as text)),'') as resource_id
    , nullif(trim(cast(s.release_state as text)),'') as release_status
    , cast(nullif(trim(cast(s.release_date as text)),'') as timestamp) as release_date
    , nullif(trim(cast(ac.acceptance_link as text)),'') as acceptance_url
    , nullif(trim(cast(s.isrc as text)),'') as isrc
    , nullif(trim(cast(s.distro as text)),'') as distributor
from {{ source('staging', 'x_music_song') }} s
left join {{ source('staging','x_acceptance_cert') }} ac
    on cast(s.purchase_order_id as bigint) = cast(ac.purchase_order_id as bigint)
where nullif(trim(cast(s.isrc as text)),'') is not null
    and s.active = true
order by s.isrc, s.id asc