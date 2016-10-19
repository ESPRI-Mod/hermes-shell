-- DROP obsolete columns.
ALTER TABLE mq.tbl_message_email_stats DROP COLUMN outgoing_3000;
ALTER TABLE mq.tbl_message_email_stats DROP COLUMN outgoing_3100;
ALTER TABLE mq.tbl_message_email_stats DROP COLUMN outgoing_3900;
ALTER TABLE mq.tbl_message_email_stats DROP COLUMN outgoing_3999;

-- ADD new columns.
ALTER TABLE mq.tbl_message_email_stats ADD COLUMN outgoing_1001 integer;
