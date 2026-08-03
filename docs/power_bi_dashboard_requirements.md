# NHS Operational Intelligence Dashboard Requirements

## Document Status

| Item | Value |
|---|---|
| Project | NHS Operational Data Platform |
| Development stage | Week 14 — Power BI requirements and KPI design |
| Session | Day 1, Session 1 — data-foundation review |
| Source status | Fully synthetic portfolio data |
| Reporting grain | One row per fictional Trust per reporting date |
| Reporting period | 1 January 2026 to 30 January 2026 |
| Current export | 90 rows and 56 columns |

---

## 1. Document Purpose

This document defines the initial business, analytical, data, governance and quality requirements for a Power BI operational-intelligence dashboard built from the NHS Operational Data Platform.

It provides the controlled foundation for later work on:

- user personas and decision-support questions;
- KPI definitions and aggregation rules;
- dashboard pages and navigation;
- the Power BI semantic model;
- DAX measures;
- reconciliation with PostgreSQL;
- accessibility, governance and acceptance testing.

The requirements must be reviewed before dashboard visuals or final KPI measures are developed.

---

## 2. Product Vision

The proposed dashboard will provide a clear, governed view of synthetic operational pressure across fictional healthcare organisations.

It should allow authorised users to:

- compare operational pressure between Trusts;
- monitor changes across the reporting period;
- investigate capacity, demand, patient-flow and workforce indicators;
- examine ambulance and A&E pressure;
- compare recommended and human-approved OPEL levels;
- identify human overrides;
- understand data quality, lineage and limitations;
- trace headline KPIs back to controlled source fields.

The dashboard is a decision-support and portfolio-demonstration product. It must not imply that it makes operational or clinical decisions.

---

## 3. Required Dashboard Disclaimer

The following statement must be visible on the dashboard home or guidance page:

> This dashboard uses fully synthetic data for learning, testing and portfolio demonstration. It must not be used for real operational or clinical decisions.

Where space permits, supporting pages should also state:

> The report provides operational intelligence for authorised human review. It does not independently determine escalation, staffing or clinical action.

---

## 4. Intended and Prohibited Use

### Intended use

The dashboard may be used for:

- learning and portfolio demonstration;
- Power BI design and semantic-modelling practice;
- synthetic operational analysis;
- SQL-to-Power-BI reconciliation;
- data-quality and governance demonstrations;
- testing future analytical pipelines and APIs.

### Prohibited use

The dashboard must not be used for:

- real operational or clinical decisions;
- real Trust comparison;
- staff performance management;
- resource allocation;
- patient-level decision-making;
- validation of an official OPEL process;
- presentation of synthetic relationships as real NHS evidence.

---

## 5. Source Data

### Primary relational source

The controlled relational source is:

`operational.vw_trust_daily_analytical`

The view combines synthetic Trust, daily operational, workforce, weather and OPEL data into one analysis-ready row per Trust per reporting date.

### Current reporting export

The current CSV source is:

`outputs/query_results.csv`

The regenerated export contains:

| Validation item | Confirmed result |
|---|---:|
| Data rows | 90 |
| Columns | 56 |
| Fictional Trusts | 3 |
| Reporting dates | 30 |
| Duplicate Trust-date records | 0 |
| Missing values | 0 |
| Reporting period | 1 January 2026 to 30 January 2026 |

Each fictional Trust contains 30 reporting-date records.

---

## 6. Reporting Grain

The required fact-table grain is:

`One row per Trust per reporting date`

Every Power BI visual, measure, relationship and reconciliation test must respect this grain.

The combination of `trust_id` and `reporting_date` is expected to identify one Trust-day record uniquely.

The model must not introduce duplicate Trust-day records through joins or relationships.

---

## 7. Available Subject Areas

The analytical source supports the following subject areas:

| Subject area | Available content | Intended Power BI use |
|---|---|---|
| Trust identity | ID, code, name, type and region | Slicers, labels and Trust comparison |
| Date | Reporting date and assessment timestamps | Trend analysis and date filtering |
| Beds | Open beds, occupied beds and occupancy percentages | Capacity KPIs and trends |
| A&E | Attendances, four-hour breaches and breach percentage | Demand and performance analysis |
| Ambulance | Arrivals, delayed handovers and delay percentage | Handover-pressure analysis |
| Patient flow | Admissions, discharges, net admissions and discharge readiness | Flow and capacity analysis |
| Workforce | Establishment, substantive, absence, agency and bank FTE; unfilled shifts | Workforce-pressure analysis |
| Weather | Temperature, precipitation, snowfall, wind and warning fields | Contextual analysis |
| OPEL | Recommended, approved and previous levels; confidence and approval fields | Escalation and override analysis |
| Operational status | Pressure status and human-override indicator | Status filtering and investigation |
| Lineage | Source system, source record, load batch and quality status | Audit and data-quality reporting |

Incident-level records are held elsewhere in the relational platform but are not included in the current Trust-day CSV export. An incident page will require a separate incident source or an enriched analytical model.

---

## 8. README Review

The project documentation confirms that the platform is a governed synthetic-data environment intended to demonstrate relational modelling, validation, operational analysis and downstream reporting.

The Power BI dashboard should focus on:

- operational-pressure monitoring;
- Trust comparison;
- trend analysis;
- capacity and patient flow;
- A&E and ambulance pressure;
- workforce pressure;
- OPEL recommendations, approvals and overrides;
- data quality, lineage and governance.

The dashboard must clearly distinguish synthetic portfolio evidence from real healthcare performance reporting.

---

## 9. Analytical Field Review

### Identifiers and dimensions

The following fields should normally be used for relationships, labels, filtering or drill-through rather than aggregation:

- `trust_id`;
- `trust_code`;
- `trust_name`;
- `trust_type`;
- `region`;
- `reporting_date`;
- `minimum_temperature_band`;
- OPEL status and approval fields;
- lineage and quality-status fields.

### Additive measures

The following daily count fields may normally be summed across Trusts and dates when the reporting context is clear:

- `general_beds_open`;
- `general_beds_occupied`;
- `critical_care_beds_open`;
- `critical_care_beds_occupied`;
- `ae_attendances`;
- `four_hour_breaches`;
- `ambulance_arrivals`;
- `ambulance_handover_delays`;
- `patients_ready_for_discharge`, subject to snapshot interpretation;
- `admissions`;
- `discharges`;
- `net_admissions`;
- `unfilled_shifts`.

FTE fields require explicit definitions before totals are used across time. Summing a daily FTE snapshot across dates may not represent a meaningful period total.

### Non-additive and semi-additive fields

The following fields must not be summed:

- occupancy percentages;
- breach and delay percentages;
- workforce absence percentage;
- temperatures and weather bands;
- OPEL levels;
- prediction confidence;
- pressure and approval status fields;
- human-override indicators.

Daily snapshot measures may be shown as latest, average, minimum or maximum values only when the selected aggregation is explicitly documented.

---

## 10. Percentage Aggregation Requirements

Stored daily percentages must not be summed.

For period-level percentage KPIs, Power BI must use the underlying numerator and denominator wherever they are available.

### General-bed occupancy

`SUM(general_beds_occupied) ÷ SUM(general_beds_open) × 100`

### Critical-care occupancy

`SUM(critical_care_beds_occupied) ÷ SUM(critical_care_beds_open) × 100`

### A&E four-hour breach percentage

`SUM(four_hour_breaches) ÷ SUM(ae_attendances) × 100`

### Ambulance handover-delay percentage

`SUM(ambulance_handover_delays) ÷ SUM(ambulance_arrivals) × 100`

### Workforce absence percentage

`SUM(absence_fte) ÷ SUM(establishment_fte) × 100`

The KPI dictionary must distinguish a weighted period percentage from an average of daily percentages.

---

## 11. Existing Findings Relevant to Dashboard Design

The existing SQL analysis identified synthetic patterns that the dashboard should be capable of reproducing and investigating, including:

- Trust comparison of bed occupancy;
- identification of high A&E breach-rate dates;
- comparison of OPEL 3 and OPEL 4 frequency;
- workforce pressure by approved OPEL level;
- recommended-versus-approved OPEL differences;
- ambulance pressure by approved OPEL level;
- relationships between weather bands and operational pressure.

Because the ambulance-arrival generator has been corrected, any previously recorded ambulance-weighted results and conclusions must be recalculated before they are quoted in the dashboard or project documentation.

The dashboard must distinguish between:

- descriptive observation;
- statistical association;
- causal conclusion.

Synthetic associations must not be presented as evidence of causation.

---

## 12. Dashboard Governance Requirements

The dashboard must:

- display the synthetic-data disclaimer prominently;
- identify the reporting period and reporting grain;
- keep recommended and approved OPEL levels separate;
- show human overrides clearly;
- describe confidence values as illustrative rather than certain;
- retain authorised human accountability;
- provide access to KPI definitions and limitations;
- avoid unsupported causal statements;
- expose refresh and lineage information where available;
- avoid presenting project-specific thresholds as official NHS thresholds.

Future production use would require additional work covering:

- named data and KPI owners;
- role-based access control;
- export restrictions;
- refresh ownership and service-level expectations;
- audit logging;
- retention requirements;
- information-governance review;
- a Data Protection Impact Assessment where applicable;
- clinical-safety and operational-governance review where applicable.

---

## 13. Current Limitations

The dashboard specification must acknowledge that:

- all organisations and values are synthetic;
- the source covers only three fictional Trusts;
- the reporting period is limited to 30 days;
- the data is not real-time;
- no production refresh process has been implemented;
- no production access controls have been implemented;
- OPEL logic is illustrative and not clinically or operationally validated;
- the Trust-day CSV does not contain incident-level records;
- previous ambulance analysis must be recalculated following the corrected seed data;
- relationships in the synthetic data do not establish causation.

---

## 14. CSV Field Inventory

The current export contains the following 56 fields:

```text
trust_id
trust_code
trust_name
trust_type
region
reporting_date
general_beds_open
general_beds_occupied
general_bed_occupancy_pct
critical_care_beds_open
critical_care_beds_occupied
critical_care_occupancy_pct
ae_attendances
four_hour_breaches
four_hour_breach_pct
ambulance_arrivals
ambulance_handover_delays
ambulance_handover_delay_pct
patients_ready_for_discharge
admissions
discharges
net_admissions
establishment_fte
substantive_fte
absence_fte
workforce_absence_pct
agency_fte
bank_fte
unfilled_shifts
temperature_min_c
temperature_max_c
precipitation_mm
snowfall_mm
wind_speed_mph
weather_warning_level
weather_warning_type
minimum_temperature_band
assessment_timestamp
recommended_opel_level
approved_opel_level
previous_approved_opel_level
prediction_confidence
assessment_method
assessment_rationale
key_pressure_factors
approval_status
assessed_by_role
reviewed_by_role
reviewed_at
rule_version
operational_pressure_status
human_override_indicator
operational_source_system
operational_source_record_id
load_batch_id
data_quality_status
```

Technical identifiers and detailed lineage fields should be retained in the semantic model but may be hidden from ordinary report users.

---

## 15. CSV Source Verification

The regenerated analytical export was reviewed directly at:

`outputs/query_results.csv`

Validation confirmed:

| Check | Result |
|---|---:|
| Data rows | 90 |
| Columns | 56 |
| Fictional Trusts | 3 |
| Reporting dates | 30 |
| Rows per Trust | 30 |
| Duplicate Trust-date records | 0 |
| Missing values | 0 |
| Percentage range failures | 0 |
| Ambulance delays exceeding arrivals | 0 |
| Ambulance percentages above 100% | 0 |
| Ambulance percentage reconciliation failures | 0 |
| Minimum ambulance delay percentage | 6.40% |
| Maximum ambulance delay percentage | 87.72% |
| Weighted whole-period ambulance delay percentage | 30.00% |

All five exported percentage fields remain within the range 0% to 100%:

- `general_bed_occupancy_pct`;
- `critical_care_occupancy_pct`;
- `four_hour_breach_pct`;
- `ambulance_handover_delay_pct`;
- `workforce_absence_pct`.

---

## 16. Ambulance Handover Validation Resolution

The original export contained seven South County Community Trust records where ambulance handover delays exceeded total ambulance arrivals. This produced daily percentages between 106.38% and 137.14%.

The investigation established that:

- the analytical percentage formula was correct;
- the synthetic generator calculated ambulance arrivals and delays independently;
- the South County arrival baseline allowed delayed handovers to exceed arrivals;
- the original database constraint checked only for non-negative values;
- the CSV did not contain the raw numerator and denominator fields needed for reconciliation.

The issue was corrected by:

- increasing the South County synthetic ambulance-arrival baseline;
- regenerating the complete synthetic batch;
- adding `chk_daily_operational_ambulance_counts` to enforce `ambulance_handover_delays <= ambulance_arrivals`;
- validating that no source records breach the rule;
- regenerating the analytical CSV from the full Trust-day view;
- retaining arrivals, delays and the derived percentage in the export.

The corrected export contains no ambulance percentages above 100%, and all 90 daily percentages reconcile exactly to their underlying arrival and delay counts.

---

## 17. Data-Foundation Conclusion

The corrected 56-column Trust-day export is suitable for initial Power BI requirements development, semantic-model design and dashboard prototyping.

It now contains the raw numerator and denominator fields required for weighted bed, A&E, ambulance and workforce percentage calculations.

The following controls remain mandatory during Power BI development:

- preserve the one-row-per-Trust-per-date grain;
- use a dedicated date dimension;
- use a Trust dimension rather than repeating descriptive filtering logic;
- prevent direct summation of percentages and status fields;
- calculate weighted period percentages from raw fields;
- reconcile headline measures to PostgreSQL;
- keep recommendations, approvals and overrides distinct;
- retain visible synthetic-data and governance warnings;
- treat incident reporting as a separate-source requirement;
- rerun affected SQL findings after source-data changes.


---

