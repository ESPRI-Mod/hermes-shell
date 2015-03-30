help_metric_add()
{
	log "metric-add PATH DUPLICATE_ACTION" 1
	log "adds a group of metrics from a json file" 2
	log "PATH: path to a metrics file" 2
	log "DUPLICATE_ACTION: Action to take when adding a duplicate metric (skip | force)"
}

help_metric_add_batch()
{
	log "metric-add-batch PATH" 1
	log "adds batches of metrics from json files" 2
	log "PATH: path to a directory containing formatted metrics files" 2
}

help_metric_delete()
{
	log "metric-delete GROUP-ID [FILTER]" 1
	log "deletes a group of metrics" 2
	log "GROUP-ID: group identifier" 2
	log "FILTER: path to a metrics query filter file" 2
}

help_metric_fetch()
{
	log "metric-fetch GROUP-ID INCLUDE-DB-FIELDS [FILTER]" 1
	log "fetches a group of metrics" 2
	log "GROUP-ID: group identifier" 2
	log "INCLUDE-DB-FIELDS: flag indicating whether db injected fields are to be returned" 2
	log "FILTER: path to a metrics query filter file" 2
}

help_metric_fetch_columns()
{
	log "metric-fetch-columns GROUP-ID [INCLUDE-DB-FIELDS]" 1
	log "fetches list of metric group columns" 2
	log "GROUP-ID: group identifier" 2
	log "INCLUDE-DB-FIELDS: flag indicating whether db injected columns are to be returned" 2
}

help_metric_fetch_count()
{
	log "metric-fetch-count GROUP-ID [FILTER]" 1
	log "fetches number of lines within a metric group" 2
	log "GROUP-ID: group identifier" 2
	log "FILTER: path to a metrics query filter file" 2
}

help_metric_fetch_list()
{
	log "metric-fetch-list" 1
	log "lists all metric group names" 2
}

help_metric_format()
{
	log "metric-format GROUP-ID INPUT-FORMAT INPUT-DIR OUTPUT-DIR [OUTPUT-FORMAT]" 1
	log "formats metrics file(s) in readiness for upload" 2
	log "GROUP-ID: group identifier" 2
	log "INPUT-FORMAT: format of input files (pcmdi | ipsl-extended)" 2
	log "INPUT-DIR: path to a directory containing unformatted metrics files" 2
	log "OUTPUT-DIR: path to a directory to which formatted files will be written" 2
	log "OUTPUT-FORMAT: format of output files (blocks | lines)" 2
}

help_metric_fetch_setup()
{
	log "metric-fetch-setup GROUP-ID [FILTER]" 1
	log "fetches a metric group's distinct column values" 2
	log "GROUP-ID: group identifier" 2
	log "FILTER: path to a metrics query filter file" 2
}

help_metric_rename()
{
	log "metric-rename GROUP-ID NEW-GROUP-ID" 1
	log "renames a metric group" 2
	log "GROUP-ID: group identifier" 2
	log "NEW-GROUP-ID: new group identifier" 2
}

help_metric_set_hashes()
{
	log "metric-set-hashes GROUP-ID" 1
	log "resets the hash identifiers for a metric group" 2
	log "GROUP-ID: group identifier" 2
}

help_metric()
{
	commands=(
		add
		add_batch
		delete
		fetch
		fetch_columns
		fetch_count
		fetch_list
		format
		fetch_setup
		rename
		set_hashes
	)
	log_help_commands "metric" ${commands[@]}
}
