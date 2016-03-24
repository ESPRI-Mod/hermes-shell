CREATE INDEX tbl_message_correlation_id_1_idx
  ON mq.tbl_message
  USING btree
  (correlation_id_1 COLLATE pg_catalog."default");
