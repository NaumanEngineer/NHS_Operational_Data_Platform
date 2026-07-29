-- NHS Operational Data Platform
-- Initial one-time PostgreSQL schema migration.
-- Run while connected to the nhs_operations database.
-- This script creates the operational schema and six core tables.
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


CREATE TABLE operational.workforce_metrics (
    workforce_metric_id BIGINT GENERATED ALWAYS AS IDENTITY,
    trust_id BIGINT NOT NULL,
    reporting_date DATE NOT NULL,
    staff_group VARCHAR(100) NOT NULL,

    establishment_fte NUMERIC(10,2),
    substantive_fte NUMERIC(10,2),
    absence_fte NUMERIC(10,2),
    agency_fte NUMERIC(10,2),
    bank_fte NUMERIC(10,2),
    unfilled_shifts INTEGER,

    source_system VARCHAR(100) NOT NULL,
    data_quality_status VARCHAR(30) NOT NULL DEFAULT 'unreviewed',
    record_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_workforce_metrics
        PRIMARY KEY (workforce_metric_id),

    CONSTRAINT fk_workforce_metrics_trust
        FOREIGN KEY (trust_id)
        REFERENCES operational.trusts(trust_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT uq_workforce_metrics_trust_date_group
        UNIQUE (trust_id, reporting_date, staff_group),

    CONSTRAINT chk_workforce_metrics_non_negative
        CHECK (
            COALESCE(establishment_fte, 0) >= 0
            AND COALESCE(substantive_fte, 0) >= 0
            AND COALESCE(absence_fte, 0) >= 0
            AND COALESCE(agency_fte, 0) >= 0
            AND COALESCE(bank_fte, 0) >= 0
            AND COALESCE(unfilled_shifts, 0) >= 0
        ),

    CONSTRAINT chk_workforce_metrics_staff_group_not_blank
        CHECK (BTRIM(staff_group) <> ''),

    CONSTRAINT chk_workforce_metrics_quality_status
        CHECK (
            data_quality_status IN (
                'unreviewed',
                'valid',
                'warning',
                'rejected'
            )
        )
);

CREATE TABLE operational.incidents (
    incident_id BIGINT GENERATED ALWAYS AS IDENTITY,
    trust_id BIGINT NOT NULL,

    incident_reference VARCHAR(100) NOT NULL,
    incident_type VARCHAR(100) NOT NULL,
    severity_level VARCHAR(30) NOT NULL,
    incident_status VARCHAR(30) NOT NULL DEFAULT 'open',

    incident_started_at TIMESTAMPTZ NOT NULL,
    incident_reported_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    incident_resolved_at TIMESTAMPTZ,

    service_area VARCHAR(150),
    operational_impact TEXT,

    source_system VARCHAR(100) NOT NULL,
    data_quality_status VARCHAR(30) NOT NULL DEFAULT 'unreviewed',
    record_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_incidents
        PRIMARY KEY (incident_id),

    CONSTRAINT fk_incidents_trust
        FOREIGN KEY (trust_id)
        REFERENCES operational.trusts(trust_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT uq_incidents_source_reference
        UNIQUE (source_system, incident_reference),

    CONSTRAINT chk_incidents_reference_not_blank
        CHECK (BTRIM(incident_reference) <> ''),

    CONSTRAINT chk_incidents_type_not_blank
        CHECK (BTRIM(incident_type) <> ''),

    CONSTRAINT chk_incidents_severity
        CHECK (
            severity_level IN (
                'low',
                'moderate',
                'high',
                'critical'
            )
        ),

    CONSTRAINT chk_incidents_status
        CHECK (
            incident_status IN (
                'open',
                'monitoring',
                'resolved',
                'closed'
            )
        ),

    CONSTRAINT chk_incidents_resolution_time
        CHECK (
            incident_resolved_at IS NULL
            OR incident_resolved_at >= incident_started_at
        ),

    CONSTRAINT chk_incidents_quality_status
        CHECK (
            data_quality_status IN (
                'unreviewed',
                'valid',
                'warning',
                'rejected'
            )
        )
);



CREATE TABLE operational.weather_metrics (
    weather_metric_id BIGINT GENERATED ALWAYS AS IDENTITY,
    trust_id BIGINT NOT NULL,
    reporting_date DATE NOT NULL,

    observation_type VARCHAR(30) NOT NULL,
    forecast_generated_at TIMESTAMPTZ,

    temperature_min_c NUMERIC(5,2),
    temperature_max_c NUMERIC(5,2),
    precipitation_mm NUMERIC(8,2),
    snowfall_mm NUMERIC(8,2),
    wind_speed_mph NUMERIC(6,2),

    weather_warning_level VARCHAR(30),
    weather_warning_type VARCHAR(100),

    source_system VARCHAR(100) NOT NULL,
    data_quality_status VARCHAR(30) NOT NULL DEFAULT 'unreviewed',
    record_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_weather_metrics
        PRIMARY KEY (weather_metric_id),

    CONSTRAINT fk_weather_metrics_trust
        FOREIGN KEY (trust_id)
        REFERENCES operational.trusts(trust_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT uq_weather_metrics_trust_date_type
        UNIQUE (
            trust_id,
            reporting_date,
            observation_type,
            forecast_generated_at
        ),

    CONSTRAINT chk_weather_metrics_observation_type
        CHECK (
            observation_type IN (
                'observed',
                'forecast',
                'warning'
            )
        ),

    CONSTRAINT chk_weather_metrics_temperature_range
        CHECK (
            temperature_min_c IS NULL
            OR temperature_max_c IS NULL
            OR temperature_min_c <= temperature_max_c
        ),

    CONSTRAINT chk_weather_metrics_non_negative
        CHECK (
            COALESCE(precipitation_mm, 0) >= 0
            AND COALESCE(snowfall_mm, 0) >= 0
            AND COALESCE(wind_speed_mph, 0) >= 0
        ),

    CONSTRAINT chk_weather_metrics_warning_level
        CHECK (
            weather_warning_level IS NULL
            OR weather_warning_level IN (
                'yellow',
                'amber',
                'red'
            )
        ),

    CONSTRAINT chk_weather_metrics_quality_status
        CHECK (
            data_quality_status IN (
                'unreviewed',
                'valid',
                'warning',
                'rejected'
            )
        )
);



CREATE TABLE operational.opel_assessments (
    opel_assessment_id BIGINT GENERATED ALWAYS AS IDENTITY,
    trust_id BIGINT NOT NULL,

    assessment_timestamp TIMESTAMPTZ NOT NULL,
    recommended_opel_level SMALLINT,
    approved_opel_level SMALLINT,
    previous_approved_opel_level SMALLINT,

    assessment_method VARCHAR(30) NOT NULL,
    assessment_rationale TEXT,
    key_pressure_factors TEXT,

    approval_status VARCHAR(30) NOT NULL DEFAULT 'pending',
    assessed_by VARCHAR(150),
    approved_by VARCHAR(150),
    approved_at TIMESTAMPTZ,

    rule_version VARCHAR(50),

    source_system VARCHAR(100) NOT NULL,
    data_quality_status VARCHAR(30) NOT NULL DEFAULT 'unreviewed',
    record_created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    record_updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_opel_assessments
        PRIMARY KEY (opel_assessment_id),

    CONSTRAINT fk_opel_assessments_trust
        FOREIGN KEY (trust_id)
        REFERENCES operational.trusts(trust_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_opel_recommended_level
        CHECK (
            recommended_opel_level IS NULL
            OR recommended_opel_level BETWEEN 1 AND 4
        ),

    CONSTRAINT chk_opel_approved_level
        CHECK (
            approved_opel_level IS NULL
            OR approved_opel_level BETWEEN 1 AND 4
        ),

    CONSTRAINT chk_opel_previous_level
        CHECK (
            previous_approved_opel_level IS NULL
            OR previous_approved_opel_level BETWEEN 1 AND 4
        ),

    CONSTRAINT chk_opel_assessment_method
        CHECK (
            assessment_method IN (
                'manual',
                'rules_based',
                'analyst_supported'
            )
        ),

    CONSTRAINT chk_opel_approval_status
        CHECK (
            approval_status IN (
                'pending',
                'approved',
                'rejected',
                'superseded'
            )
        ),

    CONSTRAINT chk_opel_approval_timestamp
        CHECK (
            approved_at IS NULL
            OR approved_at >= assessment_timestamp
        ),

    CONSTRAINT chk_opel_quality_status
        CHECK (
            data_quality_status IN (
                'unreviewed',
                'valid',
                'warning',
                'rejected'
            )
        )
);




















