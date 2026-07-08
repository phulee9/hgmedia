with channel_user_map as (

    select distinct on (cu."ChannelId")
        cu."ChannelId" as channel_id,
        u."FullName"   as employee_name
    from "hgmediadb"."staging"."channel_user" cu
    left join "hgmediadb"."staging"."user" u on cu."UserId" = u."Id"
    where cu."IsDeleted" = false
    order by cu."ChannelId", cu."CreatedTimeUtc" desc

),

channel_network_map as (

    select
        cd."ChannelId"  as channel_id,
        n."Id"          as network_id
    from "hgmediadb"."staging"."channel_deal" cd
    left join "hgmediadb"."staging"."cms" cms on cd."CmsId" = cms."Id"
    left join "hgmediadb"."staging"."network" n on cms."NetworkId" = n."Id"
    where cd."IsDeleted" = false
      and cd."IsOutNet" = false

)

select distinct on (c."YoutubeChannelId")
    md5(cast(coalesce(cast(c."YoutubeChannelId" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_channel_sk
    , nullif(trim(cast(c."YoutubeChannelId" as text)),'') as channel_id
    , nullif(trim(cast(c."Title" as text)),'') as channel_name
    , nullif(trim(cast(p."CompanyId" as text)),'') as company_id
    , nullif(trim(cast(cum.employee_name as text)),'') as employee_name
    , nullif(trim(cast(cp."ProjectId" as text)),'') as project_id
    , nullif(trim(cast(p."ParentId" as text)),'') as sub_project_id
    , nullif(trim(cast(c."Description" as text)),'') as link
    , nullif(trim(cast(cnm.network_id as text)),'') as network_id
from "hgmediadb"."staging"."channel" c
left join "hgmediadb"."staging"."channel_project" cp on c."Id" = cp."ChannelId"
left join "hgmediadb"."staging"."project" p on cp."ProjectId" = p."Id"
left join channel_user_map cum on c."Id" = cum.channel_id
left join channel_network_map cnm on c."Id" = cnm.channel_id
order by c."YoutubeChannelId"