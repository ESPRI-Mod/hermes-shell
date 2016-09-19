-- CEST
UPDATE 
  monitoring.tbl_job
SET
  execution_end_date = execution_end_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_end_date >= '2015-03-29 02:00:00'::timestamp AND execution_end_date < '2015-10-25 03:00:00'::timestamp;

UPDATE 
  monitoring.tbl_job
SET
  execution_start_date = execution_start_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_start_date >= '2015-03-29 02:00:00'::timestamp AND execution_start_date < '2015-10-25 03:00:00'::timestamp;

UPDATE 
  monitoring.tbl_simulation
SET
  execution_end_date = execution_end_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_end_date >= '2015-03-29 02:00:00'::timestamp AND execution_end_date < '2015-10-25 03:00:00'::timestamp;

UPDATE 
  monitoring.tbl_simulation
SET
  execution_start_date = execution_start_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_start_date >= '2015-03-29 02:00:00'::timestamp AND execution_start_date < '2015-10-25 03:00:00'::timestamp;

UPDATE 
  mq.tbl_message
SET
  timestamp = timestamp AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  timestamp >= '2015-03-29 02:00:00'::timestamp AND timestamp < '2015-10-25 03:00:00'::timestamp;

-- CET
UPDATE 
  monitoring.tbl_job
SET
  execution_end_date = execution_end_date AT TIME ZONE 'CET' AT TIME ZONE 'UTC'
WHERE
  execution_end_date >= '2015-10-25 03:00:00'::timestamp AND execution_end_date < '2016-03-27 02:00:00'::timestamp;

UPDATE 
  monitoring.tbl_job
SET
  execution_start_date = execution_start_date AT TIME ZONE 'CET' AT TIME ZONE 'UTC'
WHERE
  execution_start_date >= '2015-10-25 03:00:00'::timestamp AND execution_start_date < '2016-03-27 02:00:00'::timestamp;

UPDATE 
  monitoring.tbl_simulation
SET
  execution_end_date = execution_end_date AT TIME ZONE 'CET' AT TIME ZONE 'UTC'
WHERE
  execution_end_date >= '2015-10-25 03:00:00'::timestamp AND execution_end_date < '2016-03-27 02:00:00'::timestamp;

UPDATE 
  monitoring.tbl_simulation
SET
  execution_start_date = execution_start_date AT TIME ZONE 'CET' AT TIME ZONE 'UTC'
WHERE
  execution_start_date >= '2015-10-25 03:00:00'::timestamp AND execution_start_date < '2016-03-27 02:00:00'::timestamp;

UPDATE 
  mq.tbl_message
SET
  timestamp = timestamp AT TIME ZONE 'CET' AT TIME ZONE 'UTC'
WHERE
  timestamp >= '2015-10-25 03:00:00'::timestamp AND timestamp < '2016-03-27 02:00:00'::timestamp;

-- CEST
UPDATE 
  monitoring.tbl_job
SET
  execution_end_date = execution_end_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_end_date >= '2016-03-27 02:00:00'::timestamp AND execution_end_date < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  monitoring.tbl_job
SET
  execution_start_date = execution_start_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_start_date >= '2016-03-27 02:00:00'::timestamp AND execution_start_date < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  monitoring.tbl_simulation
SET
  execution_end_date = execution_end_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_end_date >= '2016-03-27 02:00:00'::timestamp AND execution_end_date < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  monitoring.tbl_simulation
SET
  execution_start_date = execution_start_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  execution_start_date >= '2016-03-27 02:00:00'::timestamp AND execution_start_date < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  mq.tbl_message
SET
  timestamp = timestamp AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  timestamp >= '2016-03-27 02:00:00'::timestamp AND timestamp < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  mq.tbl_message_email
SET
  arrival_date = arrival_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  arrival_date >= '2016-03-27 02:00:00'::timestamp AND arrival_date < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  mq.tbl_message_email
SET
  dispatch_date = dispatch_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  dispatch_date >= '2016-03-27 02:00:00'::timestamp AND dispatch_date < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  mq.tbl_message_email_stats
SET
  arrival_date = arrival_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  arrival_date >= '2016-03-27 02:00:00'::timestamp AND arrival_date < '2016-10-30 03:00:00'::timestamp;

UPDATE 
  mq.tbl_message_email_stats
SET
  dispatch_date = dispatch_date AT TIME ZONE 'CEST' AT TIME ZONE 'UTC'
WHERE
  dispatch_date >= '2016-03-27 02:00:00'::timestamp AND dispatch_date < '2016-10-30 03:00:00'::timestamp;

