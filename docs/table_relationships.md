# Table Relationships

## Overview

The NHS Operational Data Platform uses `operational.trusts` as the central parent table.

Each related operational table stores `trust_id` as a foreign key. This creates a one-to-many relationship between one NHS Trust and multiple operational records.

## Parent Table

### `operational.trusts`

The `trusts` table stores one reference record for each NHS Trust.

Its primary key is:

```text
trust_id

operational.trusts.trust_id
    →
operational.daily_operational_metrics.trust_id

operational.trusts.trust_id
    →
operational.workforce_metrics.trust_id

operational.trusts.trust_id
    →
operational.incidents.trust_id

operational.trusts.trust_id
    →
operational.weather_metrics.trust_id

operational.trusts.trust_id
    →
operational.opel_assessments.trust_id


Relationship Summary:

trusts
  ├── daily_operational_metrics
  ├── workforce_metrics
  ├── incidents
  ├── weather_metrics
  └── opel_assessment
