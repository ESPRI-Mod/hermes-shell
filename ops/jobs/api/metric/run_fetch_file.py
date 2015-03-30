# -*- coding: utf-8 -*-
import json, os

from tornado.options import define, options

import utils



# Define command line options.
define("group",
       help="ID of a metrics group")
define("output_dir",
       type=str,
       help="Path to which downloaded metrics files will be written.")

# Target metric API endpoint.
_EP = r"/api/1/metric/fetch?group={0}&format=json"


def _main():
    """Main entry point.

    """
    # Parse params.
    options.parse_command_line()
    group_id = utils.parse_group_id(options.group)
    output_dir = utils.parse_group_id(options.output_dir)

    # Invoke api.
    endpoint = _EP.format(group_id, 'json')
    endpoint = utils.get_endpoint(endpoint)
    response = utils.invoke_api(endpoint, expecting_json=True)

    # Log to stdout.
    if type(response) == dict and 'error' in response:
        utils.log_error("fetch", response['error'])
    else:
        with open(os.path.join(output_dir, "metrics.json"), 'w') as outfile:
            outfile.write(json.dumps(response, indent=4))


# Main entry point.
if __name__ == '__main__':
    _main()
