# -*- coding: utf-8 -*-

# Module imports.
import os

import requests
from tornado.options import define, options

import utils
import utils_convert as convert



# Define command line options.
define("file",
       help="Path to a metrics file to be uploaded to server")
define("duplicate_action",
       help="Action to take when adding a metric with a duplicate hash identifier")

# Metric API endpoints.
_EP = r"/api/1/metric/add?duplicate_action={0}"

# Supported file extensions.
_ENCODING_CSV = "csv"
_ENCODING_JSON = "json"


def _get_group_from_csv_file(filepath):
    """Returns a metric group from a local csv file.

    """
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
    """Returns a metric group from a local json file.

    """
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
    duplicate_action = utils.parse_duplicate_action(options.duplicate_action)
    filepath = utils.parse_filepath(options.file)
    filename = filepath.split("/")[-1]

    # Set payload.
    encoding = utils.parse_encoding(os.path.splitext(filepath)[1][1:])
    payload = _GROUP_FACTORIES[encoding](filepath)

    # Invoke api.
    endpoint = utils.get_endpoint(_EP.format(duplicate_action))
    response = utils.invoke_api(endpoint, verb=requests.post, payload=payload)

    # Log to stdout.
    if 'error' in response:
        utils.log_error("add", response['error'])
    else:
        msg = "processed file: {}".format(filename)
        msg += " (added row count={0}, duplicate row count={1})".format(response['addedCount'], response['duplicateCount'])
        msg += "."
        utils.log("add", msg)


# Main entry point.
if __name__ == '__main__':
    options.parse_command_line()
    _main()
