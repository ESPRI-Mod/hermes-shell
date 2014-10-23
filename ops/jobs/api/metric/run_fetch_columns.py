# -*- coding: utf-8 -*-

import sys

from tornado.options import define, options

import utils



# Define command line options.
define("group",
       help="ID of a metrics group")
define("include_db_id",
       default=True,
       help="Flag indicating whether to also return db id column")

# Metric API endpoint.
_EP = r"/api/1/metric/fetch_columns?group={0}&include_db_id={1}"


def _main():
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(options.group)
    include_db_id = utils.parse_boolean(options.include_db_id)

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
    options.parse_command_line()
    _main()
