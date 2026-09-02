# NHS Operational Intelligence — Power BI

## Overview

This folder documents the Power BI implementation for the NHS Operational Data Platform portfolio project.

The Power BI solution converts a validated PostgreSQL analytical source into a governed semantic model designed for operational intelligence reporting.

The current implementation includes:

- PostgreSQL source connection;
- Power Query staging;
- controlled dimension tables;
- Trust-date fact table;
- star-schema relationships;
- explicit DAX measure layer;
- weighted KPI calculations;
- governance and lineage fields;
- PostgreSQL reconciliation;
- filter-context testing;
- formal UAT.

The project uses synthetic data only and must not be used for real NHS clinical or operational decision-making.

---

# Current Implementation Status

Current status:

**Semantic model implemented and validated — final dashboard visual implementation pending.**

Completed:

- PostgreSQL source integration
- source validation
- dimension layer
- fact table
- star-schema relationships
- explicit DAX measures
- weighted KPI logic
- data-quality measures
- PostgreSQL reconciliation
- filter-context testing
- governance validation
- formal UAT

Remaining:

- final dashboard page implementation
- drill-through
- navigation
- accessibility testing
- final visual UAT

---

# Data Source

Power BI currently connects to:

`nhs_operations_test`

PostgreSQL schema:

`operational`

Analytical view:

`operational.vw_trust_daily_analytical`

The validated analytical source contains:

- 90 Trust-date rows;
- 3 fictional Trusts;
- 30 reporting dates;
- reporting period 2026-01-01 to 2026-01-30;
- no duplicate Trust-date records.

The Power Query staging query is:

`SourceTrustDailyAnalytical`

This query is retained as the controlled source layer and is not loaded directly into the report model.

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

Conceptual model:

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
