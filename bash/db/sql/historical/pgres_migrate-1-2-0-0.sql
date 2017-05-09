-- Add new simulation table column to simplify inter-monitoring use case.
ALTER TABLE monitoring.tbl_simulation ADD COLUMN is_im boolean;
ALTER TABLE monitoring.tbl_simulation ALTER COLUMN is_im SET DEFAULT false;