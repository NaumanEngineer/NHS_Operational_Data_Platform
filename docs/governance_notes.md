# NHS Operational Data Platform — Governance Notes

## Purpose

This document defines the permitted use, prohibited use, governance controls, accountability principles, and future assurance requirements for the NHS Operational Data Platform portfolio project.

The platform currently uses synthetic organisations and synthetic operational values only.

---

## 1. Intended Use

The current platform is intended for:

- learning PostgreSQL and relational data modelling;
- testing schema constraints and data-quality logic;
- demonstrating NHS-style operational analytics;
- producing portfolio evidence for data, BI, engineering and healthcare AI roles;
- testing Power BI, Python, API and future AI workflows;
- exploring how operational, workforce, incident, weather and OPEL data may be integrated.

The platform may also be used to demonstrate:

- reproducible data loading;
- analytical SQL;
- data lineage;
- human-reviewed decision fields;
- management reporting concepts;
- feature preparation for future modelling.

---

## 2. Prohibited Use

The platform must not be used to:

- make real operational decisions;
- make clinical decisions;
- assess the performance of a real NHS organisation;
- compare or rank real Trusts;
- identify patients or members of staff;
- allocate clinical resources;
- determine patient priority;
- replace professional judgement;
- validate a real OPEL escalation decision;
- train or deploy a production predictive model without further governance;
- present synthetic findings as real NHS evidence.

No result from this portfolio project should be used as the sole basis for action.

---

## 3. Synthetic-Data Disclaimer

All organisation names, codes, operational values, incidents, weather records, workforce measures and OPEL assessments are fictional.

The synthetic dataset was created for:

- learning;
- technical testing;
- portfolio demonstration;
- reproducibility exercises.

The dataset does not represent:

- real NHS activity;
- real Trust performance;
- real staffing conditions;
- real incidents;
- real weather observations;
- real escalation decisions;
- validated model outputs.

Any similarity to a real organisation or event is unintended.

---

## 4. Data Minimisation

The platform currently contains only aggregated operational information.

It intentionally excludes:

- patient names;
- NHS numbers;
- dates of birth;
- addresses;
- diagnoses;
- treatment information;
- clinical notes;
- staff names;
- payroll identifiers;
- staff contact details;
- patient-level activity;
- free text copied from real operational systems.

Only fields necessary to demonstrate operational analytics are included.

In a future real-world implementation, every field should be justified against a defined business purpose and removed if it is not necessary.

---

## 5. Access Control

The current GitHub repository contains synthetic data only and may be shared publicly for portfolio purposes.

A future implementation using real operational data would require:

- authenticated access;
- role-based permissions;
- least-privilege access;
- separation between development, testing and production;
- restricted access to raw source data;
- controlled access to exports;
- logging of access and administrative actions;
- periodic access reviews;
- secure credential management.

Database passwords, connection strings, tokens and secrets must never be committed to GitHub.

---

## 6. Auditability and Data Lineage

The schema includes fields that support traceability:

- `source_system`
- `source_record_id`
- `load_batch_id`
- `data_quality_status`
- `record_created_at`
- `record_updated_at`
- `rule_version`
- `assessment_timestamp`
- `reviewed_at`
- `assessed_by_role`
- `reviewed_by_role`

These fields help answer:

- where a record came from;
- when it was loaded;
- which batch created it;
- whether it passed quality checks;
- which rule version produced an assessment;
- whether a human review occurred;
- when a decision was reviewed.

In a production system, lineage should extend from source extraction through transformation, reporting, modelling and downstream API use.

---

## 7. Data-Quality Assurance

The project includes SQL checks for:

- expected record counts;
- duplicate records;
- missing required values;
- impossible capacity values;
- A&E breaches exceeding attendances;
- ambulance delays exceeding arrivals;
- negative workforce values;
- orphan Trust relationships;
- inconsistent incident timestamps;
- invalid weather values;
- invalid OPEL levels;
- incomplete review information;
- missing reporting dates;
- one-row-per-Trust-per-date analytical grain.

Data-quality tests reduce risk but do not prove that data is correct, complete or suitable for every purpose.

A future production system would also require:

- agreed quality thresholds;
- automated monitoring;
- exception workflows;
- named data owners;
- issue resolution times;
- source-to-report reconciliation;
- change control;
- quality trend reporting.

---

## 8. Human Accountability

The platform separates:

- rules-based OPEL recommendations;
- human-approved OPEL decisions.

This distinction is important because an automated recommendation should not be treated as the final operational decision.

Human reviewers remain responsible for:

- considering context not represented in the data;
- challenging unusual outputs;
- confirming or overriding recommendations;
- documenting the reason for material overrides;
- escalating safety or quality concerns;
- ensuring decisions remain proportionate.

The system should support professional judgement, not replace it.

---

## 9. Explainability

The OPEL table includes:

- recommended level;
- approved level;
- prediction confidence;
- assessment method;
- assessment rationale;
- key pressure factors;
- rule version;
- reviewer role;
- review timestamp.

These fields provide a basic audit trail.

However:

- synthetic confidence values are not validated probabilities;
- listed pressure factors do not prove causation;
- simple explanations may omit important operational context;
- future machine-learning explanations would require formal validation.

---

## 10. Retention Considerations

The current synthetic dataset may be retained for portfolio and learning purposes.

A future real-world implementation would require a documented retention schedule covering:

- raw extracts;
- transformed operational records;
- incident records;
- analytical outputs;
- model features;
- model predictions;
- audit logs;
- exported files;
- backups.

Retention periods should be based on:

- legal requirements;
- operational need;
- records-management policy;
- information-governance advice;
- minimisation principles.

Records should not be retained indefinitely without a defined purpose.

---

## 11. Export and Downstream Use

The analytical CSV export is intended for:

- Power BI;
- Python analysis;
- controlled API development;
- later feature engineering;
- demonstration of downstream integration.

Exports create additional governance risk because they can:

- be copied;
- become outdated;
- lose access controls;
- be used outside the original context;
- become disconnected from lineage.

A production system should use controlled export locations, versioning, access restrictions and clear refresh dates.

---

## 12. Future DPIA Requirement

A Data Protection Impact Assessment would be required before introducing real personal data where processing may create a high risk to individuals.

A future DPIA should consider:

- purpose and lawful basis;
- categories of data;
- data flows;
- access permissions;
- linkage risk;
- automated decision support;
- profiling;
- retention;
- security;
- data sharing;
- individual rights;
- mitigations;
- residual risk.

This portfolio project does not require a formal DPIA because it uses synthetic and non-identifiable data only.

---

## 13. Future Information-Governance Requirements

Before production use, the project would require review of:

- data-controller and data-processor responsibilities;
- lawful basis;
- data-sharing agreements;
- records of processing;
- role-based access;
- retention schedules;
- breach procedures;
- secure hosting;
- backup and recovery;
- supplier assurance;
- audit logging;
- data-subject rights where applicable.

---

## 14. Clinical-Safety Considerations

The current platform is operational rather than clinical, but operational decisions can still influence patient care.

A future implementation may require:

- formal clinical-safety assessment;
- a named Clinical Safety Officer;
- hazard identification;
- risk controls;
- documented intended use;
- documented limitations;
- user training;
- incident reporting;
- change control;
- appropriate application of DCB0129 and DCB0160 where relevant.

The portfolio project has not undergone clinical-safety assurance.

---

## 15. Model and Decision-Support Limitations

The current OPEL logic is synthetic and rules-based.

It has not been validated for:

- predictive accuracy;
- calibration;
- fairness;
- generalisability;
- operational benefit;
- patient safety;
- distribution shift;
- real-time use;
- Trust-to-Trust transferability.

Any future model would require:

- appropriately governed training data;
- independent validation;
- subgroup analysis;
- error analysis;
- human-factors testing;
- monitoring;
- rollback procedures;
- documented approval.

---

## 16. Accountability Roles for Future Production

A production implementation should define named responsibilities for:

| Role | Example responsibility |
|---|---|
| Data owner | Approves purpose, definitions and permitted use |
| Source-system owner | Maintains source reliability |
| Data engineer | Maintains ingestion, transformation and lineage |
| Information analyst | Validates reporting logic and interpretation |
| Operational lead | Reviews operational relevance and decisions |
| Information Governance lead | Reviews lawful and proportionate use |
| Clinical Safety Officer | Reviews safety risks where applicable |
| Model owner | Maintains model validation and monitoring |
| Security lead | Maintains access, logging and technical safeguards |

This portfolio project does not assign real NHS personnel to these roles.

---

## 17. Known Governance Limitations

- The dataset is synthetic.
- The reporting period covers only 30 days.
- The organisations are fictional.
- OPEL logic is simplified.
- Confidence scores are illustrative.
- No production access-control system is implemented.
- No formal DPIA has been completed.
- No clinical-safety case has been completed.
- No external security testing has been performed.
- No real source-to-report reconciliation has been conducted.
- No real-world user testing has been completed.

---

## 18. Governance Position

The platform demonstrates how governance can be designed into a data product through:

- minimised data;
- relational integrity;
- lineage fields;
- quality checks;
- controlled values;
- human review;
- documented limitations;
- transparent synthetic-data labelling.

These controls improve trustworthiness but do not make the platform production ready.

---

> This is a synthetic operational analytics platform for learning and portfolio demonstration. It is not a production NHS system and should not be used to make operational or clinical decisions.
