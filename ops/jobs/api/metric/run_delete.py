# -*- coding: utf-8 -*-

import sys

import requests

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/delete?group={0}"


def _main(group_id):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id))
    response = utils.invoke_api(endpoint, verb=requests.post)

    if 'error' in response:
        utils.log("delete", response['error'])
    else:
        utils.log("delete", "{0} was deleted".format(group_id))


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1])
