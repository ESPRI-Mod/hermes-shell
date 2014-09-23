# -*- coding: utf-8 -*-

import sys

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/fetch_columns?group={0}&include_db_id={1}"


def _main(group_id, include_db_id):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)
    include_db_id = utils.parse_boolean(include_db_id)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id, include_db_id))
    response = utils.invoke_api(endpoint)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("fetch-columns", response['error'])
    else:
        utils.log("fetch-columns", ", ".join(response['columns']))


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1], 'false' if len(sys.argv) <= 2 else sys.argv[2])
