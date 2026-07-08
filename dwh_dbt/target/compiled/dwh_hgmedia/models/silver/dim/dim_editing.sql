select
    md5(cast(coalesce(cast("EditingFileId" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_editing_sk
    , nullif(trim("EditingFileId"),'') as editing_code
    , nullif(trim("Title"),'') as editing_name
    , nullif(cast("EditingSoftware" as text),'') as software
    , cast(nullif(trim(cast("CreatedDate" as text)),'') as timestamp) as date
from "hgmediadb"."staging"."editings"
where nullif(trim("EditingFileId"),'') is not null
group by "EditingFileId", "Title", "EditingSoftware", "CreatedDate"