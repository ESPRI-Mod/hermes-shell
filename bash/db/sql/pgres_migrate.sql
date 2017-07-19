-- Add new columns related to job executionlate issues.
ALTER TABLE monitoring.tbl_job ADD COLUMN warning_limit timestamp without time zone;
ALTER TABLE monitoring.tbl_job ADD COLUMN warning_state integer;
ALTER TABLE monitoring.tbl_job ALTER COLUMN warning_state SET DEFAULT 0;

-- Calculate job execution end date limits.
UPDATE
	monitoring.tbl_job
SET
	warning_limit = execution_start_date + warning_delay * interval '1 second'
WHERE
	warning_limit IS NULL AND
	execution_start_date IS NOT NULL;

-- Initialise warning_state indicator.
UPDATE
	monitoring.tbl_job as j
SET
	warning_state = 0;

-- Set warning_state indicator where jobs are under supervision.
UPDATE
	monitoring.tbl_job as j
SET
	warning_state = 1
WHERE
	j.job_uid IN (SELECT job_uid FROM superviseur.tbl_supervision WHERE trigger_code != '1999');

-- Set warning_state indicator where jobs are late.
UPDATE
	monitoring.tbl_job
SET
	warning_state = 2
WHERE
	warning_state != 1 AND
	execution_start_date IS NOT NULL AND
	execution_end_date IS NULL AND
	now() > warning_limit;

-- Set execution state of late jobs.
UPDATE
	monitoring.tbl_job
SET
	execution_state = 'l'
WHERE
	execution_end_date IS NULL AND
	warning_state > 0;
