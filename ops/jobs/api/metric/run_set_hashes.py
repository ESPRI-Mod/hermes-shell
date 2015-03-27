# -*- coding: utf-8 -*-

# Module imports.
import requests

from tornado.options import define, options

import utils



# Define command line options.
define("group",
       type=str,
       help="Name of metrics group whose hash identifiers are to be reset (e.g. cmip5-1).")


# Metric API endpoint.
_EP = r"/api/1/metric/set_hashes?group={0}"


def _main():
    """Main entry point.

    """
    # Parse params.
    options.parse_command_line()
    group = utils.parse_group_id(options.group)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group))
    response = utils.invoke_api(endpoint, verb=requests.post)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("set_hashes", response['error'])
    else:
        utils.log("set_hashes",
                  "Group {0} hash identifiers sucessfully set.".format(group))


# Main entry point.
if __name__ == '__main__':
    _main()
