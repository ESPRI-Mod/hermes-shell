#!/bin/bash

# ###############################################################
# SECTION: OTHER
# ###############################################################

# Miscellaneous function.
misc()
{
	log "Executing miscellaneuos function"

	activate_venv server
	python ./exec.py "misc"
}
