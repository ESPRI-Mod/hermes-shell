ALTER TABLE mq.tbl_message_email_stats ADD COLUMN email_rejected boolean;
UPDATE mq.tbl_message_email_stats SET email_rejected = FALSE;
