# -*- coding: utf-8 -*-

import utils



# Metric API endpoint.
_EP = r"/api/1/ops/heartbeat"



def _main():
    """Main entry point."""
    # Invoke api.
    endpoint = utils.get_endpoint(_EP)
    response = utils.invoke_api(endpoint)

    # Log to stdout.
    utils.log("heartbeat", response)


# Main entry point.
if __name__ == '__main__':
    _main()