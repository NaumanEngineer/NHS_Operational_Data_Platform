-- NHS Operational Data Platform
-- Synthetic data quality checks
--
-- Purpose:
-- Validate completeness, uniqueness, referential integrity,
-- value ranges, and logical consistency after the synthetic load.
--
-- Run against nhs_operations_test.

-- ============================================================
-- 1. RECORD COUNT CHECKS
-- ============================================================

SELECT 'trusts' AS check_name, COUNT(*) AS result
FROM operational.trusts

UNION ALL

SELECT 'daily_operational_metrics', COUNT(*)
FROM operational.daily_operational_metrics

UNION ALL

SELECT 'workforce_metrics', COUNT(*)
FROM operational.workforce_metrics

UNION ALL

SELECT 'incidents', COUNT(*)
FROM operational.incidents

UNION ALL

SELECT 'weather_metrics', COUNT(*)
FROM operational.weather_metrics

UNION ALL

SELECT 'opel_assessments', COUNT(*)
FROM operational.opel_assessments;


-- ============================================================
-- 2. MISSING TRUST RELATIONSHIPS
-- Expected result: 0 rows
-- ============================================================

SELECT 'daily_operational_metrics' AS table_name, COUNT(*) AS orphan_count
FROM operational.daily_operational_metrics d
LEFT JOIN operational.trusts t
    ON d.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT 'workforce_metrics', COUNT(*)
FROM operational.workforce_metrics w
LEFT JOIN operational.trusts t
    ON w.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT 'incidents', COUNT(*)
FROM operational.incidents i
LEFT JOIN operational.trusts t
    ON i.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT 'weather_metrics', COUNT(*)
FROM operational.weather_metrics w
LEFT JOIN operational.trusts t
    ON w.trust_id = t.trust_id
WHERE t.trust_id IS NULL

UNION ALL

SELECT 'opel_assessments', COUNT(*)
FROM operational.opel_assessments o
LEFT JOIN operational.trusts t
    ON o.trust_id = t.trust_id
WHERE t.trust_id IS NULL;


-- ============================================================
-- 3. DUPLICATE DAILY OPERATIONAL RECORDS
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    COUNT(*) AS duplicate_count
FROM operational.daily_operational_metrics
GROUP BY trust_id, reporting_date
HAVING COUNT(*) > 1;


-- ============================================================
-- 4. DUPLICATE WORKFORCE RECORDS
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    staff_group,
    COUNT(*) AS duplicate_count
FROM operational.workforce_metrics
GROUP BY trust_id, reporting_date, staff_group
HAVING COUNT(*) > 1;


-- ============================================================
-- 5. DUPLICATE SOURCE RECORD IDENTIFIERS
-- Expected result: 0 rows
-- ============================================================

SELECT
    source_system,
    source_record_id,
    COUNT(*) AS duplicate_count
FROM operational.daily_operational_metrics
GROUP BY source_system, source_record_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 6. INVALID BED OCCUPANCY
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    general_beds_open,
    general_beds_occupied,
    critical_care_beds_open,
    critical_care_beds_occupied
FROM operational.daily_operational_metrics
WHERE general_beds_occupied > general_beds_open
   OR critical_care_beds_occupied > critical_care_beds_open
   OR general_beds_open < 0
   OR general_beds_occupied < 0
   OR critical_care_beds_open < 0
   OR critical_care_beds_occupied < 0;


-- ============================================================
-- 7. INVALID A&E ACTIVITY
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    ae_attendances,
    four_hour_breaches
FROM operational.daily_operational_metrics
WHERE ae_attendances < 0
   OR four_hour_breaches < 0
   OR four_hour_breaches > ae_attendances;


-- ============================================================
-- 8. INVALID WORKFORCE VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
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
-- 9. INCIDENT STATUS AND RESOLUTION CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
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
      );


-- ============================================================
-- 10. WEATHER RANGE CHECKS
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    temperature_min_c,
    temperature_max_c,
    precipitation_mm,
    snowfall_mm,
    wind_speed_mph
FROM operational.weather_metrics
WHERE temperature_min_c > temperature_max_c
   OR precipitation_mm < 0
   OR snowfall_mm < 0
   OR wind_speed_mph < 0;


-- ============================================================
-- 11. OPEL RANGE AND APPROVAL CHECKS
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    assessment_timestamp,
    recommended_opel_level,
    approved_opel_level,
    prediction_confidence,
    approval_status,
    reviewed_by_role,
    reviewed_at
FROM operational.opel_assessments
WHERE recommended_opel_level NOT BETWEEN 1 AND 4
   OR approved_opel_level NOT BETWEEN 1 AND 4
   OR prediction_confidence NOT BETWEEN 0 AND 1
   OR (
        approval_status = 'approved'
        AND (
            reviewed_by_role IS NULL
            OR reviewed_at IS NULL
        )
      );


-- ============================================================
-- 12. REPORTING-DATE COVERAGE
-- Expected result:
-- 3 Trusts, 30 dates, 90 rows
-- ============================================================

SELECT
    COUNT(DISTINCT trust_id) AS trust_count,
    COUNT(DISTINCT reporting_date) AS reporting_date_count,
    COUNT(*) AS total_rows,
    MIN(reporting_date) AS earliest_date,
    MAX(reporting_date) AS latest_date
FROM operational.daily_operational_metrics;
