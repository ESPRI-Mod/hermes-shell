-- Drop column: monitoring.tbl_job.is_startup
ALTER TABLE monitoring.tbl_job DROP COLUMN is_startup;

-- Add column: monitoring.tbl_job.is_compute_end
ALTER TABLE monitoring.tbl_job ADD COLUMN is_compute_end boolean;
