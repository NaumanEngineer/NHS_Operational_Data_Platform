-- NHS Operational Data Platform
-- Synthetic sample data seed script
--
-- All organisations and operational values in this file are fictional.
-- This dataset is intended only for learning, testing, and portfolio use.
-- It must not be interpreted as real NHS performance evidence.
--
-- Reporting period: 2026-01-01 to 2026-01-30
-- Load batch ID: 11111111-1111-4111-8111-111111111111
--
-- Expected rows:
-- trusts: 3
-- daily_operational_metrics: 90
-- workforce_metrics: 90
-- incidents: 24
-- weather_metrics: 90
-- opel_assessments: 90
--
-- Run while connected to nhs_operations_test.

BEGIN;

-- ============================================================
-- 0. REMOVE A PREVIOUS COPY OF THIS SYNTHETIC BATCH
-- Child tables must be cleared before the parent Trust table.
-- ============================================================

DELETE FROM operational.opel_assessments
WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

DELETE FROM operational.weather_metrics
WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

DELETE FROM operational.incidents
WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

DELETE FROM operational.workforce_metrics
WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

DELETE FROM operational.daily_operational_metrics
WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';

DELETE FROM operational.trusts
WHERE load_batch_id = '11111111-1111-4111-8111-111111111111';


-- ============================================================
-- 1. FICTIONAL TRUST REFERENCE DATA
-- Expected rows: 3
-- ============================================================

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
-- Grain: one row per Trust and reporting date
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
        END AS base_critical_beds,

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
        tp.base_general_beds,
        tp.base_critical_beds,
        tp.base_ae_attendances,
        rd.reporting_date,
        EXTRACT(DAY FROM rd.reporting_date)::INTEGER AS day_number
    FROM trust_profiles AS tp
    CROSS JOIN reporting_dates AS rd
),
calculated_activity AS (
    SELECT
        trust_id,
        trust_code,
        reporting_date,
        day_number,
        base_general_beds,
        base_critical_beds,

        base_ae_attendances
        + CASE
            WHEN day_number BETWEEN 1 AND 7 THEN 0
            WHEN day_number BETWEEN 8 AND 14 THEN 35
            WHEN day_number BETWEEN 15 AND 22 THEN 55
            ELSE 75
          END
        + MOD(day_number * 11, 25) AS calculated_ae_attendances

    FROM generated_records
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

    base_critical_beds,

    LEAST(
        base_critical_beds,
        ROUND(
            base_critical_beds *
            CASE
                WHEN day_number BETWEEN 1 AND 10 THEN 0.72
                WHEN day_number BETWEEN 11 AND 20 THEN 0.84
                ELSE 0.92
            END
        )::INTEGER
    ),

    calculated_ae_attendances,

    ROUND(
        calculated_ae_attendances *
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
        WHEN day_number BETWEEN 1 AND 14
            THEN MOD(day_number * 4, 15)
        ELSE MOD(day_number * 2, 9)
      END,

    'synthetic_seed_v1',

    'OPS-' || trust_code || '-' ||
    TO_CHAR(reporting_date, 'YYYYMMDD'),

    '11111111-1111-4111-8111-111111111111',

    'valid'

FROM calculated_activity;


-- ============================================================
-- 3. WORKFORCE METRICS
-- Expected rows: 90
-- Grain: one row per Trust, date, and staff group
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
        + MOD(day_number * 3, 5),
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
-- 4. SYNTHETIC OPERATIONAL INCIDENTS
-- Expected rows: 24
-- Grain: one row per incident
-- ============================================================

WITH incident_numbers AS (
    SELECT generate_series(1, 24) AS incident_number
),
incident_profiles AS (
    SELECT
        incident_number,

        CASE
            WHEN incident_number BETWEEN 1 AND 10 THEN 'WGH001'
            WHEN incident_number BETWEEN 11 AND 18 THEN 'NRT002'
            ELSE 'SCT003'
        END AS trust_code,

        CASE
            WHEN incident_number BETWEEN 1 AND 10
                THEN incident_number
            WHEN incident_number BETWEEN 11 AND 18
                THEN incident_number - 10
            ELSE incident_number - 18
        END AS trust_incident_number,

        CASE MOD(incident_number - 1, 8)
            WHEN 0 THEN 'staffing disruption'
            WHEN 1 THEN 'temporary bed closure'
            WHEN 2 THEN 'IT outage'
            WHEN 3 THEN 'heating failure'
            WHEN 4 THEN 'infection-control pressure'
            WHEN 5 THEN 'ambulance access pressure'
            WHEN 6 THEN 'medical-equipment fault'
            ELSE 'transport disruption'
        END AS incident_type,

        CASE MOD(incident_number - 1, 4)
            WHEN 0 THEN 'low'
            WHEN 1 THEN 'moderate'
            WHEN 2 THEN 'high'
            ELSE 'critical'
        END AS severity_level,

        CASE
            WHEN incident_number IN (5, 9, 15, 22)
                THEN 'monitoring'
            WHEN incident_number IN (10, 17, 24)
                THEN 'open'
            ELSE 'resolved'
        END AS incident_status

    FROM incident_numbers
),
prepared_incidents AS (
    SELECT
        ip.*,
        t.trust_id,

        MAKE_TIMESTAMPTZ(
            2026,
            1,
            incident_number,
            8,
            0,
            0,
            'UTC'
        ) AS incident_started_at

    FROM incident_profiles AS ip
    JOIN operational.trusts AS t
        ON t.trust_code = ip.trust_code
)
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
SELECT
    trust_id,

    'INC-' || trust_code || '-' ||
    LPAD(trust_incident_number::TEXT, 3, '0'),

    incident_type,
    severity_level,
    incident_status,

    incident_started_at,

    incident_started_at + INTERVAL '20 minutes',

    CASE
        WHEN incident_status = 'resolved'
            THEN incident_started_at + INTERVAL '8 hours'
        ELSE NULL
    END,

    CASE incident_type
        WHEN 'staffing disruption'
            THEN 'Workforce Operations'
        WHEN 'temporary bed closure'
            THEN 'Acute Medicine'
        WHEN 'IT outage'
            THEN 'Operational Reporting'
        WHEN 'heating failure'
            THEN 'Estates and Facilities'
        WHEN 'infection-control pressure'
            THEN 'Inpatient Services'
        WHEN 'ambulance access pressure'
            THEN 'Emergency Department'
        WHEN 'medical-equipment fault'
            THEN 'Clinical Operations'
        ELSE 'Trust-wide Operations'
    END,

    CASE incident_type
        WHEN 'staffing disruption'
            THEN 'Synthetic staffing gaps reduced planned service capacity.'
        WHEN 'temporary bed closure'
            THEN 'Synthetic bed closures reduced available operational capacity.'
        WHEN 'IT outage'
            THEN 'Synthetic system disruption affected operational reporting.'
        WHEN 'heating failure'
            THEN 'Synthetic estate disruption affected part of the service.'
        WHEN 'infection-control pressure'
            THEN 'Synthetic infection-control measures reduced operational flexibility.'
        WHEN 'ambulance access pressure'
            THEN 'Synthetic ambulance demand exceeded planned receiving capacity.'
        WHEN 'medical-equipment fault'
            THEN 'Synthetic equipment unavailability affected service delivery.'
        ELSE
            'Synthetic transport disruption affected workforce and service access.'
    END,

    'synthetic_seed_v1',

    'INC-' || trust_code || '-' ||
    LPAD(trust_incident_number::TEXT, 3, '0'),

    '11111111-1111-4111-8111-111111111111',

    'valid'

FROM prepared_incidents;


-- ============================================================
-- 5. WEATHER METRICS
-- Expected rows: 90
-- Grain: one observed record per Trust and reporting date
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
    temperature_min_c,
    temperature_max_c,
    precipitation_mm,
    snowfall_mm,
    wind_speed_mph,
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
            + MOD(day_number * 3, 5) * 0.4
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
            + MOD(day_number * 2, 6) * 0.5
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
                    THEN 45.0
                WHEN trust_code = 'WGH001'
                     AND day_number IN (4, 12, 19)
                    THEN 15.0
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

        ELSE NULL
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
                    ELSE 3
                END
        END::SMALLINT AS recommended_opel_level

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
            WHEN trust_code = 'WGH001'
                 AND day_number = 18
                THEN 2

            WHEN trust_code = 'WGH001'
                 AND day_number = 27
                THEN 3

            WHEN trust_code = 'NRT002'
                 AND day_number = 13
                THEN 3

            WHEN trust_code = 'SCT003'
                 AND day_number = 24
                THEN 2

            ELSE recommended_opel_level
        END::SMALLINT AS approved_opel_level

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
        )::SMALLINT AS previous_approved_opel_level

    FROM approved_decisions
)
INSERT INTO operational.opel_assessments (
    trust_id,
    assessment_timestamp,
    recommended_opel_level,
    approved_opel_level,
    previous_approved_opel_level,
    prediction_confidence,
    assessment_method,
    assessment_rationale,
    key_pressure_factors,
    approval_status,
    assessed_by_role,
    reviewed_by_role,
    reviewed_at,
    rule_version,
    source_system,
    source_record_id,
    load_batch_id,
    data_quality_status
)
SELECT
    trust_id,

    (
        assessment_date + TIME '10:00:00'
    ) AT TIME ZONE 'UTC',

    recommended_opel_level,
    approved_opel_level,
    previous_approved_opel_level,

    CASE recommended_opel_level
        WHEN 1 THEN 0.9100
        WHEN 2 THEN 0.8700
        WHEN 3 THEN 0.8300
        WHEN 4 THEN 0.7900
    END,

    'rules_based',

    CASE
        WHEN approved_opel_level <> recommended_opel_level THEN
            'Human reviewer adjusted the synthetic rules-based recommendation.'

        WHEN recommended_opel_level = 4 THEN
            'Synthetic critical operational pressure required system-level escalation.'

        WHEN recommended_opel_level = 3 THEN
            'Synthetic significant pressure required enhanced operational coordination.'

        WHEN recommended_opel_level = 2 THEN
            'Synthetic moderate pressure required active monitoring.'

        ELSE
            'Synthetic operational conditions remained within routine arrangements.'
    END,

    CASE
        WHEN recommended_opel_level = 4 THEN
            'High bed occupancy; ambulance delays; workforce gaps; unresolved incidents'

        WHEN recommended_opel_level = 3 THEN
            'Rising occupancy; discharge pressure; workforce absence'

        WHEN recommended_opel_level = 2 THEN
            'Moderate demand; selected capacity and workforce pressure'

        ELSE
            'Routine demand and manageable operational pressure'
    END,

    'approved',

    'Operational Intelligence Analyst',

    'Duty Operations Manager',

    (
        assessment_date + TIME '10:30:00'
    ) AT TIME ZONE 'UTC',

    'opel_rules_v1.0',

    'synthetic_seed_v1',

    'OPEL-' || trust_code || '-' ||
    TO_CHAR(assessment_date, 'YYYYMMDD'),

    '11111111-1111-4111-8111-111111111111',

    'valid'

FROM final_assessments;


-- ============================================================
-- 7. PRE-COMMIT VALIDATION
-- The transaction fails if expected counts are not achieved.
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
    SELECT COUNT(*)
    INTO trust_count
    FROM operational.trusts
    WHERE load_batch_id =
        '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*)
    INTO daily_count
    FROM operational.daily_operational_metrics
    WHERE load_batch_id =
        '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*)
    INTO workforce_count
    FROM operational.workforce_metrics
    WHERE load_batch_id =
        '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*)
    INTO incident_count
    FROM operational.incidents
    WHERE load_batch_id =
        '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*)
    INTO weather_count
    FROM operational.weather_metrics
    WHERE load_batch_id =
        '11111111-1111-4111-8111-111111111111';

    SELECT COUNT(*)
    INTO opel_count
    FROM operational.opel_assessments
    WHERE load_batch_id =
        '11111111-1111-4111-8111-111111111111';

    IF trust_count <> 3 THEN
        RAISE EXCEPTION
            'Validation failed: expected 3 Trust rows, found %',
            trust_count;
    END IF;

    IF daily_count <> 90 THEN
        RAISE EXCEPTION
            'Validation failed: expected 90 daily rows, found %',
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


-- ============================================================
-- 8. POST-LOAD SUMMARY
-- ============================================================

SELECT
    'trusts' AS table_name,
    COUNT(*) AS record_count
FROM operational.trusts
WHERE load_batch_id =
    '11111111-1111-4111-8111-111111111111'

UNION ALL

SELECT
    'daily_operational_metrics',
    COUNT(*)
FROM operational.daily_operational_metrics
WHERE load_batch_id =
    '11111111-1111-4111-8111-111111111111'

UNION ALL

SELECT
    'workforce_metrics',
    COUNT(*)
FROM operational.workforce_metrics
WHERE load_batch_id =
    '11111111-1111-4111-8111-111111111111'

UNION ALL

SELECT
    'incidents',
    COUNT(*)
FROM operational.incidents
WHERE load_batch_id =
    '11111111-1111-4111-8111-111111111111'

UNION ALL

SELECT
    'weather_metrics',
    COUNT(*)
FROM operational.weather_metrics
WHERE load_batch_id =
    '11111111-1111-4111-8111-111111111111'

UNION ALL

SELECT
    'opel_assessments',
    COUNT(*)
FROM operational.opel_assessments
WHERE load_batch_id =
    '11111111-1111-4111-8111-111111111111';
