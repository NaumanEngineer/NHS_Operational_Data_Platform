# Week 15 Reflection — Power BI Semantic Model Implementation

## Overview

Week 15 moved the project from a Power BI design specification into an implemented and validated semantic model.

The work covered:

- PostgreSQL source connection;
- source inspection;
- Power Query staging;
- dimension creation;
- fact-table creation;
- star-schema relationships;
- explicit DAX measures;
- weighted KPI calculations;
- governance controls;
- SQL reconciliation;
- filter-context testing;
- formal UAT.

The implementation used synthetic operational data only.

---

# 1. Main Achievement

The main achievement of Week 15 was converting a validated PostgreSQL analytical view into a governed Power BI semantic model.

The final model includes:

- `FactTrustDailyOperations`
- `DimDate`
- `DimTrust`
- `DimOPEL`
- `DimPressureStatus`
- `DimWeatherWarning`
- `_Measures`

The fact table operates at:

**one row per fictional Trust per reporting date**

The validated dataset contains:

- 90 Trust-date rows;
- 3 fictional Trusts;
- 30 reporting dates.

---

# 2. Why Source Inspection Mattered

One of the most important lessons from Week 15 was that the actual source must be inspected before implementation assumptions are treated as fact.

The Week 14 design had deliberately marked several KPI capabilities as blocked because the available source fields had not yet been confirmed.

During Week 15 source inspection, the analytical view was found to contain a much richer set of raw fields than expected.

Examples included:

- `general_beds_open`
- `general_beds_occupied`
- `four_hour_breaches`
- `ae_attendances`
- `ambulance_arrivals`
- `ambulance_handover_delays`
- `establishment_fte`
- `absence_fte`
- `recommended_opel_level`
- `approved_opel_level`
- `human_override_indicator`

This changed the implementation plan significantly.

---

# 3. Moving KPIs from Blocked to Ready

## Weighted A&E Four-Hour Breach Rate

Week 14 status:

`Blocked`

Reason:

The raw breach numerator had not been confirmed.

Week 15 confirmed:

- `four_hour_breaches`
- `ae_attendances`

This allowed the KPI to be implemented as:

`SUM(four_hour_breaches) / SUM(ae_attendances)`

The measure reconciled against PostgreSQL at:

`19.82%`

The KPI therefore moved from:

`Blocked`

to:

`Validated`

---

## Recommended vs Approved OPEL

Week 14 status:

`Blocked`

Week 15 source inspection confirmed:

- `recommended_opel_level`
- `approved_opel_level`
- `human_override_indicator`

This allowed implementation of:

- recommendation agreement;
- recommendation mismatch;
- human override count;
- override percentage;
- override reconciliation.

PostgreSQL showed:

- 4 human overrides;
- 4 recommended/approved mismatches.

The Power BI reconciliation variance was:

`0`

This capability therefore moved from:

`Blocked`

to:

`Validated`

---

# 4. Weighted Measures vs Average Percentages

Week 15 reinforced the importance of distinguishing between:

- averaging percentages;
- calculating a weighted rate from raw numerator and denominator fields.

Examples include:

## Bed Occupancy

Instead of relying only on:

`AVERAGE(general_bed_occupancy_pct)`

the model can calculate:

`SUM(general_beds_occupied) / SUM(general_beds_open)`

This produces a capacity-weighted occupancy measure.

---

## A&E Breach Rate

The governed measure uses:

`SUM(four_hour_breaches) / SUM(ae_attendances)`

rather than averaging daily breach percentages.

---

## Workforce Absence

The weighted workforce calculation uses:

`SUM(absence_fte) / SUM(establishment_fte)`

rather than relying only on the simple average of daily absence percentages.

This was an important analytical modelling lesson because a simple average can give misleading results when denominators differ between records.

---

# 5. FTE Semantics

Another important lesson was that FTE values are not automatically additive over time.

For example:

`SUM(agency_fte)`

across 30 reporting dates would represent something closer to FTE-days rather than the staffing level on a typical day.

The model therefore uses measures such as:

- Average Daily Agency FTE
- Average Daily Bank FTE
- Average Establishment FTE
- Average Substantive FTE

This makes the metric meaning clearer for report users.

---

# 6. Patient-Day Semantics

The source field:

`patients_ready_for_discharge`

is a daily snapshot.

Summing this across dates does not produce a unique patient count.

The measure is therefore labelled:

`Discharge-Ready Patient-Days`

This avoids overstating what the data represents.

---

# 7. Star-Schema Design

Week 15 implemented a controlled star schema.

Primary relationships are:

- `DimDate` → `FactTrustDailyOperations`
- `DimTrust` → `FactTrustDailyOperations`
- `DimOPEL` → `FactTrustDailyOperations`
- `DimPressureStatus` → `FactTrustDailyOperations`
- `DimWeatherWarning` → `FactTrustDailyOperations`

Relationship controls include:

- one-to-many cardinality;
- dimensions on the one side;
- fact table on the many side;
- single-direction filtering;
- active primary relationships;
- no many-to-many primary relationships;
- no unnecessary bidirectional filters.

The dedicated `_Measures` table remains intentionally disconnected because it functions only as a DAX measure container.

---

# 8. OPEL Governance

The model uses:

`approved_opel_level`

as the primary relationship to `DimOPEL`.

This reflects the human-reviewed operational outcome.

The separate:

`recommended_opel_level`

field remains in the fact table for governance comparison.

This preserves the distinction between:

- system recommendation;
- human-reviewed decision;
- override behaviour.

This is more transparent than replacing the approved outcome with an automated recommendation.

---

# 9. Weather-Dimension Defect

One of the most useful QA findings during Week 15 involved the weather-warning dimension.

The original dimension appeared to contain:

- No warning
- yellow / ice
- amber / snow and ice

However, PostgreSQL reconciliation showed another valid combination:

`yellow / wind`

with:

`6 Trust-days`

The problem was traced to Power Query duplicate-removal logic.

Duplicates had been removed using only:

`weather_warning_level`

Because both:

- yellow / ice
- yellow / wind

shared the same warning level, Power Query retained only one yellow row.

The fix was to remove duplicates using the combination of:

- weather warning level;
- weather warning type.

The final dimension contained:

- No warning
- yellow / ice
- yellow / wind
- amber / snow and ice

Final reconciliation:

`20 weather-warning Trust-days`

This was an important lesson:

**dimension uniqueness must be defined using the true business key, not merely the most obvious descriptive field.**

---

# 10. Power Query Staging Lesson

`SourceTrustDailyAnalytical` was retained as a staging query.

The staging query is not loaded directly into the report model.

Dimensions and the fact table are created as referenced queries.

This gives a controlled flow:

`PostgreSQL → staging query → fact/dimensions → semantic model`

A temporary issue occurred when transformations intended for a dimension were applied to the staging query.

The source query was restored and the dimensions were rebuilt correctly.

The practical lesson was:

**keep the staging query stable and apply dimension-specific transformations only to referenced queries.**

---

# 11. PostgreSQL Reconciliation

Power BI calculations were not accepted purely because they produced plausible numbers.

The model was reconciled directly against PostgreSQL.

Validated results included:

| KPI | Result |
|---|---:|
| Fact rows | 90 |
| Trusts | 3 |
| Reporting dates | 30 |
| A&E Attendances | 25,800 |
| Four-Hour Breaches | 5,113 |
| Weighted A&E Breach Rate | 19.82% |
| Admissions | 16,425 |
| Discharges | 15,654 |
| Net Admissions | 771 |
| OPEL 3-4 Trust-days | 39 |
| OPEL 4 Trust-days | 7 |
| Human Overrides | 4 |
| High-Pressure Trust-days | 39 |
| Weather-Warning Trust-days | 20 |

This made the Power BI model evidence-based rather than visually plausible.

---

# 12. Filter-Context Testing

The semantic model was tested under multiple slicer contexts.

Examples included:

- one Trust = 30 fact rows;
- 10 dates × 3 Trusts = 30 rows;
- 10 dates × 1 Trust = 10 rows;
- OPEL 4 = 7 rows;
- OPEL 3–4 = 39 rows;
- Significant + Critical pressure = 39 rows;
- yellow / ice = 12 rows;
- yellow / wind = 6 rows;
- amber / snow and ice = 2 rows;
- all warning states = 20 rows;
- no warning = 70 rows.

This confirmed that relationships and DAX measures responded correctly to filter context.

---

# 13. Data-Quality Measures

The model includes explicit QA measures such as:

- Fact Row Count
- Duplicate Trust-Date Count
- Reporting Completeness Percentage
- Net Admissions Variance
- A&E Breach Rate QA
- Workforce Absence Difference
- OPEL Recommendation Mismatch Count
- Override Reconciliation Variance

Expected clean-model results included:

- duplicate count = 0;
- reporting completeness = 100%;
- net admissions variance = 0;
- A&E QA variance = 0;
- workforce QA variance = 0;
- override reconciliation variance = 0.

These controls make quality checks visible inside the semantic model rather than relying only on external documentation.

---

# 14. Formal UAT

Week 15 progressed beyond informal checking into structured acceptance testing.

Current UAT position:

- 49 planned tests;
- 39 Pass;
- 0 Fail;
- 1 Blocked;
- 1 Deferred;
- 8 Not run.

The remaining Not Run tests relate mainly to:

- final dashboard visuals;
- drill-through;
- navigation;
- accessibility;
- usability.

This means the semantic model and KPI layer have been validated, while final report-level testing remains clearly separated.

---

# 15. Remaining Limitation — Ambulance KPI

The source contains:

- `ambulance_arrivals`
- `ambulance_handover_delays`
- `ambulance_handover_delay_pct`

A technical rate can be calculated.

However, the exact business definition of:

`ambulance_handover_delays`

has not been formally confirmed.

The measure therefore remains:

`Provisional`

This is preferable to presenting a technically valid calculation with an unsupported business interpretation.

---

# 16. Incident KPIs

Incident KPIs remain intentionally deferred.

Incident records exist at a different grain from the Trust-date fact table.

Rather than forcing them into the current model, a future design should consider:

- a dedicated incident fact table;
- controlled daily aggregation;
- or a multi-fact semantic model.

This avoids creating incorrect totals or many-to-many relationship problems.

---

# 17. Main Technical Lessons

The most important Week 15 lessons were:

1. inspect the real source before finalising KPI readiness;
2. preserve raw numerators and denominators;
3. weighted rates are often more appropriate than averages of percentages;
4. understand the time semantics of FTE measures;
5. treat daily snapshot counts carefully;
6. use a controlled star schema;
7. use one-directional dimension-to-fact relationships;
8. keep DAX measures separate from raw columns;
9. keep staging queries stable;
10. identify the true business key before removing duplicates;
11. validate measures against the source system;
12. test filter context explicitly;
13. keep automated recommendations separate from human-reviewed outcomes;
14. document unresolved business definitions rather than guessing;
15. use formal UAT rather than relying only on visual inspection.

---

# 18. Portfolio Value

Week 15 demonstrates more than basic Power BI dashboard skills.

The work now shows experience with:

- PostgreSQL;
- Power Query;
- semantic modelling;
- star-schema design;
- DAX;
- weighted KPI design;
- operational reporting;
- data quality;
- governance;
- AI/human decision comparison;
- lineage;
- source reconciliation;
- UAT;
- defect investigation.

This provides evidence of end-to-end analytical engineering rather than isolated visualisation work.

---

# 19. Week 15 Final Status

Week 15 status:

**Power BI semantic model implemented and validated.**

Completed:

- source integration;
- source inspection;
- dimensions;
- fact model;
- relationships;
- explicit DAX layer;
- weighted KPI calculations;
- governance measures;
- QA measures;
- PostgreSQL reconciliation;
- filter-context testing;
- formal UAT.

Remaining:

- final dashboard pages;
- drill-through;
- navigation;
- accessibility;
- final visual UAT.

Next stage:

**Build the management-facing Power BI dashboard on top of the validated semantic model.**
