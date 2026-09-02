# Week 15 Day 5 — PostgreSQL Reconciliation and UAT

## Objective

Day 5 focused on validating the Power BI semantic model against PostgreSQL, testing filter context, reviewing data-quality controls, and executing the formal UAT framework.

The goal was to prove that the semantic model produces trustworthy results rather than simply rendering visuals.

---

## PostgreSQL Source

Validated database:

`nhs_operations_test`

Validated analytical source:

`operational.vw_trust_daily_analytical`

---

## Baseline Source Validation

PostgreSQL reconciliation confirmed:

- 90 fact rows
- 3 fictional Trusts
- 30 reporting dates
- reporting period 2026-01-01 to 2026-01-30
- 0 duplicate Trust-date records
- 30 Trust-date rows per Trust

---

## Core PostgreSQL KPI Baseline

| KPI | PostgreSQL Result |
|---|---:|
| Total A&E Attendances | 25,800 |
| Total Four-Hour Breaches | 5,113 |
| Weighted A&E Four-Hour Breach Rate | 19.82% |
| Total Admissions | 16,425 |
| Total Discharges | 15,654 |
| Net Admissions | 771 |
| OPEL 3–4 Trust-days | 39 |
| OPEL 4 Trust-days | 7 |
| Human Overrides | 4 |
| Recommendation / Approval Mismatches | 4 |
| High Operational-Pressure Trust-days | 39 |
| Weather-Warning Trust-days | 20 |

---

## Patient-Flow Reconciliation

Source calculation:

`16,425 admissions - 15,654 discharges = 771`

Source `net_admissions` total:

`771`

Power BI reconciliation measure:

`Net Admissions Variance`

Expected:

`0`

Result:

**Pass**

---

## A&E Reconciliation

Weighted A&E breach rate is calculated using:

`SUM(four_hour_breaches) / SUM(ae_attendances)`

PostgreSQL result:

`19.82%`

Power BI result reconciled within the agreed tolerance.

Result:

**Pass**

This KPI was previously blocked during Week 14 because the raw breach numerator had not yet been confirmed.

Week 15 source inspection confirmed the required raw fields.

---

## OPEL Reconciliation

PostgreSQL confirmed:

- OPEL 3–4 Trust-days = 39
- OPEL 4 Trust-days = 7

Observed Power BI Trust-level OPEL 3–4 results:

- NRT002 = 17
- SCT003 = 7
- WGH001 = 15

Total:

`39`

Result:

**Pass**

---

## Override Reconciliation

PostgreSQL:

- human override count = 4
- recommended/approved OPEL mismatches = 4

Power BI:

`Override Reconciliation Variance = 0`

Result:

**Pass**

This provides evidence that the human-override indicator is consistent with recommendation/approval mismatch logic in the synthetic dataset.

---

## Pressure-Status Validation

Source distribution:

| Status | Trust-days |
|---|---:|
| Routine pressure | 21 |
| Moderate pressure | 30 |
| Significant pressure | 32 |
| Critical pressure | 7 |

High-pressure logic uses:

- Significant pressure
- Critical pressure

Expected:

`32 + 7 = 39`

Power BI:

`High Operational-Pressure Days = 39`

Result:

**Pass**

The pressure classifications remain project-defined illustrative rules.

---

## Weather-Warning Validation

PostgreSQL identified:

| Warning | Trust-days |
|---|---:|
| No warning | 70 |
| Yellow / Ice | 12 |
| Yellow / Wind | 6 |
| Amber / Snow and Ice | 2 |

Total warning Trust-days:

`20`

During UAT, the original Power BI weather dimension was found to be missing:

`yellow / wind`

The issue was traced to duplicate-removal logic being applied to warning level alone.

The dimension was corrected so duplicate removal uses the combination of:

- warning level
- warning type

Final Power BI result:

`Weather-Warning Days = 20`

Result:

**Pass**

This issue is retained in the evidence trail because it demonstrates defect identification, root-cause analysis, correction and reconciliation.

---

## Filter-Context Testing

The semantic model was tested using Trust, date, OPEL, pressure-status and weather-warning slicers.

Observed expected behaviour included:

- one Trust = 30 rows
- 10 dates × 3 Trusts = 30 rows
- 10 dates × 1 Trust = 10 rows
- OPEL 4 = 7 rows
- OPEL 3–4 = 39 rows
- Significant + Critical pressure = 39 rows
- yellow / ice = 12 rows
- yellow / wind = 6 rows
- amber / snow and ice = 2 rows
- all warning states = 20 rows
- no warning = 70 rows

Result:

**Pass**

---

## Data-Quality Measures

Validated controls include:

- Fact Row Count
- Duplicate Trust-Date Count
- Reporting Completeness Percentage
- Net Admissions Variance
- A&E Breach Rate QA
- Workforce Absence Difference
- Override Reconciliation Variance

Expected clean results:

- Duplicate Trust-Date Count = 0
- Reporting Completeness Percentage = 100%
- Net Admissions Variance = 0
- A&E Breach Rate QA = 0
- Workforce Absence Difference = 0
- Override Reconciliation Variance = 0

---

## Previous OPEL Nulls

`previous_approved_opel_level` contains expected structural nulls.

The first reporting date for each fictional Trust has no previous assessment.

These values are therefore not automatically replaced with zero or another OPEL level.

---

## Ambulance KPI Status

The source contains:

- `ambulance_arrivals`
- `ambulance_handover_delays`
- `ambulance_handover_delay_pct`

A technical ratio can be calculated.

However, the exact business definition of:

`ambulance_handover_delays`

still requires confirmation.

Therefore the ambulance KPI remains:

**Provisional / source-definition clarification required**

It must not be represented as minutes unless the source definition confirms that interpretation.

---

## UAT Status

The updated acceptance-test framework contains:

- 49 planned tests
- 39 Pass
- 0 Fail
- 1 Blocked
- 1 Deferred
- 8 Not run

Outstanding tests primarily relate to:

- final dashboard pages
- drill-through
- navigation
- accessibility
- visual usability

---

## Day 5 Outcome

Day 5 established that the implemented semantic model and core DAX layer reconcile successfully with PostgreSQL within the defined tolerances.

The current implementation status is:

**Semantic model and KPI layer validated — dashboard implementation and final visual UAT pending.**

Next:

**Week 15 Day 6 — final model QA, documentation, interview evidence and Week 15 release preparation**
