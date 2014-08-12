from prodiguer.utils import convert




def main():
	"""Main entry point."""
	fp = r"/Users/macg/dev/prodiguer/repos/prodiguer-server/tests/test_files/metric_api_HISTA2_K1.csv"
	convert.csv_file_to_json_file(fp)
	convert.csv_file_to_namedtuple(fp)


if __name__ == '__main__':
    main()
