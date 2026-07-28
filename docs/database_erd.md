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
        integer ae_attendances
        integer four_hour_breaches
        varchar source_system
        varchar data_quality_status
    }

    WORKFORCE_METRICS {
        bigint workforce_metric_id PK
        bigint trust_id FK
        date reporting_date
        varchar staff_group
        numeric establishment_fte
        numeric substantive_fte
        numeric absence_fte
        integer unfilled_shifts
        varchar source_system
        varchar data_quality_status
    }

    INCIDENTS {
        bigint incident_id PK
        bigint trust_id FK
        varchar incident_reference
        varchar incident_type
        varchar severity_level
        varchar incident_status
        timestamptz incident_started_at
        timestamptz incident_resolved_at
        varchar source_system
        varchar data_quality_status
    }

    WEATHER_METRICS {
        bigint weather_metric_id PK
        bigint trust_id FK
        date reporting_date
        varchar observation_type
        numeric temperature_min_c
        numeric temperature_max_c
        numeric precipitation_mm
        varchar weather_warning_level
        varchar source_system
        varchar data_quality_status
    }

    OPEL_ASSESSMENTS {
        bigint opel_assessment_id PK
        bigint trust_id FK
        timestamptz assessment_timestamp
        smallint recommended_opel_level
        smallint approved_opel_level
        varchar assessment_method
        varchar approval_status
        varchar rule_version
        varchar source_system
        varchar data_quality_status
    }
