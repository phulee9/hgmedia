
  
    

  create  table "hgmediadb"."silver"."dim_distributed_employee__dbt_tmp"
  
  
    as
  
  (
    -- silver.dim_distributed_employee  (target theo Data Dictionary)
select
    md5(cast(coalesce(cast("Id" as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as dim_distributed_employee_sk
    , nullif(trim(cast("Id" as text)),'') as emp_id
    , nullif(trim(cast("DisplayName" as text)),'') as emp_name
    
    , null as department_id   -- TODO user_departments.DepartmentEnum | Department ID (INT) - join với users.Id = user_departments.UserId
    , null as team   -- TODO ? | 
    , null as role   -- TODO roles.Name | 1:1
from "hgmediadb"."staging"."users"

-- left join "hgmediadb"."staging"."user_departments" on ...  -- Department ID (INT) - join với users.Id = user_departments.UserId
-- left join "hgmediadb"."staging"."roles" on ...  -- 1:1
  );
  