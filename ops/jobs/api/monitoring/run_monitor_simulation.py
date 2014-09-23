# -*- coding: utf-8 -*-

import sys, uuid

import utils



# Metric API endpoint.
_EP = r"/api/1/monitoring/fe/ws"


def _parse_simulation_uid(simulation_uid):
    """Parses the simulation unique identifier."""
    simulation_uid = unicode(simulation_uid).strip()
    try:
        uuid.UUID(simulation_uid)
    except ValueError:
        raise ValueError("Simulation uid must be a universally unique identifer.")

    return simulation_uid


def _main(simulation_uid):
    """Main entry point."""
    # Parse inputs.
    _parse_simulation_uid(simulation_uid)

    utils.log("TODO - monitor simulation: {0}".format(simulation_uid))


# Main entry point.
if __name__ == '__main__':
    _main(sys.argv[1])
