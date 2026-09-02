# Power BI Acceptance Testing and UAT

## Purpose

This document defines and records acceptance testing for the NHS Operational Data Platform Power BI semantic model and reporting layer.

Testing covers:

- source-data integrity;
- semantic-model relationships;
- KPI calculations;
- source-readiness dependencies;
- filter-context behaviour;
- drill-through behaviour;
- governance controls;
- accessibility and usability.

The project uses synthetic data only.

The Power BI implementation is a portfolio demonstration and must not be used for real NHS operational or clinical decision-making.

---

# 1. Test Status Definitions

| Status | Meaning |
|---|---|
| Pass | Test executed and expected result achieved |
| Fail | Test executed and expected result not achieved |
| Blocked | Test cannot be completed because a required source definition or dependency remains unresolved |
| Deferred | Functionality intentionally excluded from the current implementation scope |
| Not run | Test has not yet been executed |

---

# 2. Reconciliation Tolerances

The following tolerances apply when comparing Power BI calculations with PostgreSQL.

| Metric type | Accepted tolerance |
|---|---:|
| Counts | Exact match |
| Distinct counts | Exact match |
| Categorical values | Exact match |
| Percentages | ±0.01 percentage points |
| Averages | ±0.01 |
| FTE values | ±0.01 |

A formatting difference is not considered a calculation failure when the underlying numeric result is equivalent.

---

# 3. Validated Source Baseline

Power BI currently uses:

`nhs_operations_test`

Source analytical view:

`operational.vw_trust_daily_analytical`

Validated PostgreSQL baseline:

| Validation | Expected / SQL Result |
|---|---:|
| Fact rows | 90 |
| Fictional Trusts | 3 |
| Reporting dates | 30 |
| Minimum reporting date | 2026-01-01 |
| Maximum reporting date | 2026-01-30 |
| Duplicate Trust-date rows | 0 |
| Rows per Trust | 30 |
| Total A&E attendances | 25,800 |
| Total four-hour breaches | 5,113 |
| Weighted A&E four-hour breach rate | 19.82% |
| Total admissions | 16,425 |
| Total discharges | 15,654 |
| Net admissions | 771 |
| Calculated net admissions | 771 |
| OPEL 3–4 Trust-days | 39 |
| OPEL 4 Trust-days | 7 |
| Human overrides | 4 |
| Recommended/approved OPEL mismatches | 4 |
| High operational-pressure Trust-days | 39 |
| Weather-warning Trust-days | 20 |
| No-warning Trust-days | 70 |

Pressure-status distribution:

| Pressure Status | Trust-days |
|---|---:|
| Routine pressure | 21 |
| Moderate pressure | 30 |
| Significant pressure | 32 |
| Critical pressure | 7 |
| Total | 90 |

Weather-warning distribution:

| Warning Level | Warning Type | Trust-days |
|---|---|---:|
| null | null | 70 |
| yellow | ice | 12 |
| yellow | wind | 6 |
| amber | snow and ice | 2 |

The combined null/null weather-warning state is represented in the semantic model as:

`No warning`

while the original source null values remain preserved.

---

# 4. DATA Tests

## DATA-001 — Fact Row Count

**Objective:** Confirm Power BI contains the expected Trust-date fact rows.

Expected:

`90`

Observed:

`90`

**Status: Pass**

Evidence:

PostgreSQL and Power BI both return 90 Trust-date records.

---

## DATA-002 — Trust Count

**Objective:** Confirm the model contains exactly three fictional Trusts.

Expected:

`3`

Expected Trust codes:

- WGH001
- NRT002
- SCT003

**Status: Pass**

---

## DATA-003 — Reporting-Date Count

**Objective:** Confirm the source contains 30 distinct reporting dates.

Expected:

`30`

**Status: Pass**

---

## DATA-004 — Reporting-Date Range

Expected:

- Minimum = 2026-01-01
- Maximum = 2026-01-30

**Status: Pass**

---

## DATA-005 — Duplicate Trust-Date Validation

Expected duplicate Trust-date combinations:

`0`

Observed:

`0`

**Status: Pass**

---

## DATA-006 — Rows Per Trust

Expected:

| Trust | Rows |
|---|---:|
| WGH001 | 30 |
| NRT002 | 30 |
| SCT003 | 30 |

**Status: Pass**

---

## DATA-007 — Dimension-Key Coverage

**Objective:** Confirm fact records map to the implemented Trust, Date, OPEL, pressure-status and weather-warning dimensions without unexpected orphan members.

Weather-warning mapping was corrected after reconciliation identified the previously omitted:

`yellow - wind`

combination.

Final weather dimension contains:

- No warning
- yellow - ice
- yellow - wind
- amber - snow and ice

**Status: Pass**

---

# 5. REL Relationship Tests

## REL-001 — Date Relationship

Relationship:

`DimDate[Date]`

→

`FactTrustDailyOperations[reporting_date]`

Expected:

- one-to-many;
- active;
- single direction;
- dimension on one side.

**Status: Pass**

---

## REL-002 — Trust Relationship

Relationship:

`DimTrust[trust_id]`

→

`FactTrustDailyOperations[trust_id]`

Expected:

- one-to-many;
- active;
- single direction.

**Status: Pass**

---

## REL-003 — OPEL Relationship

Relationship:

`DimOPEL[OPELLevel]`

→

`FactTrustDailyOperations[approved_opel_level]`

Approved OPEL is used as the primary human-reviewed operational outcome.

**Status: Pass**

---

## REL-004 — Pressure-Status Relationship

Relationship:

`DimPressureStatus[PressureStatus]`

→

`FactTrustDailyOperations[operational_pressure_status]`

Expected:

- one-to-many;
- active;
- single direction.

**Status: Pass**

---

## REL-005 — Weather-Warning Relationship

Relationship:

`DimWeatherWarning[WeatherWarningKey]`

→

`FactTrustDailyOperations[WeatherWarningKey]`

The dimension was corrected to include:

`yellow - wind`

after SQL reconciliation.

**Status: Pass**

---

## REL-006 — Relationship Architecture

Validate:

- no many-to-many primary relationships;
- no unnecessary bidirectional filters;
- no duplicate active relationship paths;
- dimensions filter the fact table.

**Status: Pass**

---

# 6. KPI Tests

## KPI-001 — Total A&E Attendances

PostgreSQL:

`25,800`

Power BI measure:

`[Total A&E Attendances]`

Expected:

`25,800`

**Status: Pass**

---

## KPI-002 — Total Four-Hour Breaches

PostgreSQL:

`5,113`

Power BI:

`[Total Four-Hour Breaches]`

Expected:

`5,113`

**Status: Pass**

---

## KPI-003 — Weighted A&E Four-Hour Breach Rate

Calculation:

`SUM(four_hour_breaches) / SUM(ae_attendances)`

PostgreSQL:

`19.82%`

Power BI:

`[Weighted A&E Four-Hour Breach Rate]`

Expected tolerance:

±0.01 percentage points

**Status: Pass**

This KPI was previously blocked during Week 14 because the design-stage source assessment did not confirm the raw numerator.

Week 15 source inspection confirmed:

- `four_hour_breaches`
- `ae_attendances`

The KPI is therefore no longer blocked.

---

## KPI-004 — Total Admissions

PostgreSQL:

`16,425`

Power BI:

`[Total Admissions]`

**Status: Pass**

---

## KPI-005 — Total Discharges

PostgreSQL:

`15,654`

Power BI:

`[Total Discharges]`

**Status: Pass**

---

## KPI-006 — Net Admissions

PostgreSQL:

`771`

Calculated PostgreSQL:

`16,425 - 15,654 = 771`

Power BI:

`[Net Admissions]`

Expected variance:

`0`

**Status: Pass**

---

## KPI-007 — Weighted General-Bed Occupancy

Power BI calculation:

`SUM(general_beds_occupied) / SUM(general_beds_open)`

Raw numerator and denominator are available in the validated source.

Final SQL-to-DAX reconciliation should remain within:

±0.01 percentage points.

**Status: Pass**

---

## KPI-008 — Weighted Critical-Care Occupancy

Power BI calculation:

`SUM(critical_care_beds_occupied) / SUM(critical_care_beds_open)`

Raw numerator and denominator are available.

Expected tolerance:

±0.01 percentage points.

**Status: Pass**

---

## KPI-009 — Weighted Workforce Absence

Power BI calculation:

`SUM(absence_fte) / SUM(establishment_fte)`

Raw numerator and denominator are available.

Expected tolerance:

±0.01 percentage points.

**Status: Pass**

---

## KPI-010 — OPEL 3–4 Days

PostgreSQL:

`39`

Power BI:

`[OPEL 3-4 Days]`

Observed Trust-level results:

- NRT002 = 17
- SCT003 = 7
- WGH001 = 15

Total:

`39`

**Status: Pass**

---

## KPI-011 — OPEL 4 Days

PostgreSQL:

`7`

Power BI:

`[OPEL 4 Days]`

Observed:

WGH001 = 7

No OPEL 4 records were observed for the other two Trusts.

**Status: Pass**

---

## KPI-012 — Human Override Count

PostgreSQL:

`4`

Power BI:

`[Human Override Count]`

Observed:

- NRT002 = 1
- SCT003 = 1
- WGH001 = 2

Total:

`4`

Human Override Percentage overall:

`4.44%`

**Status: Pass**

---

# 7. BLOCK / Source-Readiness Tests

## BLOCK-001 — Weighted A&E Source Availability

Required fields:

- `four_hour_breaches`
- `ae_attendances`

Both confirmed.

Weighted calculation reconciled with PostgreSQL.

**Status: Pass**

Previous Week 14 status:

`Blocked`

Current status:

`Ready / validated`

---

## BLOCK-002 — Ambulance Handover Definition

Available fields:

- `ambulance_arrivals`
- `ambulance_handover_delays`
- `ambulance_handover_delay_pct`

The raw fields support technical calculation of:

`ambulance_handover_delays / ambulance_arrivals`

However, the business meaning of `ambulance_handover_delays` requires explicit confirmation before the measure is represented as fully governed.

It must not be assumed to represent minutes.

**Status: Blocked**

Reason:

Source-definition clarification required.

---

## BLOCK-003 — Recommended vs Approved OPEL

Fields confirmed:

- `recommended_opel_level`
- `approved_opel_level`
- `human_override_indicator`

PostgreSQL:

- mismatches = 4
- human overrides = 4

Power BI reconciliation variance:

`0`

**Status: Pass**

Previous Week 14 status:

`Blocked`

Current status:

`Ready / validated`

---

## BLOCK-004 — Incident KPI Integration

Incident data exists at a different grain and was intentionally not integrated into the current Trust-date Power BI fact table.

A separate incident fact model or controlled aggregation design is required before incident KPIs are introduced.

**Status: Deferred**

---

# 8. FILTER Tests

## FILTER-001 — Trust Filter

Expected:

Each individual Trust returns:

`30 fact rows`

Observed:

- WGH001 = 30
- NRT002 = 30
- SCT003 = 30

**Status: Pass**

---

## FILTER-002 — Date-Range Filter

Example:

10-day date range × 3 Trusts

Expected:

`30 rows`

One Trust × 10-day range:

`10 rows`

**Status: Pass**

---

## FILTER-003 — OPEL 4 Filter

Expected:

`7`

**Status: Pass**

---

## FILTER-004 — OPEL 3–4 Filter

Expected:

`39`

**Status: Pass**

---

## FILTER-005 — High Pressure Filter

Categories:

- Significant pressure = 32
- Critical pressure = 7

Expected combined fact count:

`39`

**Status: Pass**

---

## FILTER-006 — Weather-Warning Filter

Expected:

| Filter | Fact rows |
|---|---:|
| yellow - ice | 12 |
| yellow - wind | 6 |
| amber - snow and ice | 2 |
| Any warning | 20 |

**Status: Pass**

---

## FILTER-007 — No-Weather-Warning Filter

Expected:

`70`

because:

`90 total - 20 warning Trust-days = 70`

**Status: Pass**

---

# 9. DRILL Tests

## DRILL-001 — Trust-Day Investigation Drill-Through

Validate navigation from summary reporting to a Trust-day investigation page.

**Status: Not run**

Reason:

Final dashboard drill-through page has not yet been implemented.

---

## DRILL-002 — Drill-Through Filter Preservation

Validate Trust/date context is retained correctly when navigating to investigation detail.

**Status: Not run**

---

## DRILL-003 — Return Navigation

Validate users can return safely from investigation detail to originating summary page.

**Status: Not run**

---

# 10. GOV Governance Tests

## GOV-001 — Approved OPEL Governance

Approved OPEL is retained as the primary operational outcome.

Recommended OPEL remains separate.

**Status: Pass**

---

## GOV-002 — Human Override Auditability

The model retains:

- recommended OPEL;
- approved OPEL;
- human override indicator;
- assessment method;
- assessment rationale;
- review roles;
- review timestamp;
- rule version.

Override count reconciles with recommendation/approval mismatches.

**Status: Pass**

---

## GOV-003 — Synthetic-Data Disclaimer

The project is explicitly documented as using synthetic data.

No real patient or staff-identifiable data is included.

The model must not be represented as a production NHS decision-support system.

**Status: Pass**

---

## GOV-004 — Project-Defined Pressure Rules

Pressure statuses are explicitly treated as:

`Project-defined illustrative rules`

Observed categories:

- Routine pressure
- Moderate pressure
- Significant pressure
- Critical pressure

They must not be presented as official NHS thresholds.

**Status: Pass**

---

## GOV-005 — Lineage and Audit Fields

The fact model retains:

- `operational_source_system`
- `operational_source_record_id`
- `load_batch_id`
- `data_quality_status`

These may be hidden from ordinary report users while remaining available for auditability and QA.

**Status: Pass**

---

# 11. ACC Accessibility and Usability Tests

## ACC-001 — Colour Contrast

Validate report colours meet reasonable accessibility and contrast requirements.

**Status: Not run**

Reason:

Final dashboard visual design has not yet been implemented.

---

## ACC-002 — Non-Colour Encoding

Validate important operational states are not communicated using colour alone.

**Status: Not run**

---

## ACC-003 — Visual Titles and Labels

Validate visuals use clear titles, units and business terminology.

**Status: Not run**

---

## ACC-004 — Keyboard / Navigation Usability

Validate page navigation and interactive controls are usable and logically ordered.

**Status: Not run**

---

## ACC-005 — KPI Definition Accessibility

Validate users can reach KPI definitions, limitations and governance guidance from the final report.

**Status: Not run**

---

# 12. Additional Data-Quality Evidence

## Duplicate Trust-Date Count

Power BI:

`[Duplicate Trust-Date Count]`

Expected:

`0`

**Result: Pass**

---

## Reporting Completeness

Power BI:

`[Reporting Completeness Percentage]`

Expected full-dataset result:

`100%`

**Result: Pass**

---

## Net Admissions Reconciliation

Power BI:

`[Net Admissions Variance]`

Expected:

`0`

**Result: Pass**

---

## A&E Rate Reconciliation

Power BI:

`[A&E Breach Rate QA]`

Expected:

`0`

**Result: Pass**

---

## Workforce Absence Reconciliation

Power BI:

`[Workforce Absence Difference]`

Expected:

`0`

**Result: Pass**

---

## Override Reconciliation

Power BI:

`[Override Reconciliation Variance]`

Expected:

`0`

Observed:

- recommendation/approval mismatches = 4
- human overrides = 4

**Result: Pass**

---

# 13. Known Data Semantics

## Previous Approved OPEL

`previous_approved_opel_level` contains expected structural nulls.

The first reporting date for each Trust has no previous assessment.

These nulls must not be automatically converted to OPEL 0.

---

## Weather Warning

Source reconciliation identified four valid weather-warning combinations:

- null / null
- yellow / ice
- yellow / wind
- amber / snow and ice

The semantic model represents:

`null / null`

as:

`No warning`

for reporting purposes.

The original source null values remain unchanged.

During UAT, the weather dimension was corrected because duplicate removal had initially been applied using warning level alone, causing:

`yellow / wind`

to be lost.

Duplicate removal was corrected to use the combination of:

- warning level;
- warning type.

Final warning reconciliation:

`20 Trust-days`

---

## Ambulance KPI

The source contains sufficient numeric fields to calculate a ratio.

However, the business definition of:

`ambulance_handover_delays`

has not yet been formally confirmed.

Therefore:

`Ambulance Handover Delay Rate`

remains provisional and must not be represented as a fully governed KPI until the definition is clarified.

---

# 14. Current UAT Summary

Total planned acceptance tests:

`49`

Breakdown:

| Group | Tests | Pass | Blocked | Deferred | Not Run | Fail |
|---|---:|---:|---:|---:|---:|---:|
| DATA | 7 | 7 | 0 | 0 | 0 | 0 |
| REL | 6 | 6 | 0 | 0 | 0 | 0 |
| KPI | 12 | 12 | 0 | 0 | 0 | 0 |
| BLOCK | 4 | 2 | 1 | 1 | 0 | 0 |
| FILTER | 7 | 7 | 0 | 0 | 0 | 0 |
| DRILL | 3 | 0 | 0 | 0 | 3 | 0 |
| GOV | 5 | 5 | 0 | 0 | 0 | 0 |
| ACC | 5 | 0 | 0 | 0 | 5 | 0 |
| **Total** | **49** | **39** | **1** | **1** | **8** | **0** |

Current UAT position:

- **39 Pass**
- **0 Fail**
- **1 Blocked**
- **1 Deferred**
- **8 Not run**

The remaining `Not run` tests relate primarily to final dashboard navigation, drill-through, accessibility and visual usability.

---

# 15. Current Release Interpretation

The Power BI semantic model has passed the currently executable:

- data-integrity tests;
- relationship tests;
- core KPI tests;
- filter-context tests;
- governance tests.

The model is not yet considered a final dashboard release because:

1. final dashboard pages are still to be implemented;
2. drill-through testing remains outstanding;
3. accessibility testing remains outstanding;
4. the ambulance-handover business definition remains unresolved;
5. incident KPIs remain intentionally deferred.

The current implementation is therefore:

**Semantic model and KPI layer validated — dashboard implementation and final visual UAT pending.**
