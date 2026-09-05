# Week 16 Day 6 — Data Quality & Lineage Dashboard

## Objective

Day 6 implemented the Data Quality & Lineage page of the Power BI operational intelligence dashboard.

The page provides assurance that dashboard outputs are complete, reconciled and traceable back to the governed analytical source.

The project uses synthetic operational data only.

---

## Data Quality KPI Layer

The page includes:

- Fact Trust-Day Rows
- Duplicate Trust-Date Rows
- Reporting Completeness
- Net Admissions Reconciliation Variance
- Override Reconciliation Variance

Validated full-period results:

- Fact Trust-Day Rows = 90
- Duplicate Trust-Date Rows = 0
- Reporting Completeness = 100%
- Net Admissions Reconciliation Variance = 0
- Override Reconciliation Variance = 0

---

## Reporting Coverage

The model contains:

- 3 Trusts
- 30 reporting dates
- 90 Trust-day fact rows

Validated Trust coverage:

- WGH001 = 30 rows
- NRT002 = 30 rows
- SCT003 = 30 rows

Each reporting date contains one row per Trust.

The Daily Reporting Coverage visual therefore shows three Trust-day rows per date when all Trusts are selected.

---

## Patient Flow Reconciliation

Validated full-period values:

- Total Admissions = 16,425
- Total Discharges = 15,654
- Stored Net Admissions = 771
- Calculated Net Admissions = 771
- Net Admissions Variance = 0

The reconciliation verifies:

`Net Admissions = Admissions - Discharges`

---

## OPEL Governance Reconciliation

Validated full-period values:

- Human Override Count = 4
- Recommendation/Approval Mismatch Count = 4
- Override Reconciliation Variance = 0

This supports the project's human-in-the-loop governance logic.

---

## Additional QA Controls

Where available, additional controls include:

- A&E Breach Rate QA
- Workforce Absence Difference

These are expected to return zero when the governed weighted measures reconcile correctly.

---

## Source Lineage

The lineage layer exposes available fields such as:

- Trust code
- reporting date
- operational source system
- source record ID
- load batch ID
- data quality status

These fields support technical traceability from dashboard output back to the analytical source.

Technical lineage fields are intentionally kept off executive dashboard pages.

---

## Power BI Source

The validated Power BI source is:

`operational.vw_trust_daily_analytical`

from the PostgreSQL development database:

`nhs_operations_test`

---

## Semantic Model Governance

The validated architecture is:

`PostgreSQL → Analytical View → Power Query → Star Schema → Governed DAX Measures → Power BI Dashboard`

Loaded model tables:

- FactTrustDailyOperations
- DimDate
- DimTrust
- DimOPEL
- DimPressureStatus
- DimWeatherWarning
- _Measures

The model uses one-to-many, single-direction relationships from dimensions to the fact table.

The `_Measures` table is deliberately disconnected.

The source/staging query and QA queries remain load-disabled.

Business KPIs are implemented as explicit DAX measures rather than relying on implicit aggregation of percentage fields.

Recommended and Approved OPEL remain separate to preserve human oversight, traceability and override analysis.

---

## Filter QA

The page was tested using:

- Trust filtering
- Date-range filtering
- combined Trust and Date filtering

Known filter-context checks:

- one Trust = 30 rows
- ten days across all Trusts = 30 rows
- one Trust across ten days = 10 rows

Reconciliation controls remained valid under filter context.

---

## Design Decision

The page was intentionally kept focused on assurance and traceability.

Detailed architecture and governance explanations are provided through report-page tooltips where appropriate to avoid overcrowding the dashboard canvas.

---

## Day 6 Status

Completed:

- Data Quality & Lineage page
- QA KPI layer
- reporting coverage analysis
- patient-flow reconciliation
- override reconciliation
- source-lineage detail
- lineage tooltip
- semantic-model governance verification
- filter QA
- final visual polish

Next:

**Week 16 Day 7 — KPI Definitions, Limitations and Final UAT**
