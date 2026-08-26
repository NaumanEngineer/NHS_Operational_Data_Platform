# Week 14 Reflection — Power BI Reporting Design

## Week Overview

Week 14 focused on designing the Power BI reporting layer for the NHS Operational Intelligence Platform before beginning implementation.

The purpose of the week was not to immediately build charts.

Instead, the work focused on:

- defining reporting requirements;
- defining KPI semantics;
- designing dashboard pages;
- specifying the semantic model;
- defining governance controls;
- designing acceptance tests;
- establishing requirements traceability.

This created a controlled implementation specification for Week 15.

---

## Main Learning Outcome

The most important lesson from Week 14 was that a professional Power BI product should be designed before it is built.

A dashboard is not only a collection of visuals.

A controlled reporting product also requires:

- clear business requirements;
- agreed KPI definitions;
- correct aggregation rules;
- an understandable semantic model;
- data-quality controls;
- governance;
- reconciliation;
- accessibility;
- testing;
- release criteria.

This week moved the project from dashboard planning toward BI product engineering.

---

# What I Built During Week 14

Week 14 produced the following reporting-design components.

## 1. Reporting Requirements

I defined the intended users, business questions, reporting scope and dashboard objectives.

This helped establish why each report component should exist.

---

## 2. KPI Dictionary

I created a structured KPI dictionary containing 21 KPIs.

The dictionary documents:

- business purpose;
- source fields;
- aggregation rules;
- formatting;
- limitations;
- source-readiness status.

This prevents KPI meaning from being embedded only inside Power BI formulas.

---

## 3. Dashboard Wireframes

I designed nine report pages:

1. Home and Guidance;
2. Executive Overview;
3. Beds and Patient Flow;
4. A&E and Ambulance;
5. Workforce Pressure;
6. Incidents and OPEL;
7. Trust-Day Investigation;
8. Data Quality and Lineage;
9. KPI Definitions and Limitations.

The wireframes define:

- purpose;
- intended users;
- KPI cards;
- visual types;
- filters;
- drill-through;
- navigation;
- accessibility expectations.

---

## 4. Semantic-Model Specification

I designed a Trust-date star schema.

The planned model contains:

- `FactTrustDailyOperations`;
- `DimDate`;
- `DimTrust`;
- `DimOPEL`;
- `DimPressureStatus`;
- `DimWeatherWarning`;
- `_Measures`.

The model uses:

- one-to-many relationships;
- single-direction filtering;
- explicit DAX measures;
- controlled field summarisation;
- dimension-based slicers.

---

## 5. Governance Framework

I defined governance controls covering:

- intended use;
- prohibited use;
- synthetic-data status;
- human accountability;
- OPEL governance;
- KPI governance;
- blocked KPIs;
- threshold governance;
- source readiness;
- access control;
- change control;
- refresh controls;
- release gates.

This ensures that the dashboard is not presented as an autonomous operational decision system.

---

## 6. UAT and Acceptance Testing

I designed a formal acceptance-test framework containing 49 planned tests.

The framework covers:

- source-data validation;
- semantic-model relationships;
- KPI reconciliation;
- blocked KPI behaviour;
- filters;
- drill-through;
- governance;
- accessibility.

These tests will be executed during Power BI implementation.

---

## 7. Requirements Traceability

I created an end-to-end traceability framework linking:

```text
Requirement
    ↓
KPI / Feature
    ↓
Dashboard Page
    ↓
Semantic Model
    ↓
Governance Control
    ↓
Acceptance Test


---

# Week 14 Completion Review

## Deliverables Completed

Week 14 produced the complete design package for the Power BI reporting layer.

Completed deliverables:

- [x] Power BI dashboard requirements;
- [x] 21-KPI dictionary;
- [x] nine-page dashboard wireframes;
- [x] Trust-date semantic-model specification;
- [x] governance framework;
- [x] data-quality and lineage controls;
- [x] 49-test UAT framework;
- [x] requirements traceability;
- [x] Power BI project README;
- [x] Week 14 reflection;
- [x] interview and CV evidence.

---

## Week 14 Definition of Done

Week 14 is considered complete because:

- reporting requirements are documented;
- KPI definitions are documented;
- report pages are designed;
- semantic-model structure is specified;
- aggregation rules are defined;
- blocked source dependencies are visible;
- governance controls are documented;
- UAT has been designed;
- requirements are traceable to tests;
- portfolio documentation is complete;
- implementation claims have not been overstated.

---

## Current Power BI Status

The Power BI reporting layer is:

`Design complete — implementation not yet started`

The project should therefore use terms such as:

- designed;
- specified;
- defined;
- documented;
- modelled;
- planned.

The project should not yet claim:

- built;
- implemented;
- validated;
- deployed;
- released.

These statements will be updated as implementation progresses.

---

# Week 15 Handoff

Week 15 will begin implementation of the semantic model defined during Week 14.

The implementation sequence will be:

1. connect Power BI to the validated analytical source;
2. validate source structure;
3. create `FactTrustDailyOperations`;
4. create `DimDate`;
5. create `DimTrust`;
6. create `DimOPEL`;
7. create `DimPressureStatus`;
8. resolve or defer `DimWeatherWarning`;
9. configure one-to-many single-direction relationships;
10. create `_Measures`;
11. implement supported DAX measures;
12. configure formatting and sorting;
13. hide technical fields after validation;
14. execute Week 15 semantic-model UAT;
15. reconcile supported measures with PostgreSQL.

Blocked measures will remain blocked until required source enrichment is available.

---

# Week 14 Final Outcome

Week 14 transformed the Power BI work from a dashboard idea into a controlled implementation specification.

The final design now connects:

```text
Business Need
    ↓
Requirements
    ↓
KPI Definitions
    ↓
Dashboard Wireframes
    ↓
Semantic Model
    ↓
Governance
    ↓
Data Quality and Lineage
    ↓
UAT
    ↓
Requirements Traceability
    ↓
Implementation Plan
