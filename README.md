# NHS Operational Data Platform

## Project Overview

The NHS Operational Data Platform is a PostgreSQL-based portfolio project that demonstrates how operational healthcare data can be structured, validated, analysed and prepared for downstream reporting and AI workflows.

The platform combines fictional Trust-level data covering:

- bed capacity and occupancy;
- A&E demand and four-hour breaches;
- ambulance handover pressure;
- admissions, discharges and discharge readiness;
- workforce capacity and absence;
- operational incidents;
- weather conditions;
- OPEL recommendations and human-approved decisions.

The project was developed as the data-engineering foundation for future Power BI dashboards, Python analysis, API development, feature engineering and healthcare AI experimentation.

All organisations and values are synthetic.

---

## NHS Operational Problem

Operational teams often need to understand pressure across several connected areas rather than reviewing one metric in isolation.

For example, increasing bed occupancy may coincide with:

- higher A&E demand;
- ambulance handover delays;
- patients waiting for discharge;
- workforce absence;
- unfilled shifts;
- operational incidents;
- weather disruption;
- higher OPEL escalation levels.

When these datasets are held separately, analysts may face:

- inconsistent definitions;
- duplicated records;
- missing reporting dates;
- unreliable joins;
- unclear data lineage;
- manual reconciliation;
- weak auditability;
- difficulty producing a single management-ready view.

This project demonstrates how a relational data platform can provide a controlled analytical foundation.

---

## Intended Users

The fictional platform is designed around the needs of:

- NHS Trust information analysts;
- ICB operational analysts;
- performance and planning teams;
- winter-pressure teams;
- workforce planners;
- data engineers;
- BI developers;
- data scientists;
- healthcare AI engineers.

---

## Project Objectives

The project aims to demonstrate the ability to:

1. design a relational PostgreSQL schema;
2. apply primary keys, foreign keys, unique constraints and validation rules;
3. generate reproducible synthetic operational data;
4. preserve source and batch lineage;
5. identify poor-quality records using SQL;
6. answer operational-management questions;
7. produce one analytical row per Trust per reporting date;
8. export a controlled dataset for downstream systems;
9. document governance, limitations and human accountability;
10. communicate findings using Band 7-style analytical language.

---

## Architecture

```mermaid
flowchart LR
    A[Synthetic operational sources] --> B[PostgreSQL relational schema]

    B --> C1[Trust reference data]
    B --> C2[Daily operational metrics]
    B --> C3[Workforce metrics]
    B --> C4[Operational incidents]
    B --> C5[Weather metrics]
    B --> C6[OPEL assessments]

    C1 --> D[Data-quality validation]
    C2 --> D
    C3 --> D
    C4 --> D
    C5 --> D
    C6 --> D

    D --> E[Operational SQL analysis]
    D --> F[Trust daily analytical view]

    F --> G[CSV export]
    G --> H1[Power BI]
    G --> H2[Python modelling]
    G --> H3[API development]
    G --> H4[Future RAG and agent tools]
