# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_realtime.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Realtime IMAP client that places email uid upon MQ server for futher processing.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
from prodiguer import mail, rt
from ext_smtp_utils import dispatch as dispatch_emails



def _log(msg):
    """Helper function: logs a message.

    """
    rt.log_mq("EXT-SMTP-REALTIME :: {}".format(msg))


def _requires_reconnect(idle_response):
    """Predicate indicating if IMAP IDLE response indicates connection was dropped.

    """
    # True if response is empty.
    if not isinstance(idle_response, list):
        return True
    elif len(idle_response) == 0:
        return True

    # True if response is server initiated disconnect.
    elif len(idle_response) == 1 and \
         isinstance(idle_response[0], tuple) and \
         idle_response[0][1] == u'BYE':
         return True

    # False otherwise.
    return False


def _requires_dispatch(idle_response):
    """Predicate indicating if IMAP IDLE response indicates new emails.

    """
    # True if server sens an IMAP EXISTS response.
    for data in idle_response:
        if isinstance(data, tuple) and \
           len(data) == 2 and \
           data[1] == u'EXISTS':
           return True

    # False otherwise.
    return False


def execute(throttle=0):
    """Executes realtime SMTP sourced message production.

    :param int throttle: Limit upon number of emails to process.

    """
    try:
        while True:
            # Connect to email server.
            imap_client = mail.connect()

            # Dispatch existing emails.
            dispatch_emails(imap_client)

            # Process IMAP idle events.
            imap_client.idle()
            while True:
                # ... blocks whilst waiting for idle response
                idle_response = imap_client.idle_check()

                # ... reconnects
                if _requires_reconnect(idle_response):
                    _log("Reconnecting to SMTP server")
                    break

                # ... dispatches
                elif _requires_dispatch(idle_response):
                    dispatch_emails()

                # ... other responses can be ignored
                else:
                    pass

    # Log errors.
    except Exception as err:
        rt.log_mq_error(err)

    # Close IMAP client.
    finally:
        if imap_client:
            mail.disconnect(imap_client)
