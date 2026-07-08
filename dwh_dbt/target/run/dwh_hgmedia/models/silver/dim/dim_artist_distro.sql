
  
    

  create  table "hgmediadb"."silver"."dim_artist_distro__dbt_tmp"
  
  
    as
  
  (
    select
    md5(cast(coalesce(cast("idArtist" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_artist_distro_sk
    , nullif(trim("idArtist"),'') as artist_id
    , nullif(trim("mainArtist"),'') as artist_name
from "hgmediadb"."staging"."stream_distro"
where nullif(trim("idArtist"),'') is not null
group by "idArtist", "mainArtist"
  );
  