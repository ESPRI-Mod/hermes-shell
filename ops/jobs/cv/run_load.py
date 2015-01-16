from prodiguer import cv


def main():
	"""Main entry point.

	"""
	cv.session.init()

	term_type = cv.constants.TERM_TYPE_MODEL

	print cv.cache.get_all_termsets()

	print cv.cache.get_termset(term_type)

	print cv.cache.get_term(term_type, "ipsl-cm5a-lr")

	print cv.cache.get_random_term(term_type)

	print cv.cache.get_random_term_name(term_type)

	print cv.cache.get_term_typeset()

	print cv.cache.get_term_count()

	print cv.parser.get_term_name(term_type, "ipsl-cm5a-lr")
	print cv.parser.get_term_name(term_type, "IPSL-cm5a-lr")
	print cv.parser.get_term_name(term_type, "IPSLCM5A")
	print cv.parser.get_term_name(term_type, "ipslcm5A")

	cv.cache.reload()


if __name__ == '__main__':
    main()
