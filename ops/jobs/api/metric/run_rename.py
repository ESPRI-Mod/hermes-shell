# -*- coding: utf-8 -*-

# Module imports.
import requests

from tornado.options import define, options

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/rename?group={0}&new_name={1}"


# Define command line options.
define("group",
       type=str,
       help="Name of metrics group to be renamed (e.g. cmip5-1).")
define("new_name",
       type=str,
       help="New group name.")


def _main():
    """Main entry point.

    """
    # Parse params.
    options.parse_command_line()
    group = utils.parse_group_id(options.group)
    new_name = utils.parse_group_id(options.new_name)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group, new_name))
    response = utils.invoke_api(endpoint, verb=requests.post)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("rename", response['error'])
    else:
        utils.log("rename",
                  "Group {0} sucessfully renamed {1}".format(group, new_name))


# Main entry point.
if __name__ == '__main__':
    _main()
