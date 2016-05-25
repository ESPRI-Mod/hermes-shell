# --------------------------------------------------------------------
# General settings
# --------------------------------------------------------------------
# Path to Prodiguer server install directory.
export HERMES_HOME=$HOME/prodiguer

# Mode of deployment (dev|test|prod).
export HERMES_DEPLOYMENT_MODE=dev

# Type of machine (dev|db|mq|mq).
export HERMES_MACHINE_TYPE=dev

# Prodiguer client web service url.
export HERMES_CLIENT_WEB_URL=http://localhost:8888

# --------------------------------------------------------------------
# DB server settings
# --------------------------------------------------------------------
# Prodiguer MongoDB server hostname & port.
export HERMES_DB_MONGO_HOST=localhost:27017

# Prodiguer MongoDB password for the prodiguer-db-mongo-user account.
export HERMES_DB_MONGO_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer PostgreSQL server hostname & port.
export HERMES_DB_PGRES_HOST=localhost:5432

# Prodiguer PostgreSQL pgdump executable path.
export HERMES_DB_PGRES_PGDUMP=/usr/bin/pg_dump

# Prodiguer PostgreSQL password for the prodiguer-db-user account.
export HERMES_DB_PGRES_USER_PASSWORD=XXXXXXXXXXX

# --------------------------------------------------------------------
# MQ server settings
# --------------------------------------------------------------------
# Prodiguer RabbitMQ sever host (includes port).
export HERMES_MQ_RABBIT_HOST=localhost:5672

# Prodiguer RabbitMQ sever protocol (i.e. whether to communicate over ssl).
export HERMES_MQ_RABBIT_PROTOCOL=ampq

# Prodiguer RabbitMQ libIGCM user password.
export HERMES_MQ_RABBIT_LIBIGCM_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer RabbitMQ agent user password.
export HERMES_MQ_RABBIT_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer RabbitMQ client SSL cert path.
export HERMES_MQ_RABBIT_SSL_CLIENT_CERT=

# Prodiguer RabbitMQ client SSL cert key path.
export HERMES_MQ_RABBIT_SSL_CLIENT_KEY=

# Prodiguer IMAP mailbox.
export HERMES_MQ_IMAP_MAILBOX=AMPQ-TEST

# Prodiguer IMAP user password.
export HERMES_MQ_IMAP_PASSWORD=XXXXXXXXXXX

# Prodiguer SMTP user password.
export HERMES_MQ_SMTP_PASSWORD=XXXXXXXXXXX

# --------------------------------------------------------------------
# Web server settings
# --------------------------------------------------------------------
# Prodiguer web service cookie secret.
export HERMES_WEB_COOKIE_SECRET=XXXXXXXXXXX

# Prodiguer web service application port number.
export HERMES_WEB_PORT=8888

# Prodiguer web service url.
export HERMES_WEB_URL=http://localhost:8888
