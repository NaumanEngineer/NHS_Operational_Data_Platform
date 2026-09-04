# Week 16 Day 4 — OPEL & Governance Dashboard

## Objective

Day 4 implemented the OPEL & Governance page of the Power BI operational intelligence dashboard.

The page demonstrates operational escalation, Trust-level pressure and human-in-the-loop governance.

The dashboard uses synthetic operational data only.

---

## Headline Governance KPIs

The page includes:

- OPEL 3–4 Trust-Days
- OPEL 4 Trust-Days
- High-Pressure Trust-Days
- Human Override Count
- Human Override Rate
- Recommendation Agreement Percentage

Validated full-period values:

- OPEL 3–4 Trust-Days = 39
- OPEL 4 Trust-Days = 7
- High-Pressure Trust-Days = 39
- Human Overrides = 4
- Human Override Rate ≈ 4.4%
- Recommendation Agreement ≈ 95.6%

---

## Approved OPEL Analysis

Implemented visuals include:

- Approved OPEL Distribution
- OPEL 3–4 Trust-Days by Trust
- OPEL 4 Trust-Days by Trust or combined elevated-OPEL comparison
- Approved OPEL trend

Approved OPEL is treated as the governed operational outcome.

Recommended OPEL is retained separately as decision-support output.

---

## Human-in-the-Loop Governance

Recommended and approved OPEL values are deliberately retained separately.

A human override is recorded when:

`recommended_opel_level <> approved_opel_level`

Validated full-period results:

- Human Override Count = 4
- Recommendation/Approval Mismatch Count = 4
- Override Reconciliation Variance = 0

This preserves:

- human accountability
- auditability
- decision traceability
- model-versus-human comparison

---

## Override Analysis

The dashboard includes:

- Human Overrides by Trust
- Human Override Cases
- governance tooltip explaining override semantics

Validated override distribution:

- WGH001 = 2
- NRT002 = 1
- SCT003 = 1

---

## Pressure Interpretation

High Operational Pressure is defined in this project as:

- Significant pressure
- Critical pressure

The combined full-period count is:

`32 + 7 = 39 Trust-Days`

This reconciles with the High-Pressure Trust-Days measure.

The pressure classification is project-defined and is not presented as an official NHS operational threshold framework.

---

## Weather Context

Weather-warning data is available in the semantic model but is treated as contextual information only.

The synthetic dataset does not support a causal claim that weather warnings caused elevated OPEL or operational pressure.

Detailed weather and pressure investigation is reserved for the Trust-Day Investigation page.

---

## Filters and QA

The page was tested using:

- Trust filtering
- Date-range filtering
- combined Trust and Date filtering

Governance KPIs and analytical visuals recalculated correctly under filter context.

---

## Design Decision

The OPEL & Governance page was intentionally kept concise.

Detailed governance, weather and Trust-day investigation fields were not forced onto the executive page because this would reduce readability.

Those detailed records are reserved for:

`Trust-Day Investigation`

This preserves a clear separation between executive monitoring and detailed operational investigation.

---

## Day 4 Status

Completed:

- OPEL & Governance page
- OPEL KPI layer
- approved OPEL distribution
- Trust-level escalation analysis
- human override analysis
- recommendation-versus-approval governance
- override tooltip
- filter QA
- final visual polish

Next:

**Week 16 Day 5 — Trust-Day Investigation dashboard**
