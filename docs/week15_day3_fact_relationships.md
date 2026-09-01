# Week 15 Day 3 — Power BI Fact Table and Relationships

## Objective

Day 3 implemented the central Trust-date fact table and connected it to the controlled Power BI dimension layer.

The semantic model now follows a star-schema design.

---

## FactTrustDailyOperations

`FactTrustDailyOperations` was created as a reference from the validated staging query:

`SourceTrustDailyAnalytical`

Reporting grain:

**One row per fictional Trust per reporting date**

Expected validated row count:

- 90 fact rows
- 3 Trusts
- 30 reporting dates

No aggregation was applied during fact-table creation.

---

## Fact Fields Retained

The fact table retains technical relationship keys, operational measures, raw numerator/denominator fields, weather measures, OPEL fields, governance metadata and lineage fields.

### Relationship keys

- `trust_id`
- `reporting_date`
- `approved_opel_level`
- `operational_pressure_status`
- `WeatherWarningKey`

### Capacity and flow

- `general_beds_open`
- `general_beds_occupied`
- `general_bed_occupancy_pct`
- `critical_care_beds_open`
- `critical_care_beds_occupied`
- `critical_care_occupancy_pct`
- `patients_ready_for_discharge`
- `admissions`
- `discharges`
- `net_admissions`

### A&E and ambulance

- `ae_attendances`
- `four_hour_breaches`
- `four_hour_breach_pct`
- `ambulance_arrivals`
- `ambulance_handover_delays`
- `ambulance_handover_delay_pct`

### Workforce

- `establishment_fte`
- `substantive_fte`
- `absence_fte`
- `workforce_absence_pct`
- `agency_fte`
- `bank_fte`
- `unfilled_shifts`

### OPEL and governance

- `recommended_opel_level`
- `approved_opel_level`
- `previous_approved_opel_level`
- `prediction_confidence`
- `assessment_method`
- `assessment_rationale`
- `key_pressure_factors`
- `approval_status`
- `assessed_by_role`
- `reviewed_by_role`
- `reviewed_at`
- `rule_version`
- `human_override_indicator`

### Lineage

- `operational_source_system`
- `operational_source_record_id`
- `load_batch_id`
- `data_quality_status`

---

## Star-Schema Relationships

The model uses active one-to-many, single-direction relationships from dimensions to the fact table.

### Date

`DimDate[Date]`
→
`FactTrustDailyOperations[reporting_date]`

### Trust

`DimTrust[trust_id]`
→
`FactTrustDailyOperations[trust_id]`

### OPEL

`DimOPEL[OPELLevel]`
→
`FactTrustDailyOperations[approved_opel_level]`

### Pressure Status

`DimPressureStatus[PressureStatus]`
→
`FactTrustDailyOperations[operational_pressure_status]`

### Weather Warning

`DimWeatherWarning[WeatherWarningKey]`
→
`FactTrustDailyOperations[WeatherWarningKey]`

---

## Relationship Principles

The model uses:

- one-to-many relationships;
- dimensions on the one side;
- fact table on the many side;
- single-direction filtering;
- active relationships;
- no many-to-many relationships;
- no bidirectional relationships;
- no unnecessary duplicate relationship paths.

The primary OPEL relationship uses the human-reviewed approved OPEL level.

The recommended OPEL level remains available in the fact table for comparison analysis.

---

## Summarisation Controls

Additive operational counts use standard summation where appropriate.

Percentage fields, OPEL levels, FTE values and technical identifiers are configured to avoid inappropriate automatic aggregation.

Explicit DAX measures will be used for analytical reporting.

Raw numerator and denominator fields have been retained to support weighted KPI calculations.

---

## Model Visibility

Technical keys, lineage identifiers and sort-helper columns may be hidden from Report view while remaining available for:

- relationships;
- DAX;
- QA;
- lineage;
- auditability.

---

## Day 3 QA

Expected validation:

- Fact row count = 90
- 3 Trusts
- 30 fact rows per Trust
- no duplicate relationship paths
- no many-to-many relationships
- no unexpected orphan dimension members
- all five primary relationships active
- all primary relationships use single-direction filtering

---

## Day 3 Status

Completed:

- FactTrustDailyOperations
- fact-table field selection
- raw KPI field preservation
- WeatherWarningKey
- star-schema relationships
- relationship QA
- summarisation controls
- model organisation

Next:

**Week 15 Day 4 — Explicit DAX Measure Layer**
