# NHS Operational Intelligence Dashboard — Power BI

## Overview

This folder contains the Power BI reporting design and implementation plan for the NHS Operational Intelligence Platform.

The dashboard is designed to transform validated synthetic operational data from PostgreSQL into a governed management-information product for:

- executive operational review;
- Trust comparison;
- capacity and patient-flow analysis;
- A&E and ambulance analysis;
- workforce-pressure analysis;
- OPEL monitoring;
- data-quality review;
- governance and auditability.

All organisations and values used in this project are synthetic.

The dashboard is intended for learning, technical testing and portfolio demonstration only.

It must not be used for real clinical, operational or patient-level decision making.

---

## Project Objective

The objective of the Power BI layer is to demonstrate how a controlled operational reporting product can be designed before implementation.

The reporting layer is designed to provide:

- clear KPI definitions;
- a governed semantic model;
- consistent filtering;
- explicit DAX measures;
- drill-through investigation;
- source-readiness controls;
- PostgreSQL reconciliation;
- data-quality monitoring;
- human accountability around OPEL;
- formal UAT and release criteria.

---

## Current Project Status

The Power BI component is currently in the design-complete stage.

Week 14 completed:

- business and reporting requirements;
- KPI dictionary;
- dashboard wireframes;
- semantic-model specification;
- governance framework;
- acceptance-testing framework;
- requirements traceability.

Week 15 will begin semantic-model implementation.

The project does not yet claim that the Power BI dashboard has been fully built or validated.

---

# Reporting Architecture

The reporting architecture is:

```text
Synthetic Source Data
        ↓
PostgreSQL Operational Schema
        ↓
Data-Quality Validation
        ↓
Analytical SQL View
        ↓
CSV Export or Governed Source Connection
        ↓
Power Query
        ↓
Power BI Semantic Model
        ↓
Explicit DAX Measures
        ↓
Dashboard Pages
        ↓
UAT and Reconciliation
