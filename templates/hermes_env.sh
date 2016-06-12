# --------------------------------------------------------------------
# General settings
# --------------------------------------------------------------------
# Path to Hermes server install directory.
export HERMES_HOME=/opt/hermes

# Mode of deployment (dev|test|prod).
export HERMES_DEPLOYMENT_MODE=dev

# Type of machine (dev|db|mq|mq).
export HERMES_MACHINE_TYPE=dev

# Hermes client web service url.
export HERMES_CLIENT_WEB_URL=http://localhost:8888

# Hermes alert email addresses.
export HERMES_ALERT_EMAIL_ADDRESS_FROM=prodiguer-ops@ipsl.listes.fr
export HERMES_ALERT_EMAIL_ADDRESS_TO=prodiguer-ops@ipsl.listes.fr

# --------------------------------------------------------------------
# DB server settings
# --------------------------------------------------------------------
# Hermes MongoDB server hostname & port.
export HERMES_DB_MONGO_HOST=localhost:27017

# Hermes MongoDB password for the db user account.
export HERMES_DB_MONGO_USER_PASSWORD=XXXXXXXXXXX

# Hermes PostgreSQL server hostname & port.
export HERMES_DB_PGRES_HOST=localhost:5432

# Hermes PostgreSQL database name.
export HERMES_DB_PGRES_NAME=hermes

# Hermes PostgreSQL pgdump executable path.
export HERMES_DB_PGRES_PGDUMP=/usr/bin/pg_dump

# Hermes PostgreSQL password for the db user account.
export HERMES_DB_PGRES_USER_PASSWORD=XXXXXXXXXXX

# --------------------------------------------------------------------
# MQ server settings
# --------------------------------------------------------------------
# Hermes RabbitMQ sever host (includes port).
export HERMES_MQ_RABBIT_HOST=localhost:5672

# Hermes RabbitMQ sever protocol (i.e. whether to communicate over ssl).
export HERMES_MQ_RABBIT_PROTOCOL=ampq

# Hermes RabbitMQ libIGCM user password.
export HERMES_MQ_RABBIT_LIBIGCM_USER_PASSWORD=XXXXXXXXXXX

# Hermes RabbitMQ agent user password.
export HERMES_MQ_RABBIT_USER_PASSWORD=XXXXXXXXXXX

# Hermes RabbitMQ client SSL cert path.
export HERMES_MQ_RABBIT_SSL_CLIENT_CERT=

# Hermes RabbitMQ client SSL cert key path.
export HERMES_MQ_RABBIT_SSL_CLIENT_KEY=

# Hermes IMAP mailbox.
export HERMES_MQ_IMAP_MAILBOX=AMPQ-DEV

# Hermes IMAP mailbox - processed.
export HERMES_MQ_IMAP_MAILBOX_PROCESSED=AMPQ-DEV-PROCESSED

# Hermes IMAP user password.
export HERMES_MQ_IMAP_PASSWORD=XXXXXXXXXXX

# Hermes SMTP user password.
export HERMES_MQ_SMTP_PASSWORD=XXXXXXXXXXX

# --------------------------------------------------------------------
# Web server settings
# --------------------------------------------------------------------
# Hermes web service cookie secret.
export HERMES_WEB_COOKIE_SECRET=XXXXXXXXXXX

# Hermes web service application port number.
export HERMES_WEB_PORT=8888

# Hermes web service url.
export HERMES_WEB_URL=http://localhost:8888
