
IF object_id('tempdb..##eras') is not null
	drop table ##eras; 

--multiple proc cases with multiple categories or lap/open in same case
WITH eras AS 
(  SELECT CASE WHEN ErasCase='Eras Case' THEN 1 ELSE 0 END AS erasflag			
	
,*
FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc
), multlogs AS (
	SELECT log_id 
	FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc GROUP BY LOG_ID HAVING COUNT(*)>1
	),
 fin AS (
SELECT	PAT_NAME,PAT_MRN_ID,HOSP_ADMSN_TIME,HOSP_DISCH_TIME,e.LOG_ID,SURGERY_DATE,SurgeonName,CPTCode,ProcedureCategory,ProcedureType,
		InCPTList,PROC_DISPLAY_NAME,procline ,ErasCase
 FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc AS e
 JOIN (SELECT  log_id,SUM(erasflag) AS toteras
		,COUNT(DISTINCT ProcedureCategory) AS catcount
		,COUNT(DISTINCT ProcedureType) AS typecount
       FROM eras
	   GROUP BY LOG_ID HAVING SUM(erasflag)>0
	   ) AS fl ON e.LOG_ID=fl.LOG_ID
	),flags AS 
	(SELECT  log_id
		,COUNT(DISTINCT ProcedureCategory) AS catcount
		,COUNT(DISTINCT ProcedureType) AS typecount
       FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc
	   GROUP BY LOG_ID
	   )SELECT 'Eras cases' AS recordtype, fin.* 
	   INTO ##eras
	   FROM fin
	JOIN multlogs AS logs ON fin.LOG_ID=logs.LOG_ID
	JOIN flags AS f ON f.log_id=fin.log_id
	--WHERE f.catcount>1 OR f.typecount>1
	ORDER BY fin.log_id,procline;



IF object_id('tempdb..##multcase') is not null
	drop table ##multcase; 


WITH eras AS 
(  SELECT CASE WHEN ErasCase='Eras Case' THEN 1 ELSE 0 END AS erasflag
,*
FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc
), multlogs AS (
	SELECT log_id 
	FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc GROUP BY LOG_ID HAVING COUNT(*)>1
	),
 fin AS (
SELECT	PAT_NAME,PAT_MRN_ID,HOSP_ADMSN_TIME,HOSP_DISCH_TIME,e.LOG_ID,SURGERY_DATE,SurgeonName,CPTCode,ProcedureCategory,ProcedureType,
		InCPTList,PROC_DISPLAY_NAME,procline ,ErasCase
 FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc AS e
 JOIN (SELECT  log_id,SUM(erasflag) AS toteras
       FROM eras
	   GROUP BY LOG_ID HAVING SUM(erasflag)=0
	   ) AS fl ON e.LOG_ID=fl.LOG_ID
	),flags AS 
	(SELECT  log_id
		,COUNT(DISTINCT ProcedureCategory) AS catcount
		,COUNT(DISTINCT ProcedureType) AS typecount
       FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc
	   GROUP BY LOG_ID
	   )
	SELECT 'Mult types' AS recordtype, fin.*
	INTO ##multcase
	FROM fin
	JOIN multlogs AS logs ON fin.LOG_ID=logs.LOG_ID
	JOIN flags AS f ON f.log_id=fin.log_id
	WHERE f.catcount>1 OR f.typecount>1
	
	ORDER BY fin.log_id,procline;


	SELECT *
	FROM ##eras AS e
	UNION ALL
    SELECT * FROM ##multcase AS m
	ORDER BY recordtype,LOG_ID,procline





SELECT PAT_NAME,PAT_MRN_ID,HOSP_ADMSN_TIME,HOSP_DISCH_TIME,LOG_ID,SURGERY_DATE,SurgeonName,CPTCode,ProcedureCategory,ProcedureType,InCPTList,PROC_DISPLAY_NAME,procline ,ErasCase
FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc
JOIN  SELECT 
	  RADB.dbo.CRD_ERAS_YNHGI_Caseallproc

WHERE LOG_id IN (SELECT log_id FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc GROUP BY log_id HAVING COUNT(*)>1)

ORDER BY log_id,procline


--davinci booked first
SELECT PAT_NAME,PAT_MRN_ID,HOSP_ADMSN_TIME,HOSP_DISCH_TIME,LOG_ID,SURGERY_DATE,SurgeonName,CPTCode,ProcedureCategory,ProcedureType,InCPTList,PROC_DISPLAY_NAME,procline ,ErasCase
FROM RADB.dbo.CRD_ERAS_YNHGI_Caseallproc
WHERE LOG_id='611085'
ORDER BY log_id,procline




--SELECT * 
--FROM RADB.dbo.CRD_ERASYNHGI_Case
--WHERE admissioncsn IN (SELECT admissioncsn FROM RADB.dbo.CRD_ERASYNHGI_Case GROUP BY admissioncsn HAVING COUNT(*)>1)
--ORDER BY admissioncsn
	
--SELECT ProjectID FROM radb.dbo.CRD_ERASProject_Dim WHERE DeliveryNetwork_ShortName=@dn AND ProjectShortName=@erasproject

IF object_id('tempdb.dbo.#logid') IS NOT NULL
	DROP TABLE #logid;


SELECT DISTINCT clarity.dbo.OR_LOG.LOG_ID
INTO #logid
FROM 
 clarity.dbo.OR_LOG 
   left OUTER JOIN CLARITY.dbo.OR_LOG_ALL_PROC  ON clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.OR_LOG_ALL_PROC.LOG_ID   
   left OUTER JOIN CLARITY.dbo.OR_PROC  ON (CLARITY.dbo.OR_LOG_ALL_PROC.OR_PROC_ID=CLARITY.dbo.OR_PROC.OR_PROC_ID)   
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
  JOIN RADB.dbo.CRD_ERAS_YNHGI_CptList AS cptdim ON cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE;


IF object_id('RADB.dbo.CRD_ERAS_YNHGI_Caseallproc') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_YNHGI_Caseallproc;

SELECT   
  clarity.dbo.OR_LOG.LOG_ID,
  cptdim.ProcedureCategory,  
  cptdim.ProcedureType,
  clarity.dbo.PATIENT.PAT_NAME,
  clarity.dbo.patient.PAT_MRN_ID,
  clarity.dbo.patient.pat_id,  
  clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME,
  clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,
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
  ErasCase=CASE WHEN LTRIM(clarity.dbo.OR_LOG_ALL_PROC.PROC_DISPLAY_NAME) LIKE 'ERAS%'  THEN 'Eras Case'
		ELSE 'Non-ERAS Case' END , 
  clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE AS CPTCode,
  
  InCPTList=CASE WHEN cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE THEN 'Yes' ELSE 'No' END,
  clarity.dbo.F_AN_RECORD_SUMMARY.AN_52_ENC_CSN_ID AS anescsn,
  clarity.dbo.PAT_OR_ADM_LINK.OR_LINK_CSN AS admissioncsn,
  clarity.dbo.PAT_OR_ADM_LINK.PAT_ENC_CSN_ID AS surgicalcsn,
  clarity.dbo.or_proc.proc_name AS procedurename,
  CLARITY_SER_LOG_ROOM.PROV_NAME AS Surgery_Room_Name,
  CLARITY_SER_Surg.PROV_NAME AS SurgeonName ,
  allsurg.ROLE_C  ,
  allsurg.PANEL  ,
   CLARITY.dbo.OR_LOG_ALL_PROC.ALL_PROCS_PANEL,
  --CLARITY_SER_Anthesia1.PROV_NAME,
  clarity.dbo.OR_LOG_ALL_PROC.LINE AS procline,
  clarity.dbo.ZC_OR_SERVICE.NAME AS SurgeryServiceName,  
  clarity.dbo.OR_LOG.SURGERY_DATE,
  DateKey=RADB.dbo.fn_Generate_DateKey(clarity.dbo.OR_LOG.SURGERY_DATE) ,
  clarity.dbo.OR_LOG.SCHED_START_TIME,
  clarity.dbo.CLARITY_LOC.LOC_NAME AS SurgeryLocation,
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
  pacudelay=NULL,
  --begin process metrics
  preadm_counseling=0,
  pacutemp=CAST(NULL AS NUMERIC(13,2)),
  NormalTempInPacu=CAST(NULL AS TINYINT),
  ambulatepod0=CAST(0 AS TINYINT),
  clearliquids_3ind=CAST(0 AS TINYINT),
  clearliquids_pod0=CAST(0 AS TINYINT),
  ambulate_pod1=CAST(0 AS TINYINT),
  solidfood_pod1=CAST(0 AS TINYINT),
  ambulate_pod2=CAST(0 AS TINYINT),
  date_toleratediet=CAST(NULL AS DATETIME),
  hrs_toleratediet=CAST(null AS INT),
  date_bowelfunction=CAST(NULL AS DATETIME),
  hrs_tobowelfunction=CAST(NULL AS INT),
  thoracic_epi = CAST(0 AS INT),
  mm_pain= CAST (0 AS INT),
  iv_totalvolume_intraop =CAST(NULL AS int),
  iv_intraop_threshold =CAST( NULL AS decimal(13,4)),
  goal_guidelines=cast (NULL AS INT),  
  mm_antiemetic_intraop=CAST(0 AS INTEGER),
  iv_fluid_dc_pod0=CAST(0 AS INT),
  iv_fluid_dc_pod1noon=CAST(0 AS INT),
  iv_fluid_dc_pod2=CAST(0 AS INT),
  foleypod1=CAST(0 AS INT),
  foleycount=CAST(0 AS INT),
  foleyremovedcount=CAST(0 AS INT),
  date_last_painmed=CAST(NULL AS DATETIME),
  hrs_last_painmed=cast( NULL AS int)

  
  
INTO RADB.dbo.CRD_ERAS_YNHGI_Caseallproc

FROM    clarity.dbo.OR_LOG 
   JOIN #logid AS logs ON logs.LOG_ID=clarity.dbo.OR_LOG.LOG_ID
   LEFT OUTER JOIN CLARITY.dbo.OR_LOG_ALL_PROC  ON clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.OR_LOG_ALL_PROC.LOG_ID   
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
  LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Surg ON (ZC_PAT_CLASS_Surg.ADT_PAT_CLASS_C=CLARITY.dbo.OR_LOG.PAT_TYPE_C)   
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zocc  ON zocc.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zoclog  ON zoclog.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
  LEFT JOIN RADB.dbo.CRD_ERAS_YNHGI_CptList AS cptdim ON cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE

  												
  LEFT OUTER JOIN CLARITY.dbo.PATIENT ON (CLARITY.dbo.PATIENT.PAT_ID=CLARITY.dbo.PAT_ENC_HSP.PAT_ID)
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

  
WHERE  (clarity.dbo.OR_LOG.SURGERY_DATE>='1/1/2015' )
 AND     clarity.dbo.CLARITY_LOC.LOC_NAME  IN  ( 'YNH NORTH PAVILION OR','YNH EAST PAVILION OR','YNH SOUTH PAVILION OR','SRC MAIN OR')
  AND at.name='Elective'
  AND basecl.name='Inpatient'
  AND clarity.dbo.or_log.PAT_TYPE_C IN (101,108)
   AND clarity.dbo.or_log.STATUS_C IN (2,5)
   AND PAT_ENC_HSP.HOSP_DISCH_TIME IS NOT NULL
   
   
   

ORDER BY clarity.dbo.or_log.LOG_ID,clarity.dbo.OR_LOG_ALL_PROC.line;

UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET CaseLength_hrs=DATEDIFF(HOUR,inroom,outofroom);

UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET CaseLength_min=DATEDIFF(MINUTE,inroom,outofroom);




