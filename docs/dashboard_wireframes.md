# NHS Operational Intelligence Dashboard — Wireframes

## Document Purpose

This document defines the planned page structure, navigation, visual layout, filters, drill-through behaviour and accessibility requirements for the Power BI reporting layer of the NHS Operational Intelligence Platform.

The dashboard uses fully synthetic data for learning, technical testing and portfolio demonstration.

It must not be used to make real operational or clinical decisions.

---

## Dashboard Design Principles

The report will follow these principles:

1. Each page must answer a defined operational question.
2. Executive pages will prioritise rapid understanding.
3. Analytical pages will support investigation and comparison.
4. Data-quality and governance information will remain visible.
5. Recommended and approved OPEL levels will remain separate.
6. Percentages will use controlled measures rather than default aggregation.
7. Filter context will be visible to users.
8. Navigation will remain consistent across all pages.
9. Status will not be communicated by colour alone.
10. Synthetic findings will not be presented as causal conclusions.
11. Source-blocked KPIs will be shown as unavailable rather than replaced with unreliable calculations.
12. Visual density will be controlled so users can identify the most important information quickly.

---

## Planned Report Pages

| Page | Primary purpose | Main users |
|---|---|---|
| 1. Home and Guidance | Explain purpose, scope, navigation and limitations | All users |
| 2. Executive Overview | Provide a rapid summary of operational pressure | Executive operational leaders |
| 3. Beds and Patient Flow | Investigate occupancy, flow and discharge pressure | Operational and capacity analysts |
| 4. A&E and Ambulance | Analyse emergency demand, breaches and handover pressure | A&E and performance analysts |
| 5. Workforce Pressure | Examine absence, temporary staffing and unfilled shifts | Workforce planners |
| 6. Incidents and OPEL | Review escalation levels, human overrides and future incident measures | Operational leaders and governance reviewers |
| 7. Trust-Day Investigation | Investigate one Trust on one reporting date | Performance analysts |
| 8. Data Quality and Lineage | Review completeness, duplicates, source and refresh information | BI managers and data-quality reviewers |
| 9. KPI Definitions and Limitations | Provide measure definitions, assumptions and warnings | All users |

---

## Navigation Structure

The dashboard will use a consistent left-hand or top navigation bar.

Navigation controls will include:

- Home;
- Executive Overview;
- Beds and Patient Flow;
- A&E and Ambulance;
- Workforce Pressure;
- Incidents and OPEL;
- Trust-Day Investigation;
- Data Quality and Lineage;
- KPI Definitions and Limitations;
- Back;
- Reset Filters.

The currently selected page should be visually identifiable.

Navigation buttons must use clear text labels rather than icons alone.

Navigation should remain in the same position on every report page.

---

## Global Filters

The following filters should be available on relevant pages:

- Trust;
- reporting-date range;
- approved OPEL level;
- operational-pressure status;
- weather-warning level;
- human-override status, where relevant.

Not every filter must appear on every page.

The dashboard should avoid unnecessary slicer duplication where filter context can be synchronised across pages.

The active filter context should remain visible to users.

---

## Global Header Requirements

Each report page should display:

- dashboard title;
- current page title;
- selected Trust context;
- selected reporting period;
- synthetic-data warning;
- last refresh date or source date;
- reset-filter control.

Required warning:

> This dashboard uses fully synthetic data for learning and portfolio demonstration. It must not be used for real operational or clinical decisions.

---

# Page 1 — Home and Guidance

## Purpose

Provide users with a clear introduction to the dashboard, its intended use, its limitations and the available navigation paths.

## Primary Users

- all report users;
- recruiters reviewing the project;
- NHS analysts;
- BI developers;
- governance reviewers.

## Questions Answered

- What is this dashboard?
- What data does it use?
- Who is it designed for?
- What can it support?
- What must it not be used for?
- How should users navigate the report?
- What does the current dataset contain?

## Required Content

### Title Area

Include:

- NHS Operational Intelligence Dashboard;
- portfolio-project label;
- synthetic-data warning;
- reporting period.

### Platform Summary

Explain that the dashboard is built on:

- PostgreSQL operational tables;
- validated Trust-day analytical data;
- controlled Power BI measures;
- human-reviewed OPEL information;
- documented governance controls.

### Dataset Summary Cards

Display:

- fictional Trusts: 3;
- reporting dates: 30;
- Trust-day records: 90;
- duplicate Trust-date records: 0;
- reporting period: 1 January 2026 to 30 January 2026.

### Navigation Panel

Provide large navigation buttons linking to:

- Executive Overview;
- Beds and Patient Flow;
- A&E and Ambulance;
- Workforce Pressure;
- Incidents and OPEL;
- Trust-Day Investigation;
- Data Quality and Lineage;
- KPI Definitions and Limitations.

### Guidance Panel

Explain:

- how to use filters;
- how to reset filters;
- how to use drill-through;
- how to interpret synthetic results;
- why OPEL recommendation and approval remain separate;
- why some KPIs may display a source-readiness warning.

### Limitations Panel

Display:

- synthetic data only;
- 30-day period;
- three fictional Trusts;
- no real NHS performance data;
- no live operational refresh;
- illustrative status rules;
- no clinical or operational decision authority;
- some weighted KPIs currently require source enrichment.

## Filters

No mandatory filters are required on the Home page.

## Interactions

- navigation buttons open the relevant pages;
- information icons may open tooltip explanations;
- no analytical visual should dominate the page;
- clicking the Home button from another page should return users to the default landing page.

## Accessibility Requirements

- large readable headings;
- plain-language guidance;
- descriptive navigation labels;
- no reliance on colour alone;
- visible synthetic-data warning;
- logical reading order.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ NHS Operational Intelligence Dashboard                     │
│ Synthetic portfolio demonstration                          │
├─────────────────────────────────────────────────────────────┤
│ Platform Summary                    │ Dataset Summary        │
│ PostgreSQL → Power BI               │ 3 Trusts              │
│ Governed analytical layer           │ 30 dates              │
│ Human-reviewed OPEL design          │ 90 Trust-day rows     │
├─────────────────────────────────────────────────────────────┤
│ Navigation Buttons                                          │
│ Executive | Beds | A&E | Workforce | OPEL | Quality         │
├─────────────────────────────────────────────────────────────┤
│ How to use the dashboard                                    │
├─────────────────────────────────────────────────────────────┤
│ Limitations and synthetic-data warning                      │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 2 — Executive Overview

## Purpose

Provide senior operational users with a rapid summary of system pressure across the selected Trusts and reporting period.

## Primary Users

- executive operational leaders;
- Trust performance managers;
- ICB operational analysts;
- winter-pressure teams.

## Questions Answered

- Which Trust appears under the greatest pressure?
- How has pressure changed over time?
- How often did Trusts operate at OPEL 3 or 4?
- Which operational indicators require investigation?
- Did approved OPEL decisions differ from recommendations?
- Is the data complete enough to support interpretation?

## Headline KPI Cards

Use no more than six primary cards:

1. average general-bed occupancy;
2. total A&E attendances;
3. weighted A&E breach rate, once source-ready;
4. average workforce absence;
5. OPEL 3–4 days;
6. human override count.

Until the enriched source is available, blocked weighted-rate cards should display:

`Source enrichment required`

rather than an unreliable value.

## Required Visuals

### Operational Pressure Trend

Recommended visual:

- line chart;
- x-axis: reporting date;
- y-axis: selected pressure measure;
- legend: Trust.

Allow users to switch between:

- general-bed occupancy;
- daily A&E breach percentage;
- workforce absence;
- approved OPEL.

### Trust Comparison

Recommended visual:

- horizontal ranked bar chart;
- Trust on axis;
- selected KPI as value.

Default KPI:

- average general-bed occupancy.

### OPEL Distribution

Recommended visual:

- stacked column or bar chart;
- approved OPEL level by Trust;
- count of Trust-days.

### Pressure Matrix

Recommended visual:

- matrix or heat map;
- rows: Trust;
- columns: reporting date;
- value or status: operational-pressure category.

### Human Override Summary

Recommended visual:

- override count card;
- override percentage card;
- small table showing override dates.

### Management Insight Panel

Include a small narrative panel covering:

- strongest synthetic pressure signal;
- highest-pressure Trust;
- notable change over time;
- current data limitation.

Any narrative must be clearly labelled as synthetic and descriptive.

## Filters

- Trust;
- date range;
- approved OPEL level;
- operational-pressure status.

## Drill-Through

Users should be able to drill through from:

- a Trust;
- a date;
- a Trust-date visual point;

to:

`Page 7 — Trust-Day Investigation`

## Interaction Rules

- selecting a Trust filters all relevant visuals;
- selecting a date range updates all KPIs;
- selecting an OPEL category filters comparison visuals;
- blocked KPIs remain visibly marked as unavailable;
- narrative text must update or remain clearly labelled as static;
- selecting a heat-map cell should preserve Trust-date context.

## Accessibility Requirements

- chart titles must state the metric and filter context;
- OPEL categories require text labels, not colour alone;
- cards must include units;
- no more than six headline cards;
- visible note when a KPI is source-limited;
- trend lines should use markers or labels where useful.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ Executive Overview | Trust | Date | OPEL | Reset Filters   │
├─────────────────────────────────────────────────────────────┤
│ Occupancy │ A&E │ Breach Rate │ Absence │ OPEL 3–4 │ Override│
├─────────────────────────────────────────────────────────────┤
│ Operational Pressure Trend       │ Trust Comparison         │
│                                  │                          │
├──────────────────────────────────┼──────────────────────────┤
│ Pressure Matrix                  │ OPEL Distribution        │
│                                  │                          │
├──────────────────────────────────┼──────────────────────────┤
│ Human Override Summary           │ Management Insight       │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 3 — Beds and Patient Flow

## Purpose

Allow users to investigate capacity utilisation and patient-flow pressure over time and across fictional Trusts.

## Primary Users

- capacity analysts;
- operational performance analysts;
- discharge-flow teams;
- executive operational leaders.

## Questions Answered

- Which Trust recorded the highest occupancy?
- How did occupancy change over time?
- Where did critical-care pressure increase?
- Did net admissions indicate increasing or reducing pressure?
- How persistent was discharge-ready pressure?
- Which Trust-dates require further investigation?

## KPI Cards

- average general-bed occupancy;
- maximum general-bed occupancy;
- average critical-care occupancy;
- discharge-ready patient-days;
- net admissions;
- high operational-pressure days.

## Required Visuals

### General-Bed Occupancy Trend

- line chart;
- x-axis: reporting date;
- y-axis: general-bed occupancy percentage;
- legend: Trust.

### Critical-Care Occupancy Trend

- line chart;
- x-axis: reporting date;
- y-axis: critical-care occupancy percentage;
- legend: Trust.

### Net Admissions Trend

- column chart;
- x-axis: reporting date;
- y-axis: net admissions;
- positive and negative values clearly distinguished using labels and axis position, not colour alone.

### Discharge-Ready Pressure

- line or area chart;
- value: daily patients ready for discharge;
- include an average reference line only if clearly labelled.

### Trust Comparison

- ranked bar chart;
- default measure: average general-bed occupancy.

### High-Pressure Dates Table

Include:

- Trust;
- reporting date;
- general-bed occupancy;
- critical-care occupancy;
- patients ready for discharge;
- net admissions;
- approved OPEL;
- operational-pressure status.

## Filters

- Trust;
- reporting date;
- approved OPEL level;
- operational-pressure status.

## Drill-Through

The high-pressure table and trend visuals should allow drill-through to:

`Page 7 — Trust-Day Investigation`

## Interaction Rules

- selecting one Trust filters all capacity and flow visuals;
- selecting a date range updates trends and patient-day calculations;
- selecting a pressure status filters the high-pressure table;
- drill-through preserves Trust and date.

## Interpretation Notes

The page must explain:

- occupancy percentages are average daily values unless weighted raw-bed measures are added;
- discharge-ready patient-days are cumulative daily counts, not unique patients;
- positive net admissions may indicate additional capacity pressure but do not prove causation;
- all values are synthetic.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ Beds and Patient Flow | Trust | Date | OPEL | Reset        │
├─────────────────────────────────────────────────────────────┤
│ Avg Bed │ Max Bed │ Critical Care │ Patient-Days │ Net Adm │
├─────────────────────────────────────────────────────────────┤
│ General-Bed Occupancy Trend                                │
├──────────────────────────────────┬──────────────────────────┤
│ Critical-Care Trend              │ Trust Comparison         │
├──────────────────────────────────┼──────────────────────────┤
│ Net Admissions                   │ Discharge-Ready Pressure │
├─────────────────────────────────────────────────────────────┤
│ High-Pressure Trust-Date Table                              │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 4 — A&E and Ambulance

## Purpose

Support investigation of emergency demand, four-hour breach pressure and ambulance handover performance.

## Primary Users

- A&E analysts;
- ambulance-performance analysts;
- executive operational leaders;
- performance managers.

## Questions Answered

- Which Trust recorded the greatest A&E demand?
- Which dates had the highest daily breach percentages?
- How did emergency demand change over time?
- How did ambulance pressure vary by Trust and OPEL level?
- Which metrics are currently blocked by source limitations?

## KPI Cards

- total A&E attendances;
- weighted A&E breach rate;
- ambulance handover delay rate;
- OPEL 3–4 days;
- high operational-pressure days.

The two weighted-rate cards must remain blocked until raw source fields are available.

## Required Visuals

### A&E Attendance Trend

- line or column chart;
- x-axis: reporting date;
- y-axis: total A&E attendances;
- legend: Trust.

### Daily Four-Hour Breach Percentage

- line chart;
- clearly labelled as a daily percentage;
- not presented as a weighted period rate.

### High-Breach Dates

- ranked table or bar chart;
- include Trust, date, A&E attendances and daily breach percentage.

### Ambulance Delay Trend

- do not use the current field as a trusted KPI until corrected;
- display a source-warning placeholder during the design stage.

### OPEL Comparison

- compare A&E activity or daily breach percentage by approved OPEL level;
- avoid causal wording.

### Trust-Date Heat Map

- rows: Trust;
- columns: reporting date;
- value: daily breach percentage or operational-pressure status.

## Filters

- Trust;
- reporting date;
- approved OPEL level;
- operational-pressure status.

## Source-Limitation Banner

Display:

> Weighted A&E and ambulance rates require raw numerator and denominator fields. Current daily percentage fields are suitable only for limited exploratory analysis.

## Drill-Through

Users should be able to drill through from:

- a high-breach date;
- a heat-map cell;
- a Trust trend point;

to:

`Page 7 — Trust-Day Investigation`

## Interaction Rules

- selecting one Trust filters all emergency-demand visuals;
- selecting an OPEL level updates comparison visuals;
- blocked measures remain unavailable;
- selecting a date in a table or trend supports drill-through.

## Interpretation Notes

- higher attendance does not automatically indicate poor performance;
- daily breach percentages must not be averaged and labelled as weighted period rates;
- ambulance values above 100% must not be presented until the source definition is corrected;
- associations with OPEL do not prove causation.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ A&E and Ambulance | Trust | Date | OPEL | Reset            │
├─────────────────────────────────────────────────────────────┤
│ Attendances │ Breach Rate* │ Ambulance Rate* │ OPEL 3–4    │
│ *Source enrichment required                                │
├─────────────────────────────────────────────────────────────┤
│ A&E Attendance Trend                                       │
├──────────────────────────────────┬──────────────────────────┤
│ Daily Breach Percentage          │ High-Breach Dates        │
├──────────────────────────────────┼──────────────────────────┤
│ Trust-Date Heat Map              │ OPEL Comparison          │
├─────────────────────────────────────────────────────────────┤
│ Source-Limitation Banner                                    │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 5 — Workforce Pressure

## Purpose

Analyse workforce absence, temporary staffing and unfilled shifts across Trusts, dates and OPEL levels.

## Primary Users

- workforce planners;
- operational leaders;
- performance analysts.

## Questions Answered

- Which Trust recorded the highest workforce absence?
- Where was agency or bank use highest?
- How many unfilled shifts were recorded?
- Were workforce measures higher on OPEL 4 days?
- Which Trust-dates show combined workforce and operational pressure?

## KPI Cards

- average workforce absence;
- average daily agency FTE;
- average daily bank FTE;
- total unfilled shifts;
- OPEL 4 days;
- high operational-pressure days.

## Required Visuals

### Workforce Absence Trend

- line chart;
- x-axis: reporting date;
- y-axis: workforce absence percentage;
- legend: Trust.

### Average Agency and Bank FTE

- clustered bar chart;
- compare average daily agency and bank FTE by Trust.

### Unfilled Shifts Trend

- column chart;
- x-axis: reporting date;
- y-axis: unfilled shifts;
- legend: Trust.

### Workforce by OPEL

Compare:

- workforce absence;
- agency FTE;
- bank FTE;
- unfilled shifts;

by approved OPEL level.

### OPEL 4 Versus Non-OPEL 4

Use a comparison table including:

- average workforce absence;
- average agency FTE;
- average bank FTE;
- average unfilled shifts.

Label the results as synthetic association only.

### High-Pressure Trust-Date Table

Include:

- Trust;
- date;
- workforce absence;
- agency FTE;
- bank FTE;
- unfilled shifts;
- approved OPEL;
- operational-pressure status.

## Filters

- Trust;
- reporting date;
- approved OPEL level;
- operational-pressure status.

## Drill-Through

Allow drill-through from trend points and high-pressure rows to:

`Page 7 — Trust-Day Investigation`

## Interaction Rules

- Trust selection filters all workforce visuals;
- OPEL selection updates comparison tables;
- date filtering updates average daily FTE measures;
- no FTE measure should default to sum.

## Interpretation Notes

- agency and bank FTE should be averaged across dates, not summed and labelled as workforce size;
- high temporary staffing may reflect operational response as well as underlying pressure;
- association with OPEL does not prove causation;
- workforce measures do not include staff group, cost or shift detail.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ Workforce Pressure | Trust | Date | OPEL | Reset           │
├─────────────────────────────────────────────────────────────┤
│ Absence │ Agency FTE │ Bank FTE │ Unfilled │ OPEL 4 Days   │
├─────────────────────────────────────────────────────────────┤
│ Workforce Absence Trend                                    │
├──────────────────────────────────┬──────────────────────────┤
│ Agency vs Bank by Trust          │ Unfilled Shifts Trend    │
├──────────────────────────────────┼──────────────────────────┤
│ Workforce by OPEL               │ OPEL4 vs Non-OPEL4       │
├─────────────────────────────────────────────────────────────┤
│ High-Pressure Trust-Date Table                              │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 6 — Incidents and OPEL

## Purpose

Review escalation, human overrides and incident-related pressure once the analytical source has been enriched.

## Primary Users

- executive operational leaders;
- governance reviewers;
- operational analysts;
- BI managers.

## Questions Answered

- How often did each Trust operate at OPEL 3 or 4?
- Which Trust reached OPEL 4?
- How often did human approval differ from the recommendation?
- Which incidents coincided with higher pressure?
- Which incident measures remain unavailable in the current CSV?

## KPI Cards

- OPEL 3–4 days;
- OPEL 4 days;
- latest approved OPEL;
- human override count;
- human override percentage;
- unresolved incidents, once source-ready.

## Required Visuals

### OPEL Trend

- step or line chart;
- approved OPEL level over time;
- Trust as legend or small multiple.

### OPEL Distribution

- count of Trust-days by approved OPEL level and Trust.

### Human Override Trend

- count or marker by date;
- tooltip should explain that `recommended_opel_level` is not included in the current CSV.

### Recommended Versus Approved OPEL

- deferred until `recommended_opel_level` is added;
- reserve visual space in the wireframe;
- mark as source enrichment required.

### Incident Severity

- deferred until incident measures are added;
- reserve visual space;
- mark as source enrichment required.

### Incident and OPEL Investigation Table

Future fields:

- Trust;
- date;
- approved OPEL;
- recommended OPEL;
- human override;
- incident count;
- high or critical incidents;
- unresolved incidents.

## Filters

- Trust;
- reporting date;
- approved OPEL level;
- human-override status.

## Governance Banner

Display:

> Approved OPEL represents a human-reviewed decision. The dashboard must not imply that escalation was determined automatically.

## Interaction Rules

- selecting an OPEL level filters all relevant visuals;
- selecting a Trust filters the OPEL trend and distribution;
- human-override selection filters override dates;
- deferred incident visuals must remain visibly unavailable.

## Interpretation Notes

- overrides are governance signals, not measures of model failure or human error;
- OPEL levels are ordered categories;
- OPEL values must not be summed;
- incident analysis is deferred until source enrichment;
- approved OPEL must remain visibly separate from any future recommendation field.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ Incidents and OPEL | Trust | Date | OPEL | Override        │
├─────────────────────────────────────────────────────────────┤
│ OPEL 3–4 │ OPEL 4 │ Latest OPEL │ Overrides │ Override %  │
├─────────────────────────────────────────────────────────────┤
│ Approved OPEL Trend                                        │
├──────────────────────────────────┬──────────────────────────┤
│ OPEL Distribution               │ Human Override Trend      │
├──────────────────────────────────┼──────────────────────────┤
│ Recommended vs Approved*        │ Incident Severity*        │
│ *Source enrichment required                                 │
├─────────────────────────────────────────────────────────────┤
│ Governance Banner                                           │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 7 — Trust-Day Investigation

## Purpose

Allow users to investigate one fictional Trust on one reporting date in detail.

## Primary Users

- operational analysts;
- performance analysts;
- BI managers;
- governance reviewers.

## Required Selection

This page should require:

- one Trust;
- one reporting date.

If more than one Trust or date is selected, display an instruction message.

## Required Content

### Trust-Day Header

Include:

- Trust name;
- Trust code;
- reporting date;
- approved OPEL;
- operational-pressure status;
- human-override indicator.

### Capacity and Flow Panel

Include:

- general-bed occupancy;
- critical-care occupancy;
- patients ready for discharge;
- net admissions.

### A&E and Ambulance Panel

Include:

- A&E attendances;
- daily four-hour breach percentage;
- ambulance measure with source warning until corrected.

### Workforce Panel

Include:

- workforce absence;
- agency FTE;
- bank FTE;
- unfilled shifts.

### Weather Panel

Include:

- minimum temperature;
- maximum temperature;
- weather-warning level.

### Governance Panel

Include:

- approved OPEL;
- human-override status;
- synthetic-data warning;
- available source and quality information.

### Source and Quality Context

Display:

- source file or analytical view;
- reporting grain;
- current source-readiness warnings;
- whether the selected record contains a weather warning;
- whether blocked measures are unavailable.

## Drill-Through Sources

This page should receive drill-through context from:

- Executive Overview;
- Beds and Patient Flow;
- A&E and Ambulance;
- Workforce Pressure;
- Incidents and OPEL.

## Interaction Rules

- drill-through must preserve one Trust and one date;
- a Back button returns users to the source page;
- multiple selections should trigger an instruction message;
- no combined Trust-day detail should be shown.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ Trust-Day Investigation: Trust | Date | OPEL | Status      │
├─────────────────────────────────────────────────────────────┤
│ Capacity and Flow               │ A&E and Ambulance         │
├─────────────────────────────────┼───────────────────────────┤
│ Workforce                       │ Weather                   │
├─────────────────────────────────┼───────────────────────────┤
│ Governance and Human Override   │ Source / Quality Context  │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 8 — Data Quality and Lineage

## Purpose

Show whether the reporting dataset is complete, unique, current and appropriately documented.

## Primary Users

- BI managers;
- data-quality reviewers;
- data engineers;
- governance reviewers.

## Questions Answered

- Are all expected Trust-date records present?
- Are duplicate Trust-date rows present?
- Which fields contain blanks?
- Which KPIs are blocked by missing source fields?
- When was the data last refreshed?
- What is the reporting grain?
- What source and lineage information is available?

## KPI Cards

- reporting completeness percentage;
- duplicate Trust-date count;
- actual Trust-day rows;
- expected Trust-day rows;
- Trust count;
- reporting-date count.

## Required Visuals

### Expected Versus Actual Records

- comparison cards or bar chart;
- display 90 expected and 90 actual records for the current full dataset.

### Completeness by Trust

- table showing expected and actual dates by Trust.

### Duplicate Check

- clear pass or investigation status;
- status must include text, not colour alone.

### Missing-Value Summary

- field-level table;
- distinguish valid blank weather-warning values from unknown missing data;
- do not classify every blank automatically as a quality failure.

### KPI Source-Readiness Register

Show:

- KPI;
- current source support;
- status;
- ready;
- ready with limitation;
- blocked;
- enrichment required.

### Lineage Panel

Display available:

- source dataset;
- analytical view name;
- CSV export path;
- reporting period;
- refresh date;
- row count;
- source limitations.

## Filters

- Trust;
- reporting date.

## Interaction Rules

- selecting a Trust updates completeness measures;
- date filtering adjusts expected and actual record logic;
- source-readiness status remains visible;
- duplicate counts should respond to current context where appropriate.

## Interpretation Notes

- quality checks confirm structural consistency, not fitness for real NHS use;
- blank values require business interpretation;
- blocked KPIs must not be silently calculated using weaker methods;
- lineage information in the current CSV is limited.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ Data Quality and Lineage | Trust | Date | Reset            │
├─────────────────────────────────────────────────────────────┤
│ Completeness │ Duplicates │ Actual Rows │ Expected Rows    │
├──────────────────────────────────┬──────────────────────────┤
│ Completeness by Trust            │ Missing-Value Summary    │
├──────────────────────────────────┼──────────────────────────┤
│ KPI Source Readiness             │ Lineage Panel            │
├─────────────────────────────────────────────────────────────┤
│ Quality Interpretation and Limitations                      │
└─────────────────────────────────────────────────────────────┘
```

---

# Page 9 — KPI Definitions and Limitations

## Purpose

Provide transparent KPI definitions, aggregation rules, source readiness and interpretation guidance.

## Primary Users

- all report users;
- analysts;
- recruiters;
- governance reviewers.

## Questions Answered

- What does each KPI mean?
- How is it calculated?
- What source fields does it require?
- Is it ready, limited or blocked?
- Can it be summed, averaged or treated as a category?
- What limitations apply?

## Required Content

### KPI Search or Selection

Allow users to select a KPI name.

### Definition Panel

Display:

- business question;
- definition;
- formula;
- numerator;
- denominator;
- aggregation;
- reporting grain;
- display format;
- source fields;
- direction of concern.

### Limitation Panel

Display:

- current source limitation;
- synthetic-data status;
- whether the KPI is ready, limited or blocked;
- whether the metric is an average, weighted rate, count or latest value.

### Governance Panel

Explain:

- no official thresholds have been invented;
- synthetic associations do not prove causation;
- approved OPEL remains human reviewed;
- blocked measures must not be approximated without disclosure;
- daily percentages must not be described as weighted period rates.

### Aggregation Guidance

Provide examples of:

- additive counts;
- average daily percentages;
- weighted percentages;
- latest-value measures;
- conditional counts;
- categorical fields;
- patient-day measures;
- average daily FTE measures.

## Filters

- KPI selector;
- KPI status;
- KPI category.

## Interaction Rules

- selecting a KPI updates definition and limitation panels;
- blocked KPIs display a clear warning;
- users should be able to navigate back to the relevant analytical page;
- no KPI should appear without a documented definition.

## Wireframe

```text
┌─────────────────────────────────────────────────────────────┐
│ KPI Definitions and Limitations | KPI Selector             │
├─────────────────────────────────────────────────────────────┤
│ Business Question and Definition                            │
├──────────────────────────────────┬──────────────────────────┤
│ Formula and Aggregation          │ Source Readiness         │
├──────────────────────────────────┼──────────────────────────┤
│ Known Limitations                │ Governance Guidance      │
├─────────────────────────────────────────────────────────────┤
│ Aggregation Examples and Interpretation Notes               │
└─────────────────────────────────────────────────────────────┘
```

---

## Cross-Page Interaction Rules

The report will apply these interaction rules:

- Trust filters should synchronise across operational pages where appropriate.
- Date filters should use a consistent calendar table.
- OPEL filters should not affect pages where doing so would create misleading context.
- Drill-through should preserve Trust and reporting-date context.
- Reset buttons should return users to the documented default state.
- Blocked KPIs should display a clear source-readiness message.
- Tooltips should clarify units, grain and limitations.
- Hidden technical fields should remain available for lineage and testing.
- No page should rely on colour alone to communicate status.
- Multiple-Trust selection should not produce a misleading single latest OPEL value.
- Cross-filtering should be disabled where it would create ambiguous interpretation.
- All pages should display active filter context.

---

## Drill-Through Map

| Source page | Source visual | Destination | Context passed |
|---|---|---|---|
| Executive Overview | Pressure matrix | Trust-Day Investigation | Trust and date |
| Executive Overview | Trust comparison | Trust-Day Investigation | Trust |
| Beds and Patient Flow | High-pressure table | Trust-Day Investigation | Trust and date |
| Beds and Patient Flow | Occupancy trend point | Trust-Day Investigation | Trust and date |
| A&E and Ambulance | High-breach table | Trust-Day Investigation | Trust and date |
| A&E and Ambulance | Heat-map cell | Trust-Day Investigation | Trust and date |
| Workforce Pressure | High-pressure table | Trust-Day Investigation | Trust and date |
| Incidents and OPEL | Override date | Trust-Day Investigation | Trust and date |

Where only a Trust is passed, the user must select one date before detailed Trust-day values are shown.

---

## Default Report State

The default report state should use:

- all fictional Trusts selected;
- full reporting period selected;
- all approved OPEL levels selected;
- all operational-pressure statuses selected;
- no weather-warning restriction;
- no human-override restriction.

The Executive Overview should be the default analytical landing page after the Home page.

Reset-filter buttons should return the page to this documented state.

---

## Visual Design Standards

### Page Layout

Use:

- consistent page dimensions;
- consistent header height;
- consistent navigation placement;
- aligned cards and visuals;
- sufficient whitespace;
- clear visual hierarchy.

### Chart Selection

| Requirement | Recommended visual |
|---|---|
| Current KPI value | Card |
| Trend over time | Line chart |
| Trust comparison | Horizontal bar chart |
| Distribution | Stacked bar or column chart |
| Detailed investigation | Table or matrix |
| Trust-date pressure | Heat map |
| KPI explanation | Definition panel or tooltip |
| Expected versus actual | Cards or bar chart |
| OPEL over time | Step or line chart |

### Number Formatting

Use:

- whole numbers for counts;
- percentages with two decimal places;
- FTE values with two decimal places;
- temperature with one decimal place and `°C`;
- dates formatted consistently;
- clear units in titles or card subtitles.

### Visual Density

Avoid:

- excessive KPI cards;
- unnecessary pie charts;
- decorative gauges;
- duplicated visuals;
- overcrowded slicers;
- long paragraphs on analytical pages.

---

## Accessibility Standards

The dashboard should use:

- readable font sizes;
- clear contrast;
- concise chart titles;
- descriptive button labels;
- meaningful alt text;
- logical tab order;
- consistent number formats;
- visible filter context;
- text labels alongside status colours;
- limited visual density;
- explanatory tooltips;
- non-colour indicators such as labels, icons or patterns;
- plain language where possible.

Keyboard navigation and screen-reader support should be considered during implementation.

---

## Governance Requirements Across Pages

Every page must preserve the following principles:

- all data is synthetic;
- the dashboard is not a real NHS operational system;
- no chart should imply clinical authority;
- recommended and approved OPEL levels remain separate;
- human overrides remain visible;
- confidence values must not be described as certainty;
- synthetic associations must not be described as causal findings;
- blocked KPIs must remain visibly blocked;
- no official NHS thresholds will be invented;
- limitations should be accessible from every page.

---

## Source-Enrichment Dependencies

The following dashboard elements depend on future source enrichment:

| Required field or measure | Current status | Affected page |
|---|---|---|
| `four_hour_breaches` | Missing from current CSV | Executive Overview; A&E and Ambulance |
| `ambulance_arrivals` | Missing from current CSV | Executive Overview; A&E and Ambulance |
| `ambulance_handover_delays` | Missing from current CSV | Executive Overview; A&E and Ambulance |
| `recommended_opel_level` | Missing from current CSV | Incidents and OPEL |
| Incident count | Missing from current CSV | Incidents and OPEL |
| Incident severity | Missing from current CSV | Incidents and OPEL |
| Incident status | Missing from current CSV | Incidents and OPEL |
| Detailed lineage fields | Limited in current CSV | Data Quality and Lineage |
| Raw bed numerators and denominators | Missing from current CSV | Beds and Patient Flow |
| Raw workforce absence numerator and denominator | Missing from current CSV | Workforce Pressure |

These dependencies must be resolved before the final dashboard is approved.

---

## Wireframe Quality Review

- [x] All nine pages have a defined purpose.
- [x] Every page identifies its primary users.
- [x] Every page answers specific operational questions.
- [x] Each KPI card maps to the KPI dictionary.
- [x] Filters are documented.
- [x] Drill-through paths are documented.
- [x] Source-blocked KPIs are labelled.
- [x] Human accountability remains visible.
- [x] Synthetic-data warnings are included.
- [x] No official thresholds are implied.
- [x] Accessibility requirements are documented.
- [x] The report supports both executive overview and detailed investigation.
- [x] Patient-day and average daily FTE interpretations are preserved.
- [x] Daily percentages are not mislabelled as weighted period rates.
- [x] The source-enrichment dependencies are documented.

---

The dashboard specification is ready to support semantic-model design and Power BI implementation.
- text-based wireframes suitable for Week 15 development.

The dashboard specification is ready to support semantic-model design and Power BI implementation.
