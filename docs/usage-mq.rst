============================
HERMES Shell MQ Commands
============================

hermes-mq-daemons-ctl
----------------------------

Launches supervisorctl for fine grained control over daemonized MQ agents.

hermes-mq-daemons-init
----------------------------

Initialises & launches MQ daemon processes.

hermes-mq-daemons-kill
----------------------------

Immediately terminates all MQ daemon processes.

hermes-mq-daemons-kill-phase-1
----------------------------

Launches MQ daemon termination phase 1: stops smtp-listener daemon.

hermes-mq-daemons-kill-phase-2
----------------------------

Launches MQ daemon termination phase 2: stops remaining MQ daemons.

hermes-mq-daemons-reset-logs
----------------------------

Deletes all MQ daemon related logs.

hermes-mq-daemons-status
----------------------------

Display status of all MQ daemon processes.

hermes-mq-daemons-update-config
----------------------------

Updates supervisord.conf file for the MQ daemon processes.

hermes-mq-daemons-update-config-for-debug
----------------------------

Updates supervisord.conf file for the MQ daemon processes in support of debugging.

hermes-mq-import-broker-definitions
----------------------------

Imports RabbitMQ broker definitions (i.e. vhost, exchange, queue & user definitions).

**PASSWORD**

	Password of RabbitMQ hermes-mq-admin user account.

hermes-mq-produce
----------------------------

Launches an MQ agent that produces new messages.

**QUEUE-NAME**

	Name of queue from to which messages will be published.

**THROTTLE**

	Limit of number of messages to publish (0 = unlimited).

hermes-mq-purge-queues
----------------------------

Deletes the contents of all queues.

**PASSWORD**

	Password of RabbitMQ hermes-mq-admin user account.

hermes-mq-purge-debug-queues
----------------------------

Deletes the contents of all debug queues, i.e. those queues used in testing.

**PASSWORD**

	Password of RabbitMQ hermes-mq-admin user account.

hermes-mq-purge-live-queues
----------------------------

Deletes the contents of all live queues, i.e. those queues used in production.

**PASSWORD**

	Password of RabbitMQ hermes-mq-admin user account.

hermes-mq-run-agent
----------------------------

Launches an MQ agent that consumes messages placed upon a queue.

**QUEUE-NAME**

	Name of queue from which to consume messages.

**THROTTLE**

	Limit of number of messages to consume (0 = unlimited).
