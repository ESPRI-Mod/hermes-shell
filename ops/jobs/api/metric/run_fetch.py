# -*- coding: utf-8 -*-

import sys

from tornado.options import define, options

import utils
import utils_convert as convert



# Define command line options.
define("group",
       help="ID of a metrics group")
define("encoding",
       help="Encoding to which metrics will be converted")
define("filter",
       default=None,
       help="Path to a metrics filter to be applied")

# Target metric API endpoint.
_EP = r"/api/1/metric/fetch?group={0}&format={1}"


def _main():
    """Main entry point.

    """
    # Parse params.
    group_id = utils.parse_group_id(options.group)
    encoding = utils.parse_encoding(options.encoding)
    filepath = utils.parse_filepath(options.filter) if options.filter else None

    # Set payload.
    payload = convert.json_file_to_dict(filepath) if options.filter else None

    # Invoke api.
    endpoint = _EP.format(group_id, encoding)
    endpoint = utils.get_endpoint(endpoint)
    response = utils.invoke_api(endpoint,
                                payload=payload,
                                expecting_json=encoding=='json')

    # Log to stdout.
    if type(response) == dict and 'error' in response:
        utils.log_error("fetch", response['error'])
    else:
        utils.log("fetch", response)


# Main entry point.
if __name__ == '__main__':
    options.parse_command_line()
    _main()
