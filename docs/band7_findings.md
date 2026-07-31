# Band 7 Operational Findings

## Scope

These findings were produced from the NHS Operational Data Platform synthetic dataset covering three fictional healthcare organisations between 1 January and 30 January 2026.

The findings describe observed patterns within the simulated dataset only. They must not be interpreted as evidence of real NHS performance or used to support operational decisions without validation against appropriately governed real-world data.

---

## Finding 1 — Average bed occupancy was consistently high across all three organisations

### Observation

South County Community Trust recorded the highest average general-bed occupancy at 92.45%, followed by North Riverside NHS Trust at 92.07% and Westborough General Hospital at 91.47%.

### Interpretation

All three organisations operated at a consistently high synthetic occupancy level during the reporting period. The difference between the highest and lowest Trust was less than one percentage point, indicating a narrow variation rather than a substantial performance gap.

### Possible explanation

The pattern may reflect the common winter-pressure assumptions deliberately built into the synthetic dataset, including rising demand and increasing occupancy later in January.

### Decision implication

An operational team would likely monitor occupancy alongside discharge readiness, admissions, discharges and workforce availability rather than treating occupancy as an isolated measure.

### Limitation

The values are synthetic, the reporting period covers only 30 days, and the fictional organisations differ in size and service type. The results cannot be used to benchmark real NHS Trusts.

### Recommended next step

Create a daily occupancy trend by Trust and investigate dates where occupancy exceeded locally agreed escalation thresholds.

---

## Finding 2 — The highest A&E breach rates occurred during the later part of January

### Observation

The highest synthetic A&E four-hour breach rate was 31.25% at South County Community Trust on 27 January 2026, with 60 breaches from 192 attendances.

Several of the ten highest breach-rate days occurred between 23 and 30 January.

### Interpretation

The dataset shows a concentration of higher breach rates during the later reporting period, coinciding with the deliberately constructed increase in operational pressure.

### Possible explanation

Possible contributing factors within the simulated dataset include higher A&E demand, increasing bed occupancy, ambulance pressure, discharge constraints and workforce gaps.

### Decision implication

An operational team might review whether late-month escalation was visible early enough through leading indicators such as occupancy, unfilled shifts, delayed handovers and patients ready for discharge.

### Limitation

The pattern was intentionally generated within the seed data. It does not demonstrate that any single pressure measure caused the higher breach rate.

### Recommended next step

Develop a daily pressure dashboard showing A&E breach rate alongside occupancy, workforce absence, unfilled shifts, ambulance delays and approved OPEL level.

---

## Finding 3 — OPEL escalation frequency varied substantially between the fictional organisations

### Observation

North Riverside NHS Trust recorded approved OPEL 3 or 4 on 17 of 30 days, representing 56.67% of assessed days.

Westborough General Hospital recorded OPEL 3 or 4 on 15 days, including all seven OPEL 4 days in the dataset.

South County Community Trust recorded OPEL 3 on seven days and no OPEL 4 days.

### Interpretation

The synthetic organisations experienced different escalation profiles. North Riverside spent the greatest proportion of days at OPEL 3 or above, while Westborough was the only organisation to reach OPEL 4.

### Possible explanation

The variation may reflect the project’s rules-based synthetic OPEL logic, Trust-specific activity profiles and deliberate human-review overrides.

### Decision implication

A senior analyst would distinguish between escalation frequency and escalation severity. Frequent OPEL 3 days and a smaller number of OPEL 4 days may require different operational responses.

### Limitation

The OPEL recommendations and approvals are fictional and generated from simplified rules. They are not based on official real-world escalation decisions.

### Recommended next step

Create a Trust-level escalation timeline and compare recommended OPEL levels with approved levels to identify override patterns and review consistency.

---

## Finding 4 — Workforce pressure indicators were higher on OPEL 4 days

### Observation

On OPEL 4 days, average workforce absence was 8.68%, compared with 6.21% on non-OPEL 4 days.

Average agency FTE increased from 33.28 to 82.60, average bank FTE increased from 16.25 to 29.50, and average unfilled shifts increased from 12.41 to 29.29.

### Interpretation

Within the synthetic dataset, OPEL 4 days were associated with higher workforce pressure across every measured workforce indicator.

### Possible explanation

The pattern may reflect the deliberately constructed pressure logic in which workforce absence, temporary staffing and unfilled shifts increase during later high-pressure periods.

### Decision implication

An operational manager might use workforce indicators as part of an early-warning pack and investigate whether staffing pressures are emerging before escalation decisions are made.

### Limitation

The comparison includes only seven OPEL 4 Trust-days and does not establish that workforce shortages caused OPEL 4 escalation.

### Recommended next step

Compare workforce measures across all four OPEL levels and calculate confidence intervals or distribution summaries when a larger dataset becomes available.

---

## Finding 5 — Ambulance handover pressure increased across OPEL 1 to OPEL 3 but was lower at OPEL 4

### Observation

The weighted ambulance handover-delay percentage increased from 12.46% at OPEL 1 to 32.70% at OPEL 2 and 42.58% at OPEL 3.

The weighted result at OPEL 4 was lower at 38.44%.

### Interpretation

The synthetic data shows a general increase in handover pressure across OPEL 1 to OPEL 3, but not a perfectly increasing relationship across all four levels.

### Possible explanation

The lower OPEL 4 result may reflect the small number of OPEL 4 days, differences in Trust activity volumes, or the simplified construction of the synthetic dataset.

### Decision implication

Operational reporting should avoid assuming that every pressure indicator rises uniformly with each OPEL level. Individual components should be reviewed alongside the overall escalation decision.

### Limitation

The measure represents the percentage of ambulance arrivals recorded as delayed. It does not represent average delay duration in minutes.

### Recommended next step

Add actual handover-delay duration measures in a future schema version and compare weighted percentages, average duration and long-delay thresholds.

---

## Additional Observation — Lower temperature did not coincide with greater pressure

### Observation

The highest average occupancy, A&E breach rate, ambulance delay percentage and approved OPEL level occurred in the `3°C and above` temperature band.

### Interpretation

The synthetic dataset does not support the proposition that colder days coincided with greater operational pressure.

### Possible explanation

The result reflects the independently constructed date-based pressure patterns in the synthetic seed data rather than a validated weather effect.

### Decision implication

Weather should not be used as a standalone explanation for operational pressure. It should be assessed alongside demand, capacity, workforce and flow indicators.

### Limitation

The dataset covers only 30 synthetic winter days and does not model lagged weather effects, population vulnerability or real meteorological geography.

### Recommended next step

In future analysis, test same-day and lagged weather associations across a longer period and clearly separate correlation from causation.
