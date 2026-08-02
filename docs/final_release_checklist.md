# NHS Operational Data Platform — Final Release Checklist

## Purpose

This checklist confirms that the NHS Operational Data Platform is complete, internally consistent and ready to present as a portfolio project.

The checklist covers:

- repository structure;
- database schema;
- synthetic-data loading;
- data-quality validation;
- analytical outputs;
- documentation;
- governance;
- interview readiness;
- release quality.

---

## 1. Repository Structure

- [x] `README.md` is complete and renders correctly.
- [x] SQL files are stored in clearly named folders.
- [x] Schema scripts are numbered in execution order.
- [x] Test scripts are stored under `tests/schema/`.
- [x] Analytical outputs are stored under `outputs/`.
- [x] Supporting documentation is stored under `docs/`.
- [x] No temporary files or duplicate drafts remain.
- [x] File and folder names are consistent.
- [x] All referenced repository paths exist.

---

## 2. Database Schema

- [x] The `operational` schema is created successfully.
- [x] All six core tables are created successfully.
- [x] Primary keys are present.
- [x] Foreign keys link operational records to valid Trusts.
- [x] Unique constraints protect the intended data grain.
- [x] Check constraints prevent logically invalid values.
- [x] Delete and update behaviour is controlled.
- [x] Lineage and audit fields are included.
- [x] Table grains are documented.
- [x] The schema runs successfully in `nhs_operations_test`.

Core tables:

- [x] `trusts`
- [x] `daily_operational_metrics`
- [x] `workforce_metrics`
- [x] `incidents`
- [x] `weather_metrics`
- [x] `opel_assessments`

---

## 3. Constraint Testing

- [x] Core schema tests pass.
- [x] Duplicate Trust codes are rejected.
- [x] Duplicate Trust-date operational records are rejected.
- [x] Invalid foreign-key values are rejected.
- [x] Invalid bed values are rejected.
- [x] Invalid A&E values are rejected.
- [x] Invalid ambulance values are rejected.
- [x] Invalid workforce values are rejected.
- [x] Invalid OPEL values are rejected.
- [x] Expected constraint failures are documented.
- [x] Test results are recorded in `docs/constraint_test_results.md`.

---

## 4. Synthetic Data Load

- [x] The seed script runs successfully.
- [x] The reporting period is 1 January to 30 January 2026.
- [x] Three fictional Trusts are loaded.
- [x] The load uses deterministic SQL.
- [x] Source-record identifiers are reproducible.
- [x] The fixed synthetic load-batch identifier is applied.
- [x] The load runs inside a controlled transaction.
- [x] Expected record counts are validated before commit.
- [x] Reloading does not create unintended duplicates.
- [x] No real patient, staff or Trust performance data is included.

Expected record counts:

| Dataset | Expected records |
|---|---:|
| Fictional Trusts | 3 |
| Daily operational records | 90 |
| Workforce records | 90 |
| Operational incidents | 24 |
| Weather records | 90 |
| OPEL assessments | 90 |
| **Total physical records** | **387** |

---

## 5. Data-Quality Validation

- [x] Duplicate checks return zero failed records.
- [x] Required-value checks return zero failed records.
- [x] Impossible bed-value checks return zero failed records.
- [x] Invalid A&E checks return zero failed records.
- [x] Invalid ambulance checks return zero failed records.
- [x] Invalid workforce checks return zero failed records.
- [x] Orphan-record checks return zero failed records.
- [x] Incident timestamp checks pass.
- [x] Weather validation checks pass.
- [x] OPEL validation checks pass.
- [x] Missing-date checks pass.
- [x] The consolidated validation summary is documented.
- [x] Results are recorded in `docs/data_quality_test_results.md`.

---

## 6. Operational Analysis

- [x] Average bed occupancy has been calculated.
- [x] Highest A&E breach-rate dates have been identified.
- [x] OPEL 3 and OPEL 4 frequency has been analysed.
- [x] Workforce pressure has been compared by OPEL status.
- [x] Project-defined red-flag incidents have been analysed.
- [x] Ambulance pressure has been compared by OPEL level.
- [x] Weather and operational pressure have been analysed.
- [x] Associations are not presented as causation.
- [x] Synthetic definitions are clearly labelled.
- [x] Findings are documented in Band 7-style language.

Supporting files:

- [x] `docs/day5_operational_analysis_results.md`
- [x] `docs/day5_band7_findings.md`

---

## 7. Analytical View

- [x] `operational.vw_trust_daily_analytical` is created successfully.
- [x] The intended grain is one row per Trust per reporting date.
- [x] The view returns 90 rows.
- [x] The view contains 3 fictional Trusts.
- [x] The view contains 30 reporting dates.
- [x] Duplicate Trust-date checks return zero rows.
- [x] Workforce data is prepared at the required grain.
- [x] One observed weather record is selected per Trust-date.
- [x] One OPEL record is selected per Trust-date.
- [x] Percentage calculations use safe denominator logic.
- [x] Human OPEL overrides can be identified.

---

## 8. Exported Output

- [x] The analytical view has been exported.
- [x] The export is stored as `outputs/query_results.csv`.
- [x] The CSV contains 90 Trust-day records.
- [x] Column headings are present.
- [x] The export opens correctly.
- [x] No duplicate Trust-date rows are present.
- [x] No real NHS data is present.
- [x] The output is suitable for future Power BI and Python work.
- [x] Export limitations are documented.

---

## 9. Documentation

- [x] README overview is complete.
- [x] Architecture diagram renders correctly.
- [x] Entity-relationship diagram renders correctly.
- [x] Repository structure is accurate.
- [x] Setup instructions are complete.
- [x] Script execution order is documented.
- [x] Expected record counts are documented.
- [x] Data-quality controls are explained.
- [x] Example findings are included.
- [x] Limitations are clearly stated.
- [x] Future development stages are documented.

Supporting documentation:

- [x] `docs/architecture.md`
- [x] `docs/database_erd.md`
- [x] `docs/table_relationships.md`
- [x] `docs/data_dictionary.md`
- [x] `docs/synthetic_data_provenance.md`
- [x] `docs/synthetic_data_load_results.md`
- [x] `docs/governance_notes.md`
- [x] `docs/interview_evidence.md`

---

## 10. Governance and Safety

- [x] The synthetic-data disclaimer is visible.
- [x] Intended use is documented.
- [x] Prohibited use is documented.
- [x] Human accountability is explained.
- [x] Recommended and approved OPEL levels remain separate.
- [x] Synthetic confidence values are not described as validated probabilities.
- [x] Real operational or clinical use is prohibited.
- [x] Future DPIA requirements are acknowledged.
- [x] Future Information Governance review is acknowledged.
- [x] DCB0129 and DCB0160 consideration is acknowledged.
- [x] No passwords, tokens or secrets are committed.
- [x] No connection strings containing credentials are committed.

Required statement:

> This is a synthetic operational analytics platform for learning and portfolio demonstration. It is not a production NHS system and should not be used to make operational or clinical decisions.

---

## 11. Interview Readiness

- [x] A two-minute project explanation is prepared.
- [x] A 30-second summary is prepared.
- [x] STAR evidence is documented.
- [x] Technical design decisions can be defended.
- [x] Data-quality controls can be explained.
- [x] Analytical findings can be discussed.
- [x] Governance limitations can be explained.
- [x] Future development plans can be described.
- [x] CV evidence is prepared.
- [x] LinkedIn project text is prepared.

---

## 12. GitHub Quality Review

- [x] The repository description is clear.
- [x] The README is visible on the landing page.
- [x] Commit messages are professional.
- [x] No unfinished placeholder text remains.
- [x] No spelling or formatting errors remain.
- [x] Mermaid diagrams render correctly.
- [x] Markdown tables render correctly.
- [x] SQL blocks are properly closed.
- [x] File links and paths are accurate.
- [x] The repository can be understood without verbal explanation.

---

## 13. Final Release Decision

Release status:

- [x] Ready for portfolio presentation
- [ ] Requires minor corrections
- [ ] Requires technical rework
- [ ] Requires documentation updates

Final reviewer notes:

```text
Schema, deterministic seed load, data-quality validation, operational analysis,
analytical view, CSV export, governance documentation and interview evidence
were reviewed. The repository uses fully synthetic data and is suitable for
portfolio demonstration.
```

Final release date:

```text
2026-08-02
```

Final status:

```text
APPROVED FOR PORTFOLIO DEMONSTRATION
```

---

## Final Confirmation

The NHS Operational Data Platform has been designed as a synthetic, reproducible and governed healthcare data-engineering portfolio project.

Approval for portfolio presentation does not represent approval for deployment in a real NHS environment.


