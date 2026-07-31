-- NHS Operational Data Platform
-- Day 5: Trust daily analytical view
--
-- Purpose:
-- Produce one analysis-ready row per Trust and reporting date
-- by combining operational, workforce, observed weather and
-- approved OPEL information.
--
-- Run against: nhs_operations_test
--
-- Expected grain:
-- One row per Trust per reporting date
--
-- Expected output:
-- 3 Trusts × 30 dates = 90 rows
--
-- Governance:
-- All organisations and values are fictional.
-- This view must not be interpreted as real NHS performance evidence.


CREATE OR REPLACE VIEW operational.vw_trust_daily_analytical AS

WITH workforce_daily AS (
    SELECT
        trust_id,
        reporting_date,

        SUM(establishment_fte) AS establishment_fte,
        SUM(substantive_fte) AS substantive_fte,
        SUM(absence_fte) AS absence_fte,
        SUM(agency_fte) AS agency_fte,
        SUM(bank_fte) AS bank_fte,
        SUM(unfilled_shifts) AS unfilled_shifts

    FROM operational.workforce_metrics

    GROUP BY
        trust_id,
        reporting_date
),

observed_weather_ranked AS (
    SELECT
        trust_id,
        reporting_date,
        temperature_min_c,
        temperature_max_c,
        precipitation_mm,
        snowfall_mm,
        wind_speed_mph,
        weather_warning_level,
        weather_warning_type,

        ROW_NUMBER() OVER (
            PARTITION BY
                trust_id,
                reporting_date
            ORDER BY
                record_updated_at DESC,
                record_created_at DESC,
                source_record_id DESC
        ) AS weather_rank

    FROM operational.weather_metrics

    WHERE observation_type = 'observed'
),

observed_weather_daily AS (
    SELECT
        trust_id,
        reporting_date,
        temperature_min_c,
        temperature_max_c,
        precipitation_mm,
        snowfall_mm,
        wind_speed_mph,
        weather_warning_level,
        weather_warning_type

    FROM observed_weather_ranked

    WHERE weather_rank = 1
),

opel_ranked AS (
    SELECT
        trust_id,
        assessment_timestamp::DATE AS reporting_date,
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

        ROW_NUMBER() OVER (
            PARTITION BY
                trust_id,
                assessment_timestamp::DATE
            ORDER BY
                reviewed_at DESC NULLS LAST,
                assessment_timestamp DESC,
                record_updated_at DESC
        ) AS opel_rank

    FROM operational.opel_assessments
),

opel_daily AS (
    SELECT
        trust_id,
        reporting_date,
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
        rule_version

    FROM opel_ranked

    WHERE opel_rank = 1
)

SELECT
    -- Trust reference information
    t.trust_id,
    t.trust_code,
    t.trust_name,
    t.trust_type,
    t.region,

    -- Reporting grain
    d.reporting_date,

    -- General-bed capacity
    d.general_beds_open,
    d.general_beds_occupied,

    ROUND(
        100.0 * d.general_beds_occupied
        / NULLIF(d.general_beds_open, 0),
        2
    ) AS general_bed_occupancy_pct,

    -- Critical-care capacity
    d.critical_care_beds_open,
    d.critical_care_beds_occupied,

    ROUND(
        100.0 * d.critical_care_beds_occupied
        / NULLIF(d.critical_care_beds_open, 0),
        2
    ) AS critical_care_occupancy_pct,

    -- Emergency demand
    d.ae_attendances,
    d.four_hour_breaches,

    ROUND(
        100.0 * d.four_hour_breaches
        / NULLIF(d.ae_attendances, 0),
        2
    ) AS four_hour_breach_pct,

    -- Ambulance pressure
    d.ambulance_arrivals,
    d.ambulance_handover_delays,

    ROUND(
        100.0 * d.ambulance_handover_delays
        / NULLIF(d.ambulance_arrivals, 0),
        2
    ) AS ambulance_handover_delay_pct,

    -- Flow and discharge
    d.patients_ready_for_discharge,
    d.admissions,
    d.discharges,

    d.admissions - d.discharges AS net_admissions,

    -- Workforce
    w.establishment_fte,
    w.substantive_fte,
    w.absence_fte,

    ROUND(
        100.0 * w.absence_fte
        / NULLIF(w.establishment_fte, 0),
        2
    ) AS workforce_absence_pct,

    w.agency_fte,
    w.bank_fte,
    w.unfilled_shifts,

    -- Weather
    wm.temperature_min_c,
    wm.temperature_max_c,
    wm.precipitation_mm,
    wm.snowfall_mm,
    wm.wind_speed_mph,
    wm.weather_warning_level,
    wm.weather_warning_type,

    CASE
        WHEN wm.temperature_min_c < 0
            THEN 'Below 0°C'
        WHEN wm.temperature_min_c < 3
            THEN '0°C to below 3°C'
        WHEN wm.temperature_min_c IS NULL
            THEN 'Weather unavailable'
        ELSE '3°C and above'
    END AS minimum_temperature_band,

    -- OPEL assessment
    o.assessment_timestamp,
    o.recommended_opel_level,
    o.approved_opel_level,
    o.previous_approved_opel_level,
    o.prediction_confidence,
    o.assessment_method,
    o.assessment_rationale,
    o.key_pressure_factors,
    o.approval_status,
    o.assessed_by_role,
    o.reviewed_by_role,
    o.reviewed_at,
    o.rule_version,

    CASE
        WHEN o.approved_opel_level = 4
            THEN 'Critical pressure'
        WHEN o.approved_opel_level = 3
            THEN 'Significant pressure'
        WHEN o.approved_opel_level = 2
            THEN 'Moderate pressure'
        WHEN o.approved_opel_level = 1
            THEN 'Routine pressure'
        ELSE 'Not assessed'
    END AS operational_pressure_status,

    CASE
        WHEN o.recommended_opel_level IS NULL
             OR o.approved_opel_level IS NULL
            THEN NULL
        WHEN o.recommended_opel_level = o.approved_opel_level
            THEN FALSE
        ELSE TRUE
    END AS human_override_indicator,

    -- Data-lineage fields from the daily operational record
    d.source_system AS operational_source_system,
    d.source_record_id AS operational_source_record_id,
    d.load_batch_id,
    d.data_quality_status

FROM operational.daily_operational_metrics AS d

INNER JOIN operational.trusts AS t
    ON d.trust_id = t.trust_id

LEFT JOIN workforce_daily AS w
    ON d.trust_id = w.trust_id
   AND d.reporting_date = w.reporting_date

LEFT JOIN observed_weather_daily AS wm
    ON d.trust_id = wm.trust_id
   AND d.reporting_date = wm.reporting_date

LEFT JOIN opel_daily AS o
    ON d.trust_id = o.trust_id
   AND d.reporting_date = o.reporting_date;
