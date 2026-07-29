# Constraint Test Results

## Test environment

- Database: `nhs_operations_test`
- Schema: `operational`
- Test data: synthetic only
- Test date: 29 July 2026

## Results

| Test | Expected result | Actual result | Passed |
|---|---|---|---|
| Missing Trust code | Rejected by `NOT NULL` | Rejected | Yes |
| Duplicate Trust code | Rejected by `uq_trusts_trust_code` | Rejected with SQLSTATE `23505` | Yes |
| Negative operational value | Rejected by `chk_daily_operational_metrics_non_negative` | Rejected | Yes |
| Beds occupied above open beds | Rejected by `chk_daily_operational_beds` | Rejected | Yes |
| Critical-care occupancy above capacity | Rejected by `chk_daily_operational_critical_care_beds` | Rejected | Yes |
| OPEL level 5 | Rejected by `chk_opel_recommended_level` | Rejected | Yes |
| Unknown Trust ID | Rejected by `fk_workforce_metrics_trust` | Rejected | Yes |
| Incomplete approved OPEL record | Rejected by `chk_opel_approved_record_complete` | Rejected | Yes |
| Valid approved OPEL assessment | Accepted successfully | Inserted successfully | Yes |

## Conclusion

The PostgreSQL constraints behaved as intended during testing.

The schema successfully prevented:

- missing and duplicate Trust identifiers;
- negative operational measures;
- invalid bed-capacity relationships;
- invalid OPEL levels;
- orphan workforce records;
- incomplete approved OPEL decisions.

The schema also accepted a complete approved OPEL assessment containing both the recommended level and the final human-reviewed decision.
