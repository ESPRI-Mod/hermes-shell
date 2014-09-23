# -*- coding: utf-8 -*-

import sys

import requests

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/delete_lines"


def _main(group_id, lines):
    """Main entry point."""
    # Set payload.
    payload = {
        'group': utils.parse_group_id(group_id),
        'metric_id_list': lines.split("-")
    }

    # Invoke api.
    endpoint = utils.get_endpoint(_EP)
    response = utils.invoke_api(endpoint, verb=requests.post, payload=payload)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("delete-lines", response['error'])
    else:
        utils.log("delete-lines", "Line(s) sucessfully deleted")


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1], sys.argv[2])
