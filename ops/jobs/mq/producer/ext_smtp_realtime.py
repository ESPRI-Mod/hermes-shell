# -*- coding: utf-8 -*-

"""
.. module:: ext_smtp_realtime.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Realtime IMAP client that places email uid upon MQ server for futher processing.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import threading

from prodiguer import mail, rt
from ext_smtp_utils import dispatch



class DispatchEmails(threading.Thread):
    """Dispatches emails upon a new runtime thread.

    """
    def __init__(self):
        """Object constructor.

        """
        threading.Thread.__init__(self, target=dispatch)
        self.start()


def _requires_dispatch(idle_event_data):
    """Returns flag indicating whether IMAP IDLE response contains new email notifications.

    """
    for idle_response in idle_event_data:
        if len(idle_response) == 2 and idle_response[1] == u'EXISTS':
            return True

    return False


def execute(throttle=0):
    """Executes realtime SMTP sourced message production.

    :param int throttle: Limit upon number of emails to process.

    """
    try:
        # Get imap client.
        imap_client = mail.connect()

        # Clear items marked for deletion.
        imap_client.expunge()

        # Dispatch initial email stack.
        DispatchEmails()

        # Process IMAP idle events.
        imap_client.idle()
        while True:
            if _requires_dispatch(imap_client.idle_check()):
                DispatchEmails()

    # Log errors.
    except Exception as err:
        rt.log_mq_error(err)

    # Close IMAP client.
    finally:
        if imap_client:
            mail.disconnect(imap_client)
