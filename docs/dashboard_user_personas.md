# NHS Operational Intelligence Dashboard — User Personas

## Document Purpose

This document defines the fictional user personas for the NHS Operational Intelligence Dashboard.

The personas identify:

- who will use the dashboard;
- what questions they need answered;
- what decisions the information supports;
- which dashboard pages they require;
- the appropriate level of detail;
- potential risks of misuse or misinterpretation.

All personas and organisations are fictional.

The dashboard uses synthetic data and must not be used for real operational or clinical decisions.

---

## Persona 1 — Executive Operational Leader

### Role

A fictional senior operational leader responsible for reviewing system pressure across multiple Trusts.

### Information needs

The user needs a concise overview of:

- current operational pressure;
- Trusts experiencing the greatest pressure;
- changes across the reporting period;
- bed and critical-care occupancy;
- A&E breach performance;
- ambulance handover pressure;
- workforce absence and unfilled shifts;
- OPEL 3 and OPEL 4 frequency;
- recommended-versus-approved OPEL differences;
- important data-quality limitations.

### Key questions

1. Which Trust is experiencing the greatest operational pressure?
2. How has pressure changed during the selected period?
3. Which Trusts have the highest bed occupancy?
4. Where are A&E and ambulance pressures greatest?
5. How often has each Trust operated at OPEL 3 or OPEL 4?
6. Did approved OPEL levels differ from recommendations?
7. Are workforce pressures contributing to operational escalation?
8. Are there data-quality issues that limit interpretation?

### Decisions supported

The dashboard may support fictional discussions about:

- prioritising management attention;
- requesting further operational investigation;
- reviewing escalation patterns;
- identifying areas requiring assurance;
- requesting more detailed analysis.

The dashboard must not automatically recommend or initiate operational action.

### Required dashboard pages

- Home and Guidance;
- Executive Overview;
- Trust Comparison;
- Incidents and OPEL, once an incident-level source is added;
- Data Quality and Lineage;
- KPI Definitions and Limitations.

### Detail level

Executive summary.

The user needs:

- headline KPI cards;
- clear trends;
- Trust comparisons;
- concise exception messages;
- visible limitations;
- access to drill-through when further detail is required.

### Risks

- treating synthetic results as real NHS evidence;
- interpreting dashboard status as an official escalation decision;
- assuming association proves causation;
- comparing Trusts without considering their fictional type or context;
- relying on average percentages instead of weighted measures;
- overlooking reporting-period or data-quality limitations.

---

## Persona 2 — Trust Operational Performance Manager

### Role

A fictional Trust-level operational manager responsible for investigating daily performance and operational-pressure indicators.

### Information needs

The user requires detailed information about:

- bed availability and occupancy;
- critical-care occupancy;
- A&E attendances and four-hour breaches;
- ambulance arrivals and delayed handovers;
- admissions and discharges;
- net admissions;
- patients ready for discharge;
- workforce absence and temporary staffing;
- unfilled shifts;
- recommended and approved OPEL levels;
- human overrides;
- weather and operational context.

### Key questions

1. Which dates recorded the highest operational pressure?
2. Which indicators contributed to high-pressure days?
3. Did occupied beds approach available capacity?
4. Were A&E breaches increasing?
5. Were ambulance handover delays increasing?
6. Did admissions exceed discharges?
7. Were more patients ready for discharge on high-pressure dates?
8. Were workforce absence and unfilled shifts higher on OPEL 3 or OPEL 4 days?
9. Did the approved OPEL level differ from the recommendation?
10. What contextual information was recorded for the selected Trust-date?

### Decisions supported

The dashboard may support fictional activities such as:

- identifying dates requiring investigation;
- preparing operational-review discussions;
- comparing pressure indicators;
- reviewing human OPEL overrides;
- requesting data correction or further analysis;
- preparing management briefings.

The dashboard does not make escalation, staffing or clinical decisions.

### Required dashboard pages

- Executive Overview;
- Beds and Patient Flow;
- A&E and Ambulance;
- Workforce Pressure;
- Incidents and OPEL, once incident data is modelled;
- Trust-Day Investigation;
- KPI Definitions and Limitations.

### Detail level

Operational and investigative.

The user requires:

- Trust and date filters;
- daily trends;
- weighted percentages;
- high-pressure date tables;
- drill-through to one Trust-date;
- underlying numerator and denominator values;
- explanatory tooltips.

### Risks

- summing daily percentages;
- treating snapshot measures as period totals;
- assuming high OPEL was caused by one indicator;
- interpreting prediction confidence as certainty;
- overlooking a human override;
- acting without checking data quality and source context.

---

## Persona 3 — Performance and Business Intelligence Analyst

### Role

A fictional analyst responsible for developing measures, validating results and explaining operational patterns.

### Information needs

The user needs access to:

- raw numerator and denominator fields;
- stored daily percentages;
- Trust and date identifiers;
- operational and workforce measures;
- OPEL recommendation and approval fields;
- human-override indicators;
- source-system and load-batch information;
- data-quality status;
- KPI definitions and aggregation rules;
- PostgreSQL reconciliation results.

### Key questions

1. Does the Power BI dataset preserve one row per Trust-date?
2. Do row, Trust and date counts match PostgreSQL?
3. Are important percentage KPIs calculated from the correct fields?
4. Do weighted Power BI measures match PostgreSQL?
5. Are any percentages being summed or averaged incorrectly?
6. Are Trust and date filters behaving correctly?
7. Are recommended and approved OPEL levels represented separately?
8. Are lineage and quality fields available for investigation?
9. Can published findings be reproduced?
10. Have affected findings been recalculated after source changes?

### Decisions supported

The dashboard and semantic model may support:

- approving KPI calculations for portfolio use;
- identifying modelling or aggregation errors;
- reconciling Power BI with PostgreSQL;
- documenting limitations;
- recommending source-data enrichment;
- preparing analytical explanations and evidence.

### Required dashboard pages

- Executive Overview;
- all operational pages;
- Trust-Day Investigation;
- Data Quality and Lineage;
- KPI Definitions and Limitations.

### Detail level

Detailed analytical and technical.

The user requires:

- raw fields;
- visible filter context;
- detailed tables;
- reconciliation measures;
- calculation definitions;
- drill-through;
- source lineage;
- export capability appropriate to the synthetic dataset.

### Risks

- using stored daily percentages for period totals;
- creating circular or duplicated measures;
- introducing duplicate rows through relationships;
- using bidirectional filtering without justification;
- presenting synthetic associations as causal findings;
- failing to rerun validation after source changes.

---

## Persona 4 — Data Quality and Governance Lead

### Role

A fictional governance or data-quality lead responsible for ensuring that the dashboard is appropriately controlled, traceable and described.

### Information needs

The user needs visibility of:

- expected and actual row counts;
- Trust and reporting-date coverage;
- duplicate Trust-date records;
- missing values;
- failed validation rules;
- invalid percentage ranges;
- source-system information;
- source-record IDs;
- load-batch IDs;
- data-quality status;
- synthetic-data warnings;
- KPI definitions and limitations;
- OPEL accountability fields.

### Key questions

1. Does the dataset contain the expected 90 Trust-day records?
2. Are all three Trusts and 30 dates present?
3. Are any Trust-date records duplicated?
4. Are required fields missing?
5. Do all percentage values remain within valid ranges?
6. Do ambulance delays remain less than or equal to arrivals?
7. Can each record be traced to its source and load batch?
8. Is the synthetic-data warning visible?
9. Are recommended and approved OPEL levels clearly separated?
10. Are dashboard limitations accessible to users?

### Decisions supported

The dashboard may support fictional activities such as:

- approving data for portfolio reporting;
- rejecting an invalid refresh;
- requesting remediation;
- recording known limitations;
- confirming that governance warnings are visible;
- reviewing whether the dashboard is ready for demonstration.

### Required dashboard pages

- Home and Guidance;
- Data Quality and Lineage;
- KPI Definitions and Limitations;
- Trust-Day Investigation;
- Executive Overview.

### Detail level

Detailed assurance and audit information.

The user requires:

- quality summary cards;
- exception tables;
- source and batch fields;
- validation results;
- visible definitions;
- documented ownership and limitations.

### Risks

- treating a successful technical validation as proof that the data is suitable for every purpose;
- failing to distinguish missing data from a controlled “none” value;
- assuming synthetic data does not require governance;
- allowing technical lineage fields to confuse ordinary dashboard users;
- approving a refresh without reconciling important KPIs.

---

## Shared Persona Requirements

All dashboard personas require:

- a visible synthetic-data disclaimer;
- clear reporting-period information;
- visible Trust and date filter context;
- consistent KPI definitions;
- accessible limitations;
- weighted period percentages where appropriate;
- clear separation of recommended and approved OPEL levels;
- visibility of human overrides;
- no unsupported causal claims;
- no presentation of project-specific thresholds as official NHS thresholds.

---

## Access and Visibility Principles

The Power BI design should provide information according to user need.

### Executive users

Executive users should see:

- headline KPIs;
- major trends;
- exceptions;
- concise limitations.

Detailed technical fields should normally be hidden from the main executive view.

### Operational users

Operational users should see:

- Trust-level trends;
- daily operational measures;
- pressure indicators;
- OPEL decisions;
- drill-through information.

### Analytical users

Analytical users should have access to:

- raw source fields;
- numerator and denominator measures;
- detailed tables;
- reconciliation information;
- lineage fields.

### Governance users

Governance users should have access to:

- data-quality results;
- source lineage;
- load-batch information;
- definitions;
- limitations;
- approval and accountability fields.

---

## Users Outside Scope

The dashboard is not designed for:

- patients or members of the public;
- direct clinical care;
- individual staff-performance management;
- real NHS Trust benchmarking;
- automated operational escalation;
- real resource-allocation decisions;
- real OPEL approval.

---

## Persona Validation Requirements

The final dashboard specification must confirm that each persona can:

- locate the information relevant to their role;
- understand the selected Trust and date context;
- access KPI definitions;
- distinguish counts, snapshots and percentages;
- understand the synthetic-data limitation;
- identify when further investigation is required;
- avoid interpreting the dashboard as an automated decision-maker.

---



The next activity is:

`Week 14, Day 1, Session 3 — define decision-support questions`
