-- monitoring.tbl_simulation: add accounting_project column.
ALTER TABLE monitoring.tbl_simulation ADD COLUMN accounting_project character varying(511);

-- monitoring.tbl_simulation: add raw field columns.
ALTER TABLE monitoring.tbl_simulation ADD COLUMN activity_raw character varying(127);
ALTER TABLE monitoring.tbl_simulation ADD COLUMN compute_node_raw character varying(127);
ALTER TABLE monitoring.tbl_simulation ADD COLUMN compute_node_login_raw character varying(127);
ALTER TABLE monitoring.tbl_simulation ADD COLUMN compute_node_machine_raw character varying(127);
ALTER TABLE monitoring.tbl_simulation ADD COLUMN experiment_raw character varying(127);
ALTER TABLE monitoring.tbl_simulation ADD COLUMN model_raw character varying(127);
ALTER TABLE monitoring.tbl_simulation ADD COLUMN space_raw character varying(127);

-- monitoring.tbl_job: add typeof column.
ALTER TABLE monitoring.tbl_job ADD COLUMN typeof character varying(63);

-- monitoring.tbl_job: add accounting_project column.
ALTER TABLE monitoring.tbl_job ADD COLUMN accounting_project character varying(511);

-- monitoring.tbl_environment_metric: add new table.
CREATE TABLE monitoring.tbl_environment_metric
(
  id serial NOT NULL,
  simulation_uid character varying(63) NOT NULL,
  job_uid character varying(63) NOT NULL,
  action_name character varying(511) NOT NULL,
  action_timestamp timestamp without time zone NOT NULL,
  dir_to character varying(4096) NOT NULL,
  dir_from character varying(4096) NOT NULL,
  duration_ms integer NOT NULL,
  size_mb double precision NOT NULL,
  throughput_mb_s double precision NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_environment_metric_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE monitoring.tbl_environment_metric
  OWNER TO prodiguer_db_admin;

-- monitoring.tbl_environment_metric_id_seq: add new sequence.
CREATE SEQUENCE monitoring.tbl_environment_metric_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 11856
  CACHE 1;
ALTER TABLE monitoring.tbl_environment_metric_id_seq
  OWNER TO prodiguer_db_admin;

