ALTER TABLE monitoring.tbl_job ADD COLUMN is_late boolean;
ALTER TABLE monitoring.tbl_job ALTER COLUMN is_late SET DEFAULT false;
ALTER TABLE monitoring.tbl_job ADD COLUMN execution_end_date_limit timestamp without time zone;

UPDATE
	monitoring.tbl_job
SET
	execution_end_date_limit = execution_start_date + warning_delay * interval '1 second'
WHERE
	execution_start_date IS NOT NULL;

UPDATE
	monitoring.tbl_job
SET
	is_late = TRUE
WHERE
	execution_start_date IS NOT NULL AND
	execution_end_date IS NOT NULL AND
	execution_end_date > execution_end_date_limit;

UPDATE
	monitoring.tbl_job
SET
	is_late = TRUE
WHERE
	execution_start_date IS NOT NULL AND
	execution_end_date IS NULL AND
	now() > execution_end_date_limit;