ALTER TABLE mq.tbl_message DROP COLUMN timestamp_precision;
ALTER TABLE mq.tbl_message_email RENAME COLUMN dispatch_latency to arrival_latency;
ALTER TABLE mq.tbl_message_email RENAME COLUMN uid to email_id;
ALTER TABLE mq.tbl_message_email_stats RENAME COLUMN dispatch_latency to arrival_latency;