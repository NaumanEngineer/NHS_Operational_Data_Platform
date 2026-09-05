# Week 16 Day 5 — Trust-Day Investigation

## Objective

Day 5 implemented a detailed Trust-Day Investigation page for operational drill-down and governance review.

The page complements the executive dashboards by providing detailed contextual evidence for individual Trust-date records.

The dashboard uses synthetic operational data only.

---

## Investigation Scope

The page supports investigation by:

- Trust
- reporting date
- approved OPEL
- operational pressure status
- weather warning context

---

## Trust-Day Investigation Table

The detailed table includes available fields such as:

- Trust code
- reporting date
- recommended OPEL
- approved OPEL
- previous approved OPEL
- human override indicator
- prediction confidence
- available governance fields

Only fields actually present in the semantic model were used.

No missing governance fields were invented.

---

## Human-in-the-Loop Analysis

The page includes:

- Recommended vs Approved OPEL comparison
- Human Override Cases
- Human Overrides by Trust
- Recommendation Agreement by Trust

Validated full-period results:

- Human Overrides = 4
- Recommendation/Approval Mismatches = 4
- Override Reconciliation Variance = 0

Override distribution:

- WGH001 = 2
- NRT002 = 1
- SCT003 = 1

---

## Operational Pressure Analysis

Operational Pressure Status is project-defined as:

- Routine pressure
- Moderate pressure
- Significant pressure
- Critical pressure

Validated full-period distribution:

- Routine = 21
- Moderate = 30
- Significant = 32
- Critical = 7

High-pressure Trust-Days combine:

- Significant pressure
- Critical pressure

Therefore:

`32 + 7 = 39`

This reconciles with the High Operational-Pressure measure.

---

## Weather Context

Weather-warning information is included as operational context only.

Validated full-period distribution:

- No warning = 70
- yellow - ice = 12
- yellow - wind = 6
- amber - snow and ice = 2

Total:

`70 + 12 + 6 + 2 = 90 Trust-Days`

The synthetic dataset does not establish that weather caused operational pressure or elevated OPEL.

---

## Governance Traceability

The investigation page preserves separation between:

- system recommendation
- human-approved operational outcome

Available governance fields were reviewed for traceability.

Previous Approved OPEL blanks on first-period Trust records were preserved as structural nulls rather than replaced with zero.

---

## Filter QA

The page was tested using:

- Trust filter
- Date filter
- Approved OPEL filter
- Pressure Status filter
- Weather Warning filter
- combined filtering

All core visuals and tables recalculated under filter context.

---

## Day 5 Status

Completed:

- Trust-Day Investigation page
- recommended vs approved drill-down
- human override analysis
- governance traceability review
- operational pressure analysis
- weather-warning context
- combined filter QA
- final page polish

Next:

**Week 16 Day 6 — Data Quality & Lineage**
