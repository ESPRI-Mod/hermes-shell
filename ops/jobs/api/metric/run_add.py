# -*- coding: utf-8 -*-

# Module imports.
import os, sys

import requests
from tornado.options import define, options

from prodiguer.utils import convert

import utils



# Define command line options.
define("file",
       help="Path to a metrics file to be uploaded to server")

# Metric API endpoints.
_EP = r"/api/1/metric/add"

# Supported file extensions.
_ENCODING_CSV = "csv"
_ENCODING_JSON = "json"


def _get_group_from_csv_file(filepath):
    """Returns a metric group from a local csv file."""
    # Set group name = file name.
    group_name = unicode(os.path.basename(filepath).split(".")[0])
    group_name = group_name.lower()

    # Set group.
    group = convert.csv_file_to_dict(filepath)
    group = {
        u'group': group_name,
        u'columns': group[0].keys(),
        u'metrics': [m.values() for m in group]
    }

    return group


def _get_group_from_json_file(filepath):
    """Returns a metric group from a local json file."""
    return convert.json_file_to_dict(filepath)


# Map of supported group factories.
_GROUP_FACTORIES = {
    _ENCODING_CSV: _get_group_from_csv_file,
    _ENCODING_JSON: _get_group_from_json_file
}


def _main():
    """Main entry point.

    """
    # Parse params.
    filepath = utils.parse_filepath(options.file)
    filename = filepath.split("/")[-1]
    utils.log("add", "uploading metrics file: {}".format(filename))

    # Set payload.
    encoding = utils.parse_encoding(os.path.splitext(filepath)[1][1:])
    payload = _GROUP_FACTORIES[encoding](filepath)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP)
    response = utils.invoke_api(endpoint, verb=requests.post, payload=payload)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("add", response['error'])
    else:
        utils.log("add", "metrics uploaded (file={0} , group={1})".format(filepath.split("/")[-1], response['group']))


# Main entry point.
if __name__ == '__main__':
    options.parse_command_line()
    _main()
