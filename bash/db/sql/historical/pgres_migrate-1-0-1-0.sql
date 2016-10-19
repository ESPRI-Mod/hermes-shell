-- Drop table: monitoring.tbl_command
DROP TABLE monitoring.tbl_command;

-- Update table: monitoring.tbl_simulation: set cmip5 accounting project:
UPDATE monitoring.tbl_simulation
   SET accounting_project='cmip5'
 WHERE activity='cmip5';
