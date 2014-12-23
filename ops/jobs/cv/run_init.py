import arrow, glob, os, json, uuid
from collections import OrderedDict

from prodiguer import cv
from prodiguer.utils import convert


def main():
	"""Main entry point.

	"""
	# Load input files.
	inputs = os.path.join(cv.fpath, "json")
	inputs = os.path.join(inputs, "*.json")
	inputs = sorted(glob.glob(inputs))
	inputs = [i for i in inputs if not i.endswith("simulation.json")]
	inputs = ((i.split("/")[-1].split(".")[0], convert.json_file_to_dict(i)) for i in inputs)

	for term_type, terms in inputs:
		outdir = os.path.join(cv.fpath, "data")
		outdir = os.path.join(outdir, term_type)
		try:
			os.makedirs(outdir)
		except OSError:
			pass

		for term in terms:
			if 'synonyms' in term:
				term['synonyms'] = term['synonyms'].split(",")
				term['synonyms'] = [i.strip() for i in term['synonyms']]
				term['synonyms'] = [i for i in term['synonyms'] if i]
			term['meta'] = {
				'name': term['name'].strip().lower(),
				'associations': [],
				'type': term_type,
				'create_date': unicode(arrow.utcnow()),
				'domain': 'climate',
				'uid': unicode(uuid.uuid4())
			}

			if 'associations' in term:
				for ass_term_type, ass_term_name in term['associations'].items():
					association = "{0}.{1}".format(ass_term_type, ass_term_name)
					term['meta']['associations'].append(association)
				term['meta']['associations'] = sorted(term['meta']['associations'])
				del term['associations']

			term = OrderedDict(sorted(term.items(), key=lambda t: t[0]))
			term['meta'] = OrderedDict(sorted(term['meta'].items(), key=lambda t: t[0]))

			outfile = term['meta']['name']
			outfile = os.path.join(outdir, outfile)
			outfile = "{}.json".format(outfile)

			with open(outfile, 'w') as outfile:
				outfile.write(json.dumps(term, indent=4))



if __name__ == '__main__':
    main()
