-- Check messages in error.
SELECT DISTINCT processing_error FROM mq.tbl_message WHERE processing_error IS NOT NULL;

-- Reset is queued for processing flag.
UPDATE mq.tbl_message SET is_queued_for_reprocessing = FALSE WHERE is_queued_for_reprocessing = TRUE;

-- 0000: failed due to vocab issue.
UPDATE mq.tbl_message AS m SET is_queued_for_reprocessing = TRUE WHERE m.type_id = '0000' AND m.processing_error LIKE '%nmanur%';

-- 8000: failed due to incorrect python import.
UPDATE mq.tbl_message AS m SET is_queued_for_reprocessing = TRUE WHERE processing_error LIKE 'global name%';

-- 0000: failed due to incorrect output dates.
UPDATE mq.tbl_message AS m SET is_queued_for_reprocessing = TRUE WHERE processing_error LIKE '%Could not match input to any of%';

-- 0000: failed due to february date.
update mq.tbl_message set is_queued_for_reprocessing = TRUE WHERE processing_error LIKE '%is out of range%' and type_id = '0000';

-- 2000: failed due to february date.
update mq.tbl_message set is_queued_for_reprocessing = TRUE WHERE processing_error LIKE '%is out of range%' and type_id = '2000';

-- 0000: output dates extraction issue.
UPDATE mq.tbl_message AS m SET is_queued_for_reprocessing = TRUE WHERE m.is_queued_for_reprocessing = FALSE AND m.type_id = '0000' AND EXISTS (SELECT 1 FROM monitoring.tbl_simulation AS s WHERE s.uid = m.correlation_id_1 AND s.execution_start_date IS NOT NULL AND s.output_start_date IS NULL);

-- 0000: failed due to warning delay calculation error.
UPDATE mq.tbl_message set is_queued_for_reprocessing = TRUE WHERE processing_error LIKE '%offset-naive and offset-aware datetime%' AND type_id = '0000';

-- 1000: failed due to warning delay calculation error.
UPDATE mq.tbl_message set is_queued_for_reprocessing = TRUE WHERE processing_error LIKE '%offset-naive and offset-aware datetime%' AND type_id = '1000';

-- 2000: failed due to warning delay calculation error.
UPDATE mq.tbl_message set is_queued_for_reprocessing = TRUE WHERE processing_error LIKE '%offset-naive and offset-aware datetime%' AND type_id = '2000';


