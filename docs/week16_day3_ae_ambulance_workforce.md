# Week 16 Day 3 — A&E, Ambulance and Workforce Dashboards

## Objective

Day 3 implemented two management-facing Power BI pages:

- A&E & Ambulance
- Workforce Pressure

The pages use the validated Week 15 semantic model and synthetic operational data.

---

# A&E & Ambulance

## Headline KPIs

The page includes:

- Total A&E Attendances
- Total Four-Hour Breaches
- Weighted A&E Four-Hour Breach Rate
- Total Ambulance Arrivals
- Total Ambulance Handover Delays

Validated full-period A&E baseline:

- A&E Attendances = 25,800
- Four-Hour Breaches = 5,113
- Weighted Four-Hour Breach Rate = 19.8%

The weighted breach-rate measure is used as the primary KPI rather than a simple average of daily percentage fields.

---

## A&E Analysis

Implemented visuals include:

- A&E Attendances and Four-Hour Breaches by Date
- Weighted A&E Four-Hour Breach Rate by Trust
- Weighted A&E Four-Hour Breach Rate Trend
- A&E Attendances by Trust

Trust and Date slicers were tested across the page.

---

## Ambulance Analysis

Implemented visuals include:

- Ambulance Arrivals by Date
- Ambulance Handover Delays by Date
- Provisional Ambulance Handover Delay Rate by Trust

The ambulance rate is derived as:

`Total Ambulance Handover Delays / Total Ambulance Arrivals`

However, the exact business definition of the source field `ambulance_handover_delays` has not yet been formally confirmed.

The metric is therefore labelled as provisional.

No interpretation in minutes is used.

A report-page tooltip was designed to communicate the provisional governance status without overcrowding the dashboard.

---

# Workforce Pressure

## Headline KPIs

The page includes:

- Weighted Workforce Absence
- Average Establishment FTE
- Average Substantive FTE
- Average Daily Agency FTE
- Average Daily Bank FTE
- Total Unfilled Shifts

Weighted workforce absence is calculated using total absence FTE divided by total establishment FTE within the selected filter context.

---

## Workforce Analysis

Implemented visuals include:

- Weighted Workforce Absence Trend
- Weighted Workforce Absence by Trust
- Average Daily Agency vs Bank FTE by Trust
- Total Unfilled Shifts by Trust

An optional Workforce Gap analysis can also be used to compare establishment and substantive staffing.

---

## Filter QA

Both dashboard pages were tested using:

- Trust filtering
- Date-range filtering
- combined Trust and Date filtering

Measures recalculated correctly under filter context.

---

## Governance Controls

The Day 3 dashboards follow the project governance approach:

- synthetic operational data only
- weighted measures used where appropriate
- no unsupported operational thresholds
- no unsupported RAG classifications
- provisional ambulance metric clearly labelled
- no unverified interpretation of ambulance delay units

---

## Day 3 Status

Completed:

- A&E & Ambulance dashboard
- A&E KPI layer
- A&E activity trends
- weighted breach-rate analysis
- ambulance analysis
- provisional ambulance governance treatment
- Workforce Pressure dashboard
- workforce KPI layer
- absence analysis
- temporary-staffing comparison
- unfilled-shift analysis
- filter and interaction QA
- final visual polish

Next:

**Week 16 Day 4 — OPEL & Governance dashboard**
