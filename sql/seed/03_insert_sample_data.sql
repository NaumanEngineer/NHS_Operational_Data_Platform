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



-- COMMIT will be added after all synthetic data sections are complete.
