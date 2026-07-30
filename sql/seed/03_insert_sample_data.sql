-- NHS Operational Data Platform
-- Synthetic sample data seed script
--
-- All organisations and operational values in this file are fictional.
-- The data is intended only for learning, testing and portfolio demonstration.
-- It must not be interpreted as real NHS performance evidence.
--
-- Reporting period: 2026-01-01 to 2026-01-30
-- Expected operational grain: one row per Trust per reporting date
-- Expected load batch: 11111111-1111-4111-8111-111111111111
--
-- Run while connected to nhs_operations_test.

BEGIN;

INSERT INTO operational.trusts (
    trust_code,
    trust_name,
    trust_type,
    region,
    active_flag,
    source_system,
    source_record_id,
    load_batch_id,
    data_quality_status
)
VALUES
(
    'WGH001',
    'Westborough General Hospital',
    'Acute Trust',
    'Midlands',
    TRUE,
    'synthetic_seed_v1',
    'TRUST-WGH001',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    'NRT002',
    'North Riverside NHS Trust',
    'Acute Trust',
    'North',
    TRUE,
    'synthetic_seed_v1',
    'TRUST-NRT002',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    'SCT003',
    'South County Community Trust',
    'Community Trust',
    'South',
    TRUE,
    'synthetic_seed_v1',
    'TRUST-SCT003',
    '11111111-1111-4111-8111-111111111111',
    'valid'
);

-- ============================================================
-- 2. DAILY OPERATIONAL METRICS
-- Expected rows: 90
-- Grain: one row per Trust per reporting date
-- ============================================================

WITH reporting_dates AS (
    SELECT generate_series(
        DATE '2026-01-01',
        DATE '2026-01-30',
        INTERVAL '1 day'
    )::DATE AS reporting_date
),
trust_profiles AS (
    SELECT
        trust_id,
        trust_code,
        CASE trust_code
            WHEN 'WGH001' THEN 520
            WHEN 'NRT002' THEN 430
            WHEN 'SCT003' THEN 220
        END AS base_general_beds,
        CASE trust_code
            WHEN 'WGH001' THEN 34
            WHEN 'NRT002' THEN 28
            WHEN 'SCT003' THEN 12
        END AS base_critical_care_beds,
        CASE trust_code
            WHEN 'WGH001' THEN 330
            WHEN 'NRT002' THEN 270
            WHEN 'SCT003' THEN 95
        END AS base_ae_attendances
    FROM operational.trusts
    WHERE trust_code IN ('WGH001', 'NRT002', 'SCT003')
),
generated_records AS (
    SELECT
        tp.trust_id,
        tp.trust_code,
        rd.reporting_date,
        EXTRACT(DAY FROM rd.reporting_date)::INTEGER AS day_number,
        tp.base_general_beds,
        tp.base_critical_care_beds,
        tp.base_ae_attendances
    FROM trust_profiles AS tp
    CROSS JOIN reporting_dates AS rd
)
INSERT INTO operational.daily_operational_metrics (
    trust_id,
    reporting_date,
    general_beds_open,
    general_beds_occupied,
    critical_care_beds_open,
    critical_care_beds_occupied,
    ae_attendances,
    four_hour_breaches,
    ambulance_arrivals,
    ambulance_handover_delays,
    patients_ready_for_discharge,
    admissions,
    discharges,
    source_system,
    source_record_id,
    load_batch_id,
    data_quality_status
)
SELECT
    trust_id,
    reporting_date,

    base_general_beds,

    LEAST(
        base_general_beds,
        ROUND(
            base_general_beds *
            CASE
                WHEN day_number BETWEEN 1 AND 7 THEN 0.84
                WHEN day_number BETWEEN 8 AND 14 THEN 0.89
                WHEN day_number BETWEEN 15 AND 22 THEN 0.93
                ELSE 0.96
            END
            +
            CASE trust_code
                WHEN 'WGH001' THEN MOD(day_number * 7, 14)
                WHEN 'NRT002' THEN MOD(day_number * 5, 12)
                ELSE MOD(day_number * 3, 8)
            END
        )::INTEGER
    ),

    base_critical_care_beds,

    LEAST(
        base_critical_care_beds,
        ROUND(
            base_critical_care_beds *
            CASE
                WHEN day_number BETWEEN 1 AND 10 THEN 0.72
                WHEN day_number BETWEEN 11 AND 20 THEN 0.84
                ELSE 0.92
            END
        )::INTEGER
    ),

    base_ae_attendances
    + CASE
        WHEN day_number BETWEEN 8 AND 14 THEN 35
        WHEN day_number BETWEEN 15 AND 22 THEN 55
        WHEN day_number BETWEEN 23 AND 30 THEN 75
        ELSE 0
      END
    + MOD(day_number * 11, 25),

    ROUND(
        (
            base_ae_attendances
            + CASE
                WHEN day_number BETWEEN 8 AND 14 THEN 35
                WHEN day_number BETWEEN 15 AND 22 THEN 55
                WHEN day_number BETWEEN 23 AND 30 THEN 75
                ELSE 0
              END
            + MOD(day_number * 11, 25)
        )
        *
        CASE
            WHEN day_number BETWEEN 1 AND 7 THEN 0.08
            WHEN day_number BETWEEN 8 AND 14 THEN 0.13
            WHEN day_number BETWEEN 15 AND 22 THEN 0.22
            ELSE 0.31
        END
    )::INTEGER,

    CASE trust_code
        WHEN 'WGH001' THEN 115
        WHEN 'NRT002' THEN 90
        ELSE 35
    END
    + MOD(day_number * 4, 18),

    CASE
        WHEN day_number BETWEEN 1 AND 7 THEN 8
        WHEN day_number BETWEEN 8 AND 14 THEN 17
        WHEN day_number BETWEEN 15 AND 22 THEN 29
        ELSE 44
    END
    + MOD(day_number * 3, 7),

    CASE trust_code
        WHEN 'WGH001' THEN 38
        WHEN 'NRT002' THEN 31
        ELSE 18
    END
    + CASE
        WHEN day_number >= 15 THEN 12
        ELSE 0
      END
    + MOD(day_number, 6),

    CASE trust_code
        WHEN 'WGH001' THEN 245
        WHEN 'NRT002' THEN 205
        ELSE 72
    END
    + MOD(day_number * 5, 18),

    CASE trust_code
        WHEN 'WGH001' THEN 238
        WHEN 'NRT002' THEN 198
        ELSE 69
    END
    + CASE
        WHEN day_number BETWEEN 1 AND 14 THEN MOD(day_number * 4, 15)
        ELSE MOD(day_number * 2, 9)
      END,

    'synthetic_seed_v1',

    'OPS-' || trust_code || '-' ||
    TO_CHAR(reporting_date, 'YYYYMMDD'),

    '11111111-1111-4111-8111-111111111111',

    'valid'
FROM generated_records;

-- ============================================================
-- 3. WORKFORCE METRICS
-- Expected rows: 90
-- Grain: one row per Trust, reporting date, and staff group
-- ============================================================

WITH reporting_dates AS (
    SELECT generate_series(
        DATE '2026-01-01',
        DATE '2026-01-30',
        INTERVAL '1 day'
    )::DATE AS reporting_date
),
trust_profiles AS (
    SELECT
        trust_id,
        trust_code,
        CASE trust_code
            WHEN 'WGH001' THEN 1180.00
            WHEN 'NRT002' THEN 940.00
            WHEN 'SCT003' THEN 430.00
        END::NUMERIC(10,2) AS establishment_fte
    FROM operational.trusts
    WHERE trust_code IN ('WGH001', 'NRT002', 'SCT003')
),
generated_records AS (
    SELECT
        tp.trust_id,
        tp.trust_code,
        tp.establishment_fte,
        rd.reporting_date,
        EXTRACT(DAY FROM rd.reporting_date)::INTEGER AS day_number
    FROM trust_profiles AS tp
    CROSS JOIN reporting_dates AS rd
)
INSERT INTO operational.workforce_metrics (
    trust_id,
    reporting_date,
    staff_group,
    establishment_fte,
    substantive_fte,
    absence_fte,
    agency_fte,
    bank_fte,
    unfilled_shifts,
    source_system,
    source_record_id,
    load_batch_id,
    data_quality_status
)
SELECT
    trust_id,
    reporting_date,
    'All operational staff',

    establishment_fte,

    ROUND(
        establishment_fte *
        CASE trust_code
            WHEN 'WGH001' THEN 0.91
            WHEN 'NRT002' THEN 0.90
            ELSE 0.93
        END,
        2
    ),

    ROUND(
        establishment_fte *
        CASE
            WHEN day_number BETWEEN 1 AND 7 THEN 0.035
            WHEN day_number BETWEEN 8 AND 14 THEN 0.050
            WHEN day_number BETWEEN 15 AND 22 THEN 0.070
            ELSE 0.085
        END
        +
        MOD(day_number * 3, 5),
        2
    ),

    ROUND(
        establishment_fte *
        CASE
            WHEN day_number BETWEEN 1 AND 7 THEN 0.020
            WHEN day_number BETWEEN 8 AND 14 THEN 0.030
            WHEN day_number BETWEEN 15 AND 22 THEN 0.050
            ELSE 0.070
        END,
        2
    ),

    ROUND(
        establishment_fte *
        CASE
            WHEN day_number BETWEEN 1 AND 14 THEN 0.015
            ELSE 0.025
        END,
        2
    ),

    CASE trust_code
        WHEN 'WGH001' THEN
            CASE
                WHEN day_number BETWEEN 1 AND 7 THEN 5
                WHEN day_number BETWEEN 8 AND 14 THEN 11
                WHEN day_number BETWEEN 15 AND 22 THEN 19
                ELSE 28
            END
        WHEN 'NRT002' THEN
            CASE
                WHEN day_number BETWEEN 1 AND 7 THEN 4
                WHEN day_number BETWEEN 8 AND 14 THEN 9
                WHEN day_number BETWEEN 15 AND 22 THEN 16
                ELSE 23
            END
        ELSE
            CASE
                WHEN day_number BETWEEN 1 AND 7 THEN 2
                WHEN day_number BETWEEN 8 AND 14 THEN 5
                WHEN day_number BETWEEN 15 AND 22 THEN 8
                ELSE 12
            END
    END
    + MOD(day_number, 4),

    'synthetic_seed_v1',

    'WFR-' || trust_code || '-' ||
    TO_CHAR(reporting_date, 'YYYYMMDD'),

    '11111111-1111-4111-8111-111111111111',

    'valid'
FROM generated_records;

-- ============================================================
-- 4. SYNTHETIC INCIDENTS
-- Expected rows: 24
-- Grain: one row per fictional operational incident
-- ============================================================

INSERT INTO operational.incidents (
    trust_id,
    incident_reference,
    incident_type,
    severity_level,
    incident_status,
    incident_started_at,
    incident_reported_at,
    incident_resolved_at,
    service_area,
    operational_impact,
    source_system,
    source_record_id,
    load_batch_id,
    data_quality_status
)
VALUES

-- Westborough General Hospital: 10 incidents

(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-001',
    'staffing disruption',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-03 06:30:00+00',
    TIMESTAMPTZ '2026-01-03 07:00:00+00',
    TIMESTAMPTZ '2026-01-03 15:00:00+00',
    'Emergency Department',
    'Reduced staffing capacity during the morning shift.',
    'synthetic_seed_v1',
    'INC-WGH-001',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-002',
    'temporary bed closure',
    'high',
    'resolved',
    TIMESTAMPTZ '2026-01-06 09:00:00+00',
    TIMESTAMPTZ '2026-01-06 09:20:00+00',
    TIMESTAMPTZ '2026-01-07 14:00:00+00',
    'Acute Medicine',
    'Temporary reduction in available general-bed capacity.',
    'synthetic_seed_v1',
    'INC-WGH-002',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-003',
    'IT outage',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-09 11:15:00+00',
    TIMESTAMPTZ '2026-01-09 11:20:00+00',
    TIMESTAMPTZ '2026-01-09 13:00:00+00',
    'Patient Administration',
    'Temporary disruption to operational reporting systems.',
    'synthetic_seed_v1',
    'INC-WGH-003',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-004',
    'heating failure',
    'high',
    'resolved',
    TIMESTAMPTZ '2026-01-11 04:30:00+00',
    TIMESTAMPTZ '2026-01-11 04:45:00+00',
    TIMESTAMPTZ '2026-01-11 18:00:00+00',
    'Inpatient Services',
    'Heating disruption affected part of the inpatient estate.',
    'synthetic_seed_v1',
    'INC-WGH-004',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-005',
    'infection-control pressure',
    'high',
    'monitoring',
    TIMESTAMPTZ '2026-01-14 08:00:00+00',
    TIMESTAMPTZ '2026-01-14 08:15:00+00',
    NULL,
    'General Medicine',
    'Cohorting requirements reduced operational flexibility.',
    'synthetic_seed_v1',
    'INC-WGH-005',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-006',
    'ambulance access pressure',
    'high',
    'resolved',
    TIMESTAMPTZ '2026-01-17 15:00:00+00',
    TIMESTAMPTZ '2026-01-17 15:10:00+00',
    TIMESTAMPTZ '2026-01-17 23:30:00+00',
    'Emergency Department',
    'Ambulance arrivals exceeded planned receiving capacity.',
    'synthetic_seed_v1',
    'INC-WGH-006',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-007',
    'medical-equipment fault',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-20 10:00:00+00',
    TIMESTAMPTZ '2026-01-20 10:10:00+00',
    TIMESTAMPTZ '2026-01-20 16:30:00+00',
    'Critical Care',
    'One item of equipment was temporarily unavailable.',
    'synthetic_seed_v1',
    'INC-WGH-007',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-008',
    'transport disruption',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-23 06:00:00+00',
    TIMESTAMPTZ '2026-01-23 06:20:00+00',
    TIMESTAMPTZ '2026-01-23 12:00:00+00',
    'Workforce Operations',
    'Staff travel disruption affected shift start times.',
    'synthetic_seed_v1',
    'INC-WGH-008',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-009',
    'temporary bed closure',
    'critical',
    'monitoring',
    TIMESTAMPTZ '2026-01-26 09:00:00+00',
    TIMESTAMPTZ '2026-01-26 09:05:00+00',
    NULL,
    'Acute Medicine',
    'A significant bed-capacity reduction increased escalation risk.',
    'synthetic_seed_v1',
    'INC-WGH-009',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'WGH001'),
    'INC-WGH-010',
    'staffing disruption',
    'high',
    'open',
    TIMESTAMPTZ '2026-01-29 05:30:00+00',
    TIMESTAMPTZ '2026-01-29 05:45:00+00',
    NULL,
    'Critical Care',
    'Unplanned staffing gaps required operational escalation.',
    'synthetic_seed_v1',
    'INC-WGH-010',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),

-- North Riverside NHS Trust: 8 incidents

(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-001',
    'IT outage',
    'low',
    'resolved',
    TIMESTAMPTZ '2026-01-04 13:00:00+00',
    TIMESTAMPTZ '2026-01-04 13:10:00+00',
    TIMESTAMPTZ '2026-01-04 14:00:00+00',
    'Operational Reporting',
    'Short interruption to local reporting access.',
    'synthetic_seed_v1',
    'INC-NRT-001',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-002',
    'staffing disruption',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-08 06:00:00+00',
    TIMESTAMPTZ '2026-01-08 06:15:00+00',
    TIMESTAMPTZ '2026-01-08 18:00:00+00',
    'Emergency Department',
    'Reduced shift coverage increased operational pressure.',
    'synthetic_seed_v1',
    'INC-NRT-002',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-003',
    'severe-weather impact',
    'high',
    'resolved',
    TIMESTAMPTZ '2026-01-12 03:00:00+00',
    TIMESTAMPTZ '2026-01-12 03:20:00+00',
    TIMESTAMPTZ '2026-01-13 10:00:00+00',
    'Trust-wide',
    'Cold weather affected travel, staffing, and demand.',
    'synthetic_seed_v1',
    'INC-NRT-003',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-004',
    'temporary bed closure',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-15 10:30:00+00',
    TIMESTAMPTZ '2026-01-15 10:45:00+00',
    TIMESTAMPTZ '2026-01-16 09:00:00+00',
    'General Medicine',
    'A small number of beds were temporarily unavailable.',
    'synthetic_seed_v1',
    'INC-NRT-004',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-005',
    'ambulance access pressure',
    'high',
    'monitoring',
    TIMESTAMPTZ '2026-01-18 14:00:00+00',
    TIMESTAMPTZ '2026-01-18 14:10:00+00',
    NULL,
    'Emergency Department',
    'Sustained arrival pressure required continued monitoring.',
    'synthetic_seed_v1',
    'INC-NRT-005',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-006',
    'heating failure',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-21 07:00:00+00',
    TIMESTAMPTZ '2026-01-21 07:05:00+00',
    TIMESTAMPTZ '2026-01-21 13:00:00+00',
    'Outpatients',
    'Heating disruption affected one outpatient area.',
    'synthetic_seed_v1',
    'INC-NRT-006',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-007',
    'infection-control pressure',
    'high',
    'open',
    TIMESTAMPTZ '2026-01-25 08:00:00+00',
    TIMESTAMPTZ '2026-01-25 08:15:00+00',
    NULL,
    'Inpatient Services',
    'Infection-control measures reduced available capacity.',
    'synthetic_seed_v1',
    'INC-NRT-007',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'NRT002'),
    'INC-NRT-008',
    'transport disruption',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-28 05:00:00+00',
    TIMESTAMPTZ '2026-01-28 05:20:00+00',
    TIMESTAMPTZ '2026-01-28 11:30:00+00',
    'Workforce Operations',
    'Local transport disruption affected shift attendance.',
    'synthetic_seed_v1',
    'INC-NRT-008',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),

-- South County Community Trust: 6 incidents

(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'SCT003'),
    'INC-SCT-001',
    'staffing disruption',
    'low',
    'resolved',
    TIMESTAMPTZ '2026-01-05 07:00:00+00',
    TIMESTAMPTZ '2026-01-05 07:15:00+00',
    TIMESTAMPTZ '2026-01-05 14:00:00+00',
    'Community Services',
    'Reduced staffing affected selected community visits.',
    'synthetic_seed_v1',
    'INC-SCT-001',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'SCT003'),
    'INC-SCT-002',
    'transport disruption',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-10 06:30:00+00',
    TIMESTAMPTZ '2026-01-10 06:40:00+00',
    TIMESTAMPTZ '2026-01-10 16:00:00+00',
    'Community Nursing',
    'Travel disruption delayed selected community activity.',
    'synthetic_seed_v1',
    'INC-SCT-002',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'SCT003'),
    'INC-SCT-003',
    'IT outage',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-13 09:30:00+00',
    TIMESTAMPTZ '2026-01-13 09:35:00+00',
    TIMESTAMPTZ '2026-01-13 11:15:00+00',
    'Community Operations',
    'Temporary interruption to scheduling systems.',
    'synthetic_seed_v1',
    'INC-SCT-003',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'SCT003'),
    'INC-SCT-004',
    'severe-weather impact',
    'moderate',
    'monitoring',
    TIMESTAMPTZ '2026-01-19 05:00:00+00',
    TIMESTAMPTZ '2026-01-19 05:20:00+00',
    NULL,
    'Trust-wide',
    'Weather conditions affected travel and community access.',
    'synthetic_seed_v1',
    'INC-SCT-004',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'SCT003'),
    'INC-SCT-005',
    'staffing disruption',
    'moderate',
    'resolved',
    TIMESTAMPTZ '2026-01-24 06:00:00+00',
    TIMESTAMPTZ '2026-01-24 06:10:00+00',
    TIMESTAMPTZ '2026-01-24 18:00:00+00',
    'Intermediate Care',
    'Reduced staffing required temporary service prioritisation.',
    'synthetic_seed_v1',
    'INC-SCT-005',
    '11111111-1111-4111-8111-111111111111',
    'valid'
),
(
    (SELECT trust_id FROM operational.trusts WHERE trust_code = 'SCT003'),
    'INC-SCT-006',
    'medical-equipment fault',
    'low',
    'open',
    TIMESTAMPTZ '2026-01-30 08:30:00+00',
    TIMESTAMPTZ '2026-01-30 08:45:00+00',
    NULL,
    'Community Rehabilitation',
    'One item of non-critical equipment was unavailable.',
    'synthetic_seed_v1',
    'INC-SCT-006',
    '11111111-1111-4111-8111-111111111111',
    'valid'
);

-- ============================================================
-- 5. WEATHER METRICS
-- Expected rows: 90
-- Grain: one observed weather record per Trust and reporting date
-- ============================================================

WITH reporting_dates AS (
    SELECT generate_series(
        DATE '2026-01-01',
        DATE '2026-01-30',
        INTERVAL '1 day'
    )::DATE AS reporting_date
),
trust_profiles AS (
    SELECT
        trust_id,
        trust_code,
        CASE trust_code
            WHEN 'WGH001' THEN 1.5
            WHEN 'NRT002' THEN -0.5
            WHEN 'SCT003' THEN 3.0
        END::NUMERIC AS regional_temperature_adjustment
    FROM operational.trusts
    WHERE trust_code IN ('WGH001', 'NRT002', 'SCT003')
),
generated_records AS (
    SELECT
        tp.trust_id,
        tp.trust_code,
        tp.regional_temperature_adjustment,
        rd.reporting_date,
        EXTRACT(DAY FROM rd.reporting_date)::INTEGER AS day_number
    FROM trust_profiles AS tp
    CROSS JOIN reporting_dates AS rd
)
INSERT INTO operational.weather_metrics (
    trust_id,
    reporting_date,
    observation_type,
    forecast_generated_at,
    minimum_temperature_c,
    maximum_temperature_c,
    precipitation_mm,
    snowfall_cm,
    maximum_wind_speed_mph,
    weather_warning_level,
    weather_warning_type,
    source_system,
    source_record_id,
    load_batch_id,
    data_quality_status
)
SELECT
    trust_id,
    reporting_date,
    'observed',
    NULL,

    ROUND(
        (
            CASE
                WHEN day_number BETWEEN 1 AND 7 THEN -3.0
                WHEN day_number BETWEEN 8 AND 14 THEN 0.5
                WHEN day_number BETWEEN 15 AND 22 THEN -1.5
                ELSE 2.0
            END
            + regional_temperature_adjustment
            + (MOD(day_number * 3, 5) * 0.4)
        )::NUMERIC,
        1
    ),

    ROUND(
        (
            CASE
                WHEN day_number BETWEEN 1 AND 7 THEN 3.0
                WHEN day_number BETWEEN 8 AND 14 THEN 6.0
                WHEN day_number BETWEEN 15 AND 22 THEN 4.0
                ELSE 8.0
            END
            + regional_temperature_adjustment
            + (MOD(day_number * 2, 6) * 0.5)
        )::NUMERIC,
        1
    ),

    ROUND(
        (
            CASE
                WHEN day_number IN (4, 5, 11, 12, 18, 19, 25, 26)
                    THEN 12.0
                WHEN MOD(day_number, 4) = 0
                    THEN 5.5
                ELSE 1.2
            END
            +
            CASE trust_code
                WHEN 'NRT002' THEN 2.0
                WHEN 'SCT003' THEN 1.0
                ELSE 0.0
            END
        )::NUMERIC,
        1
    ),

    ROUND(
        (
            CASE
                WHEN trust_code = 'NRT002'
                     AND day_number IN (3, 4, 12, 13, 19)
                    THEN 4.5
                WHEN trust_code = 'WGH001'
                     AND day_number IN (4, 12, 19)
                    THEN 1.5
                ELSE 0.0
            END
        )::NUMERIC,
        1
    ),

    CASE
        WHEN day_number IN (5, 12, 19, 26) THEN 48
        WHEN day_number IN (4, 11, 18, 25) THEN 36
        ELSE 18 + MOD(day_number * 3, 12)
    END,

    CASE
        WHEN day_number IN (12, 19)
             AND trust_code = 'NRT002'
            THEN 'amber'
        WHEN day_number IN (4, 5, 11, 18, 25, 26)
            THEN 'yellow'
        ELSE 'none'
    END,

    CASE
        WHEN day_number IN (12, 19)
             AND trust_code = 'NRT002'
            THEN 'snow and ice'
        WHEN day_number IN (4, 11, 18, 25)
            THEN 'ice'
        WHEN day_number IN (5, 26)
            THEN 'wind'
        ELSE NULL
    END,

    'synthetic_seed_v1',

    'WTH-' || trust_code || '-' ||
    TO_CHAR(reporting_date, 'YYYYMMDD') || '-OBS',

    '11111111-1111-4111-8111-111111111111',

    'valid'
FROM generated_records;

-- ============================================================
-- 6. OPEL ASSESSMENTS
-- Expected rows: 90
-- Grain: one assessment per Trust and reporting date
-- ============================================================

WITH reporting_dates AS (
    SELECT generate_series(
        DATE '2026-01-01',
        DATE '2026-01-30',
        INTERVAL '1 day'
    )::DATE AS assessment_date
),
trust_dates AS (
    SELECT
        t.trust_id,
        t.trust_code,
        d.assessment_date,
        EXTRACT(DAY FROM d.assessment_date)::INTEGER AS day_number
    FROM operational.trusts AS t
    CROSS JOIN reporting_dates AS d
    WHERE t.trust_code IN ('WGH001', 'NRT002', 'SCT003')
),
recommendations AS (
    SELECT
        trust_id,
        trust_code,
        assessment_date,
        day_number,

        CASE
            WHEN day_number BETWEEN 1 AND 7 THEN 1
            WHEN day_number BETWEEN 8 AND 14 THEN 2
            WHEN day_number BETWEEN 15 AND 22 THEN
                CASE
                    WHEN trust_code = 'SCT003' THEN 2
                    ELSE 3
                END
            ELSE
                CASE
                    WHEN trust_code = 'WGH001' THEN 4
                    WHEN trust_code = 'NRT002' THEN 3
                    ELSE 3
                END
        END AS recommended_opel_level
    FROM trust_dates
),
approved_decisions AS (
    SELECT
        trust_id,
        trust_code,
        assessment_date,
        day_number,
        recommended_opel_level,

        CASE
            -- Deliberate examples of human review overriding the recommendation
            WHEN trust_code = 'WGH001' AND day_number = 18 THEN 2
            WHEN trust_code = 'WGH001' AND day_number = 27 THEN 3
            WHEN trust_code = 'NRT002' AND day_number = 13 THEN 3
            WHEN trust_code = 'SCT003' AND day_number = 24 THEN 2
            ELSE recommended_opel_level
        END AS approved_opel_level
    FROM recommendations
),
final_assessments AS (
    SELECT
        trust_id,
        trust_code,
        assessment_date,
        day_number,
        recommended_opel_level,
        approved_opel_level,

        LAG(approved_opel_level) OVER (
            PARTITION BY trust_id
            ORDER BY assessment_date
        ) AS previous_approved_opel_level
    FROM approved_decisions
)
INSERT INTO operational.opel_assessments (
    trust_id,
    assessment_date,
    assessment_timestamp,
    recommended_opel_level,
    approved_opel_level,
    previous_approved_opel_level,
    prediction_confidence,
    assessment_method,
    rule_version,
    decision_rationale,
    reviewed_by_role,
    reviewed_at,
    source_system,
    source_record_id,
    load_batch_id,
    data_quality_status
)
SELECT
    trust_id,
    assessment_date,

    assessment_date::TIMESTAMP
        + TIME '10:00:00',

    recommended_opel_level,
    approved_opel_level,
    previous_approved_opel_level,

    CASE recommended_opel_level
        WHEN 1 THEN 0.91
        WHEN 2 THEN 0.87
        WHEN 3 THEN 0.83
        WHEN 4 THEN 0.79
    END,

    'rules_based',

    'opel_rules_v1.0',

    CASE
        WHEN approved_opel_level <> recommended_opel_level THEN
            'Human reviewer adjusted the rules-based recommendation using synthetic contextual information.'
        WHEN recommended_opel_level = 4 THEN
            'Synthetic critical pressure across capacity, demand, workforce and operational indicators.'
        WHEN recommended_opel_level = 3 THEN
            'Synthetic significant pressure requiring enhanced operational coordination.'
        WHEN recommended_opel_level = 2 THEN
            'Synthetic moderate pressure requiring active monitoring and management.'
        ELSE
            'Synthetic operational conditions remained within routine management arrangements.'
    END,

    'Duty Operations Manager',

    assessment_date::TIMESTAMP
        + TIME '10:30:00',

    'synthetic_seed_v1',

    'OPEL-' || trust_code || '-' ||
    TO_CHAR(assessment_date, 'YYYYMMDD'),

    '11111111-1111-4111-8111-111111111111',

    'valid'
FROM final_assessments;

-- ============================================================
-- 7. PRE-COMMIT VALIDATION
-- Confirm the expected number of rows before committing
-- ============================================================

DO $$
DECLARE
    trust_count INTEGER;
    daily_count INTEGER;
    workforce_count INTEGER;
    incident_count INTEGER;
    weather_count INTEGER;
    opel_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO trust_count
    FROM operational.trusts
    WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*) INTO daily_count
    FROM operational.daily_operational_metrics
    WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*) INTO workforce_count
    FROM operational.workforce_metrics
    WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*) INTO incident_count
    FROM operational.incidents
    WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*) INTO weather_count
    FROM operational.weather_metrics
    WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*) INTO opel_count
    FROM operational.opel_assessments
    WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

    IF trust_count <> 3 THEN
        RAISE EXCEPTION
            'Validation failed: expected 3 Trust rows, found %',
            trust_count;
    END IF;

    IF daily_count <> 90 THEN
        RAISE EXCEPTION
            'Validation failed: expected 90 daily operational rows, found %',
            daily_count;
    END IF;

    IF workforce_count <> 90 THEN
        RAISE EXCEPTION
            'Validation failed: expected 90 workforce rows, found %',
            workforce_count;
    END IF;

    IF incident_count <> 24 THEN
        RAISE EXCEPTION
            'Validation failed: expected 24 incident rows, found %',
            incident_count;
    END IF;

    IF weather_count <> 90 THEN
        RAISE EXCEPTION
            'Validation failed: expected 90 weather rows, found %',
            weather_count;
    END IF;

    IF opel_count <> 90 THEN
        RAISE EXCEPTION
            'Validation failed: expected 90 OPEL rows, found %',
            opel_count;
    END IF;

    RAISE NOTICE
        'Validation passed: trusts %, daily %, workforce %, incidents %, weather %, OPEL %',
        trust_count,
        daily_count,
        workforce_count,
        incident_count,
        weather_count,
        opel_count;
END
$$;

COMMIT;


