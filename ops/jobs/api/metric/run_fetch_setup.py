# -*- coding: utf-8 -*-

import sys

from tornado.options import define, options

from prodiguer.utils import convert

import utils



# Define command line options.
define("group",
       help="ID of a metrics group")
define("filter",
       default=None,
       help="Path to a metrics filter to be applied")

# Metric API endpoint.
_EP = r"/api/1/metric/fetch_setup?group={0}"



def _main():
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(options.group)
    filepath = utils.parse_filepath(options.filter) if options.filter else None

    # Set payload.
    payload = convert.json_file_to_dict(filepath) if options.filter else None

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
    options.parse_command_line()
    _main()
