# NHS Operational Intelligence — Power BI

## Overview

This folder documents the Power BI implementation for the **NHS Operational Data Platform** portfolio project.

The Power BI solution converts a validated PostgreSQL analytical source into a governed semantic model and a complete management-facing operational intelligence dashboard.

The implementation demonstrates:

- PostgreSQL source integration
- Power Query staging
- dimensional modelling
- Trust-date fact design
- controlled dimension tables
- one-to-many star-schema relationships
- explicit DAX measure development
- weighted KPI calculation
- human-in-the-loop OPEL governance
- source lineage
- reconciliation controls
- filter-context testing
- report-page tooltips
- accessibility review
- formal UAT
- management dashboard implementation
- detailed operational drill-down

The project uses **synthetic data only** and must not be used for real NHS clinical or operational decision-making.

---

## Power BI Report File

The final Power BI Desktop report is:

`NHS_Operational_Intelligence.pbix`

This file contains the complete eight-page operational intelligence dashboard and governed semantic model described in this folder.
.......

# Current Implementation Status

**Power BI semantic model and dashboard implementation complete — final dashboard UAT passed.**

Completed:

- PostgreSQL source integration
- analytical-source validation
- Power Query staging
- dimension layer
- fact table
- star-schema relationships
- explicit DAX measure layer
- weighted KPI logic
- data-quality measures
- PostgreSQL reconciliation
- filter-context testing
- governance validation
- semantic-model UAT
- dashboard page implementation
- navigation
- Trust and Date filtering
- report-page governance tooltips
- accessibility review
- visual consistency review
- final dashboard UAT

---

# Data Source

Power BI connects to the PostgreSQL development database:

`nhs_operations_test`

Schema:

`operational`

Validated analytical view:

`operational.vw_trust_daily_analytical`

The validated analytical source contains:

- 90 Trust-date rows
- 3 fictional Trusts
- 30 reporting dates
- reporting period from 2026-01-01 to 2026-01-30
- no duplicate Trust-date records

The Power Query staging query is:

`SourceTrustDailyAnalytical`

This query is retained as the controlled source layer and is **not loaded directly into the report model**.

---

# Semantic Model Architecture

The implemented semantic model follows a star-schema design.

Central fact table:

`FactTrustDailyOperations`

Dimensions:

- `DimDate`
- `DimTrust`
- `DimOPEL`
- `DimPressureStatus`
- `DimWeatherWarning`

Dedicated measure table:

`_Measures`

Conceptual architecture:

```text
                   DimDate
                      |
                      |
DimTrust ---- FactTrustDailyOperations ---- DimOPEL
                      |
                      |
             DimPressureStatus
                      |
                      |
              DimWeatherWarning

                  _Measures
