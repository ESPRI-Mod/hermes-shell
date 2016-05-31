--Add column: monitoring.tbl_message.producer_version
ALTER TABLE mq.tbl_message ADD COLUMN producer_version character varying(31);
ALTER TABLE mq.tbl_message ALTER COLUMN producer_version SET NOT NULL;

--Add column: monitoring.tbl_job.scheduler_id
ALTER TABLE monitoring.tbl_job ADD COLUMN scheduler_id character varying(255);

--Add column: monitoring.tbl_job.submission_path
ALTER TABLE monitoring.tbl_job ADD COLUMN submission_path character varying(2047);

-- Add table: monitoring.tbl_command
CREATE TABLE monitoring.tbl_command
(
  id serial NOT NULL,
  simulation_uid character varying(63),
  job_uid character varying(63),
  uid character varying(63),
  "timestamp" timestamp without time zone,
  instruction text,
  is_error boolean,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_command_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE monitoring.tbl_command
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE monitoring.tbl_command TO hermes_db_admin;
