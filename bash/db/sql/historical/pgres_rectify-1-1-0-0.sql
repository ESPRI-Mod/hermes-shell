-- Reset all processing errors.
UPDATE
  mq.tbl_message
SET
  is_queued_for_reprocessing = false;

-- Set 0000 message errors.
UPDATE
  mq.tbl_message as m
SET
  is_queued_for_reprocessing = true
WHERE
  type_id = '0000' AND
  correlation_id_1 IN
  (SELECT s.uid FROM monitoring.tbl_simulation as s where s.execution_start_date IS NULL);


-- Set 0100 message errors.
UPDATE
  mq.tbl_message as m
SET
  is_queued_for_reprocessing = true
WHERE
  type_id = '0100' AND
  correlation_id_1 IN
  (SELECT s.uid FROM monitoring.tbl_simulation as s where s.execution_end_date IS NULL);


-- Set 1000 message errors.
UPDATE
  mq.tbl_message as m
SET
  is_queued_for_reprocessing = true
WHERE
  type_id = '1000' AND
  correlation_id_2 IN
  (SELECT j.job_uid FROM monitoring.tbl_job as j where j.execution_start_date IS NULL);


-- Set 2000 message errors.
UPDATE
  mq.tbl_message as m
SET
  is_queued_for_reprocessing = true
WHERE
  type_id = '2000' AND
  correlation_id_2 IN
  (SELECT j.job_uid FROM monitoring.tbl_job as j where j.execution_start_date IS NULL);
