============================
HERMES Shell DB Commands
============================

hermes-db-pgres-backup
----------------------------

Backs up HERMES PostgreSQL database to $HERMES_HOME/ops/backups/db/pgres/YYYY-MM-DD.

hermes-db-pgres-install
----------------------------

Installs HERMES PostgreSQL database.

hermes-db-pgres-migrate
----------------------------

Updates HERMES PostgreSQL database version by adding new tables / columns.

hermes-db-pgres-reset
----------------------------

Uninstalls and reinstalls HERMES PostgreSQL database.  Used during development when database schema changes.

hermes-db-pgres-reset-cv-table
----------------------------

Deletes all entries from the HERMES PostgreSQL cv.tbl_cv_term table.

hermes-db-pgres-reset-environment-metric-table
----------------------------

Deletes all entries from the HERMES PostgreSQL monitoring.tbl_environment_metric table.

hermes-db-pgres-reset-message-email-table
----------------------------

Deletes all entries from the HERMES PostgreSQL mq.tbl_message_email table.

hermes-db-pgres-reset-message-table
----------------------------

Deletes all entries from the HERMES PostgreSQL mq.tbl_message table.

hermes-db-pgres-restore BACKUP-DIR
----------------------------

Restores HERMES PostgreSQL database from a backup.

**BACKUP-DIR**

	Path to a directory containing backup file(s).

hermes-db-pgres-uninstall
----------------------------

Drops HERMES PostgreSQL database.  Called during development as part of a database reset.

hermes-db-reset
----------------------------

Pulls latest controlled vocabulary entries and resets HERMES PostgreSQL database.
