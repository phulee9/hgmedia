"""
dags/el_database_dag.py
DAG riêng cho nhóm nguồn Database — gồm cả Odoo (Postgres) và 3 SQL Server
(HG Stock, Channel Service, Editing Management). Cùng 1 DAG vì cùng category "sql",
các connection khác nhau chạy song song qua Dynamic Task Mapping (Airflow tự parallelize).
Lịch chạy dày hơn Google Sheet, ví dụ mỗi 4 tiếng.
"""
from datetime import datetime, timedelta

from airflow.decorators import dag, task

from src.config_loader import load_sources
from src.tasks.extract_task import run_extract
from src.tasks.load_task import run_load

default_args = {
    "owner": "data-team",
    "retries": 2,
    "retry_delay": timedelta(minutes=5),
}


@dag(
    dag_id="el_database_pipeline",
    schedule="0 */4 * * *",        # mỗi 4 tiếng
    start_date=datetime(2026, 1, 1),
    catchup=False,
    default_args=default_args,
    tags=["el", "database"],
    max_active_tasks=8,             # giới hạn song song để tránh quá tải nguồn
)
def el_database_pipeline():

    @task
    def get_sources():
        return load_sources("config/db_sources.yaml", "db_sources")

    @task
    def extract_and_load(source_config: dict):
        """Gộp extract+load trong 1 mapped task để tránh phải zip 2 list expand riêng."""
        extract_result = run_extract(source_config)
        if extract_result is None:
            return f"[{source_config['source_id']}] skip - không có thay đổi"
        run_load(source_config, extract_result["batch_id"], extract_result["minio_path"])
        return f"[{source_config['source_id']}] loaded"

    sources = get_sources()
    extract_and_load.expand(source_config=sources)


el_database_pipeline()
