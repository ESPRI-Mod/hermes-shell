# -*- coding: utf-8 -*-

import sys

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/fetch_setup?group={0}&columns={1}"



def _main(group_id, columns=None):
    """Main entry point."""
    # Parse params.
    group_id = utils.parse_group_id(group_id)
    columns = columns or "all"

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(group_id, columns))
    response = utils.invoke_api(endpoint, expecting_json=False)

    print response
    return
    # Log to stdout.
    if 'error' in response:
        utils.log("fetch-setup", response['error'])
    else:
        utils.log("fetch-setup", response['data'])


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1],
          sys.argv[2] if len(sys.argv) > 2 else None)
