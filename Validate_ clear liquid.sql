
--original code

--SELECT
--					pat_enc_csn_id
--					,RECORDED_TIME
--					,1 'Measure'
--				FROM
--					#PreOp
--				WHERE
--					FLO_MEAS_ID IN ( 
--									'1020100004'/*Date Last Liquid*/
--									,'1217' /*Time Last Liquid*/
--									)
--				GROUP BY pat_enc_csn_id
--						,RECORDED_TIME

--modified:

SELECT PreOp_LastLiquid_Documented = ISNULL(Measure,0)
FROM(
SELECT
					pat_enc_csn_id
					,RECORDED_TIME
					,1 'Measure'
				FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail
					
				WHERE
					FLO_MEAS_ID IN ( 
									'1020100004'/*Date Last Liquid*/
									,'1217' /*Time Last Liquid*/
									)
									AND PAT_ENC_CSN_ID=115920619
				GROUP BY pat_enc_csn_id
						,RECORDED_TIME
) AS dev

--populate last liquid metric
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET clearliquids_3ind=1
SELECT *
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN (
SELECT PAT_ENC_CSN_ID,COUNT(DISTINCT f.FLO_MEAS_ID) AS colcount
FROM  RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS f
WHERE f.FLO_MEAS_ID IN ('1020100004','1217')
AND f.anes_minus2=1
GROUP BY PAT_ENC_CSN_ID
) AS lastliq ON lastliq.PAT_ENC_CSN_ID=c.admissioncsn
WHERE lastliq.colcount=2; --both time and date columns need to be populated
