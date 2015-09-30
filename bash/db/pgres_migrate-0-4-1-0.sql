-- Add column: monitoring.tbl_job.warning_delay
ALTER TABLE monitoring.tbl_job ADD COLUMN warning_delay integer;

-- Update column: monitoring.tbl_job.warning_delay
-- Calculate based upon difference between expected and actual end dates
UPDATE
	monitoring.tbl_job
SET
	warning_delay = (SELECT EXTRACT(EPOCH FROM expected_execution_end_date)) - (SELECT EXTRACT(EPOCH FROM execution_start_date))
WHERE
	execution_start_date IS NOT NULL AND
	expected_execution_end_date IS NOT NULL;

-- Update column: monitoring.tbl_job.warning_delay
-- Set to default value if undefined
UPDATE
	monitoring.tbl_job
SET
	warning_delay = 86400
WHERE
	warning_delay IS NULL;

-- Drop column: monitoring.tbl_job.expected_execution_end_date
ALTER TABLE monitoring.tbl_job DROP COLUMN expected_execution_end_date;

-- Drop column: monitoring.tbl_job.was_late
ALTER TABLE monitoring.tbl_job DROP COLUMN was_late;

-- Reset cv table.
DELETE FROM cv.tbl_cv_term;

--Add column: cv.tbl_cv_term.uid
ALTER TABLE cv.tbl_cv_term ADD COLUMN uid character varying(63);
ALTER TABLE cv.tbl_cv_term ALTER COLUMN uid SET NOT NULL;
