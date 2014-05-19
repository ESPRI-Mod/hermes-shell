#!/bin/bash

# ###############################################################
# SECTION: OTHER
# ###############################################################

# Miscellaneous function.
run_misc()
{
	log "Executing miscellaneuos function"

	activate_venv server
	python ./exec.py "misc"
}
