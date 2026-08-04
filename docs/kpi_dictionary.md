# NHS Operational Intelligence Dashboard — KPI Dictionary

## Document Purpose

This document defines the key performance indicators used in the Power BI reporting layer of the NHS Operational Intelligence Platform.

Each KPI is documented with:

- its business purpose;
- source fields;
- calculation method;
- aggregation rule;
- reporting grain;
- filters;
- display format;
- interpretation;
- reconciliation method;
- known limitations.

All organisations and values are synthetic.

The KPI definitions are intended for learning, technical testing and portfolio demonstration. They must not be interpreted as official NHS performance definitions or escalation thresholds.

---

## KPI Design Principles

The dashboard will follow these rules:

1. Additive measures may be summed only where the business meaning supports aggregation.
2. Percentages will not be summed.
3. Period-level rates will use raw numerators and denominators wherever available.
4. Daily percentages will not be averaged unless the KPI explicitly requires an average daily rate.
5. OPEL levels will be treated as ordered categories rather than additive values.
6. Snapshot KPIs will use the latest valid reporting date within the current filter context.
7. Status bands will be labelled as illustrative portfolio rules.
8. Every major Power BI measure will have a matching SQL reconciliation query.
9. Synthetic associations will not be presented as causal findings.
10. Recommended and approved OPEL levels will remain separate.

---

## KPI Definition Template

Each KPI will use the following structure:

### KPI Name

- Business question:
- Intended user:
- Definition:
- Numerator:
- Denominator:
- Formula:
- Aggregation:
- Reporting grain:
- Date field:
- Filters:
- Display format:
- Direction of concern:
- Warning threshold:
- Source fields:
- SQL reconciliation:
- Known limitations:
- Synthetic-data status:

---

## KPI 1 — Average General-Bed Occupancy

- Business question: What was the average level of general-bed utilisation during the selected period?
- Intended user: Executive operational leader, performance analyst
- Definition: Average percentage of open general beds recorded as occupied across the selected Trust-date records
- Numerator: Daily occupied general beds
- Denominator: Daily open general beds
- Formula: Average of validated daily occupancy percentages, unless raw numerator and denominator fields are available for a weighted calculation
- Aggregation: Average
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Percentage with two decimal places
- Direction of concern: Higher values may indicate greater capacity pressure
- Warning threshold: Not defined; any status bands must be labelled as illustrative
- Source fields: `general_bed_occupancy_pct`
- SQL reconciliation: Compare the Power BI result with the PostgreSQL average occupancy query
- Known limitations: The current CSV contains the calculated percentage but not the raw open-bed and occupied-bed values
- Synthetic-data status: Fully synthetic

---

## KPI 2 — Maximum General-Bed Occupancy

- Business question: What was the highest recorded occupancy during the selected period?
- Intended user: Operational leader, performance analyst
- Definition: Highest daily general-bed occupancy percentage within the current filter context
- Numerator: Not applicable
- Denominator: Not applicable
- Formula: Maximum of `general_bed_occupancy_pct`
- Aggregation: Maximum
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Percentage with two decimal places
- Direction of concern: Higher values indicate greater peak pressure
- Warning threshold: Not defined
- Source fields: `general_bed_occupancy_pct`
- SQL reconciliation: `MAX(general_bed_occupancy_pct)`
- Known limitations: Represents the highest synthetic daily value and not an official escalation threshold
- Synthetic-data status: Fully synthetic

---

## KPI 3 — Total A&E Attendances

- Business question: How much A&E activity occurred during the selected period?
- Intended user: Executive operational leader, A&E performance analyst
- Definition: Total number of recorded A&E attendances
- Numerator: Not applicable
- Denominator: Not applicable
- Formula: Sum of `ae_attendances`
- Aggregation: Sum
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Whole number with thousands separator
- Direction of concern: Higher activity may indicate increased demand but is not inherently poor performance
- Warning threshold: Not defined
- Source fields: `ae_attendances`
- SQL reconciliation: `SUM(ae_attendances)`
- Known limitations: Activity volume must be interpreted alongside capacity and breach measures
- Synthetic-data status: Fully synthetic

---

## KPI 4 — Weighted A&E Four-Hour Breach Rate

- Business question: What proportion of A&E attendances resulted in a four-hour breach?
- Intended user: Executive operational leader, A&E analyst
- Definition: Total four-hour breaches divided by total A&E attendances during the selected period
- Numerator: Total four-hour breaches
- Denominator: Total A&E attendances
- Formula: Total breaches divided by total attendances, multiplied by 100
- Aggregation: Weighted percentage
- Reporting grain: Trust-date aggregated to the selected context
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Percentage with two decimal places
- Direction of concern: Higher values indicate greater breach pressure
- Warning threshold: No official threshold defined in this portfolio
- Source fields: `four_hour_breaches`, `ae_attendances`
- SQL reconciliation: `SUM(four_hour_breaches) / NULLIF(SUM(ae_attendances), 0) * 100`
- Known limitations: The current CSV contains `four_hour_breach_pct` but not the raw `four_hour_breaches` count. A final weighted calculation therefore requires an enriched analytical source containing both numerator and denominator.
- Synthetic-data status: Fully synthetic
- Current implementation status: Blocked pending source enrichment

---

## KPI 5 — Average Workforce Absence Percentage

- Business question: What was the average workforce absence level during the selected period?
- Intended user: Workforce planner, operational leader
- Definition: Average daily workforce absence percentage across selected Trust-date records
- Numerator: Daily absence FTE
- Denominator: Daily establishment FTE
- Formula: Average of `workforce_absence_pct`, unless raw numerator and denominator fields are available
- Aggregation: Average
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Percentage with two decimal places
- Direction of concern: Higher values indicate greater workforce pressure
- Warning threshold: Not defined
- Source fields: `workforce_absence_pct`
- SQL reconciliation: `AVG(workforce_absence_pct)`
- Known limitations: The current CSV contains the calculated percentage rather than its raw numerator and denominator
- Synthetic-data status: Fully synthetic

---

## KPI 6 — OPEL 3–4 Days

- Business question: How many Trust-days were recorded at approved OPEL 3 or OPEL 4?
- Intended user: Executive operational leader, performance analyst
- Definition: Count of distinct Trust-date records where approved OPEL level is 3 or 4
- Numerator: Count of qualifying Trust-date records
- Denominator: Not applicable
- Formula: Count of Trust-date rows where `approved_opel_level >= 3`
- Aggregation: Conditional distinct count
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period
- Display format: Whole number
- Direction of concern: Higher values indicate more frequent periods of elevated synthetic pressure
- Warning threshold: Not defined
- Source fields: `approved_opel_level`, `reporting_date`, `trust_code`
- SQL reconciliation: Count Trust-date rows where `approved_opel_level >= 3`
- Known limitations: OPEL values are synthetic and do not represent real escalation decisions
- Synthetic-data status: Fully synthetic

---

## KPI 7 — Ambulance Handover Delay Rate

- Business question: What proportion of ambulance arrivals were recorded as delayed during the selected period?
- Intended user: Executive operational leader, ambulance-performance analyst
- Definition: Total delayed ambulance handovers divided by total ambulance arrivals
- Numerator: Delayed ambulance handovers
- Denominator: Ambulance arrivals
- Formula: Total delayed handovers divided by total ambulance arrivals, multiplied by 100
- Aggregation: Weighted percentage
- Reporting grain: Trust-date aggregated to the selected context
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Percentage with two decimal places
- Direction of concern: Higher values indicate greater handover pressure
- Warning threshold: Not defined
- Source fields: `ambulance_handover_delays`, `ambulance_arrivals`
- SQL reconciliation: `SUM(ambulance_handover_delays) / NULLIF(SUM(ambulance_arrivals), 0) * 100`
- Known limitations: The current CSV contains `ambulance_handover_delay_pct`, including values above 100%, but does not contain the raw numerator and denominator fields. The KPI must not be finalised until the source definition is verified and the analytical source is corrected or enriched.
- Synthetic-data status: Fully synthetic
- Current implementation status: Blocked pending source correction

### Ambulance KPI Decision

The existing `ambulance_handover_delay_pct` field will not be used as a trusted final KPI until:

1. the source formula is verified;
2. the business meaning is confirmed;
3. the raw `ambulance_arrivals` and `ambulance_handover_delays` fields are added to the analytical source;
4. the exported CSV is regenerated;
5. the resulting rate is reconciled against PostgreSQL.

If the existing field represents delay minutes or another measure rather than a proportion of arrivals, it must be renamed accordingly.

---

## KPI 8 — Discharge-Ready Patient-Days

- Business question: What cumulative discharge-ready pressure was recorded during the selected period?
- Intended user: Operational leader, patient-flow analyst
- Definition: Sum of daily patients-ready-for-discharge values across selected Trust-date records
- Numerator: Daily patients ready for discharge
- Denominator: Not applicable
- Formula: Sum of `patients_ready_for_discharge`
- Aggregation: Sum
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Whole number
- Direction of concern: Higher values may indicate persistent discharge-flow pressure
- Warning threshold: Not defined
- Source fields: `patients_ready_for_discharge`
- SQL reconciliation: `SUM(patients_ready_for_discharge)`
- Known limitations: This is a cumulative patient-day measure, not a count of unique patients. It does not distinguish clinical, social-care or administrative discharge barriers.
- Synthetic-data status: Fully synthetic

---

## KPI 9 — Net Admissions

- Business question: Did admissions exceed discharges during the selected period?
- Intended user: Operational leader, patient-flow analyst
- Definition: Net daily patient-flow balance already calculated in the analytical source
- Numerator: Admissions minus discharges
- Denominator: Not applicable
- Formula: Sum of `net_admissions`
- Aggregation: Sum
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Whole number
- Direction of concern: Positive values may indicate increasing pressure on available capacity
- Warning threshold: Not defined
- Source fields: `net_admissions`
- SQL reconciliation: `SUM(net_admissions)`
- Known limitations: The current CSV does not contain admissions and discharges separately, so the components cannot be independently reconciled from the export
- Synthetic-data status: Fully synthetic

---

## KPI 10 — Average Critical-Care Occupancy

- Business question: What was the average critical-care occupancy during the selected period?
- Intended user: Executive operational leader, capacity analyst
- Definition: Average daily critical-care occupancy percentage across selected Trust-date records
- Numerator: Daily occupied critical-care beds
- Denominator: Daily open critical-care beds
- Formula: Average of `critical_care_occupancy_pct`, unless raw numerator and denominator fields become available
- Aggregation: Average
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Percentage with two decimal places
- Direction of concern: Higher values may indicate greater critical-care capacity pressure
- Warning threshold: Not defined
- Source fields: `critical_care_occupancy_pct`
- SQL reconciliation: `AVG(critical_care_occupancy_pct)`
- Known limitations: The current CSV contains only the calculated percentage and not the raw occupied and open critical-care bed counts
- Synthetic-data status: Fully synthetic

---

## KPI 11 — Average Daily Agency FTE

- Business question: What was the average daily agency workforce capacity during the selected period?
- Intended user: Workforce planner, operational leader
- Definition: Average recorded agency FTE across selected Trust-date records
- Numerator: Sum of daily agency FTE
- Denominator: Number of selected Trust-date records
- Formula: Average of `agency_fte`
- Aggregation: Average
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Decimal with two places
- Direction of concern: Higher values may indicate increased reliance on temporary staffing
- Warning threshold: Not defined
- Source fields: `agency_fte`
- SQL reconciliation: `AVG(agency_fte)`
- Known limitations: The measure does not include staffing cost, staff group, shift type or hours worked
- Synthetic-data status: Fully synthetic

---

## KPI 12 — Average Daily Bank FTE

- Business question: What was the average daily bank workforce capacity during the selected period?
- Intended user: Workforce planner, operational leader
- Definition: Average recorded bank FTE across selected Trust-date records
- Numerator: Sum of daily bank FTE
- Denominator: Number of selected Trust-date records
- Formula: Average of `bank_fte`
- Aggregation: Average
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Decimal with two places
- Direction of concern: Higher values may indicate increased use of flexible staffing
- Warning threshold: Not defined
- Source fields: `bank_fte`
- SQL reconciliation: `AVG(bank_fte)`
- Known limitations: The measure does not include staffing cost, staff group, shift type or hours worked
- Synthetic-data status: Fully synthetic

---

## KPI 13 — Total Unfilled Shifts

- Business question: How many unfilled shifts were recorded during the selected period?
- Intended user: Workforce planner, operational leader
- Definition: Total number of unfilled shifts across selected Trust-date records
- Numerator: Not applicable
- Denominator: Not applicable
- Formula: Sum of `unfilled_shifts`
- Aggregation: Sum
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Whole number
- Direction of concern: Higher values indicate greater workforce pressure
- Warning threshold: Not defined
- Source fields: `unfilled_shifts`
- SQL reconciliation: `SUM(unfilled_shifts)`
- Known limitations: The current dataset does not identify staff group, shift duration or clinical area
- Synthetic-data status: Fully synthetic

---

## KPI 14 — Human Override Count

- Business question: How often did the human-approved OPEL decision differ from the system recommendation?
- Intended user: Executive operational leader, governance reviewer, performance analyst
- Definition: Count of Trust-date records where the human-override indicator is true
- Numerator: Count of override records
- Denominator: Not applicable
- Formula: Count of rows where `human_override_indicator` is true
- Aggregation: Conditional count
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level
- Display format: Whole number
- Direction of concern: Neither higher nor lower is inherently good; the measure supports governance review
- Warning threshold: Not defined
- Source fields: `human_override_indicator`
- SQL reconciliation: Count rows where `human_override_indicator = true`
- Known limitations: The current CSV does not include `recommended_opel_level`, so the override cannot be independently recalculated from the export
- Synthetic-data status: Fully synthetic

---

## KPI 15 — Latest Approved OPEL Level

- Business question: What is the latest approved OPEL level within the selected reporting context?
- Intended user: Executive operational leader, performance analyst
- Definition: Approved OPEL level recorded on the latest available reporting date
- Numerator: Not applicable
- Denominator: Not applicable
- Formula: Return `approved_opel_level` for the latest valid `reporting_date`
- Aggregation: Latest-value calculation
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust and reporting period
- Display format: Whole number from 1 to 4
- Direction of concern: Higher values represent greater synthetic operational escalation
- Warning threshold: OPEL levels are displayed as categories rather than portfolio-defined warning thresholds
- Source fields: `approved_opel_level`, `reporting_date`, `trust_code`
- SQL reconciliation: Select the approved OPEL level from the latest reporting date within the same filter context
- Known limitations: Where multiple Trusts are selected, the dashboard must not present one combined OPEL value without clearly defined logic
- Synthetic-data status: Fully synthetic

---

## KPI 16 — OPEL 4 Days

- Business question: How many Trust-days were recorded at approved OPEL 4?
- Intended user: Executive operational leader, performance analyst
- Definition: Count of distinct Trust-date records where approved OPEL level equals 4
- Numerator: Count of qualifying Trust-date records
- Denominator: Not applicable
- Formula: Count of rows where `approved_opel_level = 4`
- Aggregation: Conditional count
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust and reporting period
- Display format: Whole number
- Direction of concern: Higher values indicate more frequent synthetic periods at the highest OPEL level
- Warning threshold: Not applicable
- Source fields: `approved_opel_level`, `reporting_date`, `trust_code`
- SQL reconciliation: Count Trust-date rows where `approved_opel_level = 4`
- Known limitations: The OPEL values are synthetic and do not represent real escalation events
- Synthetic-data status: Fully synthetic

---

## KPI 17 — Human Override Percentage

- Business question: What proportion of Trust-day records involved a human override?
- Intended user: Governance reviewer, executive operational leader
- Definition: Human-override records divided by total assessed Trust-day records
- Numerator: Count of records where `human_override_indicator` is true
- Denominator: Count of Trust-day records with an OPEL assessment
- Formula: Override count divided by assessed Trust-day count, multiplied by 100
- Aggregation: Percentage
- Reporting grain: Trust-date aggregated to the current filter context
- Date field: `reporting_date`
- Filters: Trust, reporting period and approved OPEL level
- Display format: Percentage with two decimal places
- Direction of concern: Neither higher nor lower is automatically good or bad; the KPI supports governance review
- Warning threshold: Not defined
- Source fields: `human_override_indicator`, `approved_opel_level`
- SQL reconciliation: Count override records divided by count of assessed Trust-date records
- Known limitations: The current CSV does not include `recommended_opel_level`, so the override logic cannot be independently reconstructed
- Synthetic-data status: Fully synthetic

---

## KPI 18 — High Operational-Pressure Days

- Business question: How many Trust-days were classified as high or critical operational pressure?
- Intended user: Executive operational leader, performance analyst
- Definition: Count of Trust-date records classified as high or critical by the project-defined pressure-status logic
- Numerator: Count of qualifying Trust-date records
- Denominator: Not applicable
- Formula: Count of rows where `operational_pressure_status` is classified as high or critical
- Aggregation: Conditional count
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period and approved OPEL level
- Display format: Whole number
- Direction of concern: Higher values indicate more frequent synthetic pressure
- Warning threshold: Based only on project-defined categories
- Source fields: `operational_pressure_status`
- SQL reconciliation: Count rows matching the documented high-pressure status values
- Known limitations: The status categories are portfolio rules and are not official NHS escalation thresholds
- Synthetic-data status: Fully synthetic

---

## KPI 19 — Weather-Warning Days

- Business question: How many Trust-days contained a recorded weather warning?
- Intended user: Operational analyst, winter-pressure team
- Definition: Count of Trust-date records where a weather-warning level is present
- Numerator: Count of records with a non-blank warning level
- Denominator: Not applicable
- Formula: Count of rows where `weather_warning_level` is not blank
- Aggregation: Conditional count
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust, reporting period, approved OPEL level and warning level
- Display format: Whole number
- Direction of concern: A higher count indicates more warning-affected synthetic days but does not prove operational impact
- Warning threshold: Not defined
- Source fields: `weather_warning_level`
- SQL reconciliation: Count rows where `weather_warning_level` is not null
- Known limitations: Blank values should be interpreted as `No warning` only after confirming that blanks do not represent missing data
- Synthetic-data status: Fully synthetic

---

## KPI 20 — Reporting Completeness Percentage

- Business question: Is the expected Trust-date reporting coverage complete?
- Intended user: BI manager, data-quality reviewer
- Definition: Actual valid Trust-day records divided by expected Trust-day records
- Numerator: Actual distinct Trust-date records
- Denominator: Expected Trust count multiplied by expected reporting-date count
- Formula: Actual Trust-day records divided by expected Trust-day records, multiplied by 100
- Aggregation: Percentage
- Reporting grain: Dataset or current reporting context
- Date field: `reporting_date`
- Filters: Trust and reporting period
- Display format: Percentage with two decimal places
- Direction of concern: Lower values indicate incomplete reporting coverage
- Warning threshold: Expected result for the current dataset is 100%
- Source fields: `trust_code`, `reporting_date`
- SQL reconciliation: Distinct Trust-date count divided by expected Trust-date combinations
- Known limitations: The expected denominator must adjust correctly when users filter to a smaller Trust or date selection
- Synthetic-data status: Fully synthetic

---

## KPI 21 — Duplicate Trust-Date Count

- Business question: Does the reporting dataset contain duplicate Trust-date records?
- Intended user: BI manager, data-quality reviewer
- Definition: Number of Trust-date combinations containing more than one record
- Numerator: Count of duplicate Trust-date groups
- Denominator: Not applicable
- Formula: Group by `trust_code` and `reporting_date`, then count groups where row count exceeds one
- Aggregation: Data-quality count
- Reporting grain: Trust-date
- Date field: `reporting_date`
- Filters: Trust and reporting period
- Display format: Whole number
- Direction of concern: Any value above zero requires investigation
- Warning threshold: Zero expected
- Source fields: `trust_code`, `reporting_date`
- SQL reconciliation: Group by Trust and reporting date and return combinations where `COUNT(*) > 1`
- Known limitations: This confirms reporting-grain uniqueness but does not identify every possible source-level duplication issue
- Synthetic-data status: Fully synthetic

---

## KPI Classification Summary

| KPI | Type | Safe to sum? | Final source ready? |
|---|---|---:|---:|
| Average general-bed occupancy | Average percentage | No | Yes, with limitation |
| Maximum general-bed occupancy | Maximum percentage | No | Yes |
| Total A&E attendances | Additive count | Yes | Yes |
| Weighted A&E breach rate | Weighted percentage | No | No — raw breach count required |
| Average workforce absence | Average percentage | No | Yes, with limitation |
| OPEL 3–4 days | Conditional distinct count | No | Yes |
| Ambulance handover delay rate | Weighted percentage | No | No — source correction required |
| Discharge-ready patient-days | Additive patient-day measure | Yes | Yes, with limitation |
| Net admissions | Additive derived measure | Yes | Yes, with limitation |
| Average critical-care occupancy | Average percentage | No | Yes, with limitation |
| Average daily agency FTE | Average | No | Yes |
| Average daily bank FTE | Average | No | Yes |
| Total unfilled shifts | Additive count | Yes | Yes |
| Human override count | Conditional count | No | Yes |
| Latest approved OPEL | Latest categorical value | No | Yes |
| OPEL 4 days | Conditional count | No | Yes |
| Human override percentage | Percentage | No | Yes, with limitation |
| High operational-pressure days | Conditional count | No | Yes |
| Weather-warning days | Conditional count | No | Requires blank-value confirmation |
| Reporting completeness | Percentage | No | Yes |
| Duplicate Trust-date count | Data-quality count | No | Yes |

---

## KPI Source-Readiness Register

| KPI | Current CSV support | Status |
|---|---|---|
| Average general-bed occupancy | Daily percentage available | Ready with limitation |
| Maximum general-bed occupancy | Daily percentage available | Ready |
| Total A&E attendances | Raw count available | Ready |
| Weighted A&E breach rate | Raw breach count absent | Blocked |
| Average workforce absence | Daily percentage available | Ready with limitation |
| OPEL 3–4 days | Approved OPEL available | Ready |
| Ambulance handover delay rate | Raw numerator and denominator absent | Blocked |
| Discharge-ready patient-days | Daily value available | Ready with limitation |
| Net admissions | Derived daily value available | Ready with limitation |
| Average critical-care occupancy | Daily percentage available | Ready with limitation |
| Average daily agency FTE | Daily FTE available | Ready |
| Average daily bank FTE | Daily FTE available | Ready |
| Unfilled shifts | Daily count available | Ready |
| Human override count | Indicator available | Ready |
| Latest approved OPEL | Approved OPEL and date available | Ready |
| OPEL 4 days | Approved OPEL available | Ready |
| Human override percentage | Indicator available | Ready with limitation |
| High operational-pressure days | Status field available | Ready |
| Weather-warning days | Warning field available | Requires blank-value confirmation |
| Reporting completeness | Trust and date available | Ready |
| Duplicate Trust-date count | Trust and date available | Ready |

---

## Deferred KPI Definitions

Incident KPIs are not included in the current Power BI source because `outputs/query_results.csv` does not contain incident counts, severity or incident-status fields.

The following KPIs are deferred until the analytical source is enriched:

- total incidents;
- high or critical incidents;
- unresolved incidents;
- incident rate per reporting day.

Recommended-versus-approved OPEL comparison is also limited because the current CSV contains `approved_opel_level` and `human_override_indicator`, but not `recommended_opel_level`.

These fields should be added to an enriched analytical view or export before the final dashboard is built.

---

## Aggregation Rules Summary

The Power BI model must apply the following aggregation rules.

### Additive Measures

These measures may be summed across Trusts and reporting dates where the business meaning supports aggregation:

- `ae_attendances`
- `patients_ready_for_discharge`, when explicitly reported as patient-days
- `net_admissions`
- `unfilled_shifts`

Additive measures must still be interpreted carefully.

For example, summing `patients_ready_for_discharge` across dates produces discharge-ready patient-days rather than a count of unique patients.

### Non-Additive Measures

These measures must not be summed:

- `general_bed_occupancy_pct`
- `critical_care_occupancy_pct`
- `four_hour_breach_pct`
- `ambulance_handover_delay_pct`
- `workforce_absence_pct`
- `agency_fte`
- `bank_fte`
- `approved_opel_level`
- `temperature_min_c`
- `temperature_max_c`
- `operational_pressure_status`
- `human_override_indicator`

These fields require averages, maximums, conditional counts, latest-value logic or categorical analysis.

### Weighted Percentages

A period-level percentage should be calculated using total numerators and denominators wherever possible.

For example:

```text
Weighted A&E breach rate
=
Total four-hour breaches
÷
Total A&E attendances
× 100
```

A simple average of daily percentages may produce a different result because each day may contain a different number of attendances.

The following weighted KPIs require enriched source fields:

- weighted A&E four-hour breach rate;
- weighted ambulance handover delay rate;
- weighted bed occupancy, if required;
- weighted workforce absence percentage, if required.

### Average Daily Percentages

An average daily percentage may be used where raw numerator and denominator fields are unavailable, provided the KPI is clearly labelled.

Examples:

- average daily general-bed occupancy percentage;
- average daily critical-care occupancy percentage;
- average daily workforce absence percentage.

These measures must not be described as weighted period rates.

### Average Daily FTE Measures

Agency and bank FTE should be averaged over selected Trust-date records rather than summed across reporting dates.

Examples:

- average daily agency FTE;
- average daily bank FTE.

Summing daily FTE values across multiple dates would create an accumulated FTE-day measure and could mislead users if labelled simply as FTE.

### Conditional Counts

Conditional-count measures include:

- OPEL 3–4 days;
- OPEL 4 days;
- human override count;
- high operational-pressure days;
- weather-warning days;
- duplicate Trust-date count.

These measures count records meeting a documented condition within the current filter context.

### Latest-Value Measures

Latest-value measures must return a value from the most recent valid reporting date.

Examples:

- latest approved OPEL level;
- latest operational-pressure status;
- latest occupancy percentage;
- latest data refresh timestamp.

Where multiple Trusts are selected, the dashboard must not combine multiple categorical values into a misleading single result.

### Distinct Counts

Distinct counts should be used for:

- Trust count;
- reporting-date count;
- Trust-day count;
- OPEL escalation days where duplicate source records may otherwise inflate results.

### Status Fields

Status fields must be treated as categories.

They must not be averaged or summed.

Examples:

- `operational_pressure_status`
- `weather_warning_level`
- OPEL categories

Any status bands used in this portfolio must be labelled as illustrative rather than official NHS thresholds.

---

## Division-by-Zero Handling

All percentage calculations must protect against a zero denominator.

In PostgreSQL, use:

```sql
numerator::numeric
/
NULLIF(denominator, 0)
```

In Power BI, use:

```DAX
DIVIDE(
    [Numerator Measure],
    [Denominator Measure]
)
```

The dashboard should return blank or a clearly documented alternative when the denominator is zero.

It must not display an artificial zero percentage unless that interpretation is explicitly justified.

---

## Filter-Context Rules

All KPIs must respond consistently to relevant report filters.

Core filter dimensions will include:

- Trust;
- reporting date;
- approved OPEL level;
- operational-pressure status;
- weather-warning level.

Measures must be tested under:

- no filters;
- one selected Trust;
- multiple selected Trusts;
- one reporting date;
- a reporting-date range;
- one OPEL level;
- combined Trust and date filters.

Data-quality KPIs may require special logic so that expected row counts adjust correctly to the current filter context.

---

## Formatting Rules

| Measure type | Display format |
|---|---|
| Activity counts | Whole number with thousands separator |
| Percentages | Percentage with two decimal places |
| FTE measures | Decimal with two places |
| OPEL level | Whole number or category |
| Temperature | Decimal with one place and °C |
| Dates | `dd MMM yyyy` |
| Data-quality counts | Whole number |
| Status values | Text category |

Formatting must remain consistent across all report pages.

---

## Threshold and Status Governance

No official NHS thresholds will be invented for this portfolio.

Where illustrative status bands are used, they must be labelled clearly as:

`Project-defined illustrative rules`

They must not be described as:

- official OPEL rules;
- national NHS targets;
- clinically validated thresholds;
- operational escalation policy.

Any future implementation using real NHS thresholds would require approved definitions, stakeholder sign-off and version control.

---

## SQL Reconciliation Requirements

Every major Power BI KPI must have a matching PostgreSQL reconciliation query.

The reconciliation process must compare:

- the same date range;
- the same Trust selection;
- the same OPEL filter;
- the same numerator;
- the same denominator;
- the same aggregation rule;
- the same handling of null and zero values.

Recommended tolerance:

| KPI type | Tolerance |
|---|---:|
| Counts | 0 |
| Distinct counts | 0 |
| Percentages | 0.01 percentage points |
| FTE values | 0.01 |
| Average values | 0.01 |
| Latest categorical values | Exact match |

Any unexplained difference must be investigated before the dashboard is approved.

---

## KPI Quality Review

The KPI dictionary was reviewed against the following principles:

- [x] Each KPI answers a defined business question.
- [x] Each KPI identifies its intended user.
- [x] Each KPI defines its reporting grain.
- [x] Additive and non-additive fields are distinguished.
- [x] Weighted rates are separated from average daily percentages.
- [x] OPEL levels are not treated as additive values.
- [x] Agency and bank FTE are treated as average daily measures.
- [x] Discharge-ready values are labelled as patient-days when summed across dates.
- [x] No official NHS threshold has been invented.
- [x] Division-by-zero handling is specified.
- [x] Each major KPI includes a SQL reconciliation method.
- [x] Current CSV limitations are documented.
- [x] Blocked KPIs are clearly identified.
- [x] Synthetic-data status is visible.
- [x] Human accountability is preserved.
- [x] Unsupported causal interpretation is prohibited.

---

















