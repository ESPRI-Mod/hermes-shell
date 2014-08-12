# -*- coding: utf-8 -*-

# Module imports.
import datetime
import random
import time

import requests

from prodiguer import db
from prodiguer.api.handlers import utils as api_utils
from prodiguer.utils import runtime as rt
from demos import utils as u



# API endpoint to post event data to.
_API_EP = '/monitoring/event'

# API not running error message.
_ERR_API_NOT_RUNNING = "API service needs to be started."

# List of simulations.
_s_list = None

# List of states that a new simulation is like to be in.
_NEW_STATES = ("RUNNING", "QUEUED")

# Time delay in seconds in between publishing events.
_PUBLISHING_INTERVAL = 1


def _invoke_api(ei):
    """Invokes prodiguer API."""
    try:
        ep = api_utils.get_endpoint(_API_EP)
        requests.get(ep, params=ei)
    except requests.exceptions.ConnectionError:
        rt.log_api(_ERR_API_NOT_RUNNING, level=rt.LOG_LEVEL_WARNING)
    except Exception as e:
        rt.log_error(e)


def _get_simulation_list():
    """Returns a mock list of simulations."""
    global _s_list

    if _s_list is None:
        _s_list = db.dao.get_all(db.types.Simulation)
        _s_list = [s for s in _s_list if s.name.startswith("v3")]

    return _s_list


def _get_simulation():
    """Returns a mock simulation."""    
    s_list = _get_simulation_list()

    return s_list[random.randint(0, len(s_list) - 1)]


def _publish_new_simulation():
    # Set helper vars.
    activity = db.cache.get_random(db.types.Activity)
    compute_node = db.cache.get_random(db.types.ComputeNode)
    compute_node_login = db.cache.get_random(db.types.ComputeNodeLogin)
    compute_node_machine = db.cache.get_random(db.types.ComputeNodeMachine)
    experiment = db.cache.get_random(db.types.Experiment)
    model = db.cache.get_random(db.types.Model)
    space = db.cache.get_random(db.types.SimulationSpace)
    state = _NEW_STATES[random.randint(0, len(_NEW_STATES) - 1)]
    state = db.cache.get_item(db.types.SimulationState, state)

    # Create.
    s = db.types.Simulation()   
    # ... collections.
    s.forcings = []
    # ... foreign keys.
    s.activity_id = activity.id
    s.compute_node_id = compute_node.id
    s.compute_node_login_id = compute_node_login.id
    s.compute_node_machine_id = compute_node_machine.id
    s.execution_state_id = state.id
    s.experiment_id = experiment.id
    s.model_id = model.id
    s.parent_simulation_id = None
    s.space_id = space.id
    # ... attributes
    s.ensemble_member = u.get_unicode(15)
    s.execution_start_date = datetime.datetime.now()
    s.execution_end_date = None
    s.name = u"v3." + experiment.name + u"." + u.get_unicode(5)
    s.output_start_date = datetime.datetime.now()
    s.output_end_date = datetime.datetime.now()
    s.parent_simulation_branch_date = None

    # Persist.
    db.session.add(s)
    
    # Set event information.
    ei = {
        'event_type': 'new',
        'id': s.id
    }

    # Log.
    msg = "Posting new simulation to API: {0} ---> {1}"
    msg = msg.format(s.id, s.name)
    rt.log_api(msg)

    # Post to API.
    _invoke_api(ei)


def _publish_simulation_status_change():
    # Load data.
    state = db.cache.get_random(db.types.SimulationState)
    simulation = _get_simulation()

    # Set event information.
    ei = {
        'event_type': 'state_change',
        'name': simulation.name,
        'id': simulation.id,
        'state': state.name
    }

    msg = "Posting simulation status change to API: {0} ---> {1}"
    msg = msg.format(ei['name'], ei['state'])
    rt.log_api(msg)

    _invoke_api(ei)


def _publish():
    # Publish new simulations.
    if random.randint(0, 3) == 0:
        _publish_new_simulation()

    # Publish simulation status updates.
    else:
        _publish_simulation_status_change()


def _main():
    # Main entry point.
    while True:
        time.sleep(_PUBLISHING_INTERVAL)
        _publish()


# Main entry point.
if __name__ == "__main__":
    _main()
