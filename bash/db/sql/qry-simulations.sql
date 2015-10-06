SELECT 
  tbl_simulation.*
FROM 
  monitoring.tbl_simulation
WHERE 
  tbl_simulation.is_obsolete = FALSE AND
  tbl_simulation.name IS NOT NULL AND
  tbl_simulation.execution_start_date > '2015-09-01 15:06:51';
