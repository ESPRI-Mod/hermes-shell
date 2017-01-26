-- Add new column to trap message processing errors.
ALTER TABLE mq.tbl_message ADD COLUMN processing_error text;

-- Add new column to trap message processing tries.
ALTER TABLE mq.tbl_message ADD COLUMN processing_tries integer;

-- Add new column to control reprocessing.
ALTER TABLE mq.tbl_message ADD COLUMN is_queued_for_reprocessing boolean;

-- Initialise new columns.
UPDATE mq.tbl_message SET processing_tries = 1;
UPDATE mq.tbl_message SET is_queued_for_reprocessing = false;

-- Ensure that there is only one configuration per simulation.
ALTER TABLE monitoring.tbl_simulation_configuration
  ADD CONSTRAINT tbl_simulation_configuration_uid_key UNIQUE(simulation_uid);