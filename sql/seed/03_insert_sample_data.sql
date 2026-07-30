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


-- COMMIT will be added after all synthetic data sections are complete.
