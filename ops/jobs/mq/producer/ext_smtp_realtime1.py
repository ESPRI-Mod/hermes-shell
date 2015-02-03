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



class _State(object):
    """Module state bag.

    """
    def __init__(self):
        self.throttle = 0
        self.emails = set([])


# Module state bag.
_STATE = _State()

# Thread synchronization lock.
_LOCK = threading.Lock()


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
    # Escape if no need to process event.
    if not _has_new_email_notification(idle_event_data):
        return

    # Caclulate new emails.
    emails = mail.get_email_uid_list()
    new_emails = sorted(set(emails).difference(_STATE.emails))

    # Dispatch new emails to MQ server.
    if new_emails:
        _log("imap_client.idle_check returned new emails {}".format(new_emails))
        with _LOCK:
            _STATE.emails.update(new_emails)
        utils.dispatch(new_emails)


def _init(throttle):
    """Initializes module state.

    """
    # Set throttle.
    _State.throttle = throttle

    # Get imap client.
    imap_client = mail.connect()

    # Clear items marked for deletion.
    imap_client.expunge()

    # Set initial email stack.
    _STATE.emails.update(mail.get_email_uid_list(imap_client))

    # Dispatch initial email stack on new thread.
    Thread(utils.dispatch, list(_STATE.emails))

    return imap_client


def execute(throttle=0):
    """Executes realtime SMTP sourced message production.

    :param int throttle: Limit upon number of emails to process.

    """
    try:
        # Initialize.
        imap_client = _init(throttle)

        # Process IMAP idle events on new thread.
        imap_client.idle()
        while True:
            _log("invoking imap_client.idle_check")
            Thread(_on_imap_idle_event, imap_client.idle_check())

    # Log errors.
    except Exception as err:
        rt.log_mq_error(err)

    # Close imap client.
    finally:
        rt.log_mq("Closing ext-smtp-realtime message producer")
        if imap_client:
            mail.disconnect(imap_client)
