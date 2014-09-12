# -*- coding: utf-8 -*-

import utils



# Metric API endpoint.
_EP = r"/api/1/metric/list"



def _main():
    """Main entry point."""
    # Invoke api.
    endpoint = utils.get_endpoint(_EP)
    response = utils.invoke_api(endpoint)

    if 'error' in response:
        utils.log("list", response['error'])
    else:
        utils.log("list", ", ".join(response['groups']))


# Main entry point.
if __name__ == '__main__':
    _main()