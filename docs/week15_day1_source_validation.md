# Week 15 Day 1 — Power BI Source Validation

## Session Objective

Day 1 focused on connecting Power BI to the validated PostgreSQL analytical source, inspecting the real source structure, validating reporting grain and source readiness, and preparing a modelling-ready Power Query layer.

---

## Source Connection

Power BI was connected to:

`nhs_operations_test`

using the PostgreSQL connector in Import mode.

The analytical source used was:

`operational.vw_trust_daily_analytical`

The Power Query source query was renamed:

`SourceTrustDailyAnalytical`

The underlying PostgreSQL view name remains unchanged.

---

## Reporting Grain Validation

The analytical source uses the expected Trust-date grain:

**One row per fictional Trust per reporting date**

Expected full-dataset structure:

- 3 fictional Trusts;
- 30 reporting dates;
- 90 Trust-date rows.

The source was reviewed in Power Query before semantic modelling began.

---

## Core Trust Fields Confirmed

The source contains:

- `trust_id`
- `trust_code`
- `trust_name`
- `trust_type`
- `region`
- `reporting_date`

Current fictional Trust codes include:

- `WGH001`
- `NRT002`
- `SCT003`

---

## Capacity Fields Confirmed

The source contains both raw bed counts and percentage fields:

- `general_beds_open`
- `general_beds_occupied`
- `general_bed_occupancy_pct`
- `critical_care_beds_open`
- `critical_care_beds_occupied`
- `critical_care_occupancy_pct`

This means weighted occupancy measures can be implemented after QA.

---

## A&E Fields Confirmed

The source contains:

- `ae_attendances`
- `four_hour_breaches`
- `four_hour_breach_pct`

This means the weighted A&E four-hour breach rate no longer needs to remain blocked because of missing source fields.

Planned DAX:

```DAX
Weighted A&E Four-Hour Breach Rate =
DIVIDE(
    SUM(FactTrustDailyOperations[four_hour_breaches]),
    SUM(FactTrustDailyOperations[ae_attendances])
)
