# NHS Operational Data Platform — Interview Evidence

## 2-Minute Project Explanation

I built the NHS Operational Data Platform to demonstrate how fragmented operational healthcare data can be brought together into a controlled analytical structure.

The fictional platform combines daily information on bed capacity, A&E demand, ambulance handover pressure, admissions, discharges, workforce availability, operational incidents, weather conditions and OPEL assessments.

I designed the solution in PostgreSQL using six related tables linked through a Trust reference table. I applied primary keys, foreign keys, unique constraints and validation rules so that invalid, duplicated or orphaned records could be prevented or identified.

I then created a deterministic synthetic dataset covering three fictional Trusts over 30 days. The load process is reproducible, uses a fixed batch identifier and validates expected record counts before committing the transaction.

To test data quality, I wrote SQL checks for duplicates, missing values, impossible bed figures, invalid A&E measures, inconsistent timestamps, invalid OPEL levels, orphan records and missing reporting dates.

I also created operational analysis queries to examine bed occupancy, A&E breach rates, workforce pressure, incidents, ambulance delays, weather and OPEL escalation.

Finally, I created a joined analytical view with one row per Trust per reporting date. This produces a controlled dataset that can later be connected to Power BI, Python, APIs and predictive modelling.

A key governance feature is that the platform separates the recommended OPEL level from the human-approved OPEL level. This preserves professional judgement, supports auditability and allows human overrides to be identified.

The project is fully synthetic and is not intended for real operational or clinical decision-making.

---

## STAR Interview Evidence

### Situation

Operational healthcare teams often work with data held across separate systems, including bed capacity, emergency demand, ambulance pressure, workforce availability, incidents, weather and escalation assessments.

When these datasets are not consistently structured, analysts may face duplicate records, unreliable joins, missing reporting dates, unclear lineage and difficulty producing a trusted operational view.

### Task

My task was to design a portfolio-grade operational data platform that could:

- integrate multiple synthetic operational datasets;
- preserve a clear reporting grain;
- prevent or identify invalid records;
- support reproducible analysis;
- provide management-focused insight;
- preserve human accountability;
- prepare the data for Power BI, Python and future AI workflows.

### Action

I designed a PostgreSQL schema containing six related tables:

- `trusts`;
- `daily_operational_metrics`;
- `workforce_metrics`;
- `incidents`;
- `weather_metrics`;
- `opel_assessments`.

I applied:

- primary and foreign keys;
- unique constraints;
- controlled-value checks;
- range and consistency checks;
- source-record identifiers;
- fixed load-batch lineage;
- created and updated timestamps.

I generated a deterministic synthetic dataset covering three fictional Trusts over 30 days and added transaction-controlled validation so that incorrect record counts would prevent the load from being committed.

I wrote SQL data-quality tests covering:

- duplicate records;
- missing values;
- impossible bed figures;
- invalid A&E and ambulance measures;
- negative workforce values;
- orphan records;
- invalid incident statuses;
- incomplete weather warnings;
- invalid OPEL levels;
- missing reporting dates.

I also created operational analysis queries and a joined analytical view with one row per Trust per reporting date.

The OPEL structure stores both the recommended level and the final human-approved level, allowing the platform to identify overrides without replacing professional judgement.

### Result

The final platform produced:

- 387 reproducible synthetic records;
- 90 validated Trust-day analytical rows;
- 3 fictional Trusts;
- 30 reporting dates;
- no duplicate Trust-date rows;
- no failed records in the consolidated validation summary;
- a controlled CSV output for downstream reporting and modelling;
- documented governance, limitations and auditability controls.

The project demonstrates that I can move beyond individual SQL queries and build a structured, tested and documented analytical data product.

---

## Likely Interview Questions and Model Answers

### 1. Why did you choose PostgreSQL for this project?

I chose PostgreSQL because it supports strong relational modelling, data-integrity constraints, views, transactions and analytical SQL.

That made it suitable for demonstrating how operational healthcare data can be structured, validated and prepared for downstream reporting. It also provides a strong foundation for later integration with Python, Power BI, APIs and cloud services.

### 2. How did you protect the quality of the data?

I applied data-quality controls at several levels.

At schema level, I used primary keys, foreign keys, unique constraints and check constraints to prevent invalid or duplicate records.

At load level, I used a transaction-controlled synthetic-data script with expected record-count validation before commit.

At analytical level, I wrote SQL checks for missing values, impossible bed figures, invalid A&E and ambulance measures, negative workforce values, orphan records, inconsistent timestamps, invalid OPEL levels and missing reporting dates.

### 3. How did you make the data load reproducible?

I used deterministic SQL rather than random generation.

The seed process uses:

- fixed fictional Trust codes;
- a fixed 30-day reporting period;
- repeatable source-record identifiers;
- a fixed load-batch identifier;
- controlled cleanup before reloading;
- validation of expected record counts before commit.

This means the same dataset can be loaded consistently into a clean test database.

### 4. How did you prevent duplicate rows in the reporting output?

I first defined the intended analytical grain as one row per Trust per reporting date.

I then:

- aggregated workforce data at Trust-date level;
- selected one observed weather record per Trust-date;
- selected one OPEL assessment per Trust-date using ranking;
- joined datasets using both `trust_id` and reporting date;
- tested the final view for duplicate Trust-date combinations.

The resulting analytical view contains 90 rows with no duplicate Trust-date records.

### 5. What operational insight did the project produce?

The analysis examined:

- average bed occupancy;
- A&E four-hour breach rates;
- ambulance handover pressure;
- workforce absence and temporary staffing;
- incident patterns;
- OPEL escalation;
- weather conditions.

For example, workforce absence, agency use, bank staffing and unfilled shifts were all higher on synthetic OPEL 4 days.

However, I reported this as an association in the synthetic data rather than claiming that workforce pressure caused OPEL escalation.

### 6. What was the most important governance feature?

The most important governance feature was separating:

- `recommended_opel_level`;
- `approved_opel_level`.

This preserves the original rules-based recommendation and the final human-reviewed decision.

It supports auditability, allows overrides to be identified and reinforces that professional judgement remains with the human reviewer.

### 7. How would this project change if it used real NHS data?

A real NHS implementation would require much stronger controls, including:

- formal stakeholder requirements;
- Information Governance approval;
- a data-protection impact assessment;
- role-based access control;
- secure identity and secrets management;
- data-sharing agreements;
- retention policies;
- logging and monitoring;
- clinical-safety assessment where applicable;
- DCB0129 and DCB0160 consideration;
- model validation and monitoring;
- documented operational accountability.

The current project is deliberately limited to synthetic data and portfolio demonstration.

### 8. What would you build next?

My next step would be to connect the analytical view to Power BI and build an operational-pressure dashboard.

After that, I would:

- connect Python for exploratory analysis and feature engineering;
- develop an explainable OPEL-risk model;
- expose approved outputs through FastAPI;
- containerise the solution with Docker;
- add automated testing and CI/CD;
- evaluate Azure deployment and governed AI workflows.

### 9. What did you learn from the project?

I learned that reliable analysis depends on more than writing SQL queries.

The most important lessons were:

- define the data grain before joining tables;
- build quality controls into the schema;
- preserve source and batch lineage;
- make loads reproducible;
- test assumptions before reporting findings;
- distinguish association from causation;
- document limitations clearly;
- preserve human accountability in AI-related workflows.

### 10. Why is this project relevant to a Band 7 role?

The project demonstrates several capabilities expected in senior analytical work:

- translating an operational problem into a structured data solution;
- designing quality and governance controls;
- producing management-focused analysis;
- explaining limitations and risks;
- creating reusable reporting assets;
- communicating findings clearly;
- considering downstream implementation and stakeholder use.

It shows that I can think beyond a single report and contribute to the design of a controlled analytical product.

---

## Technical Interview Defence

### Why did you use a relational design instead of one large table?

A single large table would create duplication, weak control over repeated values and a higher risk of inconsistent updates.

I separated the data into related tables because each subject has a different natural grain:

- one row per Trust;
- one row per Trust per reporting date for daily operations;
- one row per Trust per reporting date for workforce;
- one row per incident;
- one row per Trust, reporting date and observation type for weather;
- one row per OPEL assessment event.

This improves data integrity, supports clearer ownership of each dataset and reduces duplication.

### How did you decide the grain of each table?

I defined the grain before writing joins or analytical queries.

For example:

- `daily_operational_metrics` uses one row per Trust per reporting date;
- `workforce_metrics` uses one row per Trust per reporting date;
- `incidents` uses one row per incident;
- `weather_metrics` can hold multiple observation types per Trust-date;
- `opel_assessments` can hold multiple assessment events.

Defining the grain first helped prevent duplicate rows in the final reporting view.

### Why did you create a separate Trust reference table?

The Trust reference table provides a controlled source for organisation-level attributes such as:

- Trust code;
- Trust name;
- Trust type;
- region;
- active status.

Other tables reference it through `trust_id`.

This reduces repeated organisation details and ensures that operational records cannot be linked to an unknown Trust.

### Why did you use foreign keys?

Foreign keys enforce referential integrity.

They prevent operational, workforce, incident, weather or OPEL records from referencing a Trust that does not exist in the `trusts` table.

I also used restricted update and delete behaviour to reduce the risk of removing a Trust while dependent records still exist.

### Why did you use unique constraints?

Unique constraints protect the intended data grain.

For example, a Trust should not have two daily operational rows for the same reporting date.

Without a unique constraint, duplicate records could enter the database and later inflate totals, averages and reporting outputs.

### Why did you use check constraints?

Check constraints prevent logically impossible values from entering the database.

Examples include:

- occupied beds exceeding open beds;
- A&E breaches exceeding attendances;
- ambulance delays exceeding arrivals;
- negative workforce values;
- OPEL levels outside the range 1–4;
- prediction-confidence values outside the range 0–1.

This provides earlier protection than relying only on downstream validation queries.

### Why did you use transactions in the seed script?

The seed process uses a transaction so the load is treated as one controlled unit.

If expected counts are not reached, the script raises an exception and the transaction can be rolled back.

This prevents a partially loaded dataset from being accepted as complete.

### Why did you use a fixed load-batch identifier?

The fixed synthetic `load_batch_id` makes the load traceable and reproducible.

It supports:

- identifying which records belong to the demonstration batch;
- controlled cleanup before reloading;
- easier investigation of defects;
- repeatable testing;
- consistent portfolio demonstrations.

In a production pipeline, each real ingestion run would normally receive a new batch identifier.

### Why did you use `NULLIF` in percentage calculations?

I used `NULLIF` to reduce the risk of division-by-zero errors.

For example:

```sql
four_hour_breaches::numeric
/
NULLIF(ae_attendances, 0)
```

If attendances are zero, `NULLIF` converts the denominator to `NULL` rather than allowing the query to fail.

The result must still be interpreted carefully because a `NULL` percentage indicates that the measure could not be calculated.

### How did you select one OPEL record per Trust-date?

The OPEL table can contain multiple assessment events.

To preserve one reporting row per Trust-date, I ranked assessments within each Trust-date group and selected one record according to the defined ordering rule.

This is safer than joining all assessment events directly, which could duplicate the operational row.

### How did you deal with weather records that may have multiple observation types?

The weather table supports more than one observation type per Trust-date.

For the analytical view, I filtered to the relevant observed-weather records and used ranking to select one daily record.

This prevents multiple weather rows from multiplying the daily operational row.

### Why did you aggregate workforce data before joining it?

Workforce data must match the Trust-date grain of the analytical view.

I prepared the workforce measures at that grain before joining them to daily operations.

This prevents a one-to-many join from creating duplicate Trust-date rows.

### What would happen if you joined the tables without considering grain?

A poorly controlled join could:

- duplicate daily records;
- inflate attendances or bed figures;
- distort averages;
- overcount incidents;
- produce incorrect KPI values;
- reduce trust in the report.

That is why I verified the final view with a duplicate Trust-date test.

### Why did you create a view instead of exporting directly from several queries?

The view creates one reusable and controlled reporting layer.

This helps ensure that Power BI, Python and future APIs use the same:

- joins;
- definitions;
- calculated measures;
- reporting grain;
- selection logic.

Without a shared view, different downstream tools could implement inconsistent business rules.

### What is the difference between prevention and detection in your data-quality design?

Prevention controls stop invalid data from entering the database.

Examples include:

- primary keys;
- foreign keys;
- unique constraints;
- check constraints.

Detection controls identify problems that may still occur or that constraints cannot fully evaluate.

Examples include:

- missing reporting dates;
- unexpected record counts;
- incomplete approval information;
- inconsistent timestamps;
- analytical duplicate checks.

A strong data-quality approach needs both prevention and detection.

### Why is the analytical view not the source of truth?

The underlying relational tables remain the detailed source records.

The analytical view is a derived layer designed for reporting and analysis.

It simplifies access but should not replace:

- original source fields;
- detailed assessment events;
- incident-level records;
- audit and lineage information.

### How would you improve performance at a larger scale?

For a larger implementation, I would consider:

- indexes on foreign keys and reporting dates;
- composite indexes for common Trust-date queries;
- materialised views for expensive transformations;
- table partitioning by reporting period;
- query-plan analysis using `EXPLAIN`;
- incremental data loading;
- scheduled refreshes;
- archival and retention strategies;
- monitoring slow queries.

I would only add these after measuring actual query performance.

### How would you test future schema changes?

I would:

1. apply changes first in a test database;
2. rerun core schema tests;
3. rerun expected constraint-failure tests;
4. reload the synthetic data;
5. rerun data-quality validation;
6. rebuild the analytical view;
7. check row counts and duplicates;
8. compare key analytical outputs;
9. document the change;
10. promote it only after review.

This reduces the risk of introducing silent reporting errors.

---

## 30-Second Interview Summary

I built a PostgreSQL-based NHS operational data platform using fully synthetic data.

It integrates Trust-level operational, workforce, incident, weather and OPEL information into a controlled relational structure.

I applied schema constraints, reproducible data loading, data-quality validation and a joined analytical view with one row per Trust per reporting date.

The project also preserves lineage and human accountability by separating recommended OPEL levels from human-approved decisions.

It demonstrates my ability to design, test, analyse and govern an operational healthcare data product rather than only writing individual SQL queries.

---

## CV Evidence

### Short CV Version

Built a PostgreSQL NHS operational data platform integrating synthetic bed, A&E, ambulance, workforce, incident, weather and OPEL data across three fictional Trusts. Designed relational tables, constraints, reproducible seed loading, SQL validation tests and a Trust-day analytical view for downstream Power BI, Python and AI workflows.

### Band 7 CV Version

Designed and developed a governed PostgreSQL operational intelligence platform integrating synthetic Trust-level capacity, emergency demand, workforce, incident, weather and OPEL data. Implemented relational modelling, data-integrity controls, deterministic batch loading, SQL data-quality assurance and a validated analytical reporting layer containing 90 unique Trust-day records. Produced management-focused analysis while documenting lineage, limitations, human oversight and future deployment requirements.

### Technical CV Version

Developed a PostgreSQL operational data platform with six normalised tables, primary and foreign keys, unique and check constraints, deterministic synthetic-data generation, transaction-controlled loading, lineage fields, SQL validation suites and a reusable Trust-date analytical view. Tested schema failures, duplicate prevention, missing-date detection and downstream CSV export readiness.

---

## LinkedIn Project Description

Developed a synthetic NHS Operational Data Platform in PostgreSQL to demonstrate end-to-end healthcare data-engineering capability.

The solution integrates operational capacity, A&E demand, ambulance handover pressure, workforce, incidents, weather and OPEL assessments across three fictional Trusts.

Key features include:

- relational schema design;
- data-integrity constraints;
- reproducible synthetic-data loading;
- source and batch lineage;
- SQL data-quality testing;
- operational analysis;
- a controlled Trust-day analytical view;
- human-reviewed OPEL decision tracking;
- governance and limitations documentation.

The platform is designed as a foundation for future Power BI, Python, FastAPI, Docker, Azure and explainable AI development.

---

## Evidence Summary

| Capability | Project evidence |
|---|---|
| Requirements interpretation | Converted an NHS operational-pressure problem into a structured data platform |
| Data modelling | Designed six related PostgreSQL tables with defined grains |
| Data quality | Applied preventive constraints and detective SQL validation |
| Reproducibility | Built deterministic, transaction-controlled synthetic-data loading |
| Analysis | Answered seven operational-management questions |
| Reporting | Created a reusable Trust-day analytical view |
| Governance | Documented permitted use, prohibited use, risks and limitations |
| Auditability | Preserved source, batch, timestamp and decision-review fields |
| Human oversight | Separated recommended and approved OPEL levels |
| Communication | Produced README, technical documentation and Band 7-style findings |

---

## Final Interview Message

The strongest message from this project is that reliable healthcare analytics depends on controlled data structures, clear definitions, reproducible processing and human accountability.

The technical solution is important, but the value comes from creating data that analysts, managers and future systems can use consistently, transparently and safely.



---

# Power BI Reporting Design Evidence

## 30-Second Interview Answer

In Week 14, I designed the Power BI reporting layer before implementation. I defined the reporting requirements, created a 21-KPI dictionary, designed nine dashboard pages, specified a Trust-date star schema, documented governance and source-readiness controls, and created a 49-test UAT framework. I also defined PostgreSQL reconciliation rules so the final Power BI implementation can be tested against the source rather than accepted simply because the visuals look correct.

---

# 60-Second Interview Answer

In Week 14, I treated the Power BI layer as an engineered reporting product rather than just a dashboard.

I first defined the reporting requirements and the business questions each page needed to answer. I then created a KPI dictionary covering 21 measures and documented their source fields, aggregation rules, limitations and readiness status.

After that, I designed nine dashboard pages and specified a star-schema semantic model with one Trust-date fact table, controlled dimensions and explicit DAX measures.

I also documented governance requirements such as human-reviewed OPEL, blocked KPI handling, synthetic-data warnings and PostgreSQL reconciliation.

Finally, I designed a 49-test UAT framework covering data, relationships, measures, filters, drill-through, governance and accessibility.

This means Week 15 can focus on controlled Power BI implementation rather than deciding what the report should contain.

---

# 2-Minute Technical Interview Answer

A major design decision in the project was not to start Power BI by immediately building charts.

I first defined the reporting grain as one row per Trust per reporting date. That became the basis for the semantic model, data-quality controls and drill-through behaviour.

I then defined a 21-KPI framework and reviewed each KPI for correct aggregation.

For example, I identified that percentages such as bed occupancy and workforce absence should not be summed. I also avoided treating the simple average of daily A&E breach percentages as a weighted period rate because the raw breach numerator is not currently available.

For workforce data, I designed agency and bank FTE as average daily measures rather than summing them across dates, because the sum would represent FTE-days rather than workforce size.

For OPEL, I treated levels as ordered categories rather than additive numerical measures.

The planned model uses a star schema with `FactTrustDailyOperations` at Trust-date grain and dimensions for date, Trust, OPEL, pressure status and weather warning.

I specified one-to-many, single-direction relationships and a dedicated `_Measures` table for explicit DAX calculations.

I also designed governance controls. Recommended and approved OPEL remain separate, human overrides remain visible, blocked KPIs cannot be silently replaced by weak proxies, and project-defined thresholds must not be presented as official NHS policy.

Finally, I created formal acceptance testing. The Power BI implementation will be reconciled against PostgreSQL and tested for relationships, measures, filters, drill-through, blocked KPI behaviour, governance and accessibility.

The result is that the dashboard has a defined specification and acceptance standard before implementation starts.

---

# STAR Interview Example — Designing Before Building

## Situation

I had completed the PostgreSQL operational data platform and needed to create a Power BI reporting layer for the synthetic NHS operational dataset.

## Task

My task was to design a dashboard that could support executive operational review while remaining technically reliable, governed and explainable.

## Action

Instead of starting with visuals, I designed the reporting layer in stages.

I:

- defined reporting requirements;
- created a 21-KPI dictionary;
- reviewed aggregation behaviour;
- designed nine dashboard pages;
- specified a Trust-date star schema;
- designed explicit DAX measures;
- documented blocked source dependencies;
- defined governance controls;
- created a 49-test UAT framework;
- linked requirements to acceptance tests.

I also documented PostgreSQL reconciliation tolerances so Power BI values can be verified against the source.

## Result

The project now has a controlled Power BI implementation specification.

Week 15 can focus on building and validating the semantic model against predefined requirements instead of creating the dashboard through trial and error.

---

# STAR Interview Example — Identifying a KPI Risk

## Situation

While designing the KPI framework, I reviewed several percentage-based measures that were planned for the dashboard.

## Task

I needed to determine whether the existing daily percentage fields could safely be aggregated across longer reporting periods.

## Action

I reviewed the difference between simple averages and weighted rates.

For the A&E four-hour breach KPI, I recognised that calculating a correct weighted period rate requires:

- total four-hour breaches;
- total A&E attendances.

The current source contains the daily percentage but does not yet provide the raw breach numerator needed for a properly weighted period calculation.

Instead of using an average of percentages and presenting it as the final KPI, I classified the weighted measure as blocked and documented the required source enrichment.

## Result

The reporting design avoids presenting a mathematically weaker calculation as a trusted KPI.

The limitation is transparent and can be resolved properly when the required source field is introduced.

---

# STAR Interview Example — Preventing Incorrect Aggregation

## Situation

The operational dataset contains daily agency and bank FTE measures.

## Task

I needed to decide how these measures should behave when users selected multiple reporting dates.

## Action

I identified that summing daily FTE values across dates would create an FTE-day quantity.

If that result were labelled as total workforce capacity, it would be misleading.

I therefore designed the primary measures as:

- Average Daily Agency FTE;
- Average Daily Bank FTE.

I also set the source columns to avoid automatic Sum aggregation in the semantic model.

## Result

The reporting layer preserves the correct business meaning of the workforce measures and reduces the risk of misleading totals.

---

# STAR Interview Example — Human-in-the-Loop Governance

## Situation

The platform includes OPEL-related decision-support concepts, including planned automated recommendations and human-approved OPEL outcomes.

## Task

I needed to ensure that the reporting design did not imply that an algorithm had autonomous operational authority.

## Action

I designed the model so that:

- `recommended_opel_level` and `approved_opel_level` remain separate;
- approved OPEL is treated as the human-reviewed outcome;
- human override information remains visible;
- an override is not automatically treated as model or human failure;
- recommendation-versus-approval analysis remains blocked until the recommendation field is available.

I also incorporated these rules into governance documentation and acceptance tests.

## Result

The reporting design preserves human accountability and provides a clearer audit trail for future decision-support functionality.

---

# Technical Decisions I Can Defend in Interview

## Why use a star schema?

Because it:

- separates descriptive dimensions from operational measures;
- simplifies filter behaviour;
- reduces ambiguous relationships;
- makes DAX easier to maintain;
- improves model explainability.

---

## Why use single-direction relationships?

Because they provide predictable dimension-to-fact filtering and reduce the risk of ambiguous filter paths.

Bidirectional filtering would only be introduced for a documented analytical requirement.

---

## Why use explicit DAX measures?

Because explicit measures provide controlled:

- aggregation;
- formatting;
- filter behaviour;
- null handling;
- reconciliation.

They are also easier for another analyst to review.

---

## Why not sum OPEL?

Because OPEL values are ordered categories, not additive numerical quantities.

Appropriate analysis includes:

- latest approved level;
- count of OPEL 3–4 days;
- count of OPEL 4 days;
- distribution by category.

---

## Why call the discharge KPI patient-days?

Because `patients_ready_for_discharge` is a daily count.

Summing it across dates does not necessarily represent unique patients.

The aggregated measure is therefore labelled:

`Discharge-Ready Patient-Days`

---

## Why keep blocked KPIs visible?

Because hiding limitations encourages misleading analysis.

A professional reporting product should show:

`Source enrichment required`

rather than silently substitute a weaker calculation.

---

## Why reconcile Power BI with PostgreSQL?

Because a dashboard value appearing reasonable does not prove that:

- the correct rows were loaded;
- the correct relationships were applied;
- the correct aggregation was used;
- filtering is behaving correctly.

Reconciliation provides independent evidence that the semantic model matches the validated source logic.

---

# Week 14 Portfolio Evidence

Week 14 produced:

- Power BI reporting requirements;
- 21-KPI dictionary;
- nine-page dashboard wireframe;
- Trust-date star-schema specification;
- semantic-model relationship rules;
- explicit measure strategy;
- aggregation controls;
- governance framework;
- data-quality and lineage controls;
- source-readiness register;
- 49-test UAT framework;
- requirements-to-test traceability;
- Power BI project README.

---

# CV-Ready Bullet — Current Stage

Designed the governed Power BI reporting architecture for a synthetic NHS operational intelligence platform, defining a 21-KPI framework, nine-page dashboard UX, Trust-date star schema, explicit measure strategy, PostgreSQL reconciliation controls, data lineage, governance and a 49-test UAT framework.

---

# CV-Ready Bullet — Short Version

Designed a governed Power BI semantic and reporting architecture for synthetic NHS operational intelligence, including 21 KPIs, star-schema modelling, PostgreSQL reconciliation and formal UAT.

---

# CV-Ready Bullet — Technical Version

Specified a Power BI star-schema semantic model at Trust-date grain, including controlled dimensions, one-to-many single-direction relationships, explicit DAX measure definitions, aggregation safeguards, source-readiness controls and PostgreSQL reconciliation rules.

---

# CV-Ready Bullet — Governance Version

Designed Power BI governance and UAT controls covering human-reviewed OPEL, blocked KPI management, synthetic-data disclosure, source lineage, reconciliation, accessibility and release acceptance.

---

# Important CV Wording at the Current Stage

At the end of Week 14, use words such as:

- designed;
- specified;
- defined;
- documented;
- modelled;
- planned.

Do not yet claim:

- built;
- deployed;
- implemented;
- validated;
- released.

Those claims become appropriate only after the corresponding Power BI implementation and tests are actually completed.

---

# Week 15 Interview Progression

After Week 15 semantic-model implementation, this evidence can be upgraded from:

`Designed a Power BI semantic model`

to:

`Built and validated a Power BI semantic model`

After the dashboard implementation and UAT are complete, it can progress to:

`Built, reconciled and validated a governed Power BI operational intelligence dashboard.`

---

# Week 14 Interview Summary

The strongest Week 14 story is not:

`I designed some Power BI pages.`

It is:

`I treated Power BI as an engineered reporting product. I defined requirements, KPI semantics, dimensional modelling, governance, reconciliation, traceability and acceptance tests before implementation so the final dashboard could be built against a controlled specification.`
............................................................

# Week 15 Interview Evidence — Power BI Semantic Model Implementation

## Project Context

During Week 15, I converted the PostgreSQL-based NHS Operational Data Platform into a validated Power BI semantic model.

The objective was not simply to create visuals.

The focus was to build a reporting layer that was:

- structurally correct;
- analytically governed;
- reconciled against PostgreSQL;
- auditable;
- transparent about limitations;
- suitable for future management-facing dashboard development.

The project uses synthetic data only.

---

## What I Built

I implemented:

- a PostgreSQL-to-Power-BI source connection;
- a controlled Power Query staging layer;
- `FactTrustDailyOperations`;
- `DimDate`;
- `DimTrust`;
- `DimOPEL`;
- `DimPressureStatus`;
- `DimWeatherWarning`;
- a dedicated `_Measures` table;
- explicit DAX measures;
- weighted KPI calculations;
- QA measures;
- filter-context tests;
- PostgreSQL reconciliation;
- formal UAT.

The fact table uses a defined grain:

**one row per fictional Trust per reporting date**

Validated dataset:

- 90 Trust-date rows;
- 3 fictional Trusts;
- 30 reporting dates.

---

## Semantic Modelling Evidence

I implemented a star-schema design using active one-to-many, single-direction relationships.

Primary relationships:

- `DimDate[Date]`
  → `FactTrustDailyOperations[reporting_date]`

- `DimTrust[trust_id]`
  → `FactTrustDailyOperations[trust_id]`

- `DimOPEL[OPELLevel]`
  → `FactTrustDailyOperations[approved_opel_level]`

- `DimPressureStatus[PressureStatus]`
  → `FactTrustDailyOperations[operational_pressure_status]`

- `DimWeatherWarning[WeatherWarningKey]`
  → `FactTrustDailyOperations[WeatherWarningKey]`

I avoided:

- many-to-many primary relationships;
- unnecessary bidirectional filtering;
- duplicate active paths.

The `_Measures` table is intentionally disconnected and is used purely as an explicit DAX measure container.

---

## Source Inspection and Requirements Change

A key Week 15 lesson was that implementation should be driven by the actual source rather than design assumptions.

During Week 14, some KPIs had been deliberately classified as blocked because required raw source fields had not been confirmed.

When I inspected the real analytical view in Week 15, I discovered fields including:

- `four_hour_breaches`;
- `ae_attendances`;
- `general_beds_open`;
- `general_beds_occupied`;
- `ambulance_arrivals`;
- `ambulance_handover_delays`;
- `establishment_fte`;
- `absence_fte`;
- `recommended_opel_level`;
- `approved_opel_level`;
- `human_override_indicator`.

This allowed several previously blocked capabilities to be reassessed.

---

## Weighted KPI Design

I avoided relying only on average percentage fields where raw numerator and denominator data existed.

### A&E Four-Hour Breach Rate

Instead of averaging daily breach percentages, I implemented:

`SUM(four_hour_breaches) / SUM(ae_attendances)`

PostgreSQL reconciliation result:

`19.82%`

### General-Bed Occupancy

The model supports:

`SUM(general_beds_occupied) / SUM(general_beds_open)`

rather than relying only on a simple average of daily occupancy percentages.

### Workforce Absence

I implemented:

`SUM(absence_fte) / SUM(establishment_fte)`

This produces a weighted absence measure.

This demonstrated an understanding that percentage fields should not automatically be averaged across records with different denominators.

---

## FTE Interpretation

I treated FTE metrics carefully.

For example, summing `agency_fte` across 30 dates would represent something closer to FTE-days rather than an average staffing level.

I therefore implemented measures such as:

- Average Daily Agency FTE;
- Average Daily Bank FTE;
- Average Establishment FTE;
- Average Substantive FTE.

This makes the business meaning clearer and reduces the risk of misleading reporting.

---

## OPEL and Human-Governance Evidence

The semantic model preserves both:

- `recommended_opel_level`;
- `approved_opel_level`.

The active OPEL dimension relationship uses:

`approved_opel_level`

because this represents the human-reviewed operational outcome.

Recommended OPEL remains available for governance analysis.

I implemented:

- Human Override Count;
- Human Override Percentage;
- Recommendation Agreement Count;
- Recommendation Agreement Percentage;
- OPEL Recommendation Mismatch Count;
- Override Reconciliation Variance.

PostgreSQL confirmed:

- 4 human overrides;
- 4 recommendation/approval mismatches.

Power BI reconciliation variance:

`0`

This demonstrated that automated recommendations and human-reviewed outcomes can be analysed separately rather than silently conflated.

---

## Defect Identification and Root-Cause Analysis

During UAT, PostgreSQL reconciliation identified that the weather-warning dimension was missing:

`yellow / wind`

The source contained:

- No warning = 70 Trust-days;
- yellow / ice = 12;
- yellow / wind = 6;
- amber / snow and ice = 2.

The issue was traced to Power Query duplicate-removal logic.

Duplicates had been removed using warning level alone.

Because both:

- yellow / ice;
- yellow / wind

shared the same warning level, one legitimate category was removed.

I corrected the dimension so uniqueness was based on the combination of:

- warning level;
- warning type.

Final Power BI reconciliation:

`20 weather-warning Trust-days`

This demonstrated:

- source reconciliation;
- defect detection;
- root-cause analysis;
- controlled correction;
- retesting.

---

## PostgreSQL Reconciliation Evidence

I validated the Power BI semantic model directly against PostgreSQL.

Key results included:

| KPI | Reconciled Result |
|---|---:|
| Fact rows | 90 |
| Trusts | 3 |
| Reporting dates | 30 |
| Total A&E Attendances | 25,800 |
| Four-Hour Breaches | 5,113 |
| Weighted A&E Breach Rate | 19.82% |
| Admissions | 16,425 |
| Discharges | 15,654 |
| Net Admissions | 771 |
| OPEL 3-4 Trust-days | 39 |
| OPEL 4 Trust-days | 7 |
| Human Overrides | 4 |
| High-Pressure Trust-days | 39 |
| Weather-Warning Trust-days | 20 |

Agreed tolerances were:

- counts: exact;
- percentages: ±0.01 percentage points;
- averages/FTE: ±0.01;
- categorical results: exact.

---

## Filter-Context Testing

I tested the semantic model using multiple slicer contexts.

Examples:

- one Trust = 30 fact rows;
- 10 days × 3 Trusts = 30 rows;
- 10 days × 1 Trust = 10 rows;
- OPEL 4 = 7 rows;
- OPEL 3-4 = 39 rows;
- Significant + Critical pressure = 39 rows;
- yellow / ice = 12 rows;
- yellow / wind = 6 rows;
- amber / snow and ice = 2 rows;
- all weather warnings = 20 rows;
- no warning = 70 rows.

This verified that relationships and DAX measures responded correctly to filter context.

---

## Data-Quality Controls

I created explicit QA measures including:

- Fact Row Count;
- Duplicate Trust-Date Count;
- Reporting Completeness Percentage;
- Net Admissions Variance;
- A&E Breach Rate QA;
- Workforce Absence Difference;
- OPEL Recommendation Mismatch Count;
- Override Reconciliation Variance.

Clean expected results included:

- duplicate Trust-date count = 0;
- completeness = 100%;
- net admissions variance = 0;
- A&E QA variance = 0;
- workforce QA variance = 0;
- override reconciliation variance = 0.

---

## Formal UAT

I maintained a structured Power BI acceptance-testing framework.

Current status:

- 49 planned tests;
- 39 Pass;
- 0 Fail;
- 1 Blocked;
- 1 Deferred;
- 8 Not run.

The remaining Not Run tests relate mainly to:

- final dashboard visuals;
- drill-through;
- navigation;
- accessibility;
- usability.

This separates semantic-model validation from final report-level UAT.

---

## Governance Decision — Ambulance KPI

The source contains:

- `ambulance_arrivals`;
- `ambulance_handover_delays`;
- `ambulance_handover_delay_pct`.

Although a technical ratio can be calculated, the exact business definition of `ambulance_handover_delays` has not been formally confirmed.

I therefore kept the KPI:

`Provisional`

rather than presenting an unsupported interpretation as fact.

This demonstrates that technically possible calculations should not automatically be treated as governed business KPIs.

---

## Example Interview Question

### Tell us about a Power BI model you have built.

In my NHS Operational Data Platform portfolio project, I built a Power BI semantic model on top of a validated PostgreSQL analytical view.

I first inspected the actual source rather than assuming the design specification was complete. That identified additional raw fields for bed occupancy, A&E breaches, workforce absence and OPEL governance, which allowed me to improve several KPI definitions.

I created a Trust-date fact table and controlled Date, Trust, OPEL, pressure-status and weather-warning dimensions using a one-to-many, single-direction star schema.

I then created a dedicated DAX measure layer rather than relying on implicit aggregation. For example, the A&E four-hour breach KPI uses the raw breach count divided by total attendances instead of averaging daily percentages.

I reconciled Power BI directly against PostgreSQL. The model matched 90 fact rows, 25,800 A&E attendances, 5,113 four-hour breaches and a weighted breach rate of 19.82%.

The reconciliation process also identified a real modelling defect: a yellow/wind weather-warning category had been removed because Power Query duplicate removal was using only warning level rather than level plus type. I corrected the business key, refreshed the model and reconciled the final result to 20 warning Trust-days.

I also retained recommended and approved OPEL separately so automated recommendations could be compared with human-reviewed decisions. Four recommendation mismatches reconciled exactly with four human overrides.

Finally, I executed formal UAT covering source integrity, relationships, KPIs, filters, governance and known limitations. I deliberately left the ambulance KPI provisional because its source definition still needs clarification.

The main lesson was that a reliable Power BI product is not just about visuals. It requires source validation, semantic modelling, correct aggregation, reconciliation, governance and testing.

---

# 2-Minute Interview Version

During Week 15 of my NHS Operational Data Platform project, I built and validated the Power BI semantic layer on top of PostgreSQL.

I started by inspecting the actual analytical source rather than assuming the earlier requirements were complete. That was important because I discovered raw fields that allowed me to upgrade several KPIs, including A&E breaches, weighted bed occupancy, workforce absence and recommended-versus-approved OPEL analysis.

I built a star schema with a Trust-date fact table and Date, Trust, OPEL, pressure-status and weather-warning dimensions. The relationships are one-to-many and single-direction, and I created a dedicated measure table so reporting uses governed DAX rather than implicit aggregation.

One example is the A&E four-hour breach rate. Instead of averaging daily percentages, I calculate total breaches divided by total attendances. I then reconciled that against PostgreSQL and confirmed 25,800 attendances, 5,113 breaches and a weighted rate of 19.82%.

Testing also identified a genuine modelling issue. My weather dimension initially missed yellow/wind warnings because duplicate removal was based only on warning level. PostgreSQL exposed the mismatch, I identified the composite business key, corrected the dimension and reconciled the final warning count to 20 Trust-days.

I also retained automated OPEL recommendations separately from human-approved OPEL levels, and confirmed four recommendation mismatches matched four human overrides.

Finally, I executed formal UAT across data quality, relationships, calculations, filtering and governance. Where a business definition remained unresolved, such as ambulance handover delays, I left the measure provisional rather than overclaiming.

So the project demonstrates not just Power BI visualisation, but source validation, dimensional modelling, DAX, SQL reconciliation, governance, defect investigation and formal testing.



