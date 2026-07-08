select
    md5(cast(coalesce(cast(r."Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as music_evaluation_id
    , nullif(trim(cast(r."CreatedByUserId" as text)),'') as reviewer_id
    , r."Rating"::numeric as score
    , nullif(trim(u."FullName"),'') as reviewer_name
from "hgmediadb"."staging"."review" r
left join "hgmediadb"."staging"."review_user" u
    on cast(r."CreatedByUserId" as text) = cast(u."Id" as text)