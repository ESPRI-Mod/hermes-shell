# -*- coding: utf-8 -*-

import sys

from tornado.options import define, options

import utils



# Define command line options.
define("group",
       help="ID of a metrics group")

# Metric API endpoint.
_EP = r"/api/1/metric/fetch_columns?group={0}"


def _main():
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(options.group)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id))
    response = utils.invoke_api(endpoint)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("fetch-columns", response['error'])
    else:
        utils.log("fetch-columns", ", ".join(response['columns']))


# Main entry point.
if __name__ == '__main__':
    options.parse_command_line()
    _main()
