select
    cast(record_date as date) as record_date
    , exchange_rate::float as exchange_rate
from "hgmediadb"."staging"."usd_rate"
order by record_date