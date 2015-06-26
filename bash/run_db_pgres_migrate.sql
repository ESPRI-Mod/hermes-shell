CREATE SEQUENCE monitoring.tbl_environment_metric_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 11856
  CACHE 1;
ALTER TABLE monitoring.tbl_environment_metric_id_seq
  OWNER TO prodiguer_db_admin;
GRANT ALL ON TABLE monitoring.tbl_environment_metric_id_seq TO prodiguer_db_admin;
GRANT SELECT, USAGE ON TABLE monitoring.tbl_environment_metric_id_seq TO prodiguer_db_user;
