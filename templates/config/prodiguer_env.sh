# --------------------------------------------------------------------
# General settings
# --------------------------------------------------------------------
# Path to Prodiguer server install directory.
export PRODIGUER_HOME=/opt/prodiguer

# Mode of deployment.
export PRODIGUER_DEPLOYMENT_MODE=test

# Prodiguer client web service url.
export PRODIGUER_CLIENT_WEB_URL=https://prodiguer-test-web.ipsl.fr

# --------------------------------------------------------------------
# DB server settings
# --------------------------------------------------------------------
# Prodiguer mongo server host (includes port).
export PRODIGUER_DB_MONGO_HOST=localhost:27017

# Prodiguer mongo database user password.
export PRODIGUER_DB_MONGO_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer pgres server host (includes port).
export PRODIGUER_DB_PGRES_HOST=localhost:5432

# --------------------------------------------------------------------
# MQ server settings
# --------------------------------------------------------------------
# Prodiguer Rabbit MQ sever host (includes port).
export PRODIGUER_MQ_RABBIT_HOST=localhost:5671

# Prodiguer Rabbit MQ libIGCM user password.
export PRODIGUER_MQ_RABBIT_LIBIGCM_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer Rabbit MQ agent user password.
export PRODIGUER_MQ_RABBIT_USER_PASSWORD=XXXXXXXXXXX

# Prodiguer Rabbit MQ client SSL cert path.
export PRODIGUER_MQ_RABBIT_SSL_CLIENT_CERT=$PRODIGUER_HOME/ops/certs/rabbitmq/client-cert.pem

# Prodiguer Rabbit MQ client SSL cert key path.
export PRODIGUER_MQ_RABBIT_SSL_CLIENT_KEY=$PRODIGUER_HOME/ops/certs/rabbitmq/client-key.pem

# Prodiguer IMAP user password.
export PRODIGUER_MQ_IMAP_PASSWORD=XXXXXXXXXXX

# Prodiguer SMTP user password.
export PRODIGUER_MQ_SMTP_PASSWORD=XXXXXXXXXXX

# --------------------------------------------------------------------
# Web server settings
# --------------------------------------------------------------------
# Prodiguer web service cookie secret.
export PRODIGUER_WEB_API_COOKIE_SECRET=XXXXXXXXXXX

# Prodiguer web service host (includes port).
export PRODIGUER_WEB_HOST=localhost:8888

# Prodiguer web service url.
export PRODIGUER_WEB_URL=https://prodiguer-test-web.ipsl.fr
