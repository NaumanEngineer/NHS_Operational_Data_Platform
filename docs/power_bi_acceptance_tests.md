# NHS Operational Intelligence Dashboard — Power BI Acceptance Tests

## Document Purpose

This document defines the User Acceptance Testing (UAT) and technical acceptance framework for the Power BI reporting layer of the NHS Operational Intelligence Platform.

The purpose of the framework is to confirm that the dashboard:

- loads the expected data;
- preserves the Trust-date reporting grain;
- applies relationships correctly;
- calculates KPIs correctly;
- responds correctly to filters;
- supports drill-through;
- preserves governance controls;
- exposes source limitations;
- meets basic accessibility requirements;
- behaves consistently with the documented dashboard design.

All organisations and values used in this project are synthetic.

The dashboard is intended for learning, technical testing and portfolio demonstration only.

---

## Testing Objective

The objective of UAT is to prove that the implemented Power BI report behaves as designed.

A dashboard should not be considered ready simply because:

- visuals render;
- charts appear plausible;
- filters seem to work;
- no obvious error message is visible.

Release readiness requires documented evidence that the dashboard meets defined acceptance criteria.

---

## Testing Principles

The acceptance process will follow these principles:

1. Tests must have a documented expected result.
2. The actual result must be recorded.
3. Failed tests must not be hidden.
4. Blocked KPIs must remain blocked.
5. Power BI results must reconcile with PostgreSQL.
6. Filter context must be tested explicitly.
7. Drill-through must preserve expected context.
8. Synthetic-data and governance warnings must remain visible.
9. Accessibility must be tested as part of acceptance.
10. Unexplained failures should block release.

---

## Test Status Values

Each test should use one of the following statuses:

- `Not run`
- `Pass`
- `Fail`
- `Blocked`
- `Not applicable`

During Week 14, Power BI implementation tests should remain:

`Not run — scheduled for Week 15/16`

Tests must not be marked as passed before they have actually been executed.

---

## Test Evidence Requirements

Where practical, test evidence should include one or more of:

- Power BI screenshot;
- PostgreSQL query output;
- reconciliation result;
- test notes;
- defect reference;
- GitHub commit reference.

Evidence should be sufficient for another reviewer to understand what was tested and why the result was accepted.

---

# Test Category 1 — Source and Data Validation

## UAT-DATA-001 — Trust Count

**Test**

Confirm the number of fictional Trusts in the Power BI analytical source.

**Expected result**

`3`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-DATA-002 — Reporting-Date Count

**Test**

Confirm the number of distinct reporting dates.

**Expected result**

`30`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-DATA-003 — Trust-Day Row Count

**Test**

Confirm the number of Trust-date records.

**Expected result**

`90`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-DATA-004 — Duplicate Trust-Date Check

**Test**

Check whether any Trust-date combination appears more than once.

**Expected result**

`0 duplicate Trust-date combinations`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-DATA-005 — Trust-Code Completeness

**Test**

Check for unexpected blank Trust codes.

**Expected result**

`0 unexpected blanks`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-DATA-006 — Reporting-Date Completeness

**Test**

Check for unexpected blank reporting dates.

**Expected result**

`0 unexpected blanks`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-DATA-007 — OPEL Domain Validation

**Test**

Confirm that approved OPEL values are limited to expected categories.

**Expected result**

Only:

- 1;
- 2;
- 3;
- 4.

**Current status**

`Not run — scheduled for Week 15`

---

# Test Category 2 — Semantic Model Relationships

## UAT-REL-001 — Trust Relationship

**Test**

Select one Trust using `DimTrust`.

**Expected result**

All relevant fact-table measures should update to show only the selected Trust.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-REL-002 — Date Relationship

**Test**

Select a reporting-date range using `DimDate`.

**Expected result**

All relevant visuals and measures should use only records inside the selected range.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-REL-003 — OPEL Relationship

**Test**

Select one OPEL category using `DimOPEL`.

**Expected result**

Relevant measures and visuals should filter to Trust-date records with that approved OPEL value.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-REL-004 — Pressure-Status Relationship

**Test**

Select one controlled pressure-status category.

**Expected result**

Relevant report visuals should display only matching Trust-date records.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-REL-005 — Relationship Direction

**Test**

Review semantic-model relationship settings.

**Expected result**

Primary relationships use:

- one-to-many cardinality;
- single-direction filtering.

No unintended bidirectional relationships should exist.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-REL-006 — Ambiguous Relationship Check

**Test**

Review the semantic-model relationship diagram.

**Expected result**

No ambiguous filter paths exist.

**Current status**

`Not run — scheduled for Week 15`

---

# Test Category 3 — KPI and Measure Validation

Each major measure should be reconciled against PostgreSQL.

## UAT-KPI-001 — Total A&E Attendances

**Test**

Compare the Power BI measure with the equivalent PostgreSQL result.

**Expected result**

Exact match.

**Tolerance**

`0`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-002 — Average General-Bed Occupancy

**Test**

Compare Power BI average daily general-bed occupancy with PostgreSQL.

**Expected result**

Results match within the documented tolerance.

**Tolerance**

`0.01`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-003 — Maximum General-Bed Occupancy

**Test**

Compare the maximum occupancy measure with PostgreSQL.

**Expected result**

Match within:

`0.01`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-004 — Average Critical-Care Occupancy

**Test**

Compare Power BI with PostgreSQL.

**Expected result**

Match within:

`0.01`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-005 — Average Workforce Absence

**Test**

Compare Power BI average daily workforce absence with PostgreSQL.

**Expected result**

Match within:

`0.01`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-006 — Average Daily Agency FTE

**Test**

Compare Power BI average agency FTE with PostgreSQL.

**Expected result**

Match within:

`0.01`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-007 — Average Daily Bank FTE

**Test**

Compare Power BI average bank FTE with PostgreSQL.

**Expected result**

Match within:

`0.01`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-008 — Total Unfilled Shifts

**Test**

Compare Power BI total unfilled shifts with PostgreSQL.

**Expected result**

Exact match.

**Tolerance**

`0`

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-009 — OPEL 3–4 Days

**Test**

Compare the Power BI count of Trust-days where approved OPEL is 3 or 4 with PostgreSQL.

**Expected result**

Exact match.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-010 — OPEL 4 Days

**Test**

Compare Power BI OPEL 4 Trust-day count with PostgreSQL.

**Expected result**

Exact match.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-011 — Human Override Count

**Test**

Compare Power BI human-override count with PostgreSQL.

**Expected result**

Exact match.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-KPI-012 — Reporting Completeness Percentage

**Test**

Compare the Power BI completeness calculation with the expected Trust-date reporting structure.

**Expected result for the current full dataset**

`100%`

**Current status**

`Not run — scheduled for Week 15`

---

# Test Category 4 — Blocked KPI Behaviour

## UAT-BLOCK-001 — Weighted A&E Breach Rate

**Test**

Inspect the weighted A&E four-hour breach KPI.

**Expected result**

Until `four_hour_breaches` is added, the dashboard must display:

`Source enrichment required`

or equivalent.

It must not present the simple average of daily breach percentages as the weighted period rate.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-BLOCK-002 — Ambulance Handover Rate

**Test**

Inspect the ambulance handover KPI.

**Expected result**

The current source field must not be presented as a trusted final rate until the definition and raw source fields are confirmed.

The report should display an explicit limitation or blocked status.

**Current status**

`Not run — scheduled for Week 15`

---

## UAT-BLOCK-003 — Recommended Versus Approved OPEL

**Test**

Inspect the OPEL and governance reporting area.

**Expected result**

Recommended-versus-approved analysis remains unavailable until `recommended_opel_level` is added.

**Current status**

`Not run — scheduled for Week 15/16`

---

## UAT-BLOCK-004 — Incident KPIs

**Test**

Inspect incident-related dashboard areas.

**Expected result**

Incident measures remain marked as source-enrichment dependent until appropriate source fields are available.

**Current status**

`Not run — scheduled for Week 16`

---

# Test Category 5 — Filter Behaviour

## UAT-FILTER-001 — Default State

**Test**

Open the Executive Overview with the default report state.

**Expected result**

The dashboard displays:

- all fictional Trusts;
- full reporting period;
- all approved OPEL levels;
- all pressure statuses.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-FILTER-002 — Single Trust

**Test**

Select one Trust.

**Expected result**

All relevant KPIs and visuals update to the selected Trust.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-FILTER-003 — Multiple Trusts

**Test**

Select two Trusts.

**Expected result**

Aggregated measures update correctly.

Latest approved OPEL must not return a misleading single category where multiple different Trust values exist.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-FILTER-004 — Single Reporting Date

**Test**

Select one reporting date.

**Expected result**

All relevant operational measures use only the selected date.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-FILTER-005 — Date Range

**Test**

Select a subset of reporting dates.

**Expected result**

Measures recalculate using only the selected period.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-FILTER-006 — OPEL Filter

**Test**

Select OPEL 4.

**Expected result**

Relevant visuals display only records associated with approved OPEL 4.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-FILTER-007 — Combined Trust and Date Filter

**Test**

Select one Trust and a date range.

**Expected result**

All visuals use the intersection of both filter conditions.

**Current status**

`Not run — scheduled for Week 16`

---

# Test Category 6 — Drill-Through

## UAT-DRILL-001 — Trust-Day Drill-Through

**Test**

From a source visual containing Trust and reporting date, drill through to:

`Trust-Day Investigation`

**Expected result**

The destination page shows exactly one Trust and one reporting date.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-DRILL-002 — Back Navigation

**Test**

Use the Back button after drill-through.

**Expected result**

The user returns to the originating report page without losing the expected filter context.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-DRILL-003 — Incomplete Drill-Through Context

**Test**

Navigate to the Trust-Day Investigation page with only a Trust selected.

**Expected result**

The dashboard should request selection of one reporting date rather than displaying ambiguous Trust-day values.

**Current status**

`Not run — scheduled for Week 16`

---

# Test Category 7 — Governance Controls

## UAT-GOV-001 — Synthetic-Data Warning

**Test**

Review every relevant dashboard page.

**Expected result**

The dashboard clearly communicates that the data is synthetic and not suitable for real clinical or operational decisions.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-GOV-002 — Human Accountability

**Test**

Review OPEL and governance visuals.

**Expected result**

Approved OPEL remains visibly a human-reviewed outcome.

The report does not imply that escalation is autonomous.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-GOV-003 — Human Override Interpretation

**Test**

Review human-override measures and explanatory text.

**Expected result**

Overrides are presented as governance signals and not automatically described as model or human failures.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-GOV-004 — Threshold Labelling

**Test**

Review project-defined pressure categories.

**Expected result**

Illustrative categories are not presented as official NHS thresholds.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-GOV-005 — Source-Readiness Visibility

**Test**

Review all blocked KPI areas.

**Expected result**

Source limitations are visibly disclosed.

**Current status**

`Not run — scheduled for Week 16`

---

# Test Category 8 — Accessibility and Usability

## UAT-ACC-001 — Navigation Labels

**Test**

Review all page-navigation controls.

**Expected result**

Buttons contain clear text labels and are understandable without relying on icons alone.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-ACC-002 — Status Without Colour Alone

**Test**

Review OPEL, pressure and quality-status visuals.

**Expected result**

Meaning is communicated through text, labels, values or icons in addition to colour.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-ACC-003 — Chart Titles

**Test**

Review analytical visuals.

**Expected result**

Chart titles clearly identify:

- measure;
- context;
- units where required.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-ACC-004 — Number Formatting

**Test**

Review KPI and visual formatting.

**Expected result**

- percentages use percentage formatting;
- counts use whole numbers;
- FTE uses two decimal places;
- temperatures display °C;
- dates are formatted consistently.

**Current status**

`Not run — scheduled for Week 16`

---

## UAT-ACC-005 — Visual Density

**Test**

Review each dashboard page.

**Expected result**

The report does not contain unnecessary visual clutter or excessive KPI cards.

**Current status**

`Not run — scheduled for Week 16`

---

# Acceptance Criteria

A dashboard release can be considered acceptable only when:

1. critical source tests pass;
2. semantic-model relationships behave correctly;
3. major KPIs reconcile with PostgreSQL;
4. blocked KPIs remain visibly blocked;
5. core filters behave as designed;
6. drill-through works correctly;
7. governance controls are visible;
8. accessibility checks pass;
9. no unexplained critical defect remains open.

---

# Release-Blocking Failures

The following should block release:

- incorrect KPI calculation;
- unexplained SQL/Power BI reconciliation difference;
- duplicate Trust-date records;
- broken core relationship;
- blocked KPI displayed as final;
- misleading multi-Trust OPEL result;
- missing synthetic-data warning;
- recommendation presented as approved OPEL;
- material drill-through failure;
- material governance failure.

Minor cosmetic defects may be documented for later correction where they do not alter interpretation or functionality.

---

# Defect Severity

## Critical

Examples:

- wrong KPI;
- incorrect filter logic;
- misleading OPEL result;
- missing governance control.

Release:

`Blocked`

## Major

Examples:

- broken drill-through;
- missing important visual;
- incorrect formatting that materially affects interpretation.

Release:

Normally blocked until resolved.

## Minor

Examples:

- spacing issue;
- non-critical label adjustment;
- minor formatting inconsistency.

Release:

May proceed if documented and accepted.

---

# Master UAT Test Register

| Test ID | Area | Test Summary | Expected Result | Planned Execution | Status |
|---|---|---|---|---|---|
| UAT-DATA-001 | Data | Trust count | 3 Trusts | Week 15 | Not run |
| UAT-DATA-002 | Data | Reporting-date count | 30 dates | Week 15 | Not run |
| UAT-DATA-003 | Data | Trust-day row count | 90 rows | Week 15 | Not run |
| UAT-DATA-004 | Data | Duplicate Trust-date check | 0 duplicates | Week 15 | Not run |
| UAT-DATA-005 | Data | Trust-code completeness | 0 unexpected blanks | Week 15 | Not run |
| UAT-DATA-006 | Data | Reporting-date completeness | 0 unexpected blanks | Week 15 | Not run |
| UAT-DATA-007 | Data | OPEL domain validation | Only 1, 2, 3, 4 | Week 15 | Not run |
| UAT-REL-001 | Relationship | Trust dimension filtering | Selected Trust filters relevant facts | Week 15 | Not run |
| UAT-REL-002 | Relationship | Date dimension filtering | Selected dates filter relevant facts | Week 15 | Not run |
| UAT-REL-003 | Relationship | OPEL dimension filtering | Selected OPEL filters relevant facts | Week 15 | Not run |
| UAT-REL-004 | Relationship | Pressure-status filtering | Selected status filters relevant facts | Week 15 | Not run |
| UAT-REL-005 | Relationship | Relationship direction | One-to-many, single direction | Week 15 | Not run |
| UAT-REL-006 | Relationship | Ambiguous-path check | No ambiguous paths | Week 15 | Not run |
| UAT-KPI-001 | KPI | Total A&E Attendances | Exact SQL match | Week 15 | Not run |
| UAT-KPI-002 | KPI | Average General-Bed Occupancy | Within 0.01 of SQL | Week 15 | Not run |
| UAT-KPI-003 | KPI | Maximum General-Bed Occupancy | Within 0.01 of SQL | Week 15 | Not run |
| UAT-KPI-004 | KPI | Average Critical-Care Occupancy | Within 0.01 of SQL | Week 15 | Not run |
| UAT-KPI-005 | KPI | Average Workforce Absence | Within 0.01 of SQL | Week 15 | Not run |
| UAT-KPI-006 | KPI | Average Daily Agency FTE | Within 0.01 of SQL | Week 15 | Not run |
| UAT-KPI-007 | KPI | Average Daily Bank FTE | Within 0.01 of SQL | Week 15 | Not run |
| UAT-KPI-008 | KPI | Total Unfilled Shifts | Exact SQL match | Week 15 | Not run |
| UAT-KPI-009 | KPI | OPEL 3–4 Days | Exact SQL match | Week 15 | Not run |
| UAT-KPI-010 | KPI | OPEL 4 Days | Exact SQL match | Week 15 | Not run |
| UAT-KPI-011 | KPI | Human Override Count | Exact SQL match | Week 15 | Not run |
| UAT-KPI-012 | KPI | Reporting Completeness | 100% for current full dataset | Week 15 | Not run |
| UAT-BLOCK-001 | Blocked KPI | Weighted A&E breach rate | Source enrichment warning | Week 15 | Not run |
| UAT-BLOCK-002 | Blocked KPI | Ambulance handover rate | Remains blocked | Week 15 | Not run |
| UAT-BLOCK-003 | Blocked KPI | Recommended vs approved OPEL | Remains unavailable until source-ready | Week 15/16 | Not run |
| UAT-BLOCK-004 | Blocked KPI | Incident KPIs | Remain deferred | Week 16 | Not run |
| UAT-FILTER-001 | Filter | Default report state | Documented default state restored | Week 16 | Not run |
| UAT-FILTER-002 | Filter | Single Trust | Relevant visuals filter correctly | Week 16 | Not run |
| UAT-FILTER-003 | Filter | Multiple Trusts | Aggregates correctly; latest OPEL not misleading | Week 16 | Not run |
| UAT-FILTER-004 | Filter | Single date | Selected date only | Week 16 | Not run |
| UAT-FILTER-005 | Filter | Date range | Selected period only | Week 16 | Not run |
| UAT-FILTER-006 | Filter | OPEL 4 | OPEL 4 records only | Week 16 | Not run |
| UAT-FILTER-007 | Filter | Trust and date | Correct filter intersection | Week 16 | Not run |
| UAT-DRILL-001 | Drill-through | Trust-day drill-through | One Trust and one date passed | Week 16 | Not run |
| UAT-DRILL-002 | Drill-through | Back navigation | Returns correctly | Week 16 | Not run |
| UAT-DRILL-003 | Drill-through | Incomplete context | User prompted to select one date | Week 16 | Not run |
| UAT-GOV-001 | Governance | Synthetic-data warning | Visible on relevant pages | Week 16 | Not run |
| UAT-GOV-002 | Governance | Human accountability | Approved OPEL remains human-reviewed | Week 16 | Not run |
| UAT-GOV-003 | Governance | Override interpretation | No blame or error assumption | Week 16 | Not run |
| UAT-GOV-004 | Governance | Threshold labelling | Illustrative only | Week 16 | Not run |
| UAT-GOV-005 | Governance | Source-readiness visibility | Blocked status clearly visible | Week 16 | Not run |
| UAT-ACC-001 | Accessibility | Navigation labels | Clear text labels | Week 16 | Not run |
| UAT-ACC-002 | Accessibility | Status without colour alone | Text or label also used | Week 16 | Not run |
| UAT-ACC-003 | Accessibility | Chart titles | Metric and context clear | Week 16 | Not run |
| UAT-ACC-004 | Accessibility | Number formatting | Correct units and formats | Week 16 | Not run |
| UAT-ACC-005 | Accessibility | Visual density | No unnecessary clutter | Week 16 | Not run |

---

# Requirements-to-Test Traceability

| Requirement Area | Source Document | Acceptance Tests |
|---|---|---|
| Trust-date reporting grain | `power_bi_data_model_specification.md` | UAT-DATA-003, UAT-DATA-004 |
| Trust filtering | `dashboard_wireframes.md` | UAT-REL-001, UAT-FILTER-002 |
| Date filtering | `dashboard_wireframes.md` | UAT-REL-002, UAT-FILTER-004, UAT-FILTER-005 |
| OPEL filtering | `dashboard_wireframes.md` | UAT-REL-003, UAT-FILTER-006 |
| Star-schema relationships | `power_bi_data_model_specification.md` | UAT-REL-001 to UAT-REL-006 |
| Total A&E Attendances | `kpi_dictionary.md` | UAT-KPI-001 |
| Average General-Bed Occupancy | `kpi_dictionary.md` | UAT-KPI-002 |
| Maximum General-Bed Occupancy | `kpi_dictionary.md` | UAT-KPI-003 |
| Critical-Care Occupancy | `kpi_dictionary.md` | UAT-KPI-004 |
| Workforce Absence | `kpi_dictionary.md` | UAT-KPI-005 |
| Agency FTE | `kpi_dictionary.md` | UAT-KPI-006 |
| Bank FTE | `kpi_dictionary.md` | UAT-KPI-007 |
| Unfilled Shifts | `kpi_dictionary.md` | UAT-KPI-008 |
| OPEL 3–4 Days | `kpi_dictionary.md` | UAT-KPI-009 |
| OPEL 4 Days | `kpi_dictionary.md` | UAT-KPI-010 |
| Human Override Count | `kpi_dictionary.md` | UAT-KPI-011 |
| Reporting Completeness | `kpi_dictionary.md` | UAT-KPI-012 |
| Weighted A&E breach rate blocked | `kpi_dictionary.md` | UAT-BLOCK-001 |
| Ambulance handover rate blocked | `kpi_dictionary.md` | UAT-BLOCK-002 |
| Recommended vs approved OPEL separation | `power_bi_governance.md` | UAT-BLOCK-003, UAT-GOV-002 |
| Incident KPIs deferred | `kpi_dictionary.md` | UAT-BLOCK-004 |
| Trust-Day Investigation | `dashboard_wireframes.md` | UAT-DRILL-001, UAT-DRILL-003 |
| Default report state | `dashboard_wireframes.md` | UAT-FILTER-001 |
| Synthetic-data warning | `power_bi_governance.md` | UAT-GOV-001 |
| Human accountability | `power_bi_governance.md` | UAT-GOV-002, UAT-GOV-003 |
| Illustrative thresholds | `power_bi_governance.md` | UAT-GOV-004 |
| Blocked KPI visibility | `power_bi_governance.md` | UAT-GOV-005 |
| Accessible navigation | `dashboard_wireframes.md` | UAT-ACC-001 |
| Status not communicated by colour alone | `dashboard_wireframes.md` | UAT-ACC-002 |
| Clear chart titles | `dashboard_wireframes.md` | UAT-ACC-003 |
| Number-format standards | `power_bi_data_model_specification.md` | UAT-ACC-004 |
| Controlled visual density | `dashboard_wireframes.md` | UAT-ACC-005 |

---

# Defect Register Structure

When a test fails, the issue should be recorded using a controlled defect record.

Recommended fields:

| Field | Purpose |
|---|---|
| Defect ID | Unique defect reference |
| Test ID | Acceptance test that identified the problem |
| Area | Data, model, measure, visual, governance or accessibility |
| Description | Clear description of the defect |
| Severity | Critical, Major or Minor |
| Expected result | What should have happened |
| Actual result | What happened |
| Root cause | Identified cause when known |
| Resolution | Corrective action |
| Retest status | Not retested, Pass or Fail |
| Release impact | Blocked or accepted |
| Evidence | Screenshot, SQL output or commit reference |

---

## Example Defect

```text
Defect ID: DEF-001
Test ID: UAT-KPI-002
Area: KPI
Severity: Critical

Description:
Power BI average general-bed occupancy does not match the PostgreSQL result.

Expected:
Value matches the PostgreSQL reconciliation result within 0.01.

Actual:
Value differs by more than the permitted tolerance.

Release impact:
Blocked pending investigation.
```

The example is illustrative.

A real defect record should contain actual implementation evidence.

---

# Retesting Rules

A failed test should not be changed directly from:

`Fail`

to:

`Pass`

without retesting.

The expected process is:

```text
Test fails
    ↓
Defect recorded
    ↓
Root cause investigated
    ↓
Correction implemented
    ↓
Relevant tests rerun
    ↓
Evidence recorded
    ↓
Test closed
```

Where a change may affect other functionality, regression testing should also be performed.

---

# Regression Testing

Regression testing should be considered when changes affect:

- semantic-model relationships;
- DAX measures;
- Power Query transformations;
- KPI definitions;
- Trust or date dimensions;
- OPEL logic;
- filter interactions;
- drill-through behaviour.

For example, changing a relationship to fix one visual may unintentionally change several other measures.

Relevant existing tests should therefore be rerun.

---

# Acceptance Sign-Off

Before a dashboard release is considered accepted, the project should be able to answer:

- Were the core data tests completed?
- Did the semantic model behave as specified?
- Did major KPIs reconcile with PostgreSQL?
- Were blocked KPIs kept blocked?
- Did filters behave correctly?
- Did drill-through behave correctly?
- Were governance controls visible?
- Were accessibility checks completed?
- Are any critical or major defects still open?

If a material issue remains unresolved, the release should not be described as fully accepted.

---

# Acceptance-Test Quality Review

Before the UAT specification is considered complete, confirm that:

- [x] Test objectives are documented.
- [x] Test status values are defined.
- [x] Evidence requirements are documented.
- [x] Source-data tests are defined.
- [x] Relationship tests are defined.
- [x] KPI reconciliation tests are defined.
- [x] Blocked-KPI tests are defined.
- [x] Filter tests are defined.
- [x] Drill-through tests are defined.
- [x] Governance tests are defined.
- [x] Accessibility tests are defined.
- [x] Release-blocking failures are defined.
- [x] Defect severities are documented.
- [x] A master test register exists.
- [x] Requirements-to-test traceability exists.
- [x] Defect-management fields are defined.
- [x] Retesting rules are documented.
- [x] Regression-testing principles are documented.
- [x] Acceptance-sign-off criteria are documented.
- [x] Unexecuted Power BI tests remain marked as Not run.

---

# Week 15 and Week 16 Test Execution Plan

## Week 15 — Semantic Model Testing

Priority tests:

- source row counts;
- Trust-date uniqueness;
- dimension relationships;
- filter direction;
- A&E attendance measure;
- occupancy measures;
- workforce measures;
- OPEL measures;
- data-quality measures;
- blocked-measure behaviour.

The objective is to confirm that the semantic model is mathematically and structurally correct.

---

## Week 16 — Report and User Testing

Priority tests:

- page navigation;
- slicers;
- cross-filtering;
- default/reset behaviour;
- drill-through;
- multi-Trust behaviour;
- governance warnings;
- source-readiness messages;
- accessibility;
- visual formatting;
- management interpretation.

The objective is to confirm that the completed report behaves correctly from the user perspective.

---

# Day 5 Acceptance-Test Completion Status

Week 14 Day 5 produced a formal Power BI acceptance-testing framework.

The completed framework includes:

- detailed test cases;
- 49 planned acceptance tests;
- source-data testing;
- semantic-model testing;
- KPI reconciliation;
- blocked-KPI testing;
- filter testing;
- drill-through testing;
- governance testing;
- accessibility testing;
- a master UAT register;
- requirements-to-test traceability;
- defect management;
- retesting rules;
- regression testing;
- release-blocking criteria;
- acceptance-sign-off requirements.

Power BI implementation tests intentionally remain marked as:

`Not run`

until the semantic model and report are actually implemented.

This preserves the integrity of the testing record.
until the semantic model and report are actually implemented.

This preserves the integrity of the testing record.
