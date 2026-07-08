
      insert into "hgmediadb"."silver"."fact_evaluation_assignment" ("music_evaluation_id", "reviewer_id", "score", "reviewer_name")
    (
        select "music_evaluation_id", "reviewer_id", "score", "reviewer_name"
        from "fact_evaluation_assignment__dbt_tmp013227520334"
    )


  