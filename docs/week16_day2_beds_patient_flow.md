# Week 16 Day 2 — Beds & Patient Flow Dashboard

## Objective

Day 2 implemented the Beds & Patient Flow page of the Power BI operational intelligence dashboard.

The page was designed to help management understand:

- bed occupancy;
- critical-care pressure;
- admissions and discharges;
- net patient flow;
- discharge-ready patient-days;
- Trust-level variation.

The dashboard uses synthetic operational data only.

---

## Page Implemented

Power BI page:

`Beds & Patient Flow`

The page uses the validated semantic model created during Week 15.

---

## Headline KPI Cards

The page includes:

- Weighted General-Bed Occupancy
- Maximum General-Bed Occupancy
- Weighted Critical-Care Occupancy
- Discharge-Ready Patient-Days

The discharge-ready measure is explicitly labelled as patient-days because the source represents daily snapshots rather than unique patients.

---

## Bed Occupancy Analysis

The page includes:

### Weighted General-Bed Occupancy Trend

Shows changes in general-bed occupancy over time.

### General vs Critical-Care Occupancy by Trust

Compares weighted general-bed and critical-care occupancy across fictional Trusts.

No unsupported operational threshold lines were added.

Values above 100% are not artificially suppressed if present in the synthetic source.

---

## Patient Flow Analysis

Implemented measures include:

- Total Admissions
- Total Discharges
- Net Admissions

Validated full-period baseline:

- Admissions = 16,425
- Discharges = 15,654
- Net Admissions = 771

Reconciliation:

`16,425 - 15,654 = 771`

---

## Admissions vs Discharges

A time-series visual compares daily admissions and discharges.

This supports identification of periods where inflow exceeds outflow.

---

## Net Admissions by Trust

A Trust comparison visual shows net patient flow by organisation.

Positive net admissions indicate that admissions exceeded discharges over the selected filter context.

Net admissions are not interpreted as a standalone bed-pressure threshold.

---

## Discharge-Ready Patient-Days

The page includes a time-series view of:

`Discharge-Ready Patient-Days`

The measure is intentionally not labelled as unique patients.

It represents the sum of daily discharge-ready snapshots.

---

## Filters

The page includes:

- Trust filter
- Date-range filter

Both were tested across:

- KPI cards;
- occupancy visuals;
- admissions/discharges;
- net admissions;
- discharge-ready patient-days.

Combined Trust and Date filtering was also tested.

---

## Design Controls

The page follows the dashboard-wide design system:

- consistent navigation;
- 16:9 layout;
- light professional background;
- consistent typography;
- restrained chart density;
- no unsupported RAG threshold colouring;
- synthetic-data disclaimer visible.

---

## Day 2 Status

Completed:

- Beds & Patient Flow page
- capacity KPI cards
- weighted occupancy trend
- Trust occupancy comparison
- critical-care comparison
- admissions vs discharges
- net admissions analysis
- discharge-ready patient-days
- slicer interaction QA
- final visual polish

Next:

**Week 16 Day 3 — A&E & Ambulance and Workforce Pressure dashboards**
