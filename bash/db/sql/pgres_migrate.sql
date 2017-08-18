-- Add new columns related to job executionlate issues.
ALTER TABLE monitoring.tbl_job ADD COLUMN warning_limit timestamp without time zone;
ALTER TABLE monitoring.tbl_job ADD COLUMN warning_state integer;
ALTER TABLE monitoring.tbl_job ALTER COLUMN warning_state SET DEFAULT 0;

-- Initialise warning_state indicator.
UPDATE
	monitoring.tbl_job as j
SET
	warning_state = 0;

-- Initialise job warning limits.
UPDATE
	monitoring.tbl_job
SET
	warning_limit = execution_start_date + warning_delay * interval '1 second'
WHERE
	warning_limit IS NULL AND
	execution_start_date IS NOT NULL;

-- Jobs under supervision :: update warning state.
UPDATE
	monitoring.tbl_job as j
SET
	warning_state = 1
WHERE
	warning_state = 0 AND
	j.job_uid IN (SELECT job_uid FROM superviseur.tbl_supervision WHERE trigger_code != '1999');

-- Late jobs not under supervision :: update warning state.
UPDATE
	monitoring.tbl_job
SET
	warning_state = 2
WHERE
	warning_state != 1 AND
	execution_start_date IS NOT NULL AND
	execution_end_date IS NULL AND
	now() > warning_limit;

-- Late jobs :: update execution state.
UPDATE
	monitoring.tbl_job
SET
	execution_state = 'l'
WHERE
	execution_end_date IS NULL AND
	warning_state > 0;

