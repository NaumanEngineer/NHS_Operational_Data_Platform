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
-- 4. DUPLICATE INCIDENT REFERENCES
-- Expected result: 0 rows
-- ============================================================

SELECT
    source_system,
    incident_reference,
    COUNT(*) AS duplicate_count
FROM operational.incidents
GROUP BY
    source_system,
    incident_reference
HAVING COUNT(*) > 1;


-- ============================================================
-- 5. DUPLICATE DAILY SOURCE RECORD IDENTIFIERS
-- Expected result: 0 rows
-- ============================================================

SELECT
    source_system,
    source_record_id,
    COUNT(*) AS duplicate_count
FROM operational.daily_operational_metrics
GROUP BY
    source_system,
    source_record_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 6. MISSING DAILY OPERATIONAL VALUES
-- Expected result: 0 rows
--
-- Bed occupancy percentage is calculated rather than stored.
-- The source capacity fields are checked for missing values.
-- ============================================================

SELECT
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
    discharges
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
   OR ambulance_handover_delays IS NULL
   OR patients_ready_for_discharge IS NULL
   OR admissions IS NULL
   OR discharges IS NULL;


-- ============================================================
-- 7. MISSING WORKFORCE VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
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
WHERE trust_id IS NULL
   OR reporting_date IS NULL
   OR staff_group IS NULL
   OR establishment_fte IS NULL
   OR substantive_fte IS NULL
   OR absence_fte IS NULL
   OR agency_fte IS NULL
   OR bank_fte IS NULL
   OR unfilled_shifts IS NULL;


-- ============================================================
-- 8. IMPOSSIBLE BED VALUES
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
WHERE general_beds_open < 0
   OR general_beds_occupied < 0
   OR critical_care_beds_open < 0
   OR critical_care_beds_occupied < 0
   OR general_beds_occupied > general_beds_open
   OR critical_care_beds_occupied > critical_care_beds_open;


-- ============================================================
-- 9. IMPOSSIBLE CALCULATED BED OCCUPANCY
-- Expected result: 0 rows
--
-- The broad 120% threshold is retained from the Day 5 brief.
-- Existing table constraints should prevent occupancy above 100%.
-- ============================================================

WITH calculated_occupancy AS (
    SELECT
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
SELECT
    trust_id,
    reporting_date,
    general_bed_occupancy_pct,
    critical_care_occupancy_pct
FROM calculated_occupancy
WHERE general_bed_occupancy_pct < 0
   OR general_bed_occupancy_pct > 120
   OR critical_care_occupancy_pct < 0
   OR critical_care_occupancy_pct > 120;


-- ============================================================
-- 10. ZERO OPEN-BED CAPACITY
-- Expected result: review only
--
-- Zero capacity is not automatically treated as invalid because
-- some service types may legitimately report no beds.
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    general_beds_open,
    critical_care_beds_open
FROM operational.daily_operational_metrics
WHERE general_beds_open = 0
   OR critical_care_beds_open = 0;


-- ============================================================
-- 11. INVALID A&E ACTIVITY
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
-- 12. INVALID AMBULANCE ACTIVITY
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    ambulance_arrivals,
    ambulance_handover_delays
FROM operational.daily_operational_metrics
WHERE ambulance_arrivals < 0
   OR ambulance_handover_delays < 0
   OR ambulance_handover_delays > ambulance_arrivals;


-- ============================================================
-- 13. INVALID ADMISSIONS AND DISCHARGE VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    patients_ready_for_discharge,
    admissions,
    discharges
FROM operational.daily_operational_metrics
WHERE patients_ready_for_discharge < 0
   OR admissions < 0
   OR discharges < 0;


-- ============================================================
-- 14. INVALID WORKFORCE VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
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
-- 15. WORKFORCE LOGICAL CONSISTENCY
-- Expected result: 0 rows
--
-- Flags records where substantive staffing exceeds the
-- established workforce capacity.
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    staff_group,
    establishment_fte,
    substantive_fte
FROM operational.workforce_metrics
WHERE substantive_fte > establishment_fte;


-- ============================================================
-- 16. ORPHAN RECORDS
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
-- 17. INCIDENT TIMESTAMP AND STATUS CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
    incident_reference,
    incident_status,
    severity_level,
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
   )

   OR (
        incident_resolved_at IS NOT NULL
        AND incident_resolved_at < incident_reported_at
   );


-- ============================================================
-- 18. INVALID INCIDENT CONTROLLED VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
    incident_reference,
    severity_level,
    incident_status
FROM operational.incidents
WHERE severity_level NOT IN (
        'low',
        'moderate',
        'high',
        'critical'
    )
   OR incident_status NOT IN (
        'open',
        'monitoring',
        'resolved'
    );


-- ============================================================
-- 19. WEATHER VALUE CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
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
-- 20. INVALID WEATHER CONTROLLED VALUES
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    reporting_date,
    observation_type,
    weather_warning_level,
    weather_warning_type
FROM operational.weather_metrics
WHERE observation_type NOT IN (
        'observed',
        'forecast'
    )

   OR (
        weather_warning_level IS NOT NULL
        AND weather_warning_level NOT IN (
            'yellow',
            'amber',
            'red'
        )
   );


-- ============================================================
-- 21. OPEL VALUE AND APPROVAL CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
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

   OR (
        approved_opel_level IS NOT NULL
        AND approved_opel_level NOT BETWEEN 1 AND 4
   )

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
-- 22. OPEL REVIEW TIMESTAMP CONSISTENCY
-- Expected result: 0 rows
-- ============================================================

SELECT
    trust_id,
    assessment_timestamp,
    approval_status,
    reviewed_by_role,
    reviewed_at
FROM operational.opel_assessments
WHERE reviewed_at IS NOT NULL
  AND reviewed_at < assessment_timestamp;


-- ============================================================
-- 23. MISSING REPORTING DATES BY TRUST
-- Expected result: 0 rows
--
-- Creates a complete calendar from the earliest to latest
-- operational reporting date and searches for gaps.
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
WHERE dom.trust_id IS NULL
ORDER BY
    etd.trust_code,
    etd.reporting_date;


-- ============================================================
-- 24. MISSING WORKFORCE DATES
-- Expected result: 0 rows
-- ============================================================

SELECT
    d.trust_id,
    t.trust_code,
    t.trust_name,
    d.reporting_date
FROM operational.daily_operational_metrics AS d
INNER JOIN operational.trusts AS t
    ON d.trust_id = t.trust_id
LEFT JOIN operational.workforce_metrics AS w
    ON d.trust_id = w.trust_id
   AND d.reporting_date = w.reporting_date
   AND w.staff_group = 'All operational staff'
WHERE w.trust_id IS NULL
ORDER BY
    t.trust_code,
    d.reporting_date;


-- ============================================================
-- 25. MISSING OBSERVED WEATHER DATES
-- Expected result: 0 rows
-- ============================================================

SELECT
    d.trust_id,
    t.trust_code,
    t.trust_name,
    d.reporting_date
FROM operational.daily_operational_metrics AS d
INNER JOIN operational.trusts AS t
    ON d.trust_id = t.trust_id
LEFT JOIN operational.weather_metrics AS wm
    ON d.trust_id = wm.trust_id
   AND d.reporting_date = wm.reporting_date
   AND wm.observation_type = 'observed'
WHERE wm.trust_id IS NULL
ORDER BY
    t.trust_code,
    d.reporting_date;


-- ============================================================
-- 26. MISSING OPEL ASSESSMENT DATES
-- Expected result: 0 rows
-- ============================================================

SELECT
    d.trust_id,
    t.trust_code,
    t.trust_name,
    d.reporting_date
FROM operational.daily_operational_metrics AS d
INNER JOIN operational.trusts AS t
    ON d.trust_id = t.trust_id
LEFT JOIN operational.opel_assessments AS o
    ON d.trust_id = o.trust_id
   AND d.reporting_date = o.assessment_timestamp::DATE
WHERE o.trust_id IS NULL
ORDER BY
    t.trust_code,
    d.reporting_date;


-- ============================================================
-- 27. REPORTING COVERAGE SUMMARY
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
-- 28. RECORD COUNT BY TRUST
-- Expected: 30 operational rows per Trust
-- ============================================================

SELECT
    t.trust_code,
    t.trust_name,
    COUNT(d.trust_id) AS operational_record_count,
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

-- ============================================================
-- 29. COMPLETE VALIDATION SUMMARY
-- Run this entire section together.
-- Expected: every failed-record count equals 0
-- ============================================================

WITH duplicate_daily AS (
    SELECT COUNT(*) AS failed_records
    FROM (
        SELECT
            trust_id,
            reporting_date
        FROM operational.daily_operational_metrics
        GROUP BY
            trust_id,
            reporting_date
        HAVING COUNT(*) > 1
    ) AS duplicate_records
),

missing_daily_values AS (
    SELECT COUNT(*) AS failed_records
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
       OR ambulance_handover_delays IS NULL
       OR patients_ready_for_discharge IS NULL
       OR admissions IS NULL
       OR discharges IS NULL
),

invalid_bed_values AS (
    SELECT COUNT(*) AS failed_records
    FROM operational.daily_operational_metrics
    WHERE general_beds_open < 0
       OR general_beds_occupied < 0
       OR critical_care_beds_open < 0
       OR critical_care_beds_occupied < 0
       OR general_beds_occupied > general_beds_open
       OR critical_care_beds_occupied > critical_care_beds_open
),

invalid_ae_values AS (
    SELECT COUNT(*) AS failed_records
    FROM operational.daily_operational_metrics
    WHERE ae_attendances < 0
       OR four_hour_breaches < 0
       OR four_hour_breaches > ae_attendances
),

orphan_records AS (
    SELECT
        (
            SELECT COUNT(*)
            FROM operational.daily_operational_metrics AS d
            LEFT JOIN operational.trusts AS t
                ON d.trust_id = t.trust_id
            WHERE t.trust_id IS NULL
        )
        +
        (
            SELECT COUNT(*)
            FROM operational.workforce_metrics AS w
            LEFT JOIN operational.trusts AS t
                ON w.trust_id = t.trust_id
            WHERE t.trust_id IS NULL
        )
        +
        (
            SELECT COUNT(*)
            FROM operational.incidents AS i
            LEFT JOIN operational.trusts AS t
                ON i.trust_id = t.trust_id
            WHERE t.trust_id IS NULL
        )
        +
        (
            SELECT COUNT(*)
            FROM operational.weather_metrics AS wm
            LEFT JOIN operational.trusts AS t
                ON wm.trust_id = t.trust_id
            WHERE t.trust_id IS NULL
        )
        +
        (
            SELECT COUNT(*)
            FROM operational.opel_assessments AS o
            LEFT JOIN operational.trusts AS t
                ON o.trust_id = t.trust_id
            WHERE t.trust_id IS NULL
        ) AS failed_records
),

reporting_boundaries AS (
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
        d.reporting_date
    FROM operational.trusts AS t
    CROSS JOIN expected_dates AS d
    WHERE t.active_flag = TRUE
),

missing_reporting_dates AS (
    SELECT COUNT(*) AS failed_records
    FROM expected_trust_dates AS etd
    LEFT JOIN operational.daily_operational_metrics AS dom
        ON etd.trust_id = dom.trust_id
       AND etd.reporting_date = dom.reporting_date
    WHERE dom.trust_id IS NULL
)

SELECT
    1 AS check_order,
    'Duplicate daily records' AS validation_check,
    failed_records,
    CASE
        WHEN failed_records = 0 THEN 'Passed'
        ELSE 'Failed'
    END AS result
FROM duplicate_daily

UNION ALL

SELECT
    2,
    'Missing daily values',
    failed_records,
    CASE
        WHEN failed_records = 0 THEN 'Passed'
        ELSE 'Failed'
    END
FROM missing_daily_values

UNION ALL

SELECT
    3,
    'Invalid bed values',
    failed_records,
    CASE
        WHEN failed_records = 0 THEN 'Passed'
        ELSE 'Failed'
    END
FROM invalid_bed_values

UNION ALL

SELECT
    4,
    'Invalid A&E values',
    failed_records,
    CASE
        WHEN failed_records = 0 THEN 'Passed'
        ELSE 'Failed'
    END
FROM invalid_ae_values

UNION ALL

SELECT
    5,
    'Orphan records',
    failed_records,
    CASE
        WHEN failed_records = 0 THEN 'Passed'
        ELSE 'Failed'
    END
FROM orphan_records

UNION ALL

SELECT
    6,
    'Missing reporting dates',
    failed_records,
    CASE
        WHEN failed_records = 0 THEN 'Passed'
        ELSE 'Failed'
    END
FROM missing_reporting_dates

ORDER BY check_order;
