
import pika

from prodiguer.utils import config as cfg


connection = pika.BlockingConnection(pika.URLParameters(str(cfg.mq.connection)))

channel = connection.channel()

channel.queue_bind(exchange='x-in', queue='q-in-log')


def callback(ch, method, properties, body):
    print " [x] %r:%r" % (method.routing_key, body,)


channel.basic_consume(callback, queue='q-in-log', no_ack=True)


try:
    channel.start_consuming()
except KeyboardInterrupt:
    channel.stop_consuming()
connection.close()

# method_frame, header_frame, body = channel.basic_get('q-in-log')

# print method_frame, header_frame, body

# print connection


def _main():
    """Main entry point handler."""
    print "Hello Dolly"


# Main entry point.
if __name__ == "__main__":
    _main()
