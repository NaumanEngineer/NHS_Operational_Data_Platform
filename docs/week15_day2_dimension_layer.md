# Week 15 Day 2 — Power BI Dimension Layer

## Objective

Day 2 implemented the controlled dimension layer for the Power BI semantic model using the validated PostgreSQL analytical source.

The model is being developed as a star schema with dimensions separated from the Trust-date operational fact table.

---

## DimDate

A dedicated Date dimension was created covering:

- 01 January 2025
- 31 December 2027

The table includes:

- Date
- DateKey
- Year
- Quarter
- QuarterNumber
- Month
- MonthShort
- MonthNumber
- MonthYear
- MonthYearSort
- WeekNumber
- Day
- DayName
- DayShort
- DayOfWeekNumber
- IsWeekend
- StartOfWeek
- EndOfWeek

`DimDate[Date]` was marked as the official Power BI Date column.

Explicit sort columns were configured for month, quarter and weekday labels.

---

## DimTrust

`DimTrust` was created as a referenced Power Query table from the validated source.

Grain:

**One row per fictional Trust**

Fields retained:

- trust_id
- trust_code
- trust_name
- trust_type
- region

Validation:

- 3 Trust rows
- unique Trust IDs
- unique Trust codes
- no expected duplicate Trust records

---

## DimOPEL

A controlled four-row OPEL dimension was implemented.

Levels:

- OPEL 1
- OPEL 2
- OPEL 3
- OPEL 4

Additional fields include:

- sort order
- descriptive label
- elevated-OPEL indicator
- highest-OPEL indicator

OPEL is treated as an ordered categorical variable rather than an additive numeric measure.

---

## DimPressureStatus

The dimension was generated from actual source categories rather than invented labels.

Observed categories:

1. Routine pressure
2. Moderate pressure
3. Significant pressure
4. Critical pressure

`Significant pressure` and `Critical pressure` are flagged as high-pressure categories under the project's illustrative pressure-status rules.

The dimension includes explicit governance metadata:

`Project-defined v1`

These categories must not be represented as official NHS operational thresholds.

---

## DimWeatherWarning

Weather-warning semantics were investigated before dimension creation.

Observed source combinations were:

- no warning-level/type value
- yellow / ice
- amber / snow and ice

The combined blank state is represented in the dimension display key as:

`No warning`

while the original source nulls are preserved.

The dimension includes:

- warning level
- warning type
- display key
- sort order
- weather-warning indicator

---

## Modelling Controls

The dimension layer follows these principles:

- one row per dimension key;
- explicit sort columns;
- controlled categorical values;
- no automatic replacement of meaningful nulls;
- source-derived categories where possible;
- project-defined rules labelled transparently;
- relationships deferred until fact-table implementation.

---

## Day 2 Status

Completed:

- DimDate
- DimTrust
- DimOPEL
- DimPressureStatus
- DimWeatherWarning
- dimension data-type review
- dimension sorting
- dimension QA

Next:

**Week 15 Day 3 — FactTrustDailyOperations and star-schema relationships**
