-- Set new simulation.is_im flag.
UPDATE
	monitoring.tbl_simulation
SET
	is_im = TRUE
WHERE
	accounting_project = 'cmip5' OR
	uid IN (SELECT DISTINCT j.simulation_uid FROM monitoring.tbl_job AS j WHERE j.is_im = True);
