CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
CREATE SCHEMA IF NOT EXISTS meta;

-- Sổ cái theo dõi mọi lần extract (thay cho _file_registry cũ, dùng chung cho mọi loại nguồn)
CREATE TABLE IF NOT EXISTS meta._source_registry (
    id              BIGSERIAL PRIMARY KEY,
    source_id       VARCHAR(150) NOT NULL,      -- vd: dim_partners, fact_distribution
    source_type     VARCHAR(50)  NOT NULL,      -- excel | google_sheet | sql | elasticsearch
    connection_name VARCHAR(100),                -- vd: odoo_pg, hg_stock, channel_service
    batch_id        VARCHAR(150) NOT NULL UNIQUE,
    minio_path      TEXT NOT NULL,
    checksum        VARCHAR(64),                 -- md5 (excel/gsheet) hoặc null (sql dùng watermark)
    watermark_value VARCHAR(100),                -- giá trị watermark lớn nhất của batch này (nếu có)
    row_count       INTEGER,
    status          VARCHAR(20) NOT NULL DEFAULT 'pending',  -- pending|extracted|loaded|failed|rolled_back
    extracted_at    TIMESTAMP DEFAULT now(),
    loaded_at       TIMESTAMP,
    error_message   TEXT
);

CREATE INDEX IF NOT EXISTS idx_source_registry_source_id ON meta._source_registry (source_id, extracted_at DESC);
