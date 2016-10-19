CREATE INDEX tbl_message_correlation_id_1_idx
  ON mq.tbl_message
  USING btree
  (correlation_id_1 COLLATE pg_catalog."default");

CREATE UNIQUE INDEX tbl_consumption_unique_idx_1 ON conso.tbl_consumption (allocation_id, date, login, sub_project) WHERE login IS NOT NULL AND sub_project IS NOT NULL;
CREATE UNIQUE INDEX tbl_consumption_unique_idx_2 ON conso.tbl_consumption (allocation_id, date, login) WHERE login IS NOT NULL AND sub_project IS NULL;
CREATE UNIQUE INDEX tbl_consumption_unique_idx_3 ON conso.tbl_consumption (allocation_id, date, sub_project) WHERE login IS NULL AND sub_project IS NOT NULL;
CREATE UNIQUE INDEX tbl_consumption_unique_idx_4 ON conso.tbl_consumption (allocation_id, date) WHERE login IS NULL AND sub_project IS NULL;
