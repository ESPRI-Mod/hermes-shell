# -*- coding: utf-8 -*-

import sys

import requests
from prodiguer.utils import convert

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/fetch_filtered?group={0}&include_db_id={1}"



def _main(group_id, include_db_id, filepath):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)
    include_db_id = utils.parse_boolean(include_db_id)
    filepath = utils.parse_filepath(filepath)

    # Set payload.
    payload = convert.json_file_to_dict(filepath)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id, include_db_id))
    response = utils.invoke_api(endpoint, verb=requests.get, payload=payload)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("fetch-filtered", response['error'])
    else:
        utils.log("fetch-filtered", response)


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1], sys.argv[2], sys.argv[3])
