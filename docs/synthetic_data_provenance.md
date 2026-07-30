# Synthetic Data Provenance

## Purpose

This dataset was created solely for learning, technical testing, schema validation, and portfolio demonstration within the NHS Operational Data Platform project.

It must not be interpreted as real NHS operational evidence or used to assess the performance of any real Trust, ICB, service, workforce, or clinical team.

## Fictional Organisations

The dataset contains three fictional healthcare organisations:

- Westborough General Hospital
- North Riverside NHS Trust
- South County Community Trust

These names and organisation codes are entirely synthetic and do not represent real NHS organisations.

## Reporting Period

The synthetic dataset covers:

`1 January 2026 to 30 January 2026`

A fixed reporting period is used to improve reproducibility and ensure that repeated data loads generate the same analytical time window.

## Dataset Grain

- `trusts`: one row per fictional Trust.
- `daily_operational_metrics`: one row per Trust and reporting date.
- `workforce_metrics`: one row per Trust and reporting date using the aggregated staff group `All operational staff`.
- `incidents`: one row per fictional operational incident.
- `weather_metrics`: one observed weather row per Trust and reporting date.
- `opel_assessments`: one OPEL assessment per Trust and reporting date.

## Generation Method

The records are generated using deterministic SQL logic and fixed assumptions.

The dataset uses:

- fixed dates;
- fixed fictional Trust codes;
- controlled value ranges;
- repeatable source record identifiers;
- a fixed load-batch UUID;
- documented operational-pressure patterns.

The generation process does not use extracts from real NHS systems.

## Operational Assumptions

The synthetic records are designed to represent simplified operational-pressure patterns involving:

- A&E demand;
- bed occupancy;
- ambulance handover pressure;
- delayed discharge pressure;
- workforce absence;
- agency staffing;
- unfilled shifts;
- operational incidents;
- winter weather;
- OPEL recommendations and approvals.

These assumptions are for technical demonstration only and are not official NHS thresholds or benchmarks.

## Winter-Pressure Patterns

The dataset will include plausible synthetic winter patterns, such as:

- colder periods associated with increased operational demand;
- higher occupancy during selected reporting days;
- increased workforce absence during pressure periods;
- higher ambulance delays during periods of escalation;
- selected OPEL 3 and OPEL 4 assessments;
- occasional differences between recommended and approved OPEL levels.

These patterns are deliberately constructed and do not demonstrate real-world causation.

## Data Lineage

Synthetic records include fields such as:

- `source_system`
- `source_record_id`
- `load_batch_id`
- `data_quality_status`
- `record_created_at`
- `record_updated_at`

These fields support reproducibility, traceability, and investigation of data-loading issues.

The fixed load-batch identifier for the initial dataset is:

`11111111-1111-4111-8111-111111111111`

## Information Governance

The dataset contains aggregate operational information only.

It does not contain:

- patient names;
- NHS numbers;
- dates of birth;
- addresses;
- clinical notes;
- staff names;
- staff payroll identifiers;
- patient-level activity;
- staff-identifiable records.

No real patient or confidential NHS data is used.

## Known Simplifications

The current synthetic design includes several simplifications:

- one aggregated workforce group per Trust and date;
- Trust-level rather than site-level operational data;
- weather linked directly to Trusts;
- one OPEL assessment per Trust and date;
- simplified incident categories and workflows;
- fictional rules-based OPEL recommendations;
- no historical Trust hierarchy;
- no real source-system latency or reconciliation process.

## Operational Records and Patient Data

Operational records describe aggregate service conditions, such as capacity, demand, workforce availability, incidents, and escalation status.

They are different from patient-level records, which contain information about identifiable individuals, care episodes, diagnoses, treatments, or outcomes.

This project intentionally excludes patient-level data.

## Analytical Limitations

Synthetic data can be used to test:

- SQL syntax;
- database constraints;
- joins;
- record counts;
- data-quality checks;
- reporting logic;
- Power BI integration;
- pipeline reproducibility.

Synthetic data cannot validate:

- real NHS operational performance;
- clinical effectiveness;
- model safety;
- model fairness;
- prediction accuracy on real services;
- generalisability across NHS organisations;
- real-world OPEL decision quality.

Any future predictive model must be evaluated using appropriately governed real-world data, formal validation methods, human oversight, Information Governance approval, and relevant clinical-safety processes.
