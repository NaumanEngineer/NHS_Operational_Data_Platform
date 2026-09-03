# Week 16 Day 1 — Executive Overview Dashboard

## Objective

Day 1 focused on converting the validated Power BI semantic model into the first management-facing dashboard page.

The Executive Overview was designed to provide a concise operational view of:

- bed occupancy;
- A&E pressure;
- workforce absence;
- OPEL escalation;
- human overrides;
- operational pressure trends.

The dashboard uses synthetic operational data only.

---

## Page Implemented

Power BI page:

`Executive Overview`

The page is designed as the primary landing page for management users.

---

## Navigation

A report-wide Page Navigator was implemented for:

- Executive Overview
- Beds & Patient Flow
- A&E & Ambulance
- Workforce Pressure
- OPEL & Governance
- Trust-Day Investigation
- Data Quality & Lineage
- KPI Definitions

QA pages remain hidden from standard navigation.

---

## Executive KPI Strip

The Executive Overview contains six headline KPI cards:

1. Weighted General-Bed Occupancy
2. Total A&E Attendances
3. Weighted A&E Four-Hour Breach Rate
4. Weighted Workforce Absence
5. OPEL 3-4 Trust-Days
6. Human Override Count

Validated full-period anchors include:

- Total A&E Attendances = 25,800
- Weighted A&E Four-Hour Breach Rate = 19.82%
- OPEL 3-4 Trust-Days = 39
- Human Override Count = 4

---

## Analytical Visuals

The page includes:

### High Operational Pressure by Date

Shows the number of fictional Trusts in Significant or Critical operational pressure by reporting date.

### OPEL 3-4 Trust-Days by Trust

Validated Trust-level results:

- NRT002 = 17
- WGH001 = 15
- SCT003 = 7

Total:

`39`

### Weighted General-Bed Occupancy Trend

Shows weighted bed occupancy over time and supports Trust-level comparison.

### Approved OPEL Distribution

Shows Trust-day distribution across approved OPEL levels 1–4.

---

## Filters

The Executive Overview includes:

- Trust slicer
- Date-range slicer

Both filters were tested against KPI cards and analytical visuals.

Expected filter examples include:

- one Trust = 30 Trust-date rows;
- 10-day period across all 3 Trusts = 30 rows;
- one Trust across a 10-day period = 10 rows.

---

## Date-Slicer Control

The Date slicer uses:

`DimDate[Date]`

and is constrained to dates with fact data using:

`Fact Row Count > 0`

This prevents the slicer from exposing future dates contained in the wider Date dimension but not present in the current synthetic reporting dataset.

---

## Design Principles

The Executive Overview follows these principles:

- 16:9 page layout;
- light professional background;
- consistent typography;
- restrained visual density;
- consistent KPI-card styling;
- concise management-facing titles;
- no unsupported RAG threshold colouring;
- synthetic-data disclaimer visible;
- navigation consistent across report pages.

---

## Governance

The dashboard does not invent official NHS thresholds.

Pressure classifications remain project-defined illustrative categories.

The page visibly states:

`Synthetic operational data | Portfolio demonstration`

The report must not be used for real clinical or operational decision-making.

---

## Day 1 Status

Completed:

- dashboard shell;
- page hierarchy;
- navigation;
- Executive Overview;
- six KPI cards;
- four analytical visuals;
- Trust filtering;
- date filtering;
- interaction testing;
- initial visual polish.

Next:

**Week 16 Day 2 — Beds & Patient Flow dashboard page**
