ALTER TABLE mq.tbl_message_email_stats ADD COLUMN email_server_id bigint;
ALTER TABLE mq.tbl_message_email_stats ALTER COLUMN email_server_id SET DEFAULT 1;