CREATE TABLE monitoring.tbl_job_period
(
  id serial NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  simulation_uid character varying(63) NOT NULL,
  job_uid character varying(63) NOT NULL,
  period_id integer NOT NULL,
  period_date_begin integer NOT NULL,
  period_date_end integer NOT NULL,
  CONSTRAINT tbl_job_period_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_job_period_job_uid_period_id_period_date_begin_period_d_key UNIQUE (job_uid, period_id, period_date_begin, period_date_end)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE monitoring.tbl_job_period
  OWNER TO hermes_db_admin;
