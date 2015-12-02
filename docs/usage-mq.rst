============================
Prodiguer Shell MQ Commands
============================

prodiguer-mq-daemons-ctl
----------------------------

Launches supervisorctl for fine grained control over daemonized MQ agents.

prodiguer-mq-daemons-init
----------------------------

Initialises & launches MQ daemon processes.

prodiguer-mq-daemons-kill
----------------------------

Immediately terminates all MQ daemon processes.

prodiguer-mq-daemons-kill-phase-1
----------------------------

Launches MQ daemon termination phase 1: stops smtp-listener daemon.

prodiguer-mq-daemons-kill-phase-2
----------------------------

Launches MQ daemon termination phase 2: stops remaining MQ daemons.

prodiguer-mq-daemons-reset-logs
----------------------------

Deletes all MQ daemon related logs.

prodiguer-mq-daemons-status
----------------------------

Display status of all MQ daemon processes.

prodiguer-mq-daemons-update-config
----------------------------

Updates supervisord.conf file for the MQ daemon processes.

prodiguer-mq-daemons-update-config-for-debug
----------------------------

Updates supervisord.conf file for the MQ daemon processes in support of debugging.

prodiguer-mq-import-broker-definitions
----------------------------

Imports RabbitMQ broker definitions (i.e. vhost, exchange, queue & user definitions).

**PASSWORD**

	Password of RabbitMQ prodiguer-mq-admin user account.

prodiguer-mq-produce
----------------------------

Launches an MQ agent that produces new messages.

**QUEUE-NAME**

	Name of queue from to which messages will be published.

**THROTTLE**

	Limit of number of messages to publish (0 = unlimited).

prodiguer-mq-purge-queues
----------------------------

Deletes the contents of all queues.

**PASSWORD**

	Password of RabbitMQ prodiguer-mq-admin user account.

prodiguer-mq-purge-debug-queues
----------------------------

Deletes the contents of all debug queues, i.e. those queues used in testing.

**PASSWORD**

	Password of RabbitMQ prodiguer-mq-admin user account.

prodiguer-mq-purge-live-queues
----------------------------

Deletes the contents of all live queues, i.e. those queues used in production.

**PASSWORD**

	Password of RabbitMQ prodiguer-mq-admin user account.

prodiguer-mq-run-agent
----------------------------

Launches an MQ agent that consumes messages placed upon a queue.

**QUEUE-NAME**

	Name of queue from which to consume messages.

**THROTTLE**

	Limit of number of messages to consume (0 = unlimited).
