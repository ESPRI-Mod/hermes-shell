-- Add column: monitoring.tbl_job.warning_delay
ALTER TABLE monitoring.tbl_job ADD COLUMN warning_delay integer;

--Add column: monitoring.tbl_job.is_startup
ALTER TABLE monitoring.tbl_job ADD COLUMN is_startup boolean;

--Add column: monitoring.tbl_job.post_processing_*
ALTER TABLE monitoring.tbl_job ADD COLUMN post_processing_name character varying(63);
ALTER TABLE monitoring.tbl_job ADD COLUMN post_processing_date timestamp without time zone;
ALTER TABLE monitoring.tbl_job ADD COLUMN post_processing_dimension character varying(63);
ALTER TABLE monitoring.tbl_job ADD COLUMN post_processing_component character varying(63);
ALTER TABLE monitoring.tbl_job ADD COLUMN post_processing_file character varying(127);

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

--Add column: cv.tbl_cv_term.sort_key
ALTER TABLE cv.tbl_cv_term ADD COLUMN sort_key character varying(127);

-- Add schema: superviseur
CREATE SCHEMA superviseur AUTHORIZATION hermes_db_admin;
GRANT ALL ON SCHEMA superviseur TO hermes_db_admin;
GRANT USAGE ON SCHEMA superviseur TO hermes_db_user;

-- Add table: superviseur.tbl_supervision
CREATE TABLE superviseur.tbl_supervision
(
  id serial NOT NULL,
  simulation_uid character varying(63) NOT NULL,
  job_uid character varying(63) NOT NULL,
  dispatch_date timestamp without time zone,
  dispatch_error text,
  dispatch_try_count integer,
  script text,
  trigger_code character varying(63) NOT NULL,
  trigger_date timestamp without time zone NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_supervision_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE superviseur.tbl_supervision OWNER TO hermes_db_admin;
GRANT ALL ON TABLE superviseur.tbl_supervision TO hermes_db_admin;
