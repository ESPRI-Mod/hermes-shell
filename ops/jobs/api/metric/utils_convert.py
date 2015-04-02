# -*- coding: utf-8 -*-

"""
.. module:: pyesdoc.utils.convert.py
   :copyright: Copyright "Feb 7, 2013", Earth System Documentation
   :license: GPL/CeCIL
   :platform: Unix, Windows
   :synopsis: Set of library conversion functions.

.. moduleauthor:: Mark Conway-Greenslade <momipsl@ipsl.jussieu.fr>


"""
import collections
import csv
import datetime
import json
import re
import types
import uuid

from dateutil import parser as date_parser



# Default character set.
_JSON_CHARSET = "ISO-8859-1"

# ISO date formats.
_ISO_DATE_FORMATS = ["%Y-%m-%d %H:%M:%S", "%Y-%m-%dT%H:%M:%S"]

# Values considered to be abbreviations.
_ABBREVIATIONS = ("id", "uid", "uuid")


def str_to_pascal_case(target, separator='_'):
    """Converts passed name to pascal case.

    :param str target: A string to be converted.

    :param str separator: A separator used to split target string into constituent parts.

    :returns: The target string converted to pascal case.
    :rtype: str

    """
    r = ''
    if target is not None and len(target):
        # Preserve initial separator
        if target[0:len(separator)] == separator:
            r = separator

        # Iterate string parts.
        s = target.split(separator)
        for s in s:

            # Upper case abbreviations.
            if s.lower() in _ABBREVIATIONS:
                r += s.upper()

            # Upper case initial character.
            elif (len(s) > 0):
                r += s[0].upper()
                if (len(s) > 1):
                    r += s[1:]

    return r


def str_to_camel_case(target, separator='_'):
    """Converts passed name to camel case.

    :param str target: A string to be converted.

    :param str separator: A separator used to split target string into constituent parts.

    :returns: The target string converted to camel case.
    :rtype: str

    """
    r = ''
    if target is not None and len(target):
        # Convert to pascal case.
        s = str_to_pascal_case(target, separator)

        # Preserve initial separator
        if s[0:len(separator)] == separator:
            r += separator
            s = s[len(separator):]

        # Lower case abbreviations.
        if s.lower() in _ABBREVIATIONS:
            r += s.lower()

        # Lower case initial character.
        elif len(s):
            r += s[0].lower()
            r += s[1:]

    return r


def str_to_spaced_case(target, separator='_'):
    """Helper function to convert a string value from camel case to spaced case.

    :param str target: A string for conversion.

    :returns: A string converted to spaced case.
    :rtype: str

    """
    if target is None:
        return ""
    elif separator is not None and len(target.split(separator)) > 1:
        return " ".join(target.split(separator))
    elif target.find(" ") == -1:
        return re.sub("([A-Z])"," \g<0>", target).strip()
    else:
        return target


def str_to_underscore_case(target):
    """Helper function to convert a from camel case string to an underscore case string.

    :param str target: A string for conversion.

    :returns: A string converted to underscore case, e.g. account_number.
    :rtype: str

    """
    if target is None or not len(target):
        return ''

    r = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', target)
    r = re.sub('([a-z0-9])([A-Z])', r'\1_\2', r)
    r = r.lower()

    return r


class _JSONEncoder(json.JSONEncoder):
    """Extends json encoder so as to handle extended types.

    """
    def default(self, obj):
        """Returns encoding for object types not automatically encoded by base class.

        """
        if isinstance(obj, datetime.datetime):
            return unicode(obj.isoformat().replace('T', ' '))
        elif isinstance(obj, datetime.date):
            return unicode(obj.isoformat())
        elif isinstance(obj, datetime.time):
            return unicode(obj.isoformat())
        elif isinstance(obj, uuid.UUID):
            return unicode(obj)
        else:
            raise TypeError(repr(obj) + " is not JSON serializable")


class _JSONDecoder(json.JSONDecoder):
    """Extends json decoder so as to handle extended types.

    """
    def __init__(self, key_formatter, to_namedtuple=False):
        """Object constructor.

        """
        json.JSONDecoder.__init__(self,
                                  encoding=_JSON_CHARSET,
                                  object_hook=self._dict_to_object)
        self.key_formatter = key_formatter
        self.to_namedtuple = to_namedtuple
        self.value_parsers = [self._unicode_to_datetime, self._unicode_to_uuid]


    def _dict_to_object(self, d):
        """Decodes dictionary to object.

        """
        # Parse values.
        for k, v in d.items():
            for parser in self.value_parsers:
                if parser(d, k, v):
                    break

        # Format keys.
        if self.key_formatter is not None:
            d = dict_keys(d, self.key_formatter)

        # Return dictionary | named tuple.
        return d if not self.to_namedtuple else dict_to_namedtuple(d)


    def _unicode_to_datetime(self, d, k, v):
        """Attempts to convert a unicode value to a datetime.

        """
        if isinstance(v, unicode) and len(v):
            try:
                float(v)
            except ValueError:
                for format in _ISO_DATE_FORMATS:
                    try:
                        v = datetime.datetime.strptime(v, format)
                    except (ValueError, TypeError):
                        pass
                    else:
                        d[k] = v
                        return True

        return False


    def _unicode_to_uuid(self, d, k, v):
        """Attempts to convert a unicode value to a UUID.

        """
        if isinstance(v, unicode) and len(v):
            try:
                v = uuid.UUID(v)
            except ValueError:
                pass
            else:
                d[k] = v
                return True

        return False


def json_to_dict(repr, key_formatter=None):
    """Converts a json encoded string to a dictionary.

    :param repr: A json encoded string.
    :type repr: str | unicode
    :param function key_formatter: Dictionary key formatter.

    :returns: A dictionary.
    :rtype: dict

    """
    return _JSONDecoder(key_formatter).decode(repr)


def json_to_namedtuple(repr, key_formatter=None):
    """Converts a json encoded string to a namedtuple.

    :param repr: A json encoded string.
    :type repr: str | unicode
    :param function key_formatter: Dictionary key formatter.

    :returns: A namedtuple.
    :rtype: namedtuple

    """
    return _JSONDecoder(key_formatter, to_namedtuple=True).decode(repr)


def _convert_file(fp, convertor, key_formatter=None):
    """Converts a file.

    """
    with open(fp, 'r') as f:
        return convertor(f.read(), key_formatter)


def json_file_to_dict(fp, key_formatter=None):
    """Converts a json file to a dictionary.

    :param str fp: A json file path.
    :param function key_formatter: Dictionary key formatter.

    :returns: A dictionary.
    :rtype: dict

    """
    return _convert_file(fp, json_to_dict, key_formatter)


def json_file_to_namedtuple(fp, key_formatter=None):
    """Converts a json file to a namedtuple.

    :param str fp: A json file path.
    :param function key_formatter: Dictionary key formatter.

    :returns: A namedtuple.
    :rtype: namedtuple

    """
    return _convert_file(fp, json_to_namedtuple, key_formatter)


def dict_to_json(d, key_formatter=None):
    """Converts a dictionary to json.

    :param dict d: A dictionary.
    :param function key_formatter: Dictionary key formatter.

    :returns: A json encoded string.
    :rtype: str

    """
    if key_formatter is not None:
        d = key_formatter(d)

    return _JSONEncoder().encode(d)


def dict_to_namedtuple(d, key_formatter=None):
    """Converts a dictionary to a named tuple.

    :param dict d: Dictionary for conversion.
    :param function key_formatter: Dictionary key formatter.

    :returns: A named tuple.
    :rtype: namedtuple

    """
    if key_formatter is not None:
        d = key_formatter(d)

    _Class = collections.namedtuple('_Class', d.keys())

    return _Class(**d)


def dict_keys(d, key_formatter=str_to_pascal_case):
    """Converts keys of a dictionary using the passed key formatter.

    :param dict d: A dictionary.
    :param function key_formatter: A dictionary key formatter function pointer.

    :returns: A dictionary with it's keys formatted accordingly.
    :rtype: dict

    """
    if not isinstance(d, dict):
        return d

    r = {}

    for k, v in d.items():
        if isinstance(v, dict):
            r[key_formatter(k)] = dict_keys(v, key_formatter)
        elif isinstance(v, types.ListType):
            r[key_formatter(k)] = map(lambda i: dict_keys(i, key_formatter), v)
        else:
            r[key_formatter(k)] = v

    return r


def dict_keys_to_lower_case(d):
    """Converts keys of a dictionary to lower case.

    :param dict d: A dictionary.

    :returns: A dictionary with it's keys formatted accordingly.
    :rtype: dict

    """
    return dict_keys(d, lambda k: k.lower())


def dict_keys_to_upper_case(d):
    """Converts keys of a dictionary to upper case.

    :param dict d: A dictionary.

    :returns: A dictionary with it's keys formatted accordingly.
    :rtype: dict

    """
    return dict_keys(d, lambda k: k.upper())


def dict_keys_to_camel_case(d):
    """Converts keys of a dictionary to camel case.

    :param dict d: A dictionary.

    :returns: A dictionary with it's keys formatted accordingly.
    :rtype: dict

    """
    return dict_keys(d, str_to_camel_case)


def dict_keys_to_pascal_case(d):
    """Converts keys of a dictionary to pascal case.

    :param dict d: A dictionary.

    :returns: A dictionary with it's keys formatted accordingly.
    :rtype: dict

    """
    return dict_keys(d, str_to_pascal_case)


def dict_keys_to_underscore_case(d):
    """Converts keys of a dictionary to underscore case.

    :param dict d: A dictionary.

    :returns: A dictionary with it's keys formatted accordingly.
    :rtype: dict

    """
    return dict_keys(d, str_to_underscore_case)


def csv_file_to_dict(fp):
    """Converts a csv file to a list of dictionaries.

    :param str fp: A csv file path.

    :returns: A list of dictionaries.
    :rtype: list

    """
    with open(fp, 'r') as input_file:
        return map(lambda r:r, csv.DictReader(input_file))


def csv_file_to_namedtuple(fp):
    """Converts a csv file to a list of named tuples.

    :param str fp: A csv file path.

    :returns: A list of named tuples.
    :rtype: list

    """
    return map(dict_to_namedtuple, csv.DictReader(open(fp)))


def csv_file_to_json(fp):
    """Converts a csv file to json.

    :param str fp: A csv file path.

    :returns: A json string.
    :rtype: unicode

    """
    return dict_to_json(csv_file_to_dict(fp))


def csv_file_to_json_file(fp, dest=None):
    """Converts a csv file to a json file.

    :param str fp: A csv file path.

    """
    if dest is None:
        dest = fp.split(".")[0] + ".json"
    with open(dest, 'w') as f:
        f.write(dict_to_json(csv_file_to_dict(fp)))


def str_to_typed_value(s, type):
    """Converts a string to a typed value.

    :param str s: A string for type conversion.
    :param class type: Target type.

    :returns: A string converted to a typed value.
    :rtype: object

    """
    # Encode.
    if s is not None:
        s = s.encode('utf-8') if isinstance(s, unicode) else str(s)

    # None if empty value.
    if s is None or not len(s):
        return None

    # Decode according to type:
    # ... date's
    if type in (datetime.datetime, datetime.date, datetime.time):
        return date_parser.parse(s)
    # ... uuid's
    elif type is uuid.UUID:
        return uuid.UUID(s)
    # ... boolean's
    elif type is bool:
        return s.lower() in ("yes", "true", "t", "1", "y")
    # ... others
    else:
        try:
            return type(s)
        # ... exceptions
        except Error as e:
            print "Scalar decoding error", s, type


# Set of types to be ignored when jsonifying.
_JSONIFYING_TYPES_IGNORE = (int, float, long, type(None), unicode)

# Set of unicodeable types used in jsonifying.
_JSONIFYING_TYPES_UNICODEABLE = (basestring, datetime.datetime, uuid.UUID)


def _jsonify(data):
    """Converts a dictionary in readiness for json encoding.

    """
    if isinstance(data, _JSONIFYING_TYPES_IGNORE):
        return data

    if isinstance(data, _JSONIFYING_TYPES_UNICODEABLE):
        return unicode(data)

    if isinstance(data, collections.Mapping):
        mapped = [(str_to_camel_case(k), _jsonify(data[k])) for k in data.keys()]
        mapped = sorted(mapped, key = lambda i: i[0].lower())
        return collections.OrderedDict(mapped)

    if isinstance(data, collections.Iterable):
        return [_jsonify(i) for i in data]


def jsonify(data):
    """Converts input dictionary to json.

    :param dict data: Data in dictionary format.

    :returns: JSON encoded string.
    :rtype: str

    """
    return json.dumps(_jsonify(data), indent=4)
