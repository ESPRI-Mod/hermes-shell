# -*- coding: utf-8 -*-

# Module imports.
import json
import uuid
from os.path import dirname, abspath, exists, join

from prodiguer.utils import runtime as rt



# Set directory paths.
DIR = dirname(abspath(__file__))
DIR_FILES = join(DIR, "demo_files")

# Set file paths.
METRICS_CSV = join(DIR_FILES, "HISTA2_K1.csv")
METRICS_JSON = join(DIR_FILES, "HISTA2_K1.json")

# Set API base endpoint.
_API_DEV = r"http://localhost:8888"
_API_TEST = r"http://prodiguer-test-web.ipsl.jussieu.fr"
_API_PROD = r"http://prodiguer-web.ipsl.jussieu.fr"

# Set API endpoints.
_EP_BASE = _API_TEST + r"/api/1/metric"
EP_ADD = _EP_BASE + r"/add"
EP_LIST_GROUP = _EP_BASE + r"/list_group"
EP_FETCH = _EP_BASE + r"/fetch?group={0}"
EP_FETCH_HEADERS = EP_FETCH + r"&headersonly=true"
EP_FETCH_CSV = EP_FETCH + r"&format=csv"
EP_DELETE_LINES = _EP_BASE + r"/delete"
EP_DELETE_GROUP = _EP_BASE + r"/delete_group?group={0}"



def log(action, msg=None):
    """Logger helper function."""
    if not msg:
        msg = action
    else:    
        msg = action + " :: " + str(msg)
    rt.log(msg, module="METRIC")



def invoke_api(verb, url, payload=None):
    """Invokes api endpoint."""
    data = headers = None
    if payload:
        headers = {'content-type': 'application/json'}
        data = json.dumps(payload)

    return verb(url, data=data, headers=headers)


def get_valid_metrics():
    """Returns a set of valid metrics."""
    return {
        u'group': "test-" + str(uuid.uuid1())[:6],
        u'columns': [
            u'a', u'b', u'c', u'd', u'e', u'f'
        ],
        u'metrics': [
            [1, 2, 3, 4, 5, 6],
            [1, 2, 3, 4, 5, 6],
            [1, 2, 3, 4, 5, 6],
            [1, 2, 3, 4, 5, 6],
            [1, 2, 3, 4, 5, 6],
            [1, 2, 3, 4, 5, 6],
        ],      
    }
