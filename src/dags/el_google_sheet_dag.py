"""
dags/el_google_sheet_dag.py
DAG riêng cho nhóm nguồn Google Sheet (ít, nhẹ -> lịch chạy thưa, ví dụ hàng ngày 6h sáng).
Dùng Dynamic Task Mapping để tự tạo task cho từng source_id trong config.
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
    dag_id="el_google_sheet_pipeline",
    schedule="0 6 * * *",          # 6h sáng mỗi ngày
    start_date=datetime(2026, 1, 1),
    catchup=False,
    default_args=default_args,
    tags=["el", "google_sheet"],
)
def el_google_sheet_pipeline():

    @task
    def get_sources():
        return load_sources("config/google_sheet_sources.yaml", "google_sheet_sources")

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


el_google_sheet_pipeline()
