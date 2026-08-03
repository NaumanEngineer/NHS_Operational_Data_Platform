# NHS Operational Intelligence Dashboard — Scope and Success Criteria

## Document Purpose

This document defines what is included in the Power BI dashboard specification, what is excluded and how successful completion will be assessed.

All organisations and data are synthetic.

The dashboard is intended only for learning, testing and portfolio demonstration. It must not be used for real operational or clinical decisions.

---

## Product Objective

The objective is to specify a governed Power BI dashboard that enables fictional operational users to:

- monitor operational pressure;
- compare fictional Trusts;
- investigate changes over time;
- examine capacity, demand, patient flow and workforce indicators;
- review OPEL recommendations and approvals;
- identify human overrides;
- understand data quality, source lineage and limitations.

Week 14 will define the dashboard. It will not build the final Power BI report.

---

## In Scope

### Business requirements

It will define:

- fictional dashboard users;
- user information needs;
- decision-support questions;
- intended and prohibited uses;
- dashboard scope;
- success criteria;
- known limitations.

### KPI requirements

It will define:

- KPI names;
- business meanings;
- formulas;
- numerators and denominators;
- aggregation rules;
- reporting grains;
- filters;
- display formats;
- known limitations;
- PostgreSQL reconciliation requirements.

### Dashboard pages

The specification will cover:

1. Home and Guidance;
2. Executive Overview;
3. Beds and Patient Flow;
4. A&E and Ambulance;
5. Workforce Pressure;
6. Incidents and OPEL;
7. Trust-Day Investigation;
8. Data Quality and Lineage;
9. KPI Definitions and Limitations.

The incident component will remain dependent on adding a separate incident-level source to the Power BI model.

### Filters and interaction

The specification will define:

- Trust filtering;
- date-range filtering;
- recommended OPEL filtering;
- approved OPEL filtering;
- human-override filtering;
- operational-pressure filtering;
- weather-warning filtering;
- data-quality filtering;
- reset-filter behaviour;
- drill-through requirements;
- tooltip requirements;
- page-navigation requirements.

### Data model

It will define:

- the Trust-day fact-table grain;
- a dedicated date dimension;
- a Trust dimension;
- relationship direction;
- required measures;
- fields hidden from ordinary users;
- treatment of technical and lineage fields;
- treatment of the separate incident source.

### Data quality

The specification will include requirements for:

- expected and actual row counts;
- Trust count;
- reporting-date count;
- duplicate Trust-date detection;
- missing-value checks;
- percentage range checks;
- numerator-and-denominator reconciliation;
- ambulance delays not exceeding arrivals;
- source-system and load-batch visibility;
- refresh validation.

### Governance

The specification will include:

- a visible synthetic-data warning;
- intended and prohibited use;
- human accountability;
- recommended-versus-approved OPEL separation;
- override visibility;
- confidence-score limitations;
- access expectations;
- export considerations;
- source lineage;
- KPI definitions;
- known limitations.

### Accessibility

The specification will include:

- readable text;
- descriptive titles;
- accessible contrast;
- no reliance on colour alone;
- visible filter context;
- logical navigation;
- useful tooltips;
- alt-text requirements;
- consistent number and date formats;
- manageable visual density.

### Testing and reconciliation

It will define:

- functional acceptance tests;
- data-quality tests;
- governance tests;
- accessibility tests;
- PostgreSQL-to-Power-BI reconciliation checks;
- expected tolerances.

---

## Out of Scope for this:

The following activities are not included:

- building the final `.pbix` report;
- publishing a Power BI service application;
- configuring scheduled refresh;
- creating production gateways;
- implementing production security;
- connecting to real NHS data;
- processing patient-level data;
- developing real clinical measures;
- creating official OPEL rules;
- predictive modelling;
- machine-learning development;
- automatic alerting;
- automated escalation;
- real-time operational control;
- staff-performance management;
- clinical decision support;
- resource-allocation recommendations;
- real Trust benchmarking;
- mobile-application development;
- production API development.

These items may be considered in later project phases where appropriate.

---

## Source Scope

### Included source

The current dashboard specification will use:

`operational.vw_trust_daily_analytical`

and its CSV export:

`outputs/query_results.csv`

The current export contains:

- 90 Trust-day records;
- 3 fictional Trusts;
- 30 reporting dates;
- 56 fields;
- no duplicate Trust-date records;
- no missing values.

### Separate incident source

Incident-level reporting requires a separate source because incident records are not included in the Trust-day CSV.

The future semantic model may include:

`operational.incidents`

This source must retain an incident-level grain and must not be joined in a way that duplicates Trust-day operational measures.

---

## Reporting Scope

The reporting period is:

`1 January 2026 to 30 January 2026`

The dashboard must not imply that data exists outside this period.

The main analytical grain is:

`One row per Trust per reporting date`

Incident reporting, when added, will use:

`One row per incident`

The semantic model must preserve both grains appropriately.

---

## KPI Scope

### Included KPI areas

The specification will define KPIs for:

- general-bed occupancy;
- critical-care occupancy;
- A&E attendances;
- four-hour breaches;
- ambulance arrivals;
- delayed handovers;
- admissions;
- discharges;
- net admissions;
- patients ready for discharge;
- workforce establishment;
- workforce absence;
- agency FTE;
- bank FTE;
- unfilled shifts;
- OPEL frequency;
- recommendations and approvals;
- human overrides;
- data quality and completeness.

### Conditional KPI areas

Incident KPIs will be specified only with a clear dependency on the separate incident-level source.

### Excluded KPI claims

The dashboard must not present:

- official NHS performance thresholds unless an authoritative source is added;
- clinically validated risk scores;
- real Trust rankings;
- causal claims;
- patient-level outcomes;
- staff-performance scores;
- automatic operational recommendations.

---

## Functional Success Criteria

The dashboard specification will be successful when it clearly defines how the future report will:

1. open on a Home and Guidance page;
2. display the synthetic-data warning;
3. show the selected reporting period;
4. allow filtering by Trust;
5. allow filtering by date range;
6. allow filtering by recommended and approved OPEL;
7. show an Executive Overview;
8. provide operational drill-down pages;
9. provide a Trust-day investigation page;
10. provide a Data Quality and Lineage page;
11. provide KPI definitions and limitations;
12. support reset-filter behaviour;
13. support drill-through;
14. show visible filter context;
15. keep recommended and approved OPEL levels separate.

---

## Data Success Criteria

The future Power BI model must:

1. represent 90 Trust-day records;
2. contain 3 fictional Trusts;
3. contain 30 reporting dates;
4. preserve one row per Trust-date;
5. contain zero duplicate Trust-date records;
6. identify missing records;
7. calculate weighted percentages from numerators and denominators;
8. return zero ambulance percentages above 100%;
9. return zero ambulance-delay counts exceeding arrivals;
10. reconcile headline measures to PostgreSQL;
11. preserve source-system and load-batch information;
12. prevent direct summation of percentage and status fields.

Expected reconciliation tolerance:

| Measure type | Tolerance |
|---|---:|
| Row, Trust, date and duplicate counts | 0 |
| Integer totals | 0 |
| Percentages | 0.01 percentage points |
| FTE measures | 0.01 FTE |
| OPEL and override counts | 0 |

---

## Governance Success Criteria

The future dashboard must:

- display the synthetic-data disclaimer;
- state the intended and prohibited uses;
- preserve human accountability;
- show recommended and approved OPEL levels separately;
- identify human overrides;
- avoid presenting confidence as certainty;
- avoid unsupported causal claims;
- avoid presenting portfolio rules as official NHS thresholds;
- provide access to KPI definitions;
- provide access to known limitations;
- show source and refresh information where available.

---

## Accessibility Success Criteria

The future dashboard must:

- use readable font sizes;
- provide descriptive chart titles;
- use accessible contrast;
- avoid communicating status by colour alone;
- provide alt text for meaningful visuals;
- use a logical tab and navigation order;
- provide explanatory tooltips;
- use consistent number formatting;
- use consistent date formatting;
- show active filter context;
- provide a reset-filter control;
- avoid excessive visual density.

---

## Technical Success Criteria

The Week specification must allow another BI developer to understand:

- the dashboard users;
- required business questions;
- required pages;
- KPI definitions;
- source fields;
- aggregation rules;
- fact and dimension tables;
- relationship rules;
- required filters;
- navigation behaviour;
- drill-through paths;
- data-quality controls;
- reconciliation requirements;
- governance controls;
- accessibility requirements;
- acceptance tests.

The specification should be detailed enough that the developer does not need to guess how critical measures should be calculated.

---

## Portfolio Success Criteria

The completed specification should demonstrate that the project author can:

- translate operational questions into dashboard requirements;
- distinguish counts, snapshots and weighted percentages;
- design for different user types;
- identify data-quality risks;
- correct a source-data defect;
- preserve human oversight;
- plan a governed semantic model;
- define reconciliation and acceptance tests;
- communicate limitations clearly.

---



---

## Next Activity

After committing this document, the next activity is:

`Week 14, Day 2, Session 1 — learn and document KPI design principles`
