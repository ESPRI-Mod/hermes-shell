-- Create new columns.
ALTER TABLE monitoring.tbl_job ADD COLUMN execution_state character(1);
ALTER TABLE monitoring.tbl_job ADD COLUMN is_im boolean;

-- Update job type to minimize network payloads.
UPDATE monitoring.tbl_job SET typeof = 'p' WHERE typeof = 'post-processing';
UPDATE monitoring.tbl_job SET typeof = 'c' WHERE typeof = 'computing';

-- Update job execution state to minimize network payloads.
UPDATE monitoring.tbl_job SET execution_state = 'r' WHERE execution_start_date IS NULL AND execution_end_date IS NULL;
UPDATE monitoring.tbl_job SET execution_state = 'e' WHERE execution_end_date IS NOT NULL AND is_error = TRUE;
UPDATE monitoring.tbl_job SET execution_state = 'c' WHERE execution_end_date IS NOT NULL AND is_error = FALSE;

-- Set job inter-monitoring flag.
UPDATE monitoring.tbl_job SET is_im = FALSE;
UPDATE monitoring.tbl_job SET is_im = TRUE WHERE post_processing_name = 'monitoring';
