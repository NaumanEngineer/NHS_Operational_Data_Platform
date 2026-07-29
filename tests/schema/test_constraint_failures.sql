Record your outcomes:
Test	Expected	Pass condition
Missing Trust code	Rejected	NOT NULL error
Duplicate Trust code	Rejected	Unique-constraint error
Negative operational value	Rejected	Non-negative check error
Occupied beds above capacity	Rejected	Bed-capacity check error
Critical-care occupancy above capacity	Rejected	Critical-care check error
OPEL level 5	Rejected	OPEL-range check error
Unknown Trust	Rejected	Foreign-key error
Incomplete OPEL approval	Rejected	Approval-completeness error
Valid OPEL record	Accepted	INSERT 0 1
