# -*- coding: utf-8 -*-

"""
.. module:: mock_libigcm_to_mq_server.py
   :copyright: Copyright "Apr 26, 2013", Institute Pierre Simon Laplace
   :license: GPL/CeCIL
   :platform: Unix
   :synopsis: Mocks simulation monitoring message production.

.. moduleauthor:: Mark Conway-Greenslade (formerly Morgan) <momipsl@ipsl.jussieu.fr>


"""
import datetime, random, sys, uuid

from prodiguer.mq import constants, utils
from prodiguer import db



# Set of existing simulations.
_SIMULATIONS = None

# Set of simulation states.
_SIMULATION_STATES = db.constants.EXECUTION_STATE_SET


def _get_sim_state():
    """Returns a random simulation execution state."""
    idx = random.randint(0, len(_SIMULATION_STATES) - 1)

    return _SIMULATION_STATES[idx]


def _get_sim_name():
    """Returns a random simulation name."""
    global _SIMULATIONS
    if _SIMULATIONS is None:
        _SIMULATIONS = db.dao.get_all(db.types.Simulation)
        _SIMULATIONS = [s.name for s in _SIMULATIONS if s.name.startswith('v3')]

    idx = random.randint(0, len(_SIMULATIONS) - 1)

    return _SIMULATIONS[idx]


def _get_name(mtype):
    """Returns a random CV name from db."""
    return db.cache.get_random_name(mtype)


def _get_ampq_message_properties(message_type):
    """Returns AMPQ message properties."""
    return utils.create_ampq_message_properties(
        constants.USER_IGCM,
        constants.PRODUCER_IGCM,
        constants.APP_MONITORING,
        message_type=message_type)


def _get_message_1000():
    """Returns a mock message: type = 1000 (new simulation)."""
    return {
        'activity': _get_name(db.types.Activity),
        'compute_node': _get_name(db.types.ComputeNode),
        'compute_node_login': _get_name(db.types.ComputeNodeLogin),
        'compute_node_machine': _get_name(db.types.ComputeNodeMachine),
        'execution_start_date': datetime.datetime.now(),
        'execution_state': _get_name(db.types.SimulationState),
        'experiment': _get_name(db.types.Experiment),
        'event_type': 'new',
        'model': _get_name(db.types.Model),
        'name': "test-" + str(uuid.uuid4())[:6],
        'space': _get_name(db.types.SimulationSpace)
    }


def _get_message_2000():
    """Returns a mock message: type = 2000 (simulation state change)."""
    return {
        'event_type': 'state_change',
        'name': _get_sim_name(),
        'state': _get_sim_state()
    }


# Message factory meta-info.
_FACTORY_INFO = (
    (constants.TYPE_SMON_1000, _get_message_1000, 1),
    (constants.TYPE_SMON_2000, _get_message_2000, 3)
    )


def _yield_messages():
    """Yields mock simulation monitoring messages."""
    for type_id, content_factory, count in _FACTORY_INFO:
        for _ in range(count):
            props = _get_ampq_message_properties(type_id)
            content = content_factory()
            yield utils.Message(constants.EXCHANGE_PRODIGUER_IN, props, content)


def _main(limit):
	"""Main entry point handler."""
	utils.publish(_yield_messages, publish_limit=limit)


# Main entry point.
if __name__ == "__main__":
    _main(None if len(sys.argv) <= 1 else int(sys.argv[1]))
