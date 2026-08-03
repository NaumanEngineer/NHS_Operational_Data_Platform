# NHS Operational Intelligence Dashboard — Decision-Support Questions

## Document Purpose

This document defines the questions that the Power BI dashboard must answer.

Each question is linked to:

- an intended user;
- required KPIs;
- an appropriate visual;
- required filters;
- the fictional decision or activity supported;
- known interpretation risks.

All data and organisations are synthetic.

The dashboard provides information for human review. It does not make operational or clinical decisions.

---

## Question 1 — Which Trust has the greatest operational pressure?

- Intended users: Executive Operational Leader; Trust Operational Performance Manager
- Required KPIs:
  - latest approved OPEL level;
  - general-bed occupancy;
  - critical-care occupancy;
  - A&E breach percentage;
  - ambulance handover-delay percentage;
  - workforce absence percentage;
  - unfilled shifts.
- Recommended visual: Trust-comparison matrix with status indicators
- Required filters:
  - reporting date;
  - Trust;
  - approved OPEL level.
- Activity supported: Identifying which fictional Trust requires further management investigation.
- Interpretation risk: No single KPI should be presented as the sole cause of operational pressure.

---

## Question 2 — How has general-bed occupancy changed over time?

- Intended users: Executive Operational Leader; Trust Operational Performance Manager
- Required KPIs:
  - occupied general beds;
  - open general beds;
  - weighted general-bed occupancy percentage;
  - maximum daily occupancy percentage.
- Recommended visual: Line chart by reporting date
- Required filters:
  - Trust;
  - date range;
  - approved OPEL level.
- Activity supported: Identifying periods of sustained or increasing bed pressure.
- Interpretation risk: Stored daily percentages must not be summed.

---

## Question 3 — When was critical-care occupancy highest?

- Intended users: Trust Operational Performance Manager; Performance and BI Analyst
- Required KPIs:
  - critical-care beds open;
  - critical-care beds occupied;
  - weighted critical-care occupancy percentage;
  - maximum daily critical-care occupancy.
- Recommended visual: Line chart with a high-value date table
- Required filters:
  - Trust;
  - date range.
- Activity supported: Investigating dates of high critical-care capacity pressure.
- Interpretation risk: The data is synthetic and must not be interpreted as real clinical capacity evidence.

---

## Question 4 — Which dates recorded the highest A&E breach pressure?

- Intended users: Executive Operational Leader; Trust Operational Performance Manager
- Required KPIs:
  - A&E attendances;
  - four-hour breaches;
  - weighted four-hour breach percentage;
  - maximum daily breach percentage.
- Recommended visual: Trend chart and ranked Trust-date table
- Required filters:
  - Trust;
  - date range;
  - approved OPEL level.
- Activity supported: Identifying high-pressure dates for further investigation.
- Interpretation risk: A high breach percentage does not by itself explain why performance changed.

---

## Question 5 — Are ambulance handover delays increasing?

- Intended users: Executive Operational Leader; Trust Operational Performance Manager
- Required KPIs:
  - ambulance arrivals;
  - ambulance handover delays;
  - weighted handover-delay percentage;
  - maximum daily handover-delay percentage.
- Recommended visual: Dual-line trend or arrivals-and-delays chart
- Required filters:
  - Trust;
  - date range;
  - approved OPEL level.
- Activity supported: Reviewing whether ambulance handover pressure increased during the selected period.
- Interpretation risk: Period performance must use total delays divided by total arrivals, not an average or sum of stored percentages.

---

## Question 6 — Are admissions exceeding discharges?

- Intended users: Trust Operational Performance Manager; Performance and BI Analyst
- Required KPIs:
  - total admissions;
  - total discharges;
  - net admissions;
  - days where admissions exceeded discharges.
- Recommended visual: Admissions-versus-discharges trend with net-admissions columns
- Required filters:
  - Trust;
  - date range;
  - approved OPEL level.
- Activity supported: Investigating possible patient-flow and capacity pressure.
- Interpretation risk: Net admissions are a simplified synthetic flow measure and do not represent a complete patient pathway.

---

## Question 7 — When were the most patients ready for discharge?

- Intended users: Trust Operational Performance Manager
- Required KPIs:
  - patients ready for discharge;
  - average daily patients ready for discharge;
  - maximum daily patients ready for discharge;
  - related bed-occupancy percentage.
- Recommended visual: Line chart and ranked date table
- Required filters:
  - Trust;
  - date range;
  - approved OPEL level.
- Activity supported: Identifying dates requiring further fictional discharge-flow investigation.
- Interpretation risk: This is a daily snapshot measure and must not automatically be summed across dates.

---

## Question 8 — Is workforce pressure higher on high-OPEL days?

- Intended users: Executive Operational Leader; Trust Operational Performance Manager; Performance and BI Analyst
- Required KPIs:
  - workforce absence percentage;
  - absence FTE;
  - agency FTE;
  - bank FTE;
  - unfilled shifts;
  - approved OPEL level.
- Recommended visual: Grouped comparison by approved OPEL level
- Required filters:
  - Trust;
  - date range;
  - approved OPEL level.
- Activity supported: Investigating associations between workforce pressure and operational escalation.
- Interpretation risk: An association between workforce measures and OPEL does not establish causation.

---

## Question 9 — How often did each Trust operate at OPEL 3 or OPEL 4?

- Intended users: Executive Operational Leader; Trust Operational Performance Manager
- Required KPIs:
  - OPEL 3 days;
  - OPEL 4 days;
  - OPEL 3–4 days;
  - percentage of reporting days at OPEL 3–4.
- Recommended visual: Stacked bar chart by Trust
- Required filters:
  - Trust;
  - date range.
- Activity supported: Comparing the frequency of higher synthetic escalation levels.
- Interpretation risk: OPEL levels are ordinal status values and must not be summed.

---

## Question 10 — Did approved OPEL levels differ from recommendations?

- Intended users: Executive Operational Leader; Trust Operational Performance Manager; Data Quality and Governance Lead
- Required KPIs:
  - recommended OPEL level;
  - approved OPEL level;
  - override count;
  - override percentage.
- Recommended visual: Recommendation-versus-approval matrix
- Required filters:
  - Trust;
  - date range;
  - recommended OPEL level;
  - approved OPEL level.
- Activity supported: Reviewing the application of fictional human judgement.
- Interpretation risk: An override must not automatically be described as an error.

---

## Question 11 — Which Trust-dates contain a human override?

- Intended users: Trust Operational Performance Manager; Data Quality and Governance Lead
- Required fields:
  - Trust;
  - reporting date;
  - recommended OPEL level;
  - approved OPEL level;
  - human-override indicator;
  - assessment rationale;
  - key pressure factors;
  - reviewer role;
  - review timestamp.
- Recommended visual: Drill-through investigation table
- Required filters:
  - Trust;
  - date range;
  - human-override indicator.
- Activity supported: Reviewing the context and accountability record for a fictional override.
- Interpretation risk: Reviewer information identifies fictional roles, not real individuals.

---

## Question 12 — What weather context accompanied operational pressure?

- Intended users: Trust Operational Performance Manager; Performance and BI Analyst
- Required fields and KPIs:
  - minimum and maximum temperature;
  - precipitation;
  - snowfall;
  - wind speed;
  - weather-warning level;
  - temperature band;
  - occupancy, breach, delay and OPEL measures.
- Recommended visual: Contextual comparison by weather band or warning level
- Required filters:
  - Trust;
  - date range;
  - weather-warning level;
  - temperature band.
- Activity supported: Exploring synthetic relationships between weather and operational indicators.
- Interpretation risk: Weather associations must not be presented as causal findings.

---

## Question 13 — Is the reporting dataset complete?

- Intended users: Performance and BI Analyst; Data Quality and Governance Lead
- Required KPIs:
  - expected Trust-day records;
  - actual Trust-day records;
  - Trust count;
  - reporting-date count;
  - completeness percentage.
- Recommended visual: Data-quality cards and completeness table
- Required filters:
  - Trust;
  - date range;
  - load-batch ID.
- Activity supported: Determining whether the dataset is complete enough for portfolio reporting.
- Expected full-period result:
  - 90 Trust-day records;
  - 3 Trusts;
  - 30 reporting dates;
  - 100% completeness.
- Interpretation risk: Completeness does not prove that every value is correct or suitable for every purpose.

---

## Question 14 — Does the dataset contain duplicates or invalid values?

- Intended users: Performance and BI Analyst; Data Quality and Governance Lead
- Required KPIs:
  - duplicate Trust-date count;
  - missing-value count;
  - percentage range failures;
  - ambulance delays exceeding arrivals;
  - failed validation count.
- Recommended visual: Quality summary cards and exception table
- Required filters:
  - Trust;
  - date range;
  - data-quality status;
  - load-batch ID.
- Activity supported: Accepting or rejecting a dataset refresh for portfolio reporting.
- Expected current result:
  - zero duplicate Trust-date records;
  - zero missing values;
  - zero percentage range failures;
  - zero ambulance delays exceeding arrivals.
- Interpretation risk: Zero recorded failures only confirms the rules that were actually tested.

---

## Question 15 — Can each Trust-day record be traced to its source?

- Intended users: Performance and BI Analyst; Data Quality and Governance Lead
- Required fields:
  - Trust code;
  - reporting date;
  - operational source system;
  - operational source-record ID;
  - load-batch ID;
  - data-quality status.
- Recommended visual: Trust-day lineage table
- Required filters:
  - Trust;
  - date range;
  - source system;
  - load-batch ID;
  - data-quality status.
- Activity supported: Tracing a dashboard value back to its synthetic source record.
- Interpretation risk: Technical lineage fields should normally remain hidden from executive users.

---

## Shared Filter Requirements

The dashboard should provide consistent filters for:

- Trust;
- reporting date or date range;
- approved OPEL level;
- recommended OPEL level;
- human-override status;
- operational-pressure status;
- weather-warning level;
- data-quality status.

Technical pages may also provide filters for:

- source system;
- source-record ID;
- load-batch ID.

---

## Shared Interpretation Requirements

Every dashboard page must:

- show the current Trust and date context;
- use weighted period percentages where appropriate;
- distinguish counts from daily snapshots;
- keep recommended and approved OPEL levels separate;
- identify synthetic data clearly;
- avoid unsupported causal conclusions;
- provide access to KPI definitions and limitations.

---

## Incident Reporting Requirement

Incident-level questions are not included in the current 15-question minimum because the Trust-day CSV does not contain incident records.

Future questions may include:

- How many incidents occurred?
- Which incidents remain unresolved?
- Which incidents were high or critical severity?
- Did incident frequency differ by OPEL level?

These questions require a separate incident-level Power BI source and appropriate relationships.

---

