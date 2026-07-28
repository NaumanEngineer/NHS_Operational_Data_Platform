CREATE SCHEMA IF NOT EXISTS operational;

CREATE TABLE operational.trusts (
    trust_id BIGINT GENERATED ALWAYS AS IDENTITY,
    trust_code VARCHAR(10) NOT NULL,
    trust_name VARCHAR(200) NOT NULL,
    trust_type VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL,
    active_flag BOOLEAN NOT NULL DEFAULT TRUE,
    source_system VARCHAR(100) NOT NULL,
    data_quality_status VARCHAR(30) NOT NULL DEFAULT 'unreviewed',
    record_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_trusts
        PRIMARY KEY (trust_id),

    CONSTRAINT uq_trusts_trust_code
        UNIQUE (trust_code),

    CONSTRAINT chk_trusts_trust_code_not_blank
        CHECK (BTRIM(trust_code) <> ''),

    CONSTRAINT chk_trusts_trust_name_not_blank
        CHECK (BTRIM(trust_name) <> ''),

    CONSTRAINT chk_trusts_data_quality_status
        CHECK (
            data_quality_status IN (
                'unreviewed',
                'valid',
                'warning',
                'rejected'
            )
        )
);


Design reasoning:
trust_id is the stable internal key.
trust_code is the NHS business identifier and must be unique.
trust_name should not become the primary key because names may change.
active_flag supports inactive organisations without deleting historical records.
source_system records the origin of the reference data.
record_created_at and record_updated_at support auditability.
data_quality_status supports investigation and validation workflow
