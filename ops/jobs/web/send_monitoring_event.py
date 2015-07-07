# -*- coding: utf-8 -*-

"""
.. module:: send_monitoring_event.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Send a test simulation monitoring event.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import argparse
import json

import requests



# Define command line arguments.
_parser = argparse.ArgumentParser("Publishes test monitoring events.")
_parser.add_argument(
    "-mt", "--message-type",
    help="Type of message driving event dispatch",
    dest="message_type",
    type=str,
    default="0000"
    )
_parser.add_argument(
    "-ep", "--endpoint",
    help="Web service endpoint",
    dest="endpoint",
    type=str,
    default=r'http://localhost:8888/api/1/simulation/monitoring/event'
    )
_parser.add_argument(
    "-sim", "--simulation-uid",
    help="UID of a simulation",
    dest="simulation_uid",
    type=str,
    default=u'8319d4eb-c3dc-4592-a90d-baf09c276404'
    )
_parser.add_argument(
    "-job", "--job-uid",
    help="UID of a job",
    dest="job_uid",
    type=str,
    default=u'f59a1cd0-0d76-4dd4-9ef8-8326f2166f1d'
    )


def _invoke(endpoint, verb=requests.post, payload=None):
    """Invokes api endpoint."""
    # Prepare request info.
    data = headers = None
    if payload:
        headers = {'content-type': 'application/json'}
        data = json.dumps(payload)

    # Invoke API.
    response = verb(endpoint, data=data, headers=headers, verify=False)
    if response.status_code != 200:
        raise ValueError("Web service failure: {0}: {1}".format(response.reason, response.status_code))

    return response


def _publish_0000(args):
    """Simulation start."""
    return _invoke(args.endpoint, payload={
        "event_type": u"simulation_start",
        "simulation_uid": args.simulation_uid
    })


def _publish_0100(args):
    """Simulation complete."""
    return _invoke(args.endpoint, payload={
        "event_type": u"simulation_complete",
        "simulation_uid": args.simulation_uid
    })


def _publish_9999(args):
    """Simulation error."""
    return _invoke(args.endpoint, payload={
        "event_type": u"simulation_error",
        "simulation_uid": args.simulation_uid
    })


def _publish_1000(args):
    """Job start."""
    return _invoke(args.endpoint, payload={
        "event_type": u"job_start",
        "job_uid": args.job_uid,
        "simulation_uid": args.simulation_uid
    })


def _publish_1100(args):
    """Job complete."""
    return _invoke(args.endpoint, payload={
        "event_type": u"job_complete",
        "job_uid": args.job_uid,
        "simulation_uid": args.simulation_uid
    })


def _publish_4900(args):
    """Job error."""
    return _invoke(args.endpoint, payload={
        "event_type": u"job_error",
        "job_uid": args.job_uid,
        "simulation_uid": args.simulation_uid
    })


# Set of publishers keyed by message type.
_PUBLISHERS = {
    '0000': _publish_0000,
    '0100': _publish_0100,
    '9999': _publish_9999,
    '1000': _publish_1000,
    '1100': _publish_1100,
    '4900': _publish_4900
}


def _main(args):
    """Main entry point.

    """
    publisher = _PUBLISHERS[args.message_type]
    print("Publishing event: {0} : {1}".format(args.message_type, publisher.__doc__))
    publisher(args)



# Main entry point.
if __name__ == '__main__':
    _main(_parser.parse_args())
