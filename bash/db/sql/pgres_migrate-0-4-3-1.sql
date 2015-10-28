-- Update column: monitoring.tbl_job.is_compute_end
UPDATE
	monitoring.tbl_job AS jj
SET
	is_compute_end = true
WHERE
	jj.job_uid IN (
		SELECT
			j.job_uid
		FROM
			monitoring.tbl_job as j, mq.tbl_message as m
		WHERE
			j.job_uid = m.correlation_id_2 AND
			j.is_compute_end IS NULL AND
			j.typeof = 'computing' AND
			m.type_id = '0100'
	)
;