CREATE DATABASE nhs_operations;
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

SELECT *
FROM operational.trusts;

CREATE TABLE operational.daily_operational_metrics (
    operational_metric_id BIGINT GENERATED ALWAYS AS IDENTITY,
    trust_id BIGINT NOT NULL,
    reporting_date DATE NOT NULL,

    general_beds_open INTEGER,
    general_beds_occupied INTEGER,
    critical_care_beds_open INTEGER,
    critical_care_beds_occupied INTEGER,
    ae_attendances INTEGER,
    four_hour_breaches INTEGER,
    ambulance_arrivals INTEGER,
    ambulance_handover_delays INTEGER,
    patients_ready_for_discharge INTEGER,
    admissions INTEGER,
    discharges INTEGER,

    source_system VARCHAR(100) NOT NULL,
    data_quality_status VARCHAR(30) NOT NULL DEFAULT 'unreviewed',
    record_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_daily_operational_metrics
        PRIMARY KEY (operational_metric_id),

    CONSTRAINT fk_daily_operational_metrics_trust
        FOREIGN KEY (trust_id)
        REFERENCES operational.trusts(trust_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT uq_daily_operational_metrics_trust_date
        UNIQUE (trust_id, reporting_date),

    CONSTRAINT chk_daily_operational_metrics_non_negative
        CHECK (
            COALESCE(general_beds_open, 0) >= 0
            AND COALESCE(general_beds_occupied, 0) >= 0
            AND COALESCE(critical_care_beds_open, 0) >= 0
            AND COALESCE(critical_care_beds_occupied, 0) >= 0
            AND COALESCE(ae_attendances, 0) >= 0
            AND COALESCE(four_hour_breaches, 0) >= 0
            AND COALESCE(ambulance_arrivals, 0) >= 0
            AND COALESCE(ambulance_handover_delays, 0) >= 0
            AND COALESCE(patients_ready_for_discharge, 0) >= 0
            AND COALESCE(admissions, 0) >= 0
            AND COALESCE(discharges, 0) >= 0
        ),

    CONSTRAINT chk_daily_operational_beds
        CHECK (
            general_beds_occupied IS NULL
            OR general_beds_open IS NULL
            OR general_beds_occupied <= general_beds_open
        ),

    CONSTRAINT chk_daily_operational_breaches
        CHECK (
            four_hour_breaches IS NULL
            OR ae_attendances IS NULL
            OR four_hour_breaches <= ae_attendances
        ),

    CONSTRAINT chk_daily_operational_quality_status
        CHECK (
            data_quality_status IN (
                'unreviewed',
                'valid',
                'warning',
                'rejected'
            )
        )
);

SELECT *
FROM operational.daily_operational_metrics;
