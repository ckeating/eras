
IF object_id('tempdb..#sched') is not null
	drop table #sched; 

SELECT 
p.PAT_NAME AS PatientName,
p.PAT_MRN_ID AS MRN,
zpc.name AS OR_PatClass,ol.LOG_ID,ol.SURGERY_DATE, cl.LOC_NAME AS SurgeryLocation,ol.SCHED_START_TIME,
CLARITY_SER_Surg.PROV_NAME AS PrimarySurgeon,vlt.PATIENT_IN_ROOM_DTTM,
vlt.PROCEDURE_START_DTTM,
vlt.PROCEDURE_COMP_DTTM,
vlt.PATIENT_OUT_ROOM_DTTM,
vlt.CASE_REQUEST_DTTM,
oc.RECORD_CREATE_DATE

INTO #sched
FROM    ##logid AS l
		JOIN clarity.dbo.OR_Log AS ol ON l.LOG_ID=ol.LOG_ID
		LEFT JOIN Clarity.dbo.OR_CASE AS oc ON oc.OR_CASE_ID=ol.LOG_ID
LEFT JOIN clarity.dbo.patient AS p ON ol.PAT_ID=p.PAT_ID
LEFT JOIN clarity.dbo.ZC_PAT_CLASS AS zpc ON zpc.ADT_PAT_CLASS_C=ol.PAT_TYPE_C
LEFT JOIN clarity.dbo.CLARITY_LOC AS cl ON cl.LOC_ID=ol.LOC_ID
 LEFT OUTER JOIN 
	(SELECT allsurg.*
	FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
	JOIN (SELECT log_Id,MAX(line) AS maxline
		  FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
		  WHERE PANEL=1
		  AND  ROLE_C=1 
		  GROUP BY log_id   ) AS maxsurg ON maxsurg.LOG_ID=allsurg.LOG_ID
											AND maxsurg.maxline=allsurg.line
	) AS allsurg ON allsurg.LOG_ID=ol.LOG_ID 
LEFT JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_Surg ON CLARITY_SER_Surg.PROV_ID=allsurg.surg_id
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON vlt.LOG_ID=ol.LOG_ID;



--change 556504 - test condition missing case req time and 24 >= diff <48 
--in room time must be 6PM or later
--this should test false
UPDATE #sched
SET case_request_dttm=NULL
WHERE log_id='556504';

--change 556504 - test condition missing case req time diff >=48  hours
--this should test true

UPDATE #sched
SET RECORD_CREATE_DATE='5/23/2016'
,case_request_dttm = null
WHERE log_id='599336';


--change 600971- test condition missing case req time diff 24 - 48 hours and in room time is 6PM or later
--this should test true

UPDATE #sched
SET case_request_dttm=NULL
,PATIENT_IN_ROOM_DTTM= '2016-05-27 19:19:00.000'
WHERE log_id='600971';

IF object_id('tempdb..#pullvalidate') is not null
	drop table #pullvalidate; 


WITH pull AS (

SELECT 
* ,
CaseReqDiff=DATEDIFF(HOUR,CASE_REQUEST_DTTM,PATIENT_IN_ROOM_DTTM),
CaseCreateDiff=DATEDIFF(HOUR,RECORD_CREATE_DATE,PATIENT_IN_ROOM_DTTM),
convert(TIME,patient_in_room_dttm) AS InRoomTime,
CASE WHEN convert(TIME,patient_in_room_dttm)>='18:00' THEN 1 ELSE 0 END AS SixPMFlag,
CASE WHEN CASE_REQUEST_DTTM IS NULL THEN 1 ELSE 0 END AS CaseReqMissing,
CASE WHEN CASE_REQUEST_DTTM IS NULL AND
		   DATEDIFF(HOUR,RECORD_CREATE_DATE,PATIENT_IN_ROOM_DTTM)>=48 
		  OR ( DATEDIFF(HOUR,RECORD_CREATE_DATE,PATIENT_IN_ROOM_DTTM)>=24
			           AND DATEDIFF(HOUR,RECORD_CREATE_DATE,PATIENT_IN_ROOM_DTTM)<48
					   AND CONVERT(TIME,PATIENT_IN_ROOM_DTTM)>='18:00')		
				THEN 1 
	 WHEN CASE_REQUEST_DTTM IS NOT NULL AND  DATEDIFF(HOUR,CASE_REQUEST_DTTM,PATIENT_IN_ROOM_DTTM)>18 THEN 1 ELSE 0 END
	 --END
	AS InclusionFlag

FROM #sched)
SELECT *
INTO #pullvalidate
FROM pull
--WHERE CaseCreateDiff<50
--where log_id=599336
--WHERE log_id IN ('556504')
ORDER BY LOG_ID


WITH proofit AS (
SELECT  CASE WHEN CaseReqDiff>18 THEN '>18 hours'
			 WHEN CaseReqDiff<18 THEN '<18 hours'
			 WHEN CaseReqDiff IS NULL THEN 'Missing'
			 END AS CaseReqBucket,
		CASE WHEN CaseCreateDiff >=24 AND CaseCreateDiff < 48 THEN '24 to 47' 
			 WHEN CaseCreateDiff >=48  THEN '>48' 
			 WHEN CaseCreateDiff IS NULL THEN 'Missing'
			 WHEN CaseCreateDiff<24 THEN '<24'
			 END AS CaseCreateBucket

			 ,*
						
FROM #pullvalidate AS p
)SELECT CaseReqBucket,CaseCreateBucket,SixPMFlag,InclusionFlag,COUNT(*) AS NumRecords
 FROM proofit
 GROUP BY CaseReqBucket,CaseCreateBucket,SixPMFlag,InclusionFlag