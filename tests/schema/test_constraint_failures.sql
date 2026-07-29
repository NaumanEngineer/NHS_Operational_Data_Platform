
-- NHS Operational Data Platform
-- Day 3 constraint failure tests
--
-- Purpose:
-- Confirm that the PostgreSQL schema rejects invalid or incomplete records.
--
-- IMPORTANT:
-- Run each test separately in nhs_operations_test.
-- Errors are expected and indicate that the relevant constraint is working.
-- Replace trust_id = 1 if TEST01 has a different trust_id.


-- ============================================================
-- SETUP: Confirm the test Trust exists
-- Expected result: one row showing TEST01 and its trust_id
-- ============================================================

SELECT
    trust_id,
    trust_code,
    trust_name
FROM operational.trusts
WHERE trust_code = 'TEST01';


-- ============================================================
-- TEST 1: Missing Trust code
-- Expected result:
-- Rejected by the NOT NULL constraint on trusts.trust_code
-- ============================================================

INSERT INTO operational.trusts (
    trust_name,
    trust_type,
    region,
    source_system
)
VALUES (
    'Missing Code Trust',
    'Acute Trust',
    'Scotland',
    'synthetic_test'
);


-- ============================================================
-- TEST 2: Duplicate Trust code
-- Expected result:
-- Rejected by uq_trusts_trust_code
-- Expected SQLSTATE: 23505
-- ============================================================

INSERT INTO operational.trusts (
    trust_code,
    trust_name,
    trust_type,
    region,
    source_system
)
VALUES (
    'TEST01',
    'Duplicate Test Trust',
    'Acute Trust',
    'Scotland',
    'synthetic_test'
);


-- ============================================================
-- TEST 3: Negative operational value
-- Expected result:
-- Rejected by chk_daily_operational_metrics_non_negative
-- ============================================================

INSERT INTO operational.daily_operational_metrics (
    trust_id,
    reporting_date,
    general_beds_open,
    general_beds_occupied,
    source_system
)
VALUES (
    1,
    DATE '2026-07-29',
    -10,
    5,
    'synthetic_test'
);


-- ============================================================
-- TEST 4: General-bed occupancy above open capacity
-- Expected result:
-- Rejected by chk_daily_operational_beds
-- ============================================================

INSERT INTO operational.daily_operational_metrics (
    trust_id,
    reporting_date,
    general_beds_open,
    general_beds_occupied,
    source_system
)
VALUES (
    1,
    DATE '2026-07-30',
    400,
    450,
    'synthetic_test'
);


-- ============================================================
-- TEST 5: Critical-care occupancy above open capacity
-- Expected result:
-- Rejected by chk_daily_operational_critical_care_beds
-- ============================================================

INSERT INTO operational.daily_operational_metrics (
    trust_id,
    reporting_date,
    critical_care_beds_open,
    critical_care_beds_occupied,
    source_system
)
VALUES (
    1,
    DATE '2026-07-31',
    20,
    25,
    'synthetic_test'
);


-- ============================================================
-- TEST 6: Invalid OPEL level
-- Expected result:
-- Rejected by chk_opel_recommended_level
-- Valid OPEL levels are 1 to 4
-- ============================================================

INSERT INTO operational.opel_assessments (
    trust_id,
    assessment_timestamp,
    recommended_opel_level,
    assessment_method,
    source_system
)
VALUES (
    1,
    CURRENT_TIMESTAMP,
    5,
    'rules_based',
    'synthetic_test'
);


-- ============================================================
-- TEST 7: Workforce record for a Trust that does not exist
-- Expected result:
-- Rejected by fk_workforce_metrics_trust
-- ============================================================

INSERT INTO operational.workforce_metrics (
    trust_id,
    reporting_date,
    staff_group,
    establishment_fte,
    source_system
)
VALUES (
    999999,
    CURRENT_DATE,
    'Nursing and midwifery',
    100.00,
    'synthetic_test'
);


-- ============================================================
-- TEST 8: Incomplete approved OPEL assessment
-- Expected result:
-- Rejected by chk_opel_approved_record_complete
--
-- Reason:
-- An approved assessment requires:
-- approved_opel_level
-- reviewed_by_role
-- reviewed_at
-- ============================================================

INSERT INTO operational.opel_assessments (
    trust_id,
    assessment_timestamp,
    recommended_opel_level,
    approved_opel_level,
    assessment_method,
    approval_status,
    source_system
)
VALUES (
    1,
    CURRENT_TIMESTAMP,
    3,
    NULL,
    'analyst_supported',
    'approved',
    'synthetic_test'
);


-- ============================================================
-- POSITIVE CONTROL: Valid approved OPEL assessment
-- Expected result:
-- Accepted successfully
--
-- This proves that the table accepts a complete record while
-- retaining the recommendation and final approved decision.
-- ============================================================

INSERT INTO operational.opel_assessments (
    trust_id,
    assessment_timestamp,
    recommended_opel_level,
    approved_opel_level,
    prediction_confidence,
    assessment_method,
    approval_status,
    assessed_by_role,
    reviewed_by_role,
    reviewed_at,
    rule_version,
    source_system,
    data_quality_status
)
VALUES (
    1,
    CURRENT_TIMESTAMP,
    3,
    3,
    0.8700,
    'analyst_supported',
    'approved',
    'Operational Analyst',
    'Duty Director',
    CURRENT_TIMESTAMP,
    'rules_v1.0',
    'synthetic_test',
    'valid'
);


-- ============================================================
-- VERIFY THE VALID OPEL RECORD
-- Expected result:
-- At least one approved and valid OPEL assessment
-- ============================================================

SELECT
    opel_assessment_id,
    trust_id,
    recommended_opel_level,
    approved_opel_level,
    prediction_confidence,
    approval_status,
    reviewed_by_role,
    rule_version,
    data_quality_status
FROM operational.opel_assessments
ORDER BY opel_assessment_id;
