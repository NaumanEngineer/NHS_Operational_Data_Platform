-- NHS Operational Data Platform
-- Operational analysis queries
--
-- Purpose:
-- Analyse synthetic operational pressure across capacity,
-- emergency demand, workforce, incidents, weather and OPEL.
--
-- Run against: nhs_operations_test
--
-- Reporting period:
-- 2026-01-01 to 2026-01-30
--
-- Governance:
-- All organisations and values are fictional.
-- Results describe associations within the synthetic dataset only.
-- They must not be interpreted as real NHS performance evidence.


-- ============================================================
-- QUERY 1
-- Which Trust had the highest average general-bed occupancy?
-- ============================================================

SELECT
    t.trust_code,
    t.trust_name,

    ROUND(
        AVG(
            100.0 * d.general_beds_occupied
            / NULLIF(d.general_beds_open, 0)
        ),
        2
    ) AS average_general_bed_occupancy_pct,

    COUNT(*) AS reporting_days

FROM operational.daily_operational_metrics AS d

INNER JOIN operational.trusts AS t
    ON d.trust_id = t.trust_id

WHERE d.reporting_date BETWEEN
      DATE '2026-01-01' AND DATE '2026-01-30'

GROUP BY
    t.trust_code,
    t.trust_name

ORDER BY
    average_general_bed_occupancy_pct DESC,
    t.trust_code;


-- ============================================================
-- QUERY 2
-- Which Trust-dates had the highest A&E four-hour breach rates?
--
-- Returns the ten highest synthetic breach-rate days.
-- ============================================================

SELECT
    t.trust_code,
    t.trust_name,
    d.reporting_date,
    d.ae_attendances,
    d.four_hour_breaches,

    ROUND(
        100.0 * d.four_hour_breaches
        / NULLIF(d.ae_attendances, 0),
        2
    ) AS four_hour_breach_pct

FROM operational.daily_operational_metrics AS d

INNER JOIN operational.trusts AS t
    ON d.trust_id = t.trust_id

WHERE d.reporting_date BETWEEN
      DATE '2026-01-01' AND DATE '2026-01-30'

ORDER BY
    four_hour_breach_pct DESC,
    d.four_hour_breaches DESC,
    t.trust_code

LIMIT 10;


-- ============================================================
-- QUERY 3
-- How often did each Trust reach approved OPEL 3 or OPEL 4?
-- ============================================================

WITH daily_opel AS (
    SELECT
        o.trust_id,
        o.assessment_timestamp::DATE AS reporting_date,
        o.approved_opel_level,

        ROW_NUMBER() OVER (
            PARTITION BY
                o.trust_id,
                o.assessment_timestamp::DATE
            ORDER BY
                o.reviewed_at DESC NULLS LAST,
                o.assessment_timestamp DESC
        ) AS assessment_rank

    FROM operational.opel_assessments AS o

    WHERE o.assessment_timestamp::DATE BETWEEN
          DATE '2026-01-01' AND DATE '2026-01-30'
)

SELECT
    t.trust_code,
    t.trust_name,

    COUNT(*) FILTER (
        WHERE o.approved_opel_level IN (3, 4)
    ) AS opel_3_or_4_days,

    COUNT(*) FILTER (
        WHERE o.approved_opel_level = 3
    ) AS opel_3_days,

    COUNT(*) FILTER (
        WHERE o.approved_opel_level = 4
    ) AS opel_4_days,

    COUNT(*) AS assessed_days,

    ROUND(
        100.0 *
        COUNT(*) FILTER (
            WHERE o.approved_opel_level IN (3, 4)
        )
        / NULLIF(COUNT(*), 0),
        2
    ) AS opel_3_or_4_day_pct

FROM daily_opel AS o

INNER JOIN operational.trusts AS t
    ON o.trust_id = t.trust_id

WHERE o.assessment_rank = 1

GROUP BY
    t.trust_code,
    t.trust_name

ORDER BY
    opel_3_or_4_days DESC,
    t.trust_code;


-- ============================================================
-- QUERY 4
-- Was workforce pressure higher on approved OPEL 4 days?
--
-- Workforce pressure indicators:
-- absence percentage
-- agency FTE
-- bank FTE
-- unfilled shifts
--
-- This describes association, not causation.
-- ============================================================

WITH workforce_daily AS (
    SELECT
        trust_id,
        reporting_date,

        SUM(establishment_fte) AS establishment_fte,
        SUM(absence_fte) AS absence_fte,
        SUM(agency_fte) AS agency_fte,
        SUM(bank_fte) AS bank_fte,
        SUM(unfilled_shifts) AS unfilled_shifts

    FROM operational.workforce_metrics

    WHERE reporting_date BETWEEN
          DATE '2026-01-01' AND DATE '2026-01-30'

    GROUP BY
        trust_id,
        reporting_date
),

daily_opel AS (
    SELECT
        trust_id,
        assessment_timestamp::DATE AS reporting_date,
        approved_opel_level,

        ROW_NUMBER() OVER (
            PARTITION BY
                trust_id,
                assessment_timestamp::DATE
            ORDER BY
                reviewed_at DESC NULLS LAST,
                assessment_timestamp DESC
        ) AS assessment_rank

    FROM operational.opel_assessments

    WHERE assessment_timestamp::DATE BETWEEN
          DATE '2026-01-01' AND DATE '2026-01-30'
),

joined_data AS (
    SELECT
        w.trust_id,
        w.reporting_date,
        o.approved_opel_level,

        100.0 * w.absence_fte
        / NULLIF(w.establishment_fte, 0)
            AS workforce_absence_pct,

        w.agency_fte,
        w.bank_fte,
        w.unfilled_shifts

    FROM workforce_daily AS w

    INNER JOIN daily_opel AS o
        ON w.trust_id = o.trust_id
       AND w.reporting_date = o.reporting_date
       AND o.assessment_rank = 1
)

SELECT
    CASE
        WHEN approved_opel_level = 4
            THEN 'OPEL 4 days'
        ELSE 'Non-OPEL 4 days'
    END AS opel_day_group,

    COUNT(*) AS trust_days,

    ROUND(
        AVG(workforce_absence_pct),
        2
    ) AS average_workforce_absence_pct,

    ROUND(
        AVG(agency_fte),
        2
    ) AS average_agency_fte,

    ROUND(
        AVG(bank_fte),
        2
    ) AS average_bank_fte,

    ROUND(
        AVG(unfilled_shifts),
        2
    ) AS average_unfilled_shifts

FROM joined_data

GROUP BY
    CASE
        WHEN approved_opel_level = 4
            THEN 'OPEL 4 days'
        ELSE 'Non-OPEL 4 days'
    END

ORDER BY
    opel_day_group;


-- ============================================================
-- QUERY 5
-- Which Trust recorded the most red-flag incidents?
--
-- Project reporting definition:
-- severity_level IN ('high', 'critical')
--
-- This is a synthetic project rule and not an official
-- NHS red-flag classification.
-- ============================================================

SELECT
    t.trust_code,
    t.trust_name,

    COUNT(*) FILTER (
        WHERE i.severity_level IN ('high', 'critical')
    ) AS red_flag_incident_count,

    COUNT(*) FILTER (
        WHERE i.severity_level = 'critical'
    ) AS critical_incident_count,

    COUNT(*) FILTER (
        WHERE i.incident_status IN ('open', 'monitoring')
    ) AS unresolved_incident_count,

    COUNT(i.incident_reference) AS total_incident_count

FROM operational.trusts AS t

LEFT JOIN operational.incidents AS i
    ON t.trust_id = i.trust_id
   AND i.incident_started_at::DATE BETWEEN
       DATE '2026-01-01' AND DATE '2026-01-30'

GROUP BY
    t.trust_code,
    t.trust_name

ORDER BY
    red_flag_incident_count DESC,
    critical_incident_count DESC,
    t.trust_code;


-- ============================================================
-- QUERY 6
-- What was the average ambulance handover-delay percentage
-- by approved OPEL level?
--
-- The current schema stores delayed arrivals as a count.
-- It does not store average delay duration in minutes.
-- ============================================================

WITH daily_opel AS (
    SELECT
        trust_id,
        assessment_timestamp::DATE AS reporting_date,
        approved_opel_level,

        ROW_NUMBER() OVER (
            PARTITION BY
                trust_id,
                assessment_timestamp::DATE
            ORDER BY
                reviewed_at DESC NULLS LAST,
                assessment_timestamp DESC
        ) AS assessment_rank

    FROM operational.opel_assessments

    WHERE assessment_timestamp::DATE BETWEEN
          DATE '2026-01-01' AND DATE '2026-01-30'
)

SELECT
    o.approved_opel_level,

    COUNT(*) AS trust_days,

    SUM(d.ambulance_arrivals) AS total_ambulance_arrivals,

    SUM(d.ambulance_handover_delays)
        AS total_delayed_handover_arrivals,

    ROUND(
        100.0 * SUM(d.ambulance_handover_delays)
        / NULLIF(SUM(d.ambulance_arrivals), 0),
        2
    ) AS weighted_ambulance_delay_pct,

    ROUND(
        AVG(
            100.0 * d.ambulance_handover_delays
            / NULLIF(d.ambulance_arrivals, 0)
        ),
        2
    ) AS average_daily_ambulance_delay_pct

FROM operational.daily_operational_metrics AS d

INNER JOIN daily_opel AS o
    ON d.trust_id = o.trust_id
   AND d.reporting_date = o.reporting_date
   AND o.assessment_rank = 1

WHERE d.reporting_date BETWEEN
      DATE '2026-01-01' AND DATE '2026-01-30'

GROUP BY
    o.approved_opel_level

ORDER BY
    o.approved_opel_level;


-- ============================================================
-- QUERY 7
-- Did lower temperature coincide with greater operational pressure?
--
-- Temperature bands are project-defined analytical groupings.
-- Results describe association within synthetic data only.
-- ============================================================

WITH observed_weather AS (
    SELECT
        trust_id,
        reporting_date,

        MIN(temperature_min_c) AS temperature_min_c,
        MAX(temperature_max_c) AS temperature_max_c

    FROM operational.weather_metrics

    WHERE observation_type = 'observed'
      AND reporting_date BETWEEN
          DATE '2026-01-01' AND DATE '2026-01-30'

    GROUP BY
        trust_id,
        reporting_date
),

daily_opel AS (
    SELECT
        trust_id,
        assessment_timestamp::DATE AS reporting_date,
        approved_opel_level,

        ROW_NUMBER() OVER (
            PARTITION BY
                trust_id,
                assessment_timestamp::DATE
            ORDER BY
                reviewed_at DESC NULLS LAST,
                assessment_timestamp DESC
        ) AS assessment_rank

    FROM operational.opel_assessments

    WHERE assessment_timestamp::DATE BETWEEN
          DATE '2026-01-01' AND DATE '2026-01-30'
),

joined_data AS (
    SELECT
        d.trust_id,
        d.reporting_date,
        w.temperature_min_c,
        w.temperature_max_c,
        o.approved_opel_level,

        100.0 * d.general_beds_occupied
        / NULLIF(d.general_beds_open, 0)
            AS general_bed_occupancy_pct,

        100.0 * d.four_hour_breaches
        / NULLIF(d.ae_attendances, 0)
            AS four_hour_breach_pct,

        100.0 * d.ambulance_handover_delays
        / NULLIF(d.ambulance_arrivals, 0)
            AS ambulance_delay_pct

    FROM operational.daily_operational_metrics AS d

    INNER JOIN observed_weather AS w
        ON d.trust_id = w.trust_id
       AND d.reporting_date = w.reporting_date

    INNER JOIN daily_opel AS o
        ON d.trust_id = o.trust_id
       AND d.reporting_date = o.reporting_date
       AND o.assessment_rank = 1
)

SELECT
    CASE
        WHEN temperature_min_c < 0
            THEN 'Below 0°C'
        WHEN temperature_min_c < 3
            THEN '0°C to below 3°C'
        ELSE '3°C and above'
    END AS minimum_temperature_band,

    COUNT(*) AS trust_days,

    ROUND(
        AVG(temperature_min_c),
        2
    ) AS average_minimum_temperature_c,

    ROUND(
        AVG(general_bed_occupancy_pct),
        2
    ) AS average_general_bed_occupancy_pct,

    ROUND(
        AVG(four_hour_breach_pct),
        2
    ) AS average_four_hour_breach_pct,

    ROUND(
        AVG(ambulance_delay_pct),
        2
    ) AS average_ambulance_delay_pct,

    ROUND(
        AVG(approved_opel_level),
        2
    ) AS average_approved_opel_level,

    COUNT(*) FILTER (
        WHERE approved_opel_level IN (3, 4)
    ) AS opel_3_or_4_trust_days

FROM joined_data

GROUP BY
    CASE
        WHEN temperature_min_c < 0
            THEN 'Below 0°C'
        WHEN temperature_min_c < 3
            THEN '0°C to below 3°C'
        ELSE '3°C and above'
    END

ORDER BY
    MIN(temperature_min_c);
