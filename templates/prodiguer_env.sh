# --------------------------------------------------------------------
# General settings
# --------------------------------------------------------------------
# Path to Prodiguer server install directory.
export PRODIGUER_HOME=/opt/prodiguer

# Mode of deployment.
export PRODIGUER_DEPLOYMENT_MODE=dev

# Prodiguer client web service url.
export PRODIGUER_CLIENT_WEB_URL=http://localhost:8888

# --------------------------------------------------------------------
# DB server settings
# --------------------------------------------------------------------
# Prodiguer mongo server host (includes port).
export PRODIGUER_DB_MONGO_HOST=localhost:27017

# Prodiguer mongo database user password.
export PRODIGUER_DB_MONGO_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer pgres server host (includes port).
export PRODIGUER_DB_PGRES_HOST=localhost:5432

# Prodiguer pgres pgdump executable path.
export PRODIGUER_DB_PGRES_PGDUMP=/usr/bin/pg_dump

# --------------------------------------------------------------------
# MQ server settings
# --------------------------------------------------------------------
# Prodiguer Rabbit MQ sever host (includes port).
export PRODIGUER_MQ_RABBIT_HOST=localhost:5672

# Prodiguer Rabbit MQ sever protocol (i.e. whether to communicate over ssl).
export PRODIGUER_MQ_RABBIT_PROTOCOL=ampq

# Prodiguer Rabbit MQ libIGCM user password.
export PRODIGUER_MQ_RABBIT_LIBIGCM_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer Rabbit MQ agent user password.
export PRODIGUER_MQ_RABBIT_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer Rabbit MQ client SSL cert path.
export PRODIGUER_MQ_RABBIT_SSL_CLIENT_CERT=

# Prodiguer Rabbit MQ client SSL cert key path.
export PRODIGUER_MQ_RABBIT_SSL_CLIENT_KEY=

# Prodiguer IMAP mailbox.
export PRODIGUER_MQ_IMAP_MAILBOX=AMPQ-TEST

# Prodiguer IMAP user password.
export PRODIGUER_MQ_IMAP_PASSWORD=XXXXXXXXXXX

# Prodiguer SMTP user password.
export PRODIGUER_MQ_SMTP_PASSWORD=XXXXXXXXXXX

# --------------------------------------------------------------------
# Web server settings
# --------------------------------------------------------------------
# Prodiguer web service cookie secret.
export PRODIGUER_WEB_API_COOKIE_SECRET=XXXXXXXXXXX

# Prodiguer web service application port number.
export PRODIGUER_WEB_PORT=8888

# Prodiguer web service url.
export PRODIGUER_WEB_URL=http://localhost:8888
