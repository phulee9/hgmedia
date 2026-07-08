"""
dags/dbt_run_dag.py
Chạy sau khi cả 2 DAG EL (Google Sheet, Database) hoàn tất trong ngày.
Dùng ExternalTaskSensor để chờ, sau đó gọi dbt run + dbt test.

Khi sẵn sàng dùng astronomer-cosmos, có thể thay BashOperator bằng DbtTaskGroup
để mỗi model dbt hiện thành 1 task riêng trong Airflow UI (xem comment cuối file).
"""
from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.sensors.external_task import ExternalTaskSensor

default_args = {
    "owner": "data-team",
    "retries": 1,
    "retry_delay": timedelta(minutes=10),
}

DBT_PROJECT_DIR = "/opt/dwh-pipeline/dwh_dbt"
DBT_PROFILES_DIR = "/opt/dwh-pipeline/dwh_dbt"

with DAG(
    dag_id="dbt_transform_pipeline",
    schedule="30 6 * * *",     # sau el_google_sheet (6h) và el_database (chạy mỗi 4h, có lượt 6h)
    start_date=datetime(2026, 1, 1),
    catchup=False,
    default_args=default_args,
    tags=["transform", "dbt"],
) as dag:

    wait_google_sheet = ExternalTaskSensor(
        task_id="wait_el_google_sheet",
        external_dag_id="el_google_sheet_pipeline",
        timeout=3600,
        poke_interval=60,
        mode="reschedule",
    )

    wait_database = ExternalTaskSensor(
        task_id="wait_el_database",
        external_dag_id="el_database_pipeline",
        timeout=3600,
        poke_interval=60,
        mode="reschedule",
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt run --profiles-dir {DBT_PROFILES_DIR}",
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {DBT_PROJECT_DIR} && dbt test --profiles-dir {DBT_PROFILES_DIR}",
    )

    [wait_google_sheet, wait_database] >> dbt_run >> dbt_test

# --- Khi muốn từng dbt model hiện thành 1 task riêng trong Airflow UI, thay 2 BashOperator
# trên bằng astronomer-cosmos:
#
# from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig
# dbt_tasks = DbtTaskGroup(
#     group_id="dbt_models",
#     project_config=ProjectConfig(DBT_PROJECT_DIR),
#     profile_config=ProfileConfig(profiles_yml_filepath=f"{DBT_PROFILES_DIR}/profiles.yml"),
# )
# [wait_google_sheet, wait_database] >> dbt_tasks
