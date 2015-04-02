# -*- coding: utf-8 -*-

import requests
from tornado.options import define, options

import utils
import utils_convert as convert



# Define command line options.
define("group",
       help="ID of a metrics group")
define("filter",
       default=None,
       help="Path to a metrics filter to be applied prior to deletion")

# Metric API endpoint.
_EP = r"/api/1/metric/delete?group={0}"


def _main():
    """Main entry point.

    """
    # Parse params.
    group_id = utils.parse_group_id(options.group)
    filepath = utils.parse_filepath(options.filter) if options.filter else None

    # Set payload.
    payload = convert.json_file_to_dict(filepath) if options.filter else None

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id))
    response = utils.invoke_api(endpoint, verb=requests.post, payload=payload)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("delete", response['error'])
    else:
        if filepath:
            utils.log("delete", "Group {0} metrics sucessfully deleted".format(group_id))
        else:
            utils.log("delete", "Group {0} sucessfully deleted".format(group_id))



# Main entry point.
if __name__ == '__main__':
    options.parse_command_line()
    _main()
