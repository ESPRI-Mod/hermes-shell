# -*- coding: utf-8 -*-

import utils



# Metric API endpoint.
_EP = r"/api/1/ops/list_endpoints"

# Set of endpoint types.
_EP_TYPES = set(['metric', 'monitoring', 'ops'])



def _main():
    """Main entry point."""
    # Invoke api.
    endpoint = utils.get_endpoint(_EP)
    response = utils.invoke_api(endpoint)

    # Log to stdout.
    for endpoint_type in _EP_TYPES:
    	for endpoint in response[endpoint_type]:
	    	utils.log(endpoint)


# Main entry point.
if __name__ == '__main__':
    _main()