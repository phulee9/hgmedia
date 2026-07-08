
      insert into "hgmediadb"."silver"."fact_view_stream_distro" ("fact_view_stream_distro_sk", "stream_count", "recorded_date", "platform", "isrc", "artist")
    (
        select "fact_view_stream_distro_sk", "stream_count", "recorded_date", "platform", "isrc", "artist"
        from "fact_view_stream_distro__dbt_tmp202227484273"
    )


  