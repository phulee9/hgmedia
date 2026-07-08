
      
  
    

  create  table "hgmediadb"."silver"."fact_music_evaluation"
  
  
    as
  
  (
    with ver as (
    select "Id", "RecordingSoundId", "CreatedDate",
        row_number() over (partition by "RecordingSoundId" order by "CreatedDate") as version_no
    from "hgmediadb"."staging"."recording_sound_version"
),
mkt as (
    select vnc."RecordingSoundVersionId" as version_id, avg(ucv."Rating"::numeric) as marketing_score
    from "hgmediadb"."staging"."user_comment_version" ucv
    join "hgmediadb"."staging"."version_needs_comment" vnc
        on cast(ucv."VersionNeedsCommentId" as text) = cast(vnc."Id" as text)
    group by vnc."RecordingSoundVersionId"
)
select
    md5(cast(coalesce(cast(r."Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as music_evaluation_id
    , rs."SongCode" as resource_id
    , v.version_no as version
    , case when cast(r."CreatedByUserId" as text) = '13c172f2-f476-414f-afcd-2f6635ed4ace' then r."Rating"::numeric end as internal_score
    , mkt.marketing_score
    , r."Concluding" as status
    , case
    when left(r."Comment", 1) = '{'
    then r."Comment"::json->>'Comment'
    else r."Comment"
  end as comment
    , cast(r."CreatedDate" as timestamp) as review_date
from "hgmediadb"."staging"."review" r
left join ver v on cast(r."RecordingSoundVersionId" as text) = cast(v."Id" as text)
left join "hgmediadb"."staging"."recording_sound" rs on cast(v."RecordingSoundId" as text) = cast(rs."Id" as text)
left join mkt on cast(r."RecordingSoundVersionId" as text) = cast(mkt.version_id as text)
  );
  
  