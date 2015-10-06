SELECT 
  tbl_job.*
FROM 
  monitoring.tbl_simulation, 
  monitoring.tbl_job
WHERE 
  tbl_job.simulation_uid = tbl_simulation.uid AND
  tbl_simulation.is_obsolete = FALSE AND
  tbl_simulation.name IS NOT NULL AND
  tbl_simulation.execution_start_date > '2015-09-01 15:06:51';
