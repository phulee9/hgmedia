
  
    

  create  table "hgmediadb"."silver"."fact_po_detail__dbt_tmp"
  
  
    as
  
  (
    -- silver.fact_po_detail  (target theo Data Dictionary)


select
    md5(cast(coalesce(cast(id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as fact_po_detail_sk
    , nullif(trim(cast(id as text)),'') as po_detail_id
    , nullif(trim(cast(order_id as text)),'') as po_id
    , nullif(trim(cast(product_qty as text)),'') as qty_order
    , nullif(trim(cast(x_subgenre_id as text)),'') as repository
from "hgmediadb"."staging"."purchase_order_line"
  );
  