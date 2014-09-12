# -*- coding: utf-8 -*-

import sys

import requests

import utils



# Metric API endpoints.
_EP = r"/api/1/metric/delete_lines"


def _main(lines):
    """Main entry point."""
    # Set payload.
    payload = {
        'metric_id_list': lines.split("-")
    }

    # Invoke api.
    endpoint = utils.get_endpoint(_EP)
    response = utils.invoke_api(endpoint, verb=requests.post, payload=payload)

    # Log to stdout.
    if 'error' in response:
        utils.log("delete-lines", response['error'])
    else:
        utils.log("delete-lines", response)


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1])
