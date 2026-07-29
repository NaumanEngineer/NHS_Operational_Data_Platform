# NHS Operational Data Platform Architecture

## Purpose

The NHS Operational Data Platform provides a structured PostgreSQL foundation for integrating Trust-level operational, workforce, incident, weather, and OPEL assessment data.

The platform is designed to support reproducible reporting, operational-pressure monitoring, data-quality assurance, Winter Pressures analysis, and future decision-support development using Power BI, APIs, and machine-learning workflows.

## Architectural Scope

The current version contains six core tables within the `operational` PostgreSQL schema:

- `trusts`
- `daily_operational_metrics`
- `workforce_metrics`
- `incidents`
- `weather_metrics`
- `opel_assessments`

The implementation uses synthetic, non-identifiable data and operates at Trust level.

Patient-level data, staff-identifiable records, live NHS system integration, automated OPEL declaration, and production deployment remain outside the current scope.

## Table Grain

Each table has a defined row-level meaning:

- `trusts`: one row represents one NHS Trust.
- `daily_operational_metrics`: one row represents one Trust’s aggregated operational position for one reporting date.
- `workforce_metrics`: one row represents one Trust, reporting date, and staff group.
- `incidents`: one row represents one operational incident associated with one Trust.
- `weather_metrics`: one row represents one weather observation, forecast, or warning assigned to one Trust and reporting date.
- `opel_assessments`: one row represents one Trust-level OPEL assessment event at a specified timestamp.

Defining table grain reduces duplication and prevents operational measures with different meanings from being combined incorrectly.

## Separation of Entities

The tables are separated because they represent different business processes, reporting frequencies, and validation requirements.

Operational activity is recorded daily, workforce measures may be recorded by staff group, incidents are event-driven, weather is externally sourced, and OPEL assessments represent analytical recommendations and operational decisions.

Keeping these entities separate improves maintainability, data quality, auditability, and future analytical flexibility.

## Organisational Reference Data

Trust details are stored once in `operational.trusts`.

The five operational tables use `trust_id` as a foreign key rather than repeating Trust names, codes, types, and regions.

This reduces duplication and prevents inconsistent organisation descriptions across datasets.

The generated `trust_id` is the internal database identifier, while `trust_code` is retained as the unique business identifier.

## Temporal Data and Late Arrivals

The platform retains both business dates and technical audit timestamps.

Examples include:

- `reporting_date`
- `assessment_timestamp`
- `incident_started_at`
- `record_created_at`
- `record_updated_at`

The business date shows when an operational event or measurement occurred. The audit timestamp shows when the platform received or changed the record.

This distinction supports late-arriving-data analysis, correction handling, trend reporting, and point-in-time analytical datasets.

## Data Lineage and Auditability

The schema includes:

- `source_system`
- `source_record_id`
- `load_batch_id`
- `data_quality_status`
- `record_created_at`
- `record_updated_at`

These fields support traceability from PostgreSQL records back to their source and ingestion process.

The current schema records the latest row state. It does not yet preserve a complete immutable history of every field-level change.

A future version may include ingestion-batch tables, change-history tables, correction reasons, and automated update-timestamp triggers.

## Conflicting Source Records

Where two source systems provide different values for the same Trust and reporting period, the platform should not silently overwrite one source with another.

The future ingestion process should:

1. preserve the source identifiers;
2. apply a documented source-precedence rule;
3. flag unresolved differences using `data_quality_status`;
4. route material discrepancies for analyst review;
5. retain evidence of the final resolution.

This supports transparent and reproducible NHS reporting.

## Data-Quality Controls

PostgreSQL constraints protect important business rules, including:

- unique Trust codes;
- valid foreign-key relationships;
- non-negative operational and workforce measures;
- occupied beds not exceeding open beds;
- four-hour breaches not exceeding A&E attendances;
- valid OPEL levels from 1 to 4;
- valid prediction-confidence values from 0 to 1;
- complete human-review evidence for approved OPEL decisions;
- consistent incident status and resolution timestamps.

More complex rules that may require professional judgement should be implemented as warning-level data-quality queries rather than hard database rejections.

## OPEL Prediction and Human Review

The OPEL assessment design separates:

- the recommended OPEL level;
- prediction confidence;
- the approved OPEL level;
- the previous approved level;
- the assessment method;
- the reviewer role;
- the review timestamp;
- the model or rule version.

A model or rules-based recommendation must not overwrite the final approved operational decision.

This preserves transparency and supports human oversight, investigation, model evaluation, and operational accountability.

Approved records require an approved OPEL level, reviewer role, and review timestamp.

## Model and Rule Versioning

`rule_version` identifies the rules engine or analytical version responsible for producing an OPEL recommendation.

This allows analysts to:

- reproduce previous recommendations;
- compare model or rule performance;
- investigate unexpected outputs;
- identify which version informed an operational review;
- support controlled model change management.

Future ML implementations should also preserve training-data versions, feature definitions, evaluation results, and deployment versions.

## Support for Power BI

The schema is SQL-ready and can support reporting views for Power BI and SSRS.

The design provides:

- stable Trust identifiers;
- reporting dates;
- numeric operational measures;
- clear table grain;
- one-to-many relationships;
- controlled status values;
- auditable OPEL outputs.

A future Power BI semantic model should introduce shared Trust and date dimensions.

Fact tables should connect through common dimensions rather than being linked directly to one another.

## Support for APIs

The stable primary keys, structured data types, constrained values, and defined relationships make the schema suitable for future controlled API access.

A future API layer may expose approved operational summaries, OPEL trends, workforce pressure indicators, and data-quality exceptions.

API development must include authentication, role-based access control, logging, validation, and Information Governance review.

## Future Machine-Learning Suitability

The platform provides a foundation for creating Trust-date analytical datasets containing operational, workforce, incident, weather, and historical OPEL features.

Future ML datasets must use point-in-time-correct joins.

Only information available at the prediction timestamp should be included. Using information recorded later would create data leakage and produce misleading model performance.

Free-text fields must remain synthetic during development unless approved Information Governance controls are introduced.

## Known Limitations

The current prototype has the following limitations:

- operational data is aggregated at Trust level;
- site-level pressures are not represented;
- weather is linked directly to Trusts;
- the weather uniqueness rule may permit duplicate records where `forecast_generated_at` is null;
- Trust-name history is not preserved;
- full ICB organisational history is not modelled;
- `record_updated_at` is not automatically refreshed by a database trigger;
- complete correction and change history is not retained;
- source-precedence logic is not yet automated;
- the schema uses synthetic data only.

## Future Architecture

Future development may introduce:

- Trust sites and geographical reference tables;
- ICB reference and organisational-history structures;
- a shared date dimension;
- ingestion-batch control tables;
- immutable audit-history tables;
- SQL reporting views;
- automated data-quality exception logging;
- Python ingestion pipelines;
- Power BI semantic models and dashboards;
- authenticated APIs;
- model registries and feature-version tracking;
- controlled AI-assisted operational decision support.

All future development should continue to preserve data lineage, human oversight, Information Governance, and separation between analytical recommendations and final operational decisions.
