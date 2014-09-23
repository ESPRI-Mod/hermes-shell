import json

import pymongo as pm


# Test metrics file.
_TEST_METRICS = '/Users/macg/dev/prodiguer/repos/prodiguer-docs/api/metric/request-payload-add.json'


def _get_db_collection(group_id):
    """Returns db collection."""
    client = pm.MongoClient()
    dbase = client.metrics
    collection = dbase[group_id] if group_id else None

    return collection


def _get_metrics():
    """Returns metrics for upload to db."""
    # Open test metrics json file.
    with open(_TEST_METRICS, 'r') as data_source:
        data = json.loads(data_source.read())

    # Unpack info.
    group_id = data['group']
    columns = data['columns']
    metrics = data['metrics']

    # Return formatted data.
    return group_id, \
           [{c: m[i] for i, c in enumerate(columns)} for m in metrics]


def build_indexes(group_id):
    """Builds metric group db indexes.

    :param str group_id: ID of a metric group.

    """
    collection = _get_db_collection(group_id)

    # TODO index factory by group id.
    indexes = [
        ("Institute", pm.ASCENDING),
        ("Model", pm.ASCENDING),
        ("Var", pm.ASCENDING),
        ("Freq", pm.ASCENDING),
    ]

    collection.create_index(indexes)


def fetch_list():
    """Returns set of groups within metrics database.

    :returns: set of groups within metrics database.
    :rtype: list

    """
    client = pm.MongoClient()
    dbase = client.metrics

    return dbase.collection_names()[1:]


def add(group_id, metrics):
    """Persists a set of metrics to the database.

    :param str group_id: ID of the metric group being added.
    :param list metrics: Set of metric being added.

    :returns: Set of line id's of newly inserted metrics.
    :rtype: list

    """
    collection = _get_db_collection(group_id)

    return collection.insert(metrics)


def fetch(group_id):
    """Returns a group of metrics.

    :param str group_id: ID of the metric group being returned.

    :returns: A group of metrics.
    :rtype: dict

    """
    collection = _get_db_collection(group_id)

    return collection.find()


def fetch_columns(group_id, include_db_cols=True):
    """Returns set of column names associated with a group of metrics.

    :param str group_id: ID of a metric group.
    :param bool include_db_cols: Flag indicating whether the db control cols should be returned.

    :returns: Set of column names associated with a group of metrics.
    :rtype: list

    """
    collection = _get_db_collection(group_id)
    row = collection.find_one()

    cols = sorted(row.keys()) if row else []
    if cols and not include_db_cols:
        cols = [c for c in cols if not c.startswith("_")]

    return cols


def fetch_count(group_id):
    """Returns count of number of metrics within a group.

    :param str group_id: ID of a metric group.

    :returns: Count of number of metrics within a group.
    :rtype: int

    """
    collection = _get_db_collection(group_id)

    return collection.count()


def fetch_setup(group_id):
    """Returns setup data associated with a group of metrics.

    The setup data is the set of unique values for each field within the metric group.

    :param str group_id: ID of a metric group.

    :returns: Setup data associated with a group of metrics.
    :rtype: dict

    """
    collection = _get_db_collection(group_id)

    return [collection.distinct(c) for c in fetch_columns(group_id, False)]


def delete(group_id):
    """Deletes a group of metrics.

    :param str group_id: ID of a metric group to be deleted.

    :returns: Names of remaining metric groups.
    :rtype: list

    """
    client = pm.MongoClient()
    dbase = client.metrics

    dbase.drop_collection(group_id)

    return dbase.collection_names()[1:]


def delete_lines(group_id, line_ids):
    """Deletes a group of metrics.

    :param str group_id: ID of a metric group.
    :param list line_ids: ID's of individual lines within a metric group.

    :returns: Original and updated line counts.
    :rtype: tuple

    """
    collection = _get_db_collection(group_id)

    count = collection.count()
    for line_id in line_ids:
        collection.remove({"_id": line_id})

    return count, collection.count()


def _main():
    """Inserts metrics to db."""

    group_id, metrics = _get_metrics()

    line_ids = add(group_id, metrics)
    print "add", group_id, len(line_ids)

    # Fetch.
    data = list(fetch(group_id))
    print "fetch", len(data)

    # Fetch columns.
    print "fetch-columns", fetch_columns(group_id)

    # Fetch count.
    print "fetch-count", fetch_count(group_id)

    # Fetch setup.
    print "fetch-setup", len(fetch_setup(group_id))

    # List.
    print "list", fetch_list()

    # Delete some lines.
    print "delete-lines", delete_lines(group_id, line_ids[0:3])

    # Delete group.
    print "delete", delete(group_id)


_main()


