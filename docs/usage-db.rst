============================
Prodiguer Shell DB Commands
============================

prodiguer-db-pgres-backup
----------------------------

Backs up prodiguer PostgreSQL database to $HERMES_HOME/ops/backups/db/pgres/YYYY-MM-DD.

prodiguer-db-pgres-install
----------------------------

Installs prodiguer PostgreSQL database.

prodiguer-db-pgres-migrate
----------------------------

Updates prodiguer PostgreSQL database version by adding new tables / columns.

prodiguer-db-pgres-reset
----------------------------

Uninstalls and reinstalls prodiguer PostgreSQL database.  Used during development when database schema changes.

prodiguer-db-pgres-reset-cv-table
----------------------------

Deletes all entries from the prodiguer PostgreSQL cv.tbl_cv_term table.

prodiguer-db-pgres-reset-environment-metric-table
----------------------------

Deletes all entries from the prodiguer PostgreSQL monitoring.tbl_environment_metric table.

prodiguer-db-pgres-reset-message-email-table
----------------------------

Deletes all entries from the prodiguer PostgreSQL mq.tbl_message_email table.

prodiguer-db-pgres-reset-message-table
----------------------------

Deletes all entries from the prodiguer PostgreSQL mq.tbl_message table.

prodiguer-db-pgres-restore BACKUP-DIR
----------------------------

Restores prodiguer PostgreSQL database from a backup.

**BACKUP-DIR**

	Path to a directory containing backup file(s).

prodiguer-db-pgres-uninstall
----------------------------

Drops prodiguer PostgreSQL database.  Called during development as part of a database reset.

prodiguer-db-reset
----------------------------

Pulls latest controlled vocabulary entries and resets prodiguer PostgreSQL database.
