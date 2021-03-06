--SELECT * FROM dbo.CRD_ERAS_YNHGI_MetricDim AS ceymd
--WHERE MetricType='Process'


SELECT COUNT(*), sum(CASE WHEN vlt.CASE_REQUEST_DTTM IS NULL THEN 1 ELSE 0 END)


FROM ##logid AS ol
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON vlt.LOG_ID=ol.LOG_ID


SELECT COUNT(*) AS TotalRows,SUM(CASE WHEN oc.RECORD_CREATE_DATE IS NULL THEN 1 ELSE 0 end) AS RecCreateNullCt,SUM(CASE WHEN vlt.case_request_dttm IS NULL THEN 1 ELSE 0 end) AS reqnullcount
FROM ##logid AS l
LEFT JOIN clarity.dbo.OR_CASE AS oc ON l.log_id=oc.OR_CASE_ID
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON vlt.LOG_ID=l.log_id

IF object_id('tempdb.dbo.##logid') IS NOT NULL
	DROP TABLE ##logid;

SELECT DISTINCT orl.LOG_ID
INTO ##logid
FROM 
 clarity.dbo.OR_LOG AS orl
   left OUTER JOIN CLARITY.dbo.OR_LOG_ALL_PROC  ON orl.LOG_ID=clarity.dbo.OR_LOG_ALL_PROC.LOG_ID   
   left OUTER JOIN CLARITY.dbo.OR_PROC  ON (CLARITY.dbo.OR_LOG_ALL_PROC.OR_PROC_ID=CLARITY.dbo.OR_PROC.OR_PROC_ID)   
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
  LEFT JOIN clarity.dbo.CLARITY_LOC AS cl ON orl.LOC_ID=cl.LOC_ID
  JOIN RADB.dbo.CRD_ERAS_YNHGI_CptList AS cptdim ON cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE
WHERE orl.STATUS_C IN (2,5)
AND cl.LOC_NAME IN  ( 'YNH NORTH PAVILION OR','YNH EAST PAVILION OR','YNH SOUTH PAVILION OR','SRC MAIN OR')
AND orl.SURGERY_DATE>='1/1/2015';

IF object_id('radb.dbo.CRD_ERAS_YNHGI_Case_Sched') is not null
	drop table radb.dbo.CRD_ERAS_YNHGI_Case_Sched; 

WITH sched AS (
SELECT 
p.PAT_NAME AS PatientName,
p.PAT_MRN_ID AS MRN,
zpc.name AS OR_PatClass,ol.LOG_ID,ol.SURGERY_DATE, cl.LOC_NAME AS SurgeryLocation,ol.SCHED_START_TIME,
CLARITY_SER_Surg.PROV_NAME AS PrimarySurgeon,vlt.PATIENT_IN_ROOM_DTTM,
vlt.PROCEDURE_START_DTTM,
vlt.PROCEDURE_COMP_DTTM,
vlt.PATIENT_OUT_ROOM_DTTM,
vlt.CASE_REQUEST_DTTM,
oc.RECORD_CREATE_DATE,
CaseReqDiff=DATEDIFF(HOUR,vlt.CASE_REQUEST_DTTM,vlt.PATIENT_IN_ROOM_DTTM),
ReccreateDiff=DATEDIFF(HOUR,oc.RECORD_CREATE_DATE,vlt.PATIENT_IN_ROOM_DTTM),
CASE WHEN vlt.CASE_REQUEST_DTTM IS NULL THEN 1 ELSE 0 END AS CaseReqMissing,
InclusionFlag=CAST(NULL AS INT) 
CASE WHEN vlt.CASE_REQUEST_DTTM IS NULL THEN
		  CASE WHEN DATEDIFF(HOUR,oc.RECORD_CREATE_DATE,vlt.PATIENT_IN_ROOM_DTTM)>=48 
		  OR (CASE WHEN DATEDIFF(HOUR,oc.RECORD_CREATE_DATE,vlt.PATIENT_IN_ROOM_DTTM)>=24
			           AND DATEDIFF(HOUR,oc.RECORD_CREATE_DATE,vlt.PATIENT_IN_ROOM_DTTM)<48)
				AND SixPMFlag=1)
				THEN 1 ELSE 0 END
     WHEN vlt.CASE_REQUEST_DTTM IS NOT NULL THEN 
		  CASE WHEN  DATEDIFF(HOUR,vlt.CASE_REQUEST_DTTM,vlt.PATIENT_IN_ROOM_DTTM)>18 THEN 1 ELSE 0 END
	END AS InclusionFlag
--ol.*

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
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON vlt.LOG_ID=ol.LOG_ID

)SELECT * 
INTO   radb.dbo.CRD_ERAS_YNHGI_Case_Sched
FROM sched


SELECT *,convert(TIME,patient_in_room_dttm) InRoomTime,CASE WHEN convert(TIME,patient_in_room_dttm)>='18:00' THEN 1 ELSE 0 END AS SixPMFlag
,CASE WHEN CaseReqMissing=1 THEN 
		CASE WHEN 
FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched



SELECT MIN(SURGERY_DATE),MAX(SURGERY_DATE) 
FROM radb.dbo.CRD_ERAS_YNHGI_Case AS ceyc

SELECT *
FROM dbo.OR_CASE_VIRTUAL AS ocv
WHERE OR_CASE_ID=531059

SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched
except
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case


SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched
except
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case


SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case
except
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched



SELECT * 
FROM or_log
WHERE log_id=531059


SELECT *
 FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched
 WHERE LOG_ID IN(
 642841,
604329,
348257,
554160)

 WHERE PrimarySurgeon LIKE '%schuster%'

SELECT *
 FROM radb.dbo.CRD_ERAS_YNHGI_Case
 WHERE SurgeonName LIKE '%schuster%'


SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched
except
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case


SELECT s.*
 FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched AS s
JOIN (
 SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case
EXCEPT
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched) AS x ON x.LOG_ID=s.LOG_ID


SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case
EXCEPT
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched

SELECT *
FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched


SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case
except
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched


SELECT * FROM dbo.CRD_ERAS_YNHGI_Case WHERE LOG_ID=348257


WITH logbase AS (
SELECT 
p.PAT_NAME AS PatientName,
p.PAT_MRN_ID AS MRN,
zpc.name AS OR_PatClass,ol.LOG_ID,SURGERY_DATE, cl.LOC_NAME AS SurgeryLocation,ol.SCHED_START_TIME,
CLARITY_SER_Surg.PROV_NAME AS PrimarySurgeon,vlt.PATIENT_IN_ROOM_DTTM,
ol.STATUS_C,
zos.name AS LogStatus,
vlt.PROCEDURE_START_DTTM,
vlt.PROCEDURE_COMP_DTTM,
vlt.PATIENT_OUT_ROOM_DTTM,
vlt.CASE_REQUEST_DTTM

FROM    clarity.dbo.OR_Log AS ol 
LEFT JOIN clarity.dbo.patient AS p ON ol.PAT_ID=p.PAT_ID
LEFT JOIN clarity.dbo.ZC_PAT_CLASS AS zpc ON zpc.ADT_PAT_CLASS_C=ol.PAT_TYPE_C
LEFT JOIN clarity.dbo.ZC_OR_STATUS AS zos ON zos.STATUS_C=ol.STATUS_C
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
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON vlt.LOG_ID=ol.LOG_ID
) SELECT * 
FROM logbase AS l
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON l.LOG_ID=vlt.LOG_ID
WHERE l.LOG_ID=348257

, s2 AS (SELECT l.*
 FROM logbase AS l 
 JOIN (
 SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case
EXCEPT
SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case_Sched
) AS x ON x.LOG_ID=l.LOG_ID
 )SELECT s2.*,oc.RECORD_CREATE_DATE 
 FROM s2 AS s2
 JOIN clarity.dbo.OR_CASE AS oc ON s2.LOG_ID=oc.OR_CASE_ID

 SELECT *
 FROM clarity.dbo.OR_CASE AS oc
 LEFT JOIN clarity.dbo.OR_CASE_2 AS oc2 ON oc.OR_CASE_ID=oc2.CASE_ID
 WHERE oc.OR_CASE_ID=531059


SELECT zote.name AS TimingEvent,olte.*
FROM clarity.dbo.OR_LOG_TIMING_EVENTS AS olte
LEFT JOIN clarity.dbo.ZC_OR_TIMING_EVENT AS zote ON zote.TIMING_EVENT_C = olte.TIMING_EVENT_C
WHERE LOG_ID=531059
ORDER BY olte.TIMING_EVENT_DTTM

SELECT * 
FROM clarity.dbo.OR_CASE AS oc
LEFT JOIN clarity.dbo.patient AS p ON oc.PAT_ID=p.PAT_ID
WHERE p.PAT_MRN_ID='MR1708246'

SELECT 
p.PAT_NAME AS PatientName,
p.PAT_MRN_ID AS MRN,
zpc.name AS OR_PatClass,ol.LOG_ID,SURGERY_DATE, cl.LOC_NAME AS SurgeryLocation,ol.SCHED_START_TIME,
CLARITY_SER_Surg.PROV_NAME AS PrimarySurgeon,vlt.PATIENT_IN_ROOM_DTTM,
vlt.PROCEDURE_START_DTTM,
vlt.PROCEDURE_COMP_DTTM,
vlt.PATIENT_OUT_ROOM_DTTM,
vlt.CASE_REQUEST_DTTM
--ol.*
INTO ##orl
FROM clarity.dbo.OR_Log AS ol
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
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON vlt.LOG_ID=ol.LOG_ID

WHERE p.PAT_MRN_ID='MR1708246'
AND ol.STATUS_C IN (2,5)


SELECT *
FROM clarity.dbo.V_LOG_TIMING_EVENTS AS vlte



SELECT  vl.*,a.*
FROM ##allprocs AS a
JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vl ON a.log_id=vl.LOG_ID
WHERE a.log_id IN (357776,
378237,
335694)

SELECT olt.*,te.NAME AS TimingEvent
FROM clarity.dbo.OR_LOG_TIMING_EVENTS AS olt
LEFT JOIN clarity.dbo.ZC_OR_TIMING_EVENT AS te ON te.TIMING_EVENT_C=olt.TIMING_EVENT_C
WHERE olt.LOG_ID
IN (SELECT DISTINCT  TOP  10 log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case )
ORDER BY olt.LOG_ID,olt.TIMING_EVENT_DTTM




SELECT * FROM dbo.ReDiscovery_Costs AS rdc


SELECT 
FROM clarity.dbo.PAT_ENC_HSP AS peh
LEFT JOIN clarity.dbo.HSP_ACCOUNT AS ha ON peh.HSP_ACCOUNT_ID=ha.HSP_ACCOUNT_ID
LEFT JOIN radb.dbo.vw_LocHierarchy_Department AS lh ON lh.Department_ID



--anne's har:505391986

sp_help 


SELECT YEAR(ha.DISCH_DATE_TIME),MONTH(ha.DISCH_DATE_TIME),COUNT(*)
FROM radb.dbo.ReDiscovery_Costs AS c
LEFT JOIN clarity.dbo.HSP_ACCOUNT AS ha ON c.HSP_ACCOUNT_ID=ha.HSP_ACCOUNT_ID
GROUP BY YEAR(ha.DISCH_DATE_TIME),MONTH(ha.DISCH_DATE_TIME)
ORDER BY 1,2

--baseclass
ACCT_BASECLS_HA_C
ADMIT_TYPE_EPT_C 7060 




SELECT TOP 100
 ADMIT_TYPE_EPT_C

 
 SELECT 
 hsp.HSP_ACCOUNT_ID
 ,hsp.ACCT_BASECLS_HA_C
 ,basecl.name AS BaseClass   --inpatient, outpatient, emergency
 ,hsp3.ADMIT_TYPE_EPT_C
 ,at.name AS AdmitType --whether patient had an elective or emergent procedure
 FROM clarity.dbo.HSP_ACCOUNT AS hsp
 LEFT JOIN clarity.dbo.HSP_ACCOUNT_3 AS hsp3 ON hsp.HSP_ACCOUNT_ID=hsp3.HSP_ACCOUNT_ID
 LEFT JOIN clarity.dbo.ZC_ACCT_BASECLS_HA AS basecl ON basecl.ACCT_BASECLS_HA_C=hsp.ACCT_BASECLS_HA_C
 LEFT JOIN Clarity.dbo.ZC_HOSP_ADMSN_TYPE AS at ON at.HOSP_ADMSN_TYPE_C=hsp3.ADMIT_TYPE_EPT_C
 WHERE hsp.HSP_ACCOUNT_ID IN ( 506423619,505391986)

 SELECT * 
 FROM radb.dbo.vw_PatEnc AS vpe
 WHERE HSP_ACCOUNT_ID= 505391986


 SELECT pe.APPT_MADE_DATE,pe.CONTACT_DATE,pe.ENTRY_TIME,pe.*,'>>>>> pe2>>>>',pe2.*
 FROM clarity.dbo.PAT_ENC AS pe
 LEFT join clarity.dbo.PAT_ENC_2 AS pe2 ON pe.PAT_ENC_CSN_ID=pe2.PAT_ENC_CSN_ID
 LEFT join clarity.dbo.PAT_ENC_3 AS pe3 ON pe.PAT_ENC_CSN_ID=pe3.PAT_ENC_CSN
 LEFT join clarity.dbo.PAT_ENC_4 AS pe4 ON pe.PAT_ENC_CSN_ID=pe4.PAT_ENC_CSN_ID
 LEFT join clarity.dbo.PAT_ENC_5 AS pe5 ON pe.PAT_ENC_CSN_ID=pe5.PAT_ENC_CSN_ID
 WHERE pe.PAT_ENC_CSN_ID IN (SELECT admissioncsn FROM radb.dbo.CRD_ERAS_YNHGI_Case )


 SELECT pe.APPT_MADE_DATE,pe.CONTACT_DATE,pe.ENTRY_TIME,pe.*,'>>>>> pe2>>>>',pe2.*
 FROM clarity.dbo.PAT_ENC AS pe
 LEFT join clarity.dbo.PAT_ENC_2 AS pe2 ON pe.PAT_ENC_CSN_ID=pe2.PAT_ENC_CSN_ID
 LEFT join clarity.dbo.PAT_ENC_3 AS pe3 ON pe.PAT_ENC_CSN_ID=pe3.PAT_ENC_CSN
 LEFT join clarity.dbo.PAT_ENC_4 AS pe4 ON pe.PAT_ENC_CSN_ID=pe4.PAT_ENC_CSN_ID
 LEFT join clarity.dbo.PAT_ENC_5 AS pe5 ON pe.PAT_ENC_CSN_ID=pe5.PAT_ENC_CSN_ID
 WHERE pe.CONTACT_DATE>'11/10/2016'
 AND pe.ENC_TYPE_C=50




--SELECT * FROM dbo.CRD_ERAS_YNHGI_Case 
--WHERE PAT_MRN_ID ='MR3820869'
  

IF object_id('tempdb..##allprocs') IS NOT NULL
	DROP TABLE ##allprocs;

SELECT   
  clarity.dbo.OR_LOG.LOG_ID,
  clarity.dbo.PATIENT.PAT_NAME,
  clarity.dbo.patient.PAT_MRN_ID,
  clarity.dbo.patient.pat_id,  
  clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME,
  clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,
  hsp.hsp_account_id AS HAR,
  hsp.admission_type_c,
  eradm.name AS AdmissionTypeHAR,
  at.name AS AdmitType,  
  clarity.dbo.or_log.PAT_TYPE_C AS Surgery_pat_class_c,
  ZC_PAT_CLASS_Surg.NAME AS Surgery_Patient_Class,  
  basecl.name AS BaseClass,
  clarity.dbo.or_LOG.STATUS_C,
  zos.NAME AS LogStatus,
  clarity.dbo.or_log.CASE_CLASS_C ,
  zocc.NAME AS CASECLASS_DESCR,   
  clarity.dbo.or_log.NUM_OF_PANELS,
  clarity.dbo.OR_LOG_ALL_PROC.PROC_DISPLAY_NAME,   --added
  ErasProcedure=CASE WHEN LTRIM(clarity.dbo.OR_LOG_ALL_PROC.PROC_DISPLAY_NAME) LIKE 'ERAS%'  THEN 'Eras Procedure'
		ELSE 'Non-ERAS Procedure' END ,
  clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE,
  clarity.dbo.F_AN_RECORD_SUMMARY.AN_52_ENC_CSN_ID AS anescsn,
  clarity.dbo.PAT_OR_ADM_LINK.OR_LINK_CSN AS admissioncsn,
  clarity.dbo.PAT_OR_ADM_LINK.PAT_ENC_CSN_ID AS surgicalcsn,
  clarity.dbo.or_proc.proc_name AS procedurename,  
  CASE WHEN cptdim.CPTCode IS NOT NULL THEN 'Yes' ELSE 'No' END AS InCPTList,
  cptdim.ProcedureCategory,
  cptdim.CPTCode,
  cptdim.CPTDescription,
  cptdim.ProcedureSubCategory,  
  cptdim.OpenVsLaparoscopic,
  CLARITY_SER_LOG_ROOM.PROV_NAME AS Surgery_Room_Name,
  CLARITY_SER_Surg.PROV_NAME AS SurgeonName ,
  allsurg.ROLE_C  ,
  allsurg.PANEL  ,
   CLARITY.dbo.OR_LOG_ALL_PROC.ALL_PROCS_PANEL,
  --CLARITY_SER_Anthesia1.PROV_NAME,
  clarity.dbo.OR_LOG_ALL_PROC.LINE AS ProcLineNumber,
  clarity.dbo.ZC_OR_SERVICE.NAME AS SurgeryServiceName,  
  clarity.dbo.OR_LOG.SURGERY_DATE,
  DateKey=RADB.dbo.fn_Generate_DateKey(clarity.dbo.OR_LOG.SURGERY_DATE) ,
  clarity.dbo.OR_LOG.SCHED_START_TIME,
  clarity.dbo.CLARITY_LOC.LOC_NAME AS SurgeryLocation,
  Campus=CASE WHEN clarity.dbo.CLARITY_LOC.LOC_NAME LIKE 'YNH%' THEN 'YSC' WHEN clarity.dbo.CLARITY_LOC.LOC_NAME LIKE 'SRC%' THEN 'SRC' ELSE '*Unknown' END,
  Setup_Start.TRACKING_TIME_IN AS setupstart,
  Setup_End.TRACKING_TIME_IN AS setupend,
  In_Room.TRACKING_TIME_IN AS inroom,
  Out_of_Room.TRACKING_TIME_IN AS outofroom,
  Cleanup_Start.TRACKING_TIME_IN AS cleanupstart,
  Cleanup_End.TRACKING_TIME_IN AS cleanupend,
  PACU_IN.TRACKING_TIME_IN AS inpacu,
  PACU_OUT.TRACKING_TIME_IN AS outofpacu,
  PRE_PROC_IN.TRACKING_TIME_IN AS inpreprocedure,
  PRE_PROC_OUT.TRACKING_TIME_IN AS outofpreprocedure,
  ANES_START.TRACKING_TIME_IN AS anesstart,
  ANES_FINISH.TRACKING_TIME_IN AS anesfinish,
  PROC_START.TRACKING_TIME_IN AS procedurestart,
  PROC_FINISH.TRACKING_TIME_IN AS procedurefinish,
  postopday1_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,1,PROC_START.TRACKING_TIME_IN))),
  postopday2_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,2,PROC_START.TRACKING_TIME_IN))),
  postopday3_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,3,PROC_START.TRACKING_TIME_IN))),
  postopday4_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,4,PROC_START.TRACKING_TIME_IN))),
  CaseLength_min=CAST(NULL AS int),
  CaseLength_hrs=CAST(NULL AS NUMERIC(13,4)),
  timeinpacu_min=NULL,
  pacudelay=NULL 
  
  
INTO ##allprocs

FROM    clarity.dbo.OR_LOG 
  
   left OUTER JOIN CLARITY.dbo.OR_LOG_ALL_PROC  ON clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.OR_LOG_ALL_PROC.LOG_ID   --AND clarity.dbo.OR_LOG_ALL_PROC.line=1
   left OUTER JOIN CLARITY.dbo.OR_PROC  ON (CLARITY.dbo.OR_LOG_ALL_PROC.OR_PROC_ID=CLARITY.dbo.OR_PROC.OR_PROC_ID)
   LEFT OUTER JOIN 
	(SELECT allsurg.*
	FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
	JOIN (SELECT log_Id,MAX(line) AS maxline
		  FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
		  WHERE PANEL=1
		  AND  ROLE_C=1 
		  GROUP BY log_id   ) AS maxsurg ON maxsurg.LOG_ID=allsurg.LOG_ID
											AND maxsurg.maxline=allsurg.line
	) AS allsurg ON allsurg.LOG_ID=clarity.dbo.or_log.LOG_ID 
	
  LEFT OUTER JOIN clarity.dbo.PAT_OR_ADM_LINK ON (CLARITY.dbo.PAT_OR_ADM_LINK.LOG_ID=CLARITY.dbo.OR_LOG.LOG_ID)
  LEFT OUTER JOIN clarity.dbo.PAT_ENC_HSP ON (CLARITY.dbo.PAT_ENC_HSP.PAT_ENC_CSN_ID=CLARITY.dbo.PAT_OR_ADM_LINK.OR_LINK_CSN)   
  LEFT OUTER JOIN clarity.dbo.HSP_ACCOUNT_3 AS hsp3 ON hsp3.HSP_ACCOUNT_ID=clarity.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID
  LEFT OUTER JOIN clarity.dbo.HSP_ACCOUNT AS hsp ON CLARITY.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID=hsp.HSP_ACCOUNT_ID
  LEFT JOIN clarity.dbo.ZC_ACCT_BASECLS_HA AS basecl ON basecl.ACCT_BASECLS_HA_C=hsp.ACCT_BASECLS_HA_C
  LEFT JOIN Clarity.dbo.ZC_HOSP_ADMSN_TYPE AT ON HSP3.ADMIT_TYPE_EPT_C = at.HOSP_ADMSN_TYPE_C
  LEFT JOIN Clarity.dbo.ZC_ER_ADMIT_TYP_HA eradm ON eradm.ER_ADMIT_TYP_HA_C = hsp.ADMISSION_TYPE_C
  LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Surg ON (ZC_PAT_CLASS_Surg.ADT_PAT_CLASS_C=CLARITY.dbo.OR_LOG.PAT_TYPE_C)   
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zocc  ON zocc.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zoclog  ON zoclog.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
  LEFT JOIN RADB.dbo.CRD_ERAS_YNHGI_CptList AS cptdim ON cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE  												
  INNER JOIN CLARITY.dbo.PATIENT ON (CLARITY.dbo.PATIENT.PAT_ID=CLARITY.dbo.PAT_ENC_HSP.PAT_ID)
  LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_Surg ON (allsurg.SURG_ID=CLARITY_SER_Surg.PROV_ID)
  FULL OUTER JOIN clarity.dbo.F_AN_RECORD_SUMMARY ON (clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.F_AN_RECORD_SUMMARY.AN_LOG_ID)
   LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_Anthesia1 ON (clarity.dbo.F_AN_RECORD_SUMMARY.AN_RESP_PROV_ID=CLARITY_SER_Anthesia1.PROV_ID)
   LEFT OUTER JOIN clarity.dbo.ZC_OR_SERVICE ON (clarity.dbo.ZC_OR_SERVICE.SERVICE_C=clarity.dbo.OR_LOG.SERVICE_C)
   LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_LOG_ROOM ON (CLARITY_SER_LOG_ROOM.PROV_ID=CLARITY.dbo.OR_LOG.ROOM_ID)
   LEFT OUTER JOIN clarity.dbo.CLARITY_LOC ON (clarity.dbo.CLARITY_LOC.LOC_ID=clarity.dbo.OR_LOG.LOC_ID)
   LEFT OUTER JOIN clarity.dbo.ZC_OR_STATUS AS zos   ON zos.STATUS_C=clarity.dbo.OR_LOG.STATUS_C
   LEFT OUTER JOIN clarity.dbo.ZC_CASE_TYPE AS zct ON zct.CASE_TYPE_C=clarity.dbo.or_log.CASE_TYPE_C
   
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME 
  
WHERE
( CASETIME .TRACKING_EVENT_C  = 330  )
  )  Setup_Start ON (Setup_Start.LOG_ID=CLARITY.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 340  )
  )  Setup_End ON (Setup_End.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 60  )
  )  In_Room ON (In_Room.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
  LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 110  )
  )  Out_of_Room ON (Out_of_Room.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 400  )
  )  Cleanup_Start ON (Cleanup_Start.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 410)
  )  Cleanup_End ON (Cleanup_End.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 120)
  )  PACU_IN ON (PACU_IN.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  CLARITY.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 140)
  )  PACU_OUT ON (PACU_OUT.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  CLARITY.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 20  )
  )  PRE_PROC_IN ON (PRE_PROC_IN.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  CLARITY.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 50)
  )  PRE_PROC_OUT ON (PRE_PROC_OUT.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
  --new events
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  CLARITY.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 70)
  )  ANES_START ON (ANES_START.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  CLARITY.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 100)
  )  ANES_FINISH ON (ANES_FINISH.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  CLARITY.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 80)
  )  PROC_START ON (PROC_START.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 390)
  )  PROC_FINISH ON (PROC_FINISH.LOG_ID=CLARITY.dbo.OR_LOG.LOG_ID)

  
--WHERE  clarity.dbo.OR_LOG.LOG_ID='681407'
WHERE (clarity.dbo.OR_LOG.SURGERY_DATE>='1/1/2015' )
 AND     clarity.dbo.CLARITY_LOC.LOC_NAME  IN  ( 'YNH NORTH PAVILION OR','YNH EAST PAVILION OR','YNH SOUTH PAVILION OR','SRC MAIN OR')
 --AND	clarity.dbo.clarity_loc.LOC_ID=1000991
  --AND at.name='Elective'
  --AND basecl.name='Inpatient'  
  --AND clarity.dbo.or_log.PAT_TYPE_C IN (101,108)
  -- AND clarity.dbo.or_log.STATUS_C IN (2,5)
--   AND PAT_ENC_HSP.HOSP_DISCH_TIME IS NOT NULL   
--AND CLARITY.dbo.PATIENT.PAT_MRN_ID IN ('MR3099458','MR3547393','MR909718')
--AND CLARITY.dbo.PATIENT.PAT_MRN_ID IN ('MR1708246','MR1372863','MR3577760')
--and CLARITY.dbo.PATIENT.PAT_MRN_ID  IN ('MR25--18559','MR4980357')


SELECT * FROM ##allprocs AS a
ORDER BY clarity.dbo.or_log.LOG_ID,clarity.dbo.OR_LOG_ALL_PROC.line;

SELECT CASE WHEN c.LOG_ID IS NOT NULL THEN 'In dashboard' ELSE 'Not in dashboard' END 
,a.LOG_ID
,a.PAT_NAME
,a.PAT_MRN_ID
,a.HAR
,a.admissioncsn AS csn
,a.AdmitType
,a.Surgery_pat_class_c
,a.Surgery_Patient_Class
,a.BaseClass
,a.STATUS_C
,a.HOSP_ADMSN_TIME
,a.HOSP_DISCH_TIME
,a.HAR
,a.LogStatus
,a.CASE_CLASS_C
,a.CASECLASS_DESCR
,a.NUM_OF_PANELS
,a.PROC_DISPLAY_NAME
,a.ErasProcedure
,a.REAL_CPT_CODE
,a.InCPTList
,a.ProcedureCategory
,a.CPTCode
,a.CPTDescription
,a.ProcedureSubCategory
,a.OpenVsLaparoscopic
,a.Surgery_Room_Name
,a.SurgeonName
,a.ROLE_C
,a.PANEL
,a.ALL_PROCS_PANEL
,a.ProcLineNumber
,a.SurgeryServiceName
,a.SURGERY_DATE
,a.SCHED_START_TIME
,a.SurgeryLocation
FROM ##allprocs AS a
LEFT JOIN radb.dbo.CRD_ERAS_YNHGI_Case AS c ON a.LOG_ID=c.LOG_ID
ORDER BY LOG_ID,ProcLineNumber


SELECT * FROM dbo.CRD_ERAS_YNHGI_Case AS ceyc WHERE LOG_ID='661632'

SELECT mrn,PatientName,Admission_DTTM,Discharge_DTTM,SurgeryLocation,SurgeonName,ProcLineNumber,ProcedureDisplayName
FROM radb.dbo.vw_CRD_ERAS_YNHGI_Report_Detail AS vceyrd
WHERE mrn IN ('MR3099458','MR3547393','MR909718')
ORDER BY Log_ID,ProcLineNumber

WITH orderset AS (

SELECT 
rid=ROW_NUMBER() OVER (PARTITION BY om.PAT_ENC_CSN_ID ORDER BY order_dttm)
,ec.PAT_ENC_CSN_ID
,om.ORDER_DTTM
,om.ORDER_ID
,om.DISPLAY_NAME AS 'Order_Display_Name'
,om.ORDER_TYPE_C

FROM   RADB.dbo.CRD_ERAS_YNHGI_EncDim AS ec
JOIN  clarity.dbo.ORDER_METRICS AS om ON om.PAT_ENC_CSN_ID=ec.PAT_ENC_CSN_ID
WHERE om.PRL_ORDERSET_ID=3040002508
) SELECT enc.*
, FirstOS_ordernumber=o.ORDER_ID
,FirstOS_ordername=o.Order_Display_Name
,FirstOS_orderdate=o.ORDER_DTTM
,OrdersetFlag=1
FROM RADB.dbo.CRD_ERAS_YNHGI_EncDim AS enc
LEFT JOIN orderset AS o ON o.PAT_ENC_CSN_ID=enc.PAT_ENC_CSN_ID
WHERE o.rid=1
AND enc.PAT_MRN_ID IN ('MR3099458','MR3547393','MR909718')


