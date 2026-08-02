# NHS Operational Data Platform — Data Dictionary

## Purpose

This data dictionary documents the principal fields used in the NHS Operational Data Platform.

It defines:

- the table containing each field;
- PostgreSQL data type;
- business meaning;
- expected or permitted values;
- synthetic source;
- principal data-quality rule.

All organisations and operational values in this project are fictional.

The dictionary reflects the current PostgreSQL schema and should be updated whenever the schema changes.

---

## General Conventions

| Convention | Meaning |
|---|---|
| Trust | A fictional healthcare provider organisation |
| Reporting date | The calendar date represented by an operational record |
| Trust-day | One Trust combined with one reporting date |
| OPEL | Operational Pressures Escalation Level |
| FTE | Full-time equivalent |
| Synthetic source | Data generated for learning, testing and portfolio demonstration |
| Required | The field should not contain `NULL` unless explicitly permitted |
| Derived measure | A value calculated from stored fields rather than stored directly |

---

## 1. Trust Reference Data

| Field | Table | Type | Definition | Valid range or values | Source | Quality rule |
|---|---|---|---|---|---|---|
| `trust_id` | `operational.trusts` | `BIGINT` | System-generated identifier for a Trust record. | Positive whole number | PostgreSQL identity column | Must be unique, not null and used as the primary key. |
| `trust_code` | `operational.trusts` | `VARCHAR` | Short fictional organisation code used to identify a Trust. | Non-blank; unique within the table | Synthetic seed data | Must not be null, blank or duplicated. |
| `trust_name` | `operational.trusts` | `VARCHAR` | Full fictional name of the healthcare organisation. | Non-blank text | Synthetic seed data | Must not be null or blank. |
| `trust_type` | `operational.trusts` | `VARCHAR` | Broad organisational classification. | Examples: `Acute Trust`, `Community Trust` | Synthetic seed data | Must contain a meaningful controlled or documented value. |
| `region` | `operational.trusts` | `VARCHAR` | Broad fictional geographical region associated with the Trust. | Examples: `North`, `Midlands`, `South` | Synthetic seed data | Must be documented and should not contain precise real-world location data. |
| `active_flag` | `operational.trusts` | `BOOLEAN` | Indicates whether the Trust should be included in active reporting. | `TRUE` or `FALSE` | Synthetic seed data | Must not be null. Only active Trusts should be included in current completeness checks. |
| `source_system` | All operational tables | `VARCHAR` | Name of the system or process from which the record originated. | Non-blank text | `synthetic_seed_v1` | Must be present to support lineage and reproducibility. |
| `source_record_id` | All operational tables | `VARCHAR` | Source-level identifier used to trace an individual record. | Non-blank; unique within the relevant source context | Deterministic synthetic generation | Must not be null. Duplicate identifiers should be investigated. |
| `load_batch_id` | All operational tables | `UUID` | Identifier linking records loaded during the same ingestion process. | Valid UUID | Fixed synthetic load batch | Must be present and valid. Used for repeatable load validation and batch removal. |
| `data_quality_status` | All operational tables | `VARCHAR` | Current quality classification assigned to a loaded record. | Current seed value: `valid` | Synthetic loading process | Must use a documented controlled value and should not be blank. |

---

## 2. Daily Operational Metrics

| Field | Table | Type | Definition | Valid range or values | Source | Quality rule |
|---|---|---|---|---|---|---|
| `reporting_date` | `operational.daily_operational_metrics` | `DATE` | Calendar date represented by the operational record. | Valid date within the reporting period | Synthetic date series | Must not be null. One row is permitted per Trust and reporting date. |
| `general_beds_open` | `operational.daily_operational_metrics` | `INTEGER` | Number of general inpatient beds available for use. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. Used as the denominator for occupancy calculations. |
| `general_beds_occupied` | `operational.daily_operational_metrics` | `INTEGER` | Number of open general beds occupied at the reporting point. | 0 to `general_beds_open` | Deterministic synthetic logic | Must not be negative or exceed `general_beds_open`. |
| `critical_care_beds_open` | `operational.daily_operational_metrics` | `INTEGER` | Number of available critical-care beds. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `critical_care_beds_occupied` | `operational.daily_operational_metrics` | `INTEGER` | Number of occupied critical-care beds. | 0 to `critical_care_beds_open` | Deterministic synthetic logic | Must not exceed open critical-care beds. |
| `ae_attendances` | `operational.daily_operational_metrics` | `INTEGER` | Number of synthetic A&E attendances during the reporting day. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `four_hour_breaches` | `operational.daily_operational_metrics` | `INTEGER` | Number of A&E attendances recorded as exceeding the four-hour measure. | 0 to `ae_attendances` | Deterministic synthetic logic | Must not be negative or exceed total A&E attendances. |
| `ambulance_arrivals` | `operational.daily_operational_metrics` | `INTEGER` | Number of ambulance arrivals recorded during the reporting day. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `ambulance_handover_delays` | `operational.daily_operational_metrics` | `INTEGER` | Number of ambulance arrivals classified as experiencing a handover delay. | 0 to `ambulance_arrivals` | Deterministic synthetic logic | Must not exceed ambulance arrivals. It is a count, not delay duration in minutes. |
| `patients_ready_for_discharge` | `operational.daily_operational_metrics` | `INTEGER` | Number of patients considered ready for discharge but still occupying capacity. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `admissions` | `operational.daily_operational_metrics` | `INTEGER` | Number of admissions during the reporting day. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `discharges` | `operational.daily_operational_metrics` | `INTEGER` | Number of discharges during the reporting day. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `general_bed_occupancy_pct` | Derived analytical field | `NUMERIC` | Percentage of open general beds occupied. | Normally 0% to 100% | Calculated in analytical SQL | Calculated as occupied beds divided by open beds using `NULLIF` to prevent division by zero. |
| `four_hour_breach_pct` | Derived analytical field | `NUMERIC` | Percentage of A&E attendances exceeding the four-hour measure. | 0% to 100% | Calculated in analytical SQL | Calculated as breaches divided by attendances using `NULLIF`. |
| `ambulance_handover_delay_pct` | Derived analytical field | `NUMERIC` | Percentage of ambulance arrivals classified as delayed. | 0% to 100% | Calculated in analytical SQL | Must not be described as average delay duration. |

---

## 3. Workforce Metrics

| Field | Table | Type | Definition | Valid range or values | Source | Quality rule |
|---|---|---|---|---|---|---|
| `staff_group` | `operational.workforce_metrics` | `VARCHAR` | Workforce category represented by the row. | Current synthetic value: `All operational staff` | Synthetic seed data | Must not be null or blank. Forms part of the table grain. |
| `establishment_fte` | `operational.workforce_metrics` | `NUMERIC` | Planned workforce establishment expressed as full-time equivalents. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative or null. |
| `substantive_fte` | `operational.workforce_metrics` | `NUMERIC` | Workforce capacity filled by substantive employees. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. Values exceeding establishment should be reviewed. |
| `absence_fte` | `operational.workforce_metrics` | `NUMERIC` | Workforce capacity unavailable because of absence. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `agency_fte` | `operational.workforce_metrics` | `NUMERIC` | Temporary workforce capacity supplied through agency staff. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `bank_fte` | `operational.workforce_metrics` | `NUMERIC` | Temporary workforce capacity supplied through internal bank arrangements. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `unfilled_shifts` | `operational.workforce_metrics` | `INTEGER` | Number of planned shifts that remained unfilled. | Whole number greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `workforce_absence_pct` | Derived analytical field | `NUMERIC` | Absence FTE as a percentage of establishment FTE. | Normally 0% or greater | Calculated in analytical SQL | Must use `NULLIF(establishment_fte, 0)` to prevent division by zero. |

---

## 4. Operational Incidents

| Field | Table | Type | Definition | Valid range or values | Source | Quality rule |
|---|---|---|---|---|---|---|
| `incident_reference` | `operational.incidents` | `VARCHAR` | Human-readable fictional incident identifier. | Non-blank and unique within the source system | Deterministic synthetic generation | Must not be duplicated for the same source system. |
| `incident_type` | `operational.incidents` | `VARCHAR` | Broad category describing the operational disruption. | Examples: staffing disruption, IT outage, bed closure | Synthetic incident generation | Should use documented categories and must not be blank. |
| `severity_level` | `operational.incidents` | `VARCHAR` | Assessed severity of an operational incident. | `low`, `moderate`, `high`, `critical` | Synthetic incident generation | Must match the controlled list. |
| `incident_status` | `operational.incidents` | `VARCHAR` | Current workflow status of an incident. | `open`, `monitoring`, `resolved` | Synthetic incident generation | Must match the controlled list. |
| `incident_started_at` | `operational.incidents` | `TIMESTAMPTZ` | Timestamp at which the incident began. | Valid timestamp | Synthetic incident generation | Must not occur after the reported or resolved timestamp. |
| `incident_reported_at` | `operational.incidents` | `TIMESTAMPTZ` | Timestamp at which the incident was recorded. | Same as or later than start timestamp | Synthetic incident generation | Must be greater than or equal to `incident_started_at`. |
| `incident_resolved_at` | `operational.incidents` | `TIMESTAMPTZ` | Timestamp at which the incident was resolved. | Null for unresolved incidents; valid timestamp for resolved incidents | Synthetic incident generation | Required when status is `resolved`; must be null for open or monitoring records. |
| `operational_impact` | `operational.incidents` | `TEXT` | Brief description of the operational consequence of the incident. | Non-identifiable free text | Synthetic incident generation | Must not contain patient, staff or confidential operational information. |

---

## 5. Weather Metrics

| Field | Table | Type | Definition | Valid range or values | Source | Quality rule |
|---|---|---|---|---|---|---|
| `observation_type` | `operational.weather_metrics` | `VARCHAR` | Indicates whether the record represents observed or forecast weather. | `observed`, `forecast` | Synthetic weather generation | Must use a controlled value. |
| `forecast_generated_at` | `operational.weather_metrics` | `TIMESTAMPTZ` | Timestamp at which a forecast record was produced. | Required for forecast rows; null permitted for observed rows | Synthetic weather generation | Must be populated when `observation_type = 'forecast'`. |
| `temperature_min_c` | `operational.weather_metrics` | `NUMERIC` | Minimum synthetic daily temperature in degrees Celsius. | Within schema-defined plausible range | Deterministic synthetic logic | Must not exceed `temperature_max_c`. |
| `temperature_max_c` | `operational.weather_metrics` | `NUMERIC` | Maximum synthetic daily temperature in degrees Celsius. | Within schema-defined plausible range | Deterministic synthetic logic | Must be greater than or equal to `temperature_min_c`. |
| `precipitation_mm` | `operational.weather_metrics` | `NUMERIC` | Synthetic precipitation measured in millimetres. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `snowfall_mm` | `operational.weather_metrics` | `NUMERIC` | Synthetic snowfall measured in millimetres. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `wind_speed_mph` | `operational.weather_metrics` | `NUMERIC` | Synthetic maximum wind speed in miles per hour. | Greater than or equal to 0 | Deterministic synthetic logic | Must not be negative. |
| `weather_warning_level` | `operational.weather_metrics` | `VARCHAR` | Severity level of a synthetic weather warning. | `yellow`, `amber`, `red`, or null | Synthetic weather generation | When populated, a warning type should also be supplied. |
| `weather_warning_type` | `operational.weather_metrics` | `VARCHAR` | Type of weather hazard represented by the warning. | Examples: `ice`, `wind`, `snow and ice`, or null | Synthetic weather generation | Should be populated when a warning level is present. |

---

## 6. OPEL Assessments

| Field | Table | Type | Definition | Valid range or values | Source | Quality rule |
|---|---|---|---|---|---|---|
| `assessment_timestamp` | `operational.opel_assessments` | `TIMESTAMPTZ` | Date and time at which the synthetic OPEL assessment was produced. | Valid timestamp | Synthetic OPEL process | Must not be null. Used to derive the daily assessment date. |
| `recommended_opel_level` | `operational.opel_assessments` | `SMALLINT` | OPEL level proposed by the synthetic rules-based assessment. | 1, 2, 3 or 4 | Synthetic rules engine | Must be within 1–4. It must remain separate from the approved decision. |
| `approved_opel_level` | `operational.opel_assessments` | `SMALLINT` | OPEL level approved following human review. | 1, 2, 3 or 4 | Synthetic human-review process | Required for approved records and must be within 1–4. |
| `previous_approved_opel_level` | `operational.opel_assessments` | `SMALLINT` | Approved OPEL level from the previous assessment date for the same Trust. | 1–4 or null for the first record | Derived during synthetic generation | Must be within 1–4 when populated. |
| `prediction_confidence` | `operational.opel_assessments` | `NUMERIC` | Synthetic confidence assigned to the recommended OPEL level. | 0 to 1 inclusive | Synthetic rules engine | Must not fall below 0 or exceed 1. It is not validated model probability. |
| `assessment_method` | `operational.opel_assessments` | `VARCHAR` | Method used to produce the recommendation. | Current value: `rules_based` | Synthetic OPEL process | Must use a documented value. |
| `assessment_rationale` | `operational.opel_assessments` | `TEXT` | Summary explanation supporting the recommendation or approved decision. | Non-identifiable explanatory text | Synthetic OPEL process | Must not contain confidential, patient-level or staff-identifiable information. |
| `key_pressure_factors` | `operational.opel_assessments` | `TEXT` | Summary of the principal synthetic indicators associated with the assessment. | Documented operational factors | Synthetic OPEL process | Must be interpreted as explanatory metadata, not proof of causation. |
| `approval_status` | `operational.opel_assessments` | `VARCHAR` | Workflow state of the OPEL assessment. | Controlled status such as `approved` | Synthetic review process | Approved records must include an approved level, reviewer role and review timestamp. |
| `assessed_by_role` | `operational.opel_assessments` | `VARCHAR` | Fictional role responsible for producing the initial assessment. | Non-identifiable role title | Synthetic OPEL process | Must contain a role rather than an individual’s name. |
| `reviewed_by_role` | `operational.opel_assessments` | `VARCHAR` | Fictional role responsible for reviewing or approving the assessment. | Non-identifiable role title | Synthetic human-review process | Required for approved records; individual names must not be used. |
| `reviewed_at` | `operational.opel_assessments` | `TIMESTAMPTZ` | Timestamp at which the assessment was reviewed. | Same as or later than assessment timestamp | Synthetic human-review process | Must not occur before `assessment_timestamp`. |
| `rule_version` | `operational.opel_assessments` | `VARCHAR` | Version identifier for the synthetic OPEL rules used. | Example: `opel_rules_v1.0` | Synthetic rules engine | Must be populated to support reproducibility and auditability. |

---

## Table Grain Summary

| Table | Expected grain |
|---|---|
| `operational.trusts` | One row per fictional Trust |
| `operational.daily_operational_metrics` | One row per Trust and reporting date |
| `operational.workforce_metrics` | One row per Trust, reporting date and staff group |
| `operational.incidents` | One row per operational incident |
| `operational.weather_metrics` | One row per Trust, reporting date and observation type |
| `operational.opel_assessments` | One row per OPEL assessment event |
| `operational.vw_trust_daily_analytical` | One analytical row per Trust and reporting date |

---

## Derived Analytical Measures

The following measures are calculated in SQL and are not stored as source fields:

| Derived field | Calculation |
|---|---|
| `general_bed_occupancy_pct` | `100 × general_beds_occupied / general_beds_open` |
| `critical_care_occupancy_pct` | `100 × critical_care_beds_occupied / critical_care_beds_open` |
| `four_hour_breach_pct` | `100 × four_hour_breaches / ae_attendances` |
| `ambulance_handover_delay_pct` | `100 × ambulance_handover_delays / ambulance_arrivals` |
| `workforce_absence_pct` | `100 × absence_fte / establishment_fte` |
| `net_admissions` | `admissions - discharges` |
| `human_override_indicator` | Indicates whether recommended and approved OPEL levels differ |

All division calculations use `NULLIF(denominator, 0)` to reduce division-by-zero risk.

---

## Data Quality Ownership

In a future production implementation:

- data owners would define business meaning and permitted use;
- source-system owners would be responsible for source accuracy;
- data engineers would monitor ingestion and lineage;
- information analysts would validate analytical logic;
- operational users would review interpretation;
- Information Governance and clinical-safety teams would approve appropriate use.

This portfolio project does not assign real NHS ownership because all data is synthetic.

---

## Limitations

- The definitions are designed for this portfolio schema and are not a replacement for the NHS Data Model and Dictionary.
- The current dataset contains only three fictional organisations and 30 reporting days.
- Several measures use simplified synthetic definitions.
- Ambulance handover delays are stored as a count rather than duration.
- The project-defined red-flag incident rule is not an official NHS classification.
- OPEL confidence values are synthetic and must not be treated as validated probabilities.
- Field definitions must be reviewed before any future connection to real operational data.

---

> This is a synthetic operational analytics platform for learning and portfolio demonstration. It is not a production NHS system and should not be used to make operational or clinical decisions.
