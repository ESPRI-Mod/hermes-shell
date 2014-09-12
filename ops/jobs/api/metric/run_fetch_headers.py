# -*- coding: utf-8 -*-

import sys

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/fetch_headers?group={0}&headersonly=true"


def _main(group_id):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id))
    response = utils.invoke_api(endpoint)

    if 'error' in response:
        utils.log("fetch-headers", response['error'])
    else:
        utils.log("fetch-headers", ", ".join(response['headers']))


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1])
