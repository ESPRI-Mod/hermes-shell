/* Grant schema permissions */
GRANT USAGE ON SCHEMA conso, cv, monitoring, mq, superviseur TO hermes_db_user;

/* Grant table permissions */
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA conso TO hermes_db_user;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA cv TO hermes_db_user;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA monitoring TO hermes_db_user;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA mq TO hermes_db_user;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA superviseur TO hermes_db_user;

/* Grant sequence permissions */
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA conso TO hermes_db_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA cv TO hermes_db_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA monitoring TO hermes_db_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mq TO hermes_db_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA superviseur TO hermes_db_user;
