# Data Quality Test Results

## Test Environment

Database:

`nhs_operations_test`

## Overall Result

**Passed**

The synthetic healthcare dataset was tested for completeness, uniqueness, referential integrity, valid ranges, and logical consistency.

## Record Counts

| Table | Expected | Actual | Result |
|---|---:|---:|---|
| trusts | 3 | 3 | Passed |
| daily_operational_metrics | 90 | 90 | Passed |
| workforce_metrics | 90 | 90 | Passed |
| incidents | 24 | 24 | Passed |
| weather_metrics | 90 | 90 | Passed |
| opel_assessments | 90 | 90 | Passed |

## Reporting Coverage

| Check | Result |
|---|---|
| Number of Trusts | 3 |
| Number of reporting dates | 30 |
| Total operational rows | 90 |
| Earliest reporting date | 2026-01-01 |
| Latest reporting date | 2026-01-30 |

## Referential Integrity

No orphan records were identified in:

- daily operational metrics;
- workforce metrics;
- incidents;
- weather metrics;
- OPEL assessments.

## Uniqueness

No duplicate records were identified at the defined table grains.

Checks included:

- one daily operational row per Trust and reporting date;
- one workforce row per Trust, reporting date, and staff group;
- unique source record identifiers.

## Logical Validation

No invalid records were identified for:

- occupied beds exceeding available beds;
- four-hour breaches exceeding A&E attendances;
- negative operational or workforce values;
- inconsistent incident timestamps or resolution status;
- invalid weather ranges;
- OPEL levels outside 1–4;
- confidence values outside 0–1;
- incomplete approval-review information.

## Conclusion

The synthetic dataset is structurally complete and suitable for subsequent SQL analysis, reporting, dashboard development, and controlled pipeline testing.

Passing these tests does not validate real NHS performance, clinical safety, predictive accuracy, or model generalisability.
