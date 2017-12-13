-- Reset is queued for processing flag.
UPDATE mq.tbl_message SET is_queued_for_reprocessing = FALSE WHERE is_queued_for_reprocessing = TRUE;

-- 0000: failed due to vocab issue.
UPDATE mq.tbl_message AS m SET is_queued_for_reprocessing = true WHERE m.type_id = '0000' AND m.processing_error LIKE '%nmanur%';

-- 8000: falied due to incorrect python import.
UPDATE mq.tbl_message AS m SET is_queued_for_reprocessing = true WHERE processing_error LIKE 'global name%';

