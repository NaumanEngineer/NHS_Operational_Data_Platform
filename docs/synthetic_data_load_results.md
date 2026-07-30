# Synthetic Data Load Results

## Test Environment

The synthetic dataset was loaded into:

`nhs_operations_test`

## Load Status

**Result: Passed**

The complete seed script executed successfully inside a PostgreSQL transaction.

## Final Record Counts

| Table | Expected | Actual | Result |
|---|---:|---:|---|
| trusts | 3 | 3 | Passed |
| daily_operational_metrics | 90 | 90 | Passed |
| workforce_metrics | 90 | 90 | Passed |
| incidents | 24 | 24 | Passed |
| weather_metrics | 90 | 90 | Passed |
| opel_assessments | 90 | 90 | Passed |

## Dataset Coverage

The loaded dataset contains:

- three fictional healthcare organisations;
- 30 reporting days from 1 January to 30 January 2026;
- daily operational-pressure records;
- workforce-capacity records;
- operational incidents;
- observed weather records;
- rules-based and human-approved OPEL assessments.

## Validation Outcome

The seed script validated the expected record counts before committing the transaction.

No partial load was retained.

## Defect Identified and Resolved

The initial load failed because the weather column names in the seed script did not match the deployed database schema.

The seed script was corrected to use the current schema column names and was then rerun successfully.

## Governance Statement

All organisations and operational values are fictional.

The dataset contains no patient-level or staff-identifiable information and must not be interpreted as evidence of real NHS performance.
