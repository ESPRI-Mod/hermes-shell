DROP TABLE conso.tbl_occupation_store;
DROP TABLE conso.tbl_cpu_state;
DROP TABLE conso.tbl_consumption;
DROP TABLE conso.tbl_allocation;


DROP SEQUENCE conso.tbl_allocation_id_seq;
DROP SEQUENCE conso.tbl_consumption_id_seq;
DROP SEQUENCE conso.tbl_cpu_state_id_seq;
DROP SEQUENCE conso.tbl_occupation_store_id_seq;


CREATE SEQUENCE conso.tbl_allocation_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_allocation_id_seq
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_allocation_id_seq TO hermes_db_admin;
GRANT SELECT, USAGE ON TABLE conso.tbl_allocation_id_seq TO hermes_db_user;


CREATE SEQUENCE conso.tbl_consumption_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_consumption_id_seq
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_consumption_id_seq TO hermes_db_admin;
GRANT SELECT, USAGE ON TABLE conso.tbl_consumption_id_seq TO hermes_db_user;


CREATE SEQUENCE conso.tbl_cpu_state_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_cpu_state_id_seq
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_cpu_state_id_seq TO hermes_db_admin;
GRANT SELECT, USAGE ON TABLE conso.tbl_cpu_state_id_seq TO hermes_db_user;


CREATE SEQUENCE conso.tbl_occupation_store_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_occupation_store_id_seq
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_occupation_store_id_seq TO hermes_db_admin;
GRANT SELECT, USAGE ON TABLE conso.tbl_occupation_store_id_seq TO hermes_db_user;


CREATE TABLE conso.tbl_allocation
(
  id serial NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  centre character varying(127) NOT NULL,
  project character varying(127) NOT NULL,
  sub_project character varying(127),
  machine character varying(127) NOT NULL,
  node_type character varying(127) NOT NULL,
  start_date timestamp without time zone NOT NULL,
  end_date timestamp without time zone NOT NULL,
  total_hrs double precision NOT NULL,
  is_active boolean NOT NULL,
  is_reviewed boolean NOT NULL,
  CONSTRAINT tbl_allocation_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_allocation_centre_machine_node_type_project_start_date_key UNIQUE (centre, machine, node_type, project, start_date)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_allocation
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_allocation TO hermes_db_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE conso.tbl_allocation TO hermes_db_user;


CREATE TABLE conso.tbl_consumption
(
  id serial NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  allocation_id integer NOT NULL,
  sub_project character varying(127),
  login character varying(127),
  date timestamp without time zone NOT NULL,
  total_hrs double precision NOT NULL,
  CONSTRAINT tbl_consumption_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_consumption_allocation_id_fkey FOREIGN KEY (allocation_id)
      REFERENCES conso.tbl_allocation (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT tbl_consumption_allocation_id_sub_project_login_date_key UNIQUE (allocation_id, sub_project, login, date)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_consumption
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_consumption TO hermes_db_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE conso.tbl_consumption TO hermes_db_user;

CREATE UNIQUE INDEX tbl_consumption_unique_idx_1 ON conso.tbl_consumption (allocation_id, date, login, sub_project) WHERE login IS NOT NULL AND sub_project IS NOT NULL;
CREATE UNIQUE INDEX tbl_consumption_unique_idx_2 ON conso.tbl_consumption (allocation_id, date, login) WHERE login IS NOT NULL AND sub_project IS NULL;
CREATE UNIQUE INDEX tbl_consumption_unique_idx_3 ON conso.tbl_consumption (allocation_id, date, sub_project) WHERE login IS NULL AND sub_project IS NOT NULL;
CREATE UNIQUE INDEX tbl_consumption_unique_idx_4 ON conso.tbl_consumption (allocation_id, date) WHERE login IS NULL AND sub_project IS NULL;


CREATE TABLE conso.tbl_cpu_state
(
  id serial NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  allocation_id integer NOT NULL,
  date timestamp without time zone NOT NULL,
  total_running integer NOT NULL,
  total_pending integer NOT NULL,
  CONSTRAINT tbl_cpu_state_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_cpu_state_allocation_id_fkey FOREIGN KEY (allocation_id)
      REFERENCES conso.tbl_allocation (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_cpu_state
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_cpu_state TO hermes_db_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE conso.tbl_cpu_state TO hermes_db_user;


CREATE TABLE conso.tbl_occupation_store
(
  id serial NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  centre character varying(127) NOT NULL,
  project character varying(127) NOT NULL,
  typeof character varying(7) NOT NULL,
  login character varying(127) NOT NULL,
  date timestamp without time zone NOT NULL,
  name character varying(511) NOT NULL,
  size_gb double precision NOT NULL,
  CONSTRAINT tbl_occupation_store_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_occupation_store
  OWNER TO hermes_db_admin;
GRANT ALL ON TABLE conso.tbl_occupation_store TO hermes_db_admin;
GRANT SELECT, UPDATE, INSERT, DELETE ON TABLE conso.tbl_occupation_store TO hermes_db_user;
