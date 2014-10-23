# -*- coding: utf-8 -*-
import sys, uuid

from tornado.options import define, options

import utils



# Define command line options.
define("simulation_uid",
       help="UID of a simulation")

# Metric API endpoint.
_EP = r"/api/1/monitoring/fe/ws"


def _get_option_simulation_uid():
    """Returns simulation unique identifier from command line options."""
    simulation_uid = unicode(options.simulation_uid)
    try:
        uuid.UUID(simulation_uid)
    except ValueError:
        raise ValueError("Simulation uid must be a universally unique identifer.")

    return simulation_uid


def _main():
    """Main entry point."""
    # Parse options.
    simulation_uid = _get_option_simulation_uid()

    utils.log("TODO - monitor simulation: {0}".format(simulation_uid))


# Main entry point.
if __name__ == '__main__':
    options.parse_command_line()
    _main()
