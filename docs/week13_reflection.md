# Week 13 Reflection — NHS Operational Data Platform

## Week Objective

The objective of Week 13 was to move beyond isolated SQL exercises and build a complete, portfolio-ready NHS operational data platform.

The project needed to demonstrate:

- relational database design;
- reproducible synthetic-data loading;
- schema-level data controls;
- SQL data-quality validation;
- operational healthcare analysis;
- a reusable analytical reporting layer;
- governance and human accountability;
- professional GitHub documentation;
- interview-ready evidence.

---

## What I Built

During Week 13, I created a PostgreSQL-based NHS Operational Data Platform using fully synthetic data.

The platform includes six core tables:

- `trusts`;
- `daily_operational_metrics`;
- `workforce_metrics`;
- `incidents`;
- `weather_metrics`;
- `opel_assessments`.

The schema integrates fictional Trust-level information covering:

- bed capacity and occupancy;
- A&E demand and four-hour breaches;
- ambulance handover pressure;
- admissions and discharges;
- discharge readiness;
- workforce capacity and absence;
- temporary staffing;
- operational incidents;
- weather conditions;
- recommended and approved OPEL levels.

---

## Technical Work Completed

### Relational Schema Design

I designed a relational PostgreSQL schema with clearly defined table grains.

I implemented:

- primary keys;
- foreign keys;
- unique constraints;
- check constraints;
- controlled update and delete behaviour;
- source-system fields;
- source-record identifiers;
- load-batch identifiers;
- created and updated timestamps;
- data-quality status fields.

This helped ensure that invalid, duplicated or orphaned records could be prevented or detected.

### Synthetic Data Generation

I created a deterministic synthetic dataset covering:

- 3 fictional Trusts;
- 30 reporting dates;
- 90 daily operational records;
- 90 workforce records;
- 24 incidents;
- 90 weather records;
- 90 OPEL assessments;
- 387 total physical records.

The seed process uses:

- a fixed reporting period;
- fixed fictional Trust codes;
- reproducible source-record identifiers;
- a fixed synthetic batch identifier;
- transaction control;
- expected record-count validation before commit.

### Data-Quality Validation

I created SQL validation checks covering:

- duplicate records;
- missing values;
- impossible bed figures;
- invalid A&E measures;
- invalid ambulance measures;
- negative workforce values;
- orphan records;
- inconsistent incident timestamps;
- incomplete weather-warning information;
- invalid OPEL levels;
- invalid confidence values;
- missing reporting dates;
- duplicate Trust-date rows.

The consolidated validation checks returned zero failed records for the tested synthetic dataset.

### Operational Analysis

I created SQL analysis answering seven operational-management questions.

These covered:

- average general-bed occupancy;
- highest A&E breach-rate dates;
- OPEL 3 and OPEL 4 frequency;
- workforce pressure on OPEL 4 days;
- project-defined red-flag incidents;
- ambulance handover pressure by OPEL level;
- weather and operational-pressure patterns.

I reported associations carefully and avoided presenting synthetic patterns as causation.

### Analytical Reporting View

I created:

`operational.vw_trust_daily_analytical`

The view produces:

- 90 analytical rows;
- 3 fictional Trusts;
- 30 reporting dates;
- one row per Trust per reporting date;
- zero duplicate Trust-date rows.

The view prepares controlled data for future:

- Power BI reporting;
- Python analysis;
- feature engineering;
- API development;
- predictive modelling;
- governed AI workflows.

---

## Governance and Safety Learning

One of the most important design decisions was separating:

- `recommended_opel_level`;
- `approved_opel_level`.

This preserves both the rules-based recommendation and the final human-reviewed decision.

It allows the platform to identify human overrides while ensuring that professional judgement remains visible.

I also documented:

- intended use;
- prohibited use;
- data minimisation;
- auditability;
- lineage;
- access-control requirements;
- retention considerations;
- DPIA requirements;
- Information Governance review;
- DCB0129 and DCB0160 considerations;
- model-validation requirements;
- limits of synthetic confidence values.

The project is not intended for real operational or clinical use.

---

## Problems Encountered

During the build, I encountered several practical issues.

These included:

- PostgreSQL installation and password confusion;
- attempting to recreate tables that already existed;
- trying to drop a database inside a transaction;
- duplicate-key errors during constraint testing;
- mismatched column names in weather data;
- references to table or field names that did not exist;
- incorrect assumptions about analytical grain;
- CSV export and repository-organisation issues;
- Markdown and Mermaid formatting errors in the README.

---

## How I Resolved the Problems

I resolved these issues by:

- using a clean test database;
- reviewing the schema before rerunning scripts;
- separating database-administration commands from transactions;
- using expected failures to test constraints;
- checking exact column names against the schema;
- defining table grain before joining datasets;
- validating row counts after loading;
- checking for duplicate Trust-date rows;
- previewing Markdown before committing;
- documenting technical decisions and corrections.

This reinforced the importance of testing, reproducibility and careful naming.

---

## Most Important Lessons

The most important lessons from Week 13 were:

1. Define the grain of every table before building joins.
2. Use schema constraints to prevent invalid data early.
3. Use validation queries to detect issues that constraints cannot fully prevent.
4. Treat synthetic-data generation as a controlled pipeline.
5. Validate expected row counts before committing a load.
6. Preserve source and batch lineage.
7. Do not assume correlation implies causation.
8. Separate machine recommendations from human-approved decisions.
9. Build one reusable reporting layer for downstream tools.
10. Documentation and governance are part of the technical product.
11. A strong portfolio project must be understandable without verbal explanation.
12. Test failures are useful evidence when they are intentional and documented.

---

## Skills Demonstrated

This week demonstrated practical capability in:

- PostgreSQL;
- relational data modelling;
- analytical SQL;
- transactions;
- primary and foreign keys;
- unique and check constraints;
- synthetic-data generation;
- data-quality testing;
- operational healthcare analysis;
- SQL views;
- analytical-grain management;
- GitHub documentation;
- Mermaid diagrams;
- CSV export;
- governance documentation;
- human-in-the-loop design;
- Band 7-style communication.

---

## Portfolio Outcome

The completed repository now demonstrates more than SQL knowledge.

It shows that I can:

- translate an NHS operational problem into a technical design;
- build controlled data structures;
- create reproducible datasets;
- test data quality;
- analyse management questions;
- prepare downstream reporting data;
- document governance and limitations;
- explain technical choices;
- present the project professionally;
- defend the work in an NHS interview.

The platform is ready for portfolio demonstration and provides a strong foundation for later Power BI, Python, API, cloud and AI development.

---

## Interview Reflection

The strongest interview message from this project is:

> I did not only write analytical queries. I designed, tested, documented and governed a complete operational data product.

I can explain:

- why the tables were separated;
- how their grains were defined;
- how duplicate rows were prevented;
- how data lineage was preserved;
- how the load was made reproducible;
- how validation was performed;
- how findings were communicated safely;
- how human accountability was retained;
- what would be required before real NHS use.

---

## What I Would Improve Next

The next improvements would be:

- connect the analytical view to Power BI;
- create executive and operational dashboard pages;
- add automated SQL testing;
- introduce Python-based validation;
- develop an explainable OPEL-risk model;
- build a FastAPI service;
- containerise the project with Docker;
- add CI/CD;
- evaluate Azure deployment;
- add monitoring, logging and role-based access;
- create governed RAG and agent workflows.

---

## Week 13 Completion Status

- [x] Relational schema completed
- [x] Schema constraints tested
- [x] Synthetic dataset loaded
- [x] Data-quality validation completed
- [x] Operational analysis completed
- [x] Analytical view created
- [x] CSV output exported
- [x] Data dictionary completed
- [x] Governance notes completed
- [x] README completed
- [x] Interview evidence completed
- [x] Final release checklist completed
- [x] Repository approved for portfolio demonstration

---

## Final Reflection

Week 13 marked the transition from learning individual technical concepts to building a complete healthcare data-engineering product.

The project strengthened my understanding of database design, data quality, analytical reliability, governance and professional communication.

It also showed that healthcare AI work must begin with trusted, well-structured and auditable data.

This platform will serve as the data foundation for the next stages of my Health and Care AI Engineer roadmap.
