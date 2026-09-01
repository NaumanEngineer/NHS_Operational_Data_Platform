# Week 15 Day 4 — Explicit DAX Measure Layer

## Objective

Day 4 implemented the explicit DAX measure layer for the Power BI semantic model.

The model now separates raw source fields from governed analytical calculations.

---

## Measure Organisation

All explicit measures are stored in:

`_Measures`

Display folders:

- 01 Capacity and Flow
- 02 A&E and Ambulance
- 03 Workforce
- 04 OPEL and Governance
- 05 Data Quality

This separates business calculations from raw source columns.

---

## Capacity and Flow Measures

Implemented measures include:

- Average General-Bed Occupancy
- Maximum General-Bed Occupancy
- Weighted General-Bed Occupancy
- Average Critical-Care Occupancy
- Weighted Critical-Care Occupancy
- Discharge-Ready Patient-Days
- Total Admissions
- Total Discharges
- Net Admissions
- Calculated Net Admissions

Raw bed counts are retained so weighted occupancy can use numerator/denominator logic rather than simple average percentages.

---

## A&E and Ambulance Measures

Implemented measures include:

- Total A&E Attendances
- Total Four-Hour Breaches
- Weighted A&E Four-Hour Breach Rate
- Total Ambulance Arrivals
- Total Ambulance Handover Delays
- Ambulance Handover Delay Rate

The A&E breach KPI uses:

four_hour_breaches / ae_attendances

rather than averaging daily percentage values.

The ambulance rate remains subject to final business-definition validation of the source field `ambulance_handover_delays`.

---

## Workforce Measures

Implemented measures include:

- Average Workforce Absence
- Weighted Workforce Absence
- Average Establishment FTE
- Average Substantive FTE
- Average Daily Agency FTE
- Average Daily Bank FTE
- Total Unfilled Shifts
- Average Workforce Gap FTE

FTE values are treated carefully to avoid presenting summed FTE-days as a staffing level.

---

## OPEL and Governance Measures

Implemented measures include:

- OPEL 3-4 Days
- OPEL 4 Days
- High Operational-Pressure Days
- Human Override Count
- Human Override Percentage
- Recommendation Agreement Count
- Recommendation Agreement Percentage
- Latest Approved OPEL Level
- Weather-Warning Days

Approved OPEL remains the primary human-reviewed operational outcome.

Recommended OPEL is retained for governance comparison.

---

## Data Quality Measures

Implemented QA measures include:

- Fact Row Count
- Duplicate Trust-Date Count
- Reporting Completeness Percentage
- Net Admissions Variance
- A&E Breach Rate QA
- Workforce Absence Difference
- OPEL Recommendation Mismatch Count
- Override Reconciliation Variance

Expected clean-model results include:

- duplicate Trust-date count = 0
- reporting completeness = 100%
- override reconciliation variance = 0
- net-admissions variance = 0

---

## Formatting Controls

Counts use whole-number formatting.

Rates use percentage formatting where the underlying DAX returns a decimal ratio.

FTE values and source percentage fields use controlled decimal formatting.

OPEL values remain categorical and are not summed.

---

## Day 4 Status

Completed:

- dedicated measure table
- display-folder structure
- capacity and flow measures
- A&E and ambulance measures
- workforce measures
- OPEL and governance measures
- data-quality measures
- formatting QA
- measure-home-table cleanup

Next:

**Week 15 Day 5 — PostgreSQL reconciliation, filter-context testing and formal UAT execution**
