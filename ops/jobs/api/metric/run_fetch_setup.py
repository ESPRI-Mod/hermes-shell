# -*- coding: utf-8 -*-

import sys

from prodiguer.utils import convert

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/fetch_setup?group={0}"



def _main(group_id, filepath=None):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)
    if filepath:
        filepath = utils.parse_filepath(filepath)

    # Set payload.
    payload = convert.json_file_to_dict(filepath) if filepath else None

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id))
    response = utils.invoke_api(endpoint, payload=payload)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("fetch-setup", response['error'])
    else:
        utils.log("fetch-setup", response)


# Main entry point.
if __name__ == '__main__':
    # Unpack args.
    group_id = sys.argv[1]
    try:
        filepath = sys.argv[2]
    except IndexError:
        filepath = None

    # Invoke entry point.
    _main(group_id, filepath)
