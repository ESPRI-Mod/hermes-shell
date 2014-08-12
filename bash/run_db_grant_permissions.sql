/* Grant schema permissions */
GRANT USAGE ON SCHEMA cnode, dnode, mq, shared TO prodiguer_db_user;

/* Grant table permissions */
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA cnode TO prodiguer_db_user;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA dnode TO prodiguer_db_user;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA mq TO prodiguer_db_user;
GRANT INSERT, UPDATE, DELETE, SELECT ON ALL TABLES IN SCHEMA shared TO prodiguer_db_user;

/* Grant sequence permissions */
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA cnode TO prodiguer_db_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA dnode TO prodiguer_db_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA mq TO prodiguer_db_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA shared TO prodiguer_db_user;