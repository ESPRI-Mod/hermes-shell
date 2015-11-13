-- Create message email fields to capture email transmission latencies.
ALTER TABLE mq.tbl_message_email ADD COLUMN arrival_date timestamp without time zone;
ALTER TABLE mq.tbl_message_email ADD COLUMN dispatch_date timestamp without time zone;
ALTER TABLE mq.tbl_message_email ADD COLUMN dispatch_latency integer;

-- Drop table: conso.tbl_consumption_by_project
DROP TABLE conso.tbl_consumption_by_project;

-- Drop table: conso.tbl_consumption_by_login
DROP TABLE conso.tbl_consumption_by_login;

-- Drop table: conso.tbl_occupation_store
DROP TABLE conso.tbl_occupation_store;

-- Drop table: conso.tbl_project
DROP TABLE conso.tbl_project;

-- Drop sequence: conso.tbl_project_id_seq
DROP SEQUENCE conso.tbl_project_id_seq;

-- Drop sequence: conso.tbl_consumption_by_project_id_seq
DROP SEQUENCE conso.tbl_consumption_by_project_id_seq;

-- Drop sequence: conso.tbl_consumption_by_login_id_seq
DROP SEQUENCE conso.tbl_consumption_by_login_id_seq;

-- Drop sequence: conso.tbl_occupation_store_id_seq
DROP SEQUENCE conso.tbl_occupation_store_id_seq;

-- Create table: conso.tbl_allocation
CREATE TABLE conso.tbl_allocation
(
  id serial NOT NULL,
  centre character varying(127) NOT NULL,
  end_date timestamp without time zone NOT NULL,
  machine character varying(127) NOT NULL,
  node_type character varying(127) NOT NULL,
  project character varying(127) NOT NULL,
  start_date timestamp without time zone NOT NULL,
  total_hrs character varying(127) NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_allocation_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_allocation_centre_machine_node_type_project_start_date_key UNIQUE (centre, machine, node_type, project, start_date)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_allocation
  OWNER TO prodiguer_db_admin;

-- Create sequence: conso.tbl_allocation_id_seq
CREATE SEQUENCE conso.tbl_allocation_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_allocation_id_seq
  OWNER TO prodiguer_db_admin;

-- Create table: conso.tbl_consumption
CREATE TABLE conso.tbl_consumption
(
  id serial NOT NULL,
  allocation_id integer,
  date timestamp without time zone NOT NULL,
  total_hrs double precision NOT NULL,
  login character varying(127),
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_consumption_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_consumption_allocation_id_fkey FOREIGN KEY (allocation_id)
      REFERENCES conso.tbl_allocation (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_consumption
  OWNER TO prodiguer_db_admin;

-- Create sequence: conso.tbl_consumption_id_seq
CREATE SEQUENCE conso.tbl_consumption_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_consumption_id_seq
  OWNER TO prodiguer_db_admin;

-- Create table: conso.tbl_occupation_store
CREATE TABLE conso.tbl_occupation_store
(
  id serial NOT NULL,
  date timestamp without time zone NOT NULL,
  login character varying(127) NOT NULL,
  name character varying(127) NOT NULL,
  size double precision NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_occupation_store_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_occupation_store
  OWNER TO prodiguer_db_admin;

-- Create sequence: conso.tbl_occupation_store_id_seq
CREATE SEQUENCE conso.tbl_occupation_store_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_occupation_store_id_seq
  OWNER TO prodiguer_db_admin;

