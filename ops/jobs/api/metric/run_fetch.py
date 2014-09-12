# -*- coding: utf-8 -*-

import sys

import utils



# Target metric API endpoint.
_EP = r"/api/1/metric/fetch?group={0}&format={1}"


def _main(group_id, encoding=None):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)
    encoding = utils.parse_encoding(encoding)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id, encoding))
    response = utils.invoke_api(endpoint, expecting_json=False)

    utils.log("fetch", response)


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1],
          None if len(sys.argv) <= 2 else sys.argv[2])
