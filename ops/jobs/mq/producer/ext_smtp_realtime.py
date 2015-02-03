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
import ext_smtp_utils as utils




class Thread(threading.Thread):
    """Wrapper around a runtime thread.

    """
    def __init__(self, t, *args):
        """Object constructor.

        """
        threading.Thread.__init__(self, target=t, args=args)
        self.start()


def _log(msg):
    """Helper function: writes to MQ log.

    """
    rt.log_mq("EXT-SMTP-REALTIME :: {}".format(msg))


def _has_new_email_notification(idle_event_data):
    """Returns flag indicating whether IMAP IDLE response contains new email notifications.

    """
    for idle_response in idle_event_data:
        if len(idle_response) == 2 and idle_response[1] == u'EXISTS':
            return True

    return False


def _on_imap_idle_event(idle_event_data):
    """IMAP IDLE event handler.

    """
    _log("_on_imap_idle_event data: {}".format(idle_event_data))
    # Dispatch emails to MQ server.
    emails = sorted(set(mail.get_email_uid_list()))
    if emails:
        _log("_on_imap_idle_event new emails: {}".format(emails))
        utils.dispatch(emails)


def _init(throttle):
    """Initializes module state.

    """
    # Get imap client.
    imap_client = mail.connect()

    # Clear items marked for deletion.
    imap_client.expunge()

    # Dispatch initial email stack on new thread.
    Thread(utils.dispatch, mail.get_email_uid_list(imap_client))

    return imap_client


def execute(throttle=0):
    """Executes realtime SMTP sourced message production.

    :param int throttle: Limit upon number of emails to process.

    """
    # Process IMAP idle events.
    try:
        imap_client = _init(throttle)
        imap_client.idle()
        while True:
            idle_event_data = imap_client.idle_check()
            if _has_new_email_notification(idle_event_data):
                Thread(_on_imap_idle_event, idle_event_data)

    # Log errors.
    except Exception as err:
        rt.log_mq_error(err)

    # Close imap client.
    finally:
        _log("closing message producer")
        if imap_client:
            mail.disconnect(imap_client)
