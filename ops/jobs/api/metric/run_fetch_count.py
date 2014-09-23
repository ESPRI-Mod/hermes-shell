# -*- coding: utf-8 -*-

import sys

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/fetch_count?group={0}"


def _main(group_id):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id))
    response = utils.invoke_api(endpoint)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("fetch-count", response['error'])
    else:
        utils.log("fetch-count", response['count'])


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1])
