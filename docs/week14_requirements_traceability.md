# Week 14 Requirements Traceability

## Document Purpose

This document provides end-to-end traceability for the Power BI reporting layer of the NHS Operational Intelligence Platform.

It links:

- business and reporting requirements;
- KPI definitions;
- dashboard pages;
- semantic-model components;
- governance controls;
- acceptance tests.

The purpose is to demonstrate that the Power BI design is internally connected and that major report features can be traced from requirement through implementation design to testing.

All organisations and values are synthetic.

The project is designed for learning, technical testing and portfolio demonstration only.

---

## Traceability Objective

The traceability framework should allow a reviewer to answer:

1. Why does this dashboard feature exist?
2. Which KPI or business question does it support?
3. Where will the user see it?
4. Which semantic-model component supports it?
5. Which governance rule controls it?
6. How will it be tested?

A report feature should not exist simply because it is visually attractive.

It should have a clear analytical or governance purpose.

---

# Traceability Principles

The Week 14 design follows these principles:

1. Every major dashboard feature should support a documented requirement.
2. Every major KPI should exist in the KPI dictionary.
3. Every report page should answer a defined user question.
4. Semantic-model elements should support real analytical requirements.
5. Governance controls should apply to business-significant functionality.
6. Important requirements should have acceptance tests.
7. Blocked requirements should remain visible rather than being silently implemented with weak substitutes.
8. Synthetic-data limitations must remain traceable through the reporting design.
9. Human accountability must remain visible in OPEL-related functionality.
10. The design should remain reconcilable against PostgreSQL.

---

# End-to-End Traceability Model

The reporting design follows this chain:

```text
Business Need
    ↓
Reporting Requirement
    ↓
KPI or Feature
    ↓
Dashboard Page
    ↓
Semantic Model
    ↓
Governance Control
    ↓
Acceptance Test
