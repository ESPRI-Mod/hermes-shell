ALTER TABLE monitoring.tbl_job ADD COLUMN is_late boolean;
ALTER TABLE monitoring.tbl_job ALTER COLUMN is_late SET DEFAULT false;