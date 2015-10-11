-- Column: producer_version

-- ALTER TABLE mq.tbl_message DROP COLUMN producer_version;

ALTER TABLE mq.tbl_message ADD COLUMN producer_version character varying(31);
ALTER TABLE mq.tbl_message ALTER COLUMN producer_version SET NOT NULL;
