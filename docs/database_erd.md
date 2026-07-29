# NHS Operational Data Platform — Entity Relationship Diagram

```mermaid
erDiagram
    TRUSTS ||--o{ DAILY_OPERATIONAL_METRICS : has
    TRUSTS ||--o{ WORKFORCE_METRICS : has
    TRUSTS ||--o{ INCIDENTS : has
    TRUSTS ||--o{ WEATHER_METRICS : has
    TRUSTS ||--o{ OPEL_ASSESSMENTS : has

    TRUSTS {
        bigint trust_id PK
        varchar trust_code UK
        varchar trust_name
        varchar trust_type
        varchar region
        boolean active_flag
        varchar source_system
        varchar source_record_id
        uuid load_batch_id
        varchar data_quality_status
        timestamptz record_created_at
        timestamptz record_updated_at
    }

    DAILY_OPERATIONAL_METRICS {
        bigint operational_metric_id PK
        bigint trust_id FK
        date reporting_date
        integer general_beds_open
        integer general_beds_occupied
        integer critical_care_beds_open
        integer critical_care_beds_occupied
        integer ae_attendances
        integer four_hour_breaches
        integer ambulance_arrivals
        integer ambulance_handover_delays
        integer patients_ready_for_discharge
        integer admissions
        integer discharges
        varchar source_system
        varchar source_record_id
        uuid load_batch_id
        varchar data_quality_status
        timestamptz record_created_at
        timestamptz record_updated_at
    }

    WORKFORCE_METRICS {
        bigint workforce_metric_id PK
        bigint trust_id FK
        date reporting_date
        varchar staff_group
        numeric establishment_fte
        numeric substantive_fte
        numeric absence_fte
        numeric agency_fte
        numeric bank_fte
        integer unfilled_shifts
        varchar source_system
        varchar source_record_id
        uuid load_batch_id
        varchar data_quality_status
        timestamptz record_created_at
        timestamptz record_updated_at
    }

    INCIDENTS {
        bigint incident_id PK
        bigint trust_id FK
        varchar incident_reference
        varchar incident_type
        varchar severity_level
        varchar incident_status
        timestamptz incident_started_at
        timestamptz incident_reported_at
        timestamptz incident_resolved_at
        varchar service_area
        text operational_impact
        varchar source_system
        varchar source_record_id
        uuid load_batch_id
        varchar data_quality_status
        timestamptz record_created_at
        timestamptz record_updated_at
    }

    WEATHER_METRICS {
        bigint weather_metric_id PK
        bigint trust_id FK
        date reporting_date
        varchar observation_type
        timestamptz forecast_generated_at
        numeric temperature_min_c
        numeric temperature_max_c
        numeric precipitation_mm
        numeric snowfall_mm
        numeric wind_speed_mph
        varchar weather_warning_level
        varchar weather_warning_type
        varchar source_system
        varchar source_record_id
        uuid load_batch_id
        varchar data_quality_status
        timestamptz record_created_at
        timestamptz record_updated_at
    }

        OPEL_ASSESSMENTS {
        bigint opel_assessment_id PK
        bigint trust_id FK
        timestamptz assessment_timestamp
        smallint recommended_opel_level
        smallint approved_opel_level
        smallint previous_approved_opel_level
        numeric prediction_confidence
        varchar assessment_method
        text assessment_rationale
        text key_pressure_factors
        varchar approval_status
        varchar assessed_by_role
        varchar reviewed_by_role
        timestamptz reviewed_at
        varchar rule_version
        varchar source_system
        varchar source_record_id
        uuid load_batch_id
        varchar data_quality_status
        timestamptz record_created_at
        timestamptz record_updated_at
    }
```

## Relationship Notes

- `operational.trusts` is the parent reference table.
- Each operational table contains `trust_id` as a foreign key.
- One Trust can have many operational, workforce, incident, weather, and OPEL records.
- The direct Trust-to-weather relationship is a temporary prototype simplification.
- A future design should link weather through sites or geographical areas.
- OPEL recommendations and approved operational decisions are stored separately to preserve governance and auditability.
