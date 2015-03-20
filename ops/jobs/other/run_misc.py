import datetime, uuid

from prodiguer import db, config
from prodiguer.utils.data_convertor import jsonify



_DATA = {
    'cv_terms': [("experiment", "IPSLCM5A")],
    'event_type': 'newSimulation',
    'event_timestamp': u'2014-12-17 15:41:52.483613',
    'simulation': {
        'execution_end_date': datetime.datetime(2014, 11, 3, 22, 5, 35, 752479),
        'compute_node_login': u'p86ipsl',
        'compute_node_machine': u'tgcc-curie',
        'name': u'EXP00C - 17d2317b-3779-4b5c-935d-cbc928db9658',
        'compute_node': u'tgcc',
        'space': u'test',
        'output_start_date': datetime.datetime(2000, 1, 1, 1, 0),
        'output_end_date': datetime.datetime(2000, 2, 28, 1, 0),
        'experiment': u'ipslcm5a',
        'row_update_date': datetime.datetime(2014, 12, 17, 15, 6, 40, 771498),
        'parent_simulation_branch_date': None,
        'execution_start_date': datetime.datetime(2014, 11, 3, 21, 36, 39, 18983),
        'activity': u'ipsl',
        'ensemble_member': None,
        'model': u'ipsl-cm5a-lr',
        'row_create_date': datetime.datetime(2014, 12, 17, 15, 6, 38, 908244),
        'id': 48,
        'parent_simulation_name': None,
        'uid': uuid.UUID(u'1ee0b897-c39a-4930-8327-b40fc30247b7')
        },
    'test_uid': uuid.uuid4()
    }

# print jsonify(_DATA)

_DATA = {'eventType': u'newSimulation', 'eventTimestamp': u'2014-12-19 13:06:59.150173', 'simulation': {'execution_end_date': None, 'compute_node_login': u'p86ipsl', 'compute_node_machine': u'tgcc-curie', 'name': u'EXP00C - a06456a0-e109-4500-b51d-f176a6daae5e', 'compute_node': u'tgcc', 'space': u'test', 'output_start_date': datetime.datetime(2000, 1, 1, 1, 0), 'output_end_date': datetime.datetime(2000, 2, 28, 1, 0), 'experiment': u'ipslcm5a', 'row_update_date': None, 'parent_simulation_branch_date': None, 'execution_start_date': datetime.datetime(2014, 11, 3, 21, 36, 39, 18983), 'activity': u'ipsl', 'ensemble_member': None, 'model': u'ipsl-cm5a-lr', 'row_create_date': datetime.datetime(2014, 12, 19, 13, 6, 54, 347719), 'id': 50, 'parent_simulation_name': None, 'uid': u'088b42c2-f7d1-4cbc-bd60-a90df8acb7a2'}}


db.session.start()
s =  db.dao_monitoring.retrieve_simulation("6473b806-61ab-43a4-b7ff-2f4be1927dc6")
print jsonify(s)
