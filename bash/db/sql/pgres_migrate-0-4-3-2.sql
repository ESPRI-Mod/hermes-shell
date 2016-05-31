-- Add schema: conso
CREATE SCHEMA conso AUTHORIZATION hermes_db_admin;
GRANT ALL ON SCHEMA conso TO hermes_db_admin;
GRANT USAGE ON SCHEMA conso TO hermes_db_user;

-- Create table: conso.tbl_project
CREATE TABLE conso.tbl_project
(
  id serial NOT NULL,
  name character varying(127) NOT NULL,
  centre character varying(127) NOT NULL,
  machine character varying(127) NOT NULL,
  node_type character varying(127) NOT NULL,
  allocation character varying(127) NOT NULL,
  start_date timestamp without time zone NOT NULL,
  end_date timestamp without time zone NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_project_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_project_name_centre_machine_node_type_start_date_key UNIQUE (name, centre, machine, node_type, start_date)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_project
  OWNER TO hermes_db_admin;

-- Create sequence: conso.tbl_project_id_seq
CREATE SEQUENCE conso.tbl_project_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_project_id_seq
  OWNER TO hermes_db_admin;

-- Create table: conso.tbl_consumption_by_login
CREATE TABLE conso.tbl_consumption_by_login
(
  id serial NOT NULL,
  project_id integer,
  login character varying(127) NOT NULL,
  date timestamp without time zone NOT NULL,
  total double precision NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_consumption_by_login_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_consumption_by_login_project_id_fkey FOREIGN KEY (project_id)
      REFERENCES conso.tbl_project (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_consumption_by_login
  OWNER TO hermes_db_admin;

-- Create sequence: conso.tbl_consumption_by_login_id_seq
CREATE SEQUENCE conso.tbl_consumption_by_login_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_consumption_by_login_id_seq
  OWNER TO hermes_db_admin;

-- Create table: conso.tbl_consumption_by_project
CREATE TABLE conso.tbl_consumption_by_project
(
  id serial NOT NULL,
  project_id integer,
  date timestamp without time zone NOT NULL,
  total double precision NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_consumption_by_project_pkey PRIMARY KEY (id),
  CONSTRAINT tbl_consumption_by_project_project_id_fkey FOREIGN KEY (project_id)
      REFERENCES conso.tbl_project (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_consumption_by_project
  OWNER TO hermes_db_admin;

-- Create sequence: conso.tbl_consumption_by_project_id_seq
CREATE SEQUENCE conso.tbl_consumption_by_project_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_consumption_by_project_id_seq
  OWNER TO hermes_db_admin;

-- Create table: conso.tbl_occupation_store
CREATE TABLE conso.tbl_occupation_store
(
  id serial NOT NULL,
  login character varying(127) NOT NULL,
  date timestamp without time zone NOT NULL,
  store_name character varying(127) NOT NULL,
  store_size double precision NOT NULL,
  row_create_date timestamp without time zone NOT NULL,
  row_update_date timestamp without time zone,
  CONSTRAINT tbl_occupation_store_pkey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE conso.tbl_occupation_store
  OWNER TO hermes_db_admin;

-- Create sequence: conso.tbl_occupation_store_id_seq
CREATE SEQUENCE conso.tbl_occupation_store_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE conso.tbl_occupation_store_id_seq
  OWNER TO hermes_db_admin;
