-- NHS Operational Data Platform
-- Data-quality validation queries
--
-- Purpose:
-- Test completeness, uniqueness, logical validity,
-- referential integrity, and reporting-date coverage.
--
-- Run against: nhs_operations_test
--
-- Expected loaded dataset:
-- trusts: 3
-- daily_operational_metrics: 90
-- workforce_metrics: 90
-- incidents: 24
-- weather_metrics: 90
-- opel_assessments: 90


-- ============================================================
-- 1. RECORD COUNT CHECK
-- Expected: 3, 90, 90, 24, 90, 90
-- ============================================================

SELECT
    'trusts' AS table_name,
    COUNT(*) AS record_count
FROM operational.trusts

UNION ALL

SELECT
    'daily_operational_metrics',
    COUNT(*)
FROM operational.daily_operational_metrics

UNION ALL

SELECT
    'workforce_metrics',
    COUNT(*)
FROM operational.workforce_metrics

UNION ALL

SELECT
    'incidents',
    COUNT(*)
FROM operational.incidents

UNION ALL

SELECT
    'weather_metrics',
    COUNT(*)
FROM operational.weather_metrics

UNION ALL

SELECT
    'opel_assessments',
    COUNT(*)
FROM operational.opel_assessments;


-- ============================================================
-- 2. DUPLICATE DAILY OPERATIONAL RECORDS
-- Expected result: 0 rows
-- Grain: one Trust per reporting date
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    COUNT(*) AS duplicate_count
FROM operational.daily_operational_metrics
GROUP BY
    trust_id,
    reporting_date
HAVING COUNT(*) > 1;


-- ============================================================
-- 3. DUPLICATE WORKFORCE RECORDS
-- Expected result: 0 rows
-- Grain: one Trust, date, and staff group
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    staff_group,
    COUNT(*) AS duplicate_count
FROM operational.workforce_metrics
GROUP BY
    trust_id,
    reporting_date,
    staff_group
HAVING COUNT(*) > 1;


-- ============================================================
-- 4. MISSING DAILY OPERATIONAL VALUES
-- Expected result: 0 rows
--
-- The schema does not store bed_occupancy_pct directly.
-- Occupancy is calculated from open and occupied beds.
-- ============================================================

SELECT
    metric_id,
    trust_id,
    reporting_date,
    general_beds_open,
    general_beds_occupied,
    critical_care_beds_open,
    critical_care_beds_occupied,
    ae_attendances,
    four_hour_breaches,
    ambulance_arrivals,
    ambulance_handover_delays
FROM operational.daily_operational_metrics
WHERE trust_id IS NULL
   OR reporting_date IS NULL
   OR general_beds_open IS NULL
   OR general_beds_occupied IS NULL
   OR critical_care_beds_open IS NULL
   OR critical_care_beds_occupied IS NULL
   OR ae_attendances IS NULL
   OR four_hour_breaches IS NULL
   OR ambulance_arrivals IS NULL
   OR ambulance_handover_delays IS NULL;


-- ============================================================
-- 5. IMPOSSIBLE BED VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
    metric_id,
    trust_id,
    reporting_date,
    general_beds_open,
    general_beds_occupied,
    critical_care_beds_open,
    critical_care_beds_occupied
FROM operational.daily_operational_metrics
WHERE general_beds_open < 0
   OR general_beds_occupied < 0
   OR critical_care_beds_open < 0
   OR critical_care_beds_occupied < 0
   OR general_beds_occupied > general_beds_open
   OR critical_care_beds_occupied > critical_care_beds_open;


-- ============================================================
-- 6. IMPOSSIBLE CALCULATED BED OCCUPANCY
-- Expected result: 0 rows
--
-- A broad upper threshold of 120% is included to match
-- the original validation requirement.
-- Current schema constraints should prevent occupancy above 100%.
-- ============================================================

WITH calculated_occupancy AS (
    SELECT
        metric_id,
        trust_id,
        reporting_date,

        ROUND(
            100.0 * general_beds_occupied
            / NULLIF(general_beds_open, 0),
            2
        ) AS general_bed_occupancy_pct,

        ROUND(
            100.0 * critical_care_beds_occupied
            / NULLIF(critical_care_beds_open, 0),
            2
        ) AS critical_care_occupancy_pct

    FROM operational.daily_operational_metrics
)
SELECT *
FROM calculated_occupancy
WHERE general_bed_occupancy_pct < 0
   OR general_bed_occupancy_pct > 120
   OR critical_care_occupancy_pct < 0
   OR critical_care_occupancy_pct > 120;


-- ============================================================
-- 7. ZERO OPEN BEDS
-- Expected result: review only
--
-- This is separated from the impossible-value check because
-- zero capacity may be valid for some service types.
-- ============================================================

SELECT
    metric_id,
    trust_id,
    reporting_date,
    general_beds_open,
    critical_care_beds_open
FROM operational.daily_operational_metrics
WHERE general_beds_open = 0
   OR critical_care_beds_open = 0;


-- ============================================================
-- 8. INVALID A&E ACTIVITY
-- Expected result: 0 rows
-- ============================================================

SELECT
    metric_id,
    trust_id,
    reporting_date,
    ae_attendances,
    four_hour_breaches
FROM operational.daily_operational_metrics
WHERE ae_attendances < 0
   OR four_hour_breaches < 0
   OR four_hour_breaches > ae_attendances;


-- ============================================================
-- 9. INVALID AMBULANCE ACTIVITY
-- Expected result: 0 rows
-- ============================================================

SELECT
    metric_id,
    trust_id,
    reporting_date,
    ambulance_arrivals,
    ambulance_handover_delays
FROM operational.daily_operational_metrics
WHERE ambulance_arrivals < 0
   OR ambulance_handover_delays < 0
   OR ambulance_handover_delays > ambulance_arrivals;


-- ============================================================
-- 10. INVALID WORKFORCE VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
    workforce_metric_id,
    trust_id,
    reporting_date,
    staff_group,
    establishment_fte,
    substantive_fte,
    absence_fte,
    agency_fte,
    bank_fte,
    unfilled_shifts
FROM operational.workforce_metrics
WHERE establishment_fte < 0
   OR substantive_fte < 0
   OR absence_fte < 0
   OR agency_fte < 0
   OR bank_fte < 0
   OR unfilled_shifts < 0;


-- ============================================================
-- 11. ORPHAN RECORDS
-- Expected orphan_count: 0 for every table
-- ============================================================

SELECT
    'daily_operational_metrics' AS table_name,
    COUNT(*) AS orphan_count
FROM operational.daily_operational_metrics AS d
LEFT JOIN operational.trusts AS t
    ON d.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT
    'workforce_metrics',
    COUNT(*)
FROM operational.workforce_metrics AS w
LEFT JOIN operational.trusts AS t
    ON w.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT
    'incidents',
    COUNT(*)
FROM operational.incidents AS i
LEFT JOIN operational.trusts AS t
    ON i.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT
    'weather_metrics',
    COUNT(*)
FROM operational.weather_metrics AS wm
LEFT JOIN operational.trusts AS t
    ON wm.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT
    'opel_assessments',
    COUNT(*)
FROM operational.opel_assessments AS o
LEFT JOIN operational.trusts AS t
    ON o.trust_id = t.trust_id
WHERE t.trust_id IS NULL;


-- ============================================================
-- 12. INCIDENT TIMESTAMP AND STATUS CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
    incident_id,
    incident_reference,
    incident_status,
    incident_started_at,
    incident_reported_at,
    incident_resolved_at
FROM operational.incidents
WHERE incident_reported_at < incident_started_at

   OR (
        incident_status = 'resolved'
        AND incident_resolved_at IS NULL
   )

   OR (
        incident_status <> 'resolved'
        AND incident_resolved_at IS NOT NULL
   )

   OR (
        incident_resolved_at IS NOT NULL
        AND incident_resolved_at < incident_started_at
   );


-- ============================================================
-- 13. WEATHER VALUE CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
    weather_metric_id,
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
    weather_warning_type
FROM operational.weather_metrics
WHERE temperature_min_c > temperature_max_c
   OR precipitation_mm < 0
   OR snowfall_mm < 0
   OR wind_speed_mph < 0

   OR (
        observation_type = 'forecast'
        AND forecast_generated_at IS NULL
   )

   OR (
        weather_warning_level IS NOT NULL
        AND weather_warning_type IS NULL
   );


-- ============================================================
-- 14. OPEL VALUE AND APPROVAL CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
    assessment_id,
    trust_id,
    assessment_timestamp,
    recommended_opel_level,
    approved_opel_level,
    previous_approved_opel_level,
    prediction_confidence,
    approval_status,
    reviewed_by_role,
    reviewed_at
FROM operational.opel_assessments
WHERE recommended_opel_level NOT BETWEEN 1 AND 4
   OR approved_opel_level NOT BETWEEN 1 AND 4

   OR (
        previous_approved_opel_level IS NOT NULL
        AND previous_approved_opel_level NOT BETWEEN 1 AND 4
   )

   OR prediction_confidence NOT BETWEEN 0 AND 1

   OR (
        approval_status = 'approved'
        AND (
            approved_opel_level IS NULL
            OR reviewed_by_role IS NULL
            OR reviewed_at IS NULL
        )
   );


-- ============================================================
-- 15. MISSING REPORTING DATES BY TRUST
-- Expected result: 0 rows
--
-- Builds the complete date calendar between the earliest
-- and latest operational dates, then identifies missing rows.
-- ============================================================

WITH reporting_boundaries AS (
    SELECT
        MIN(reporting_date) AS minimum_reporting_date,
        MAX(reporting_date) AS maximum_reporting_date
    FROM operational.daily_operational_metrics
),
expected_dates AS (
    SELECT
        generate_series(
            minimum_reporting_date,
            maximum_reporting_date,
            INTERVAL '1 day'
        )::DATE AS reporting_date
    FROM reporting_boundaries
),
expected_trust_dates AS (
    SELECT
        t.trust_id,
        t.trust_code,
        t.trust_name,
        d.reporting_date
    FROM operational.trusts AS t
    CROSS JOIN expected_dates AS d
    WHERE t.active_flag = TRUE
)
SELECT
    etd.trust_id,
    etd.trust_code,
    etd.trust_name,
    etd.reporting_date AS missing_reporting_date
FROM expected_trust_dates AS etd
LEFT JOIN operational.daily_operational_metrics AS dom
    ON etd.trust_id = dom.trust_id
   AND etd.reporting_date = dom.reporting_date
WHERE dom.metric_id IS NULL
ORDER BY
    etd.trust_code,
    etd.reporting_date;


-- ============================================================
-- 16. REPORTING COVERAGE SUMMARY
-- Expected:
-- 3 Trusts
-- 30 reporting dates
-- 90 total rows
-- 2026-01-01 to 2026-01-30
-- ============================================================

SELECT
    COUNT(DISTINCT trust_id) AS trust_count,
    COUNT(DISTINCT reporting_date) AS reporting_date_count,
    COUNT(*) AS total_rows,
    MIN(reporting_date) AS earliest_date,
    MAX(reporting_date) AS latest_date
FROM operational.daily_operational_metrics;


-- ============================================================
-- 17. RECORD COUNT BY TRUST
-- Expected: 30 daily rows per Trust
-- ============================================================

SELECT
    t.trust_code,
    t.trust_name,
    COUNT(d.metric_id) AS operational_record_count,
    MIN(d.reporting_date) AS earliest_date,
    MAX(d.reporting_date) AS latest_date
FROM operational.trusts AS t
LEFT JOIN operational.daily_operational_metrics AS d
    ON t.trust_id = d.trust_id
GROUP BY
    t.trust_code,
    t.trust_name
ORDER BY
    t.trust_code;
