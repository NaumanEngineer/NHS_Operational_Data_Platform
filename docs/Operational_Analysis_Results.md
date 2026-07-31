# Operational Analysis Results

## Scope

This document records the outputs from the Day 5 PostgreSQL operational-analysis queries.

All organisations and operational values are fictional. These results describe patterns within the synthetic dataset only and must not be interpreted as evidence of real NHS performance.

## Reporting Period

`2026-01-01 to 2026-01-30`

## 1. Average General-Bed Occupancy

| Trust | Average occupancy | Reporting days |
|---|---:|---:|
| South County Community Trust | 92.45% | 30 |
| North Riverside NHS Trust | 92.07% | 30 |
| Westborough General Hospital | 91.47% | 30 |

South County Community Trust recorded the highest average general-bed occupancy, although the difference between the three organisations was small.

## 2. Highest A&E Four-Hour Breach Rate

The highest observed Trust-day was:

| Trust | Date | A&E attendances | Four-hour breaches | Breach rate |
|---|---|---:|---:|---:|
| South County Community Trust | 2026-01-27 | 192 | 60 | 31.25% |

Most of the highest breach-rate dates occurred during the later part of January.

## 3. Approved OPEL 3 or 4 Frequency

| Trust | OPEL 3 or 4 days | OPEL 3 days | OPEL 4 days | Assessed days | Percentage |
|---|---:|---:|---:|---:|---:|
| North Riverside NHS Trust | 17 | 17 | 0 | 30 | 56.67% |
| Westborough General Hospital | 15 | 8 | 7 | 30 | 50.00% |
| South County Community Trust | 7 | 7 | 0 | 30 | 23.33% |

Westborough General Hospital was the only organisation with approved OPEL 4 days.

## 4. Workforce Pressure on OPEL 4 Days

| Measure | Non-OPEL 4 days | OPEL 4 days |
|---|---:|---:|
| Average workforce absence | 6.21% | 8.68% |
| Average agency FTE | 33.28 | 82.60 |
| Average bank FTE | 16.25 | 29.50 |
| Average unfilled shifts | 12.41 | 29.29 |

All four workforce-pressure measures were higher on OPEL 4 days within the synthetic dataset.

## 5. Synthetic Red-Flag Incidents

For this project, a red-flag incident is defined as:

`severity_level IN ('high', 'critical')`

| Trust | Red-flag incidents | Critical incidents | Unresolved incidents | Total incidents |
|---|---:|---:|---:|---:|
| North Riverside NHS Trust | 4 | 2 | 2 | 8 |
| South County Community Trust | 4 | 2 | 2 | 6 |
| Westborough General Hospital | 4 | 2 | 3 | 10 |

All three organisations recorded the same number of red-flag incidents. Westborough recorded the highest total number of incidents and the highest unresolved count.

## 6. Ambulance Handover Pressure by Approved OPEL Level

| Approved OPEL level | Trust-days | Weighted delay percentage | Average daily delay percentage |
|---:|---:|---:|---:|
| 1 | 21 | 12.46% | 15.22% |
| 2 | 30 | 32.70% | 43.52% |
| 3 | 32 | 42.58% | 52.89% |
| 4 | 7 | 38.44% | 38.48% |

The highest weighted ambulance handover-delay percentage occurred on OPEL 3 days rather than OPEL 4 days.

## 7. Temperature and Operational Pressure

| Minimum temperature band | Trust-days | Average occupancy | Average breach rate | Average ambulance delay | Average approved OPEL |
|---|---:|---:|---:|---:|---:|
| Below 0°C | 21 | 88.60% | 13.33% | 18.72% | 1.76 |
| 0°C to below 3°C | 40 | 91.77% | 18.05% | 34.75% | 2.15 |
| 3°C and above | 29 | 94.77% | 24.49% | 62.22% | 2.83 |

The synthetic dataset showed greater operational pressure in the warmer temperature band. It therefore does not support a simple conclusion that colder days were associated with greater pressure.

## Analytical Limitations

- The dataset is synthetic and deliberately constructed.
- The reporting period covers only 30 days.
- The three fictional organisations are not directly comparable to real NHS organisations.
- The ambulance measure is a percentage of arrivals with delay, not average delay duration.
- The red-flag definition is project-specific and not an official NHS classification.
- Associations do not establish causation.
