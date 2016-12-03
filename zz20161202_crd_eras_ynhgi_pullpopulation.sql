IF object_id('tempdb.dbo.##logid') IS NOT NULL
	DROP TABLE ##logid;


SELECT DISTINCT clarity.dbo.OR_LOG.LOG_ID
INTO ##logid
FROM 
 clarity.dbo.OR_LOG 
   left OUTER JOIN CLARITY.dbo.OR_LOG_ALL_PROC  ON clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.OR_LOG_ALL_PROC.LOG_ID   
   left OUTER JOIN CLARITY.dbo.OR_PROC  ON (CLARITY.dbo.OR_LOG_ALL_PROC.OR_PROC_ID=CLARITY.dbo.OR_PROC.OR_PROC_ID)   
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
  JOIN RADB.dbo.CRD_ERAS_YNHGI_CptList AS cptdim ON cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE;

  

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
   JOIN ##logid AS l ON l.log_id=clarity.dbo.OR_LOG.LOG_ID
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



TRUNCATE TABLE RADB.dbo.CRD_ERAS_YNHGI_AllProc;

--create all proc table 
INSERT	radb.dbo.CRD_ERAS_YNHGI_AllProc
        ( LOG_ID
        ,ProcLineNumber
        ,PROC_DISPLAY_NAME
        ,ErasProcedure
        ,ProcedureCategory
        ,ProcedureSubCategory
        ,CPTCode
        ,OpenVsLaparoscopic
        ,InCPTList
        )
SELECT LOG_ID
        ,ProcLineNumber
        ,PROC_DISPLAY_NAME
        ,ErasProcedure
        ,ProcedureCategory
        ,ProcedureSubCategory
        ,CPTCode
        ,OpenVsLaparoscopic
        ,InCPTList
FROM    ##allprocs;



--create case fact

IF object_id('radb.dbo.CRD_ERAS_YNHGI_Case') is not null
	drop table radb.dbo.CRD_ERAS_YNHGI_Case; 

WITH basecase AS (
SELECT logseq=ROW_NUMBER() OVER (PARTITION BY LOG_ID ORDER BY LOG_ID)
,	   LOG_ID
,      PAT_NAME
,      PAT_MRN_ID
,      pat_id
,      HOSP_DISCH_TIME
,      HOSP_ADMSN_TIME
,      HAR
,      AdmitType
,      Surgery_pat_class_c
,      Surgery_Patient_Class
,      BaseClass
,      STATUS_C
,      LogStatus
,      CASE_CLASS_C
,      CASECLASS_DESCR
,      NUM_OF_PANELS
,      anescsn
,      admissioncsn
,      surgicalcsn
,      procedurename
,      Surgery_Room_Name
,      SurgeonName
,      ROLE_C
,      SurgeryServiceName
,      SURGERY_DATE
,      DateKey
,      SCHED_START_TIME
,      SurgeryLocation
,	   Campus
,      setupstart
,      setupend
,      inroom
,      outofroom
,      cleanupstart
,      cleanupend
,      inpacu
,      outofpacu
,      inpreprocedure
,      outofpreprocedure
,      anesstart
,      anesfinish
,      procedurestart
,      procedurefinish
,      postopday1_begin
,      postopday2_begin
,      postopday3_begin
,      postopday4_begin
,      CaseLength_min
,      CaseLength_hrs
,      timeinpacu_min
,       pacudelay
  --case summary attributes  
  ,PrimaryProcedureCategory=CAST(NULL AS VARCHAR(100))
  ,PrimaryOpenVsLap=CAST(NULL AS VARCHAR(25))
  
  ,MultCategories=CAST(0 AS TINYINT)
  ,MultLapOpen=CAST(0 AS TINYINT)
  ,ERASCase=CAST(NULL AS VARCHAR(25))
  ,ReturnToOR=CAST(0 AS TINYINT)
  
  --begin process metrics
   ,preadm_counseling = 0
,       pacutemp = CAST(NULL AS NUMERIC(13, 2))
,       NormalTempInPacu = CAST(NULL AS TINYINT)
,       ambulatepod0 = CAST(0 AS TINYINT)
,       clearliquids_3ind = CAST(0 AS TINYINT)
,       clearliquids_pod0 = CAST(0 AS TINYINT)
,       ambulate_pod1 = CAST(0 AS TINYINT)
,       solidfood_pod1 = CAST(0 AS TINYINT)
,       ambulate_pod2 = CAST(0 AS TINYINT)
,       date_toleratediet = CAST(NULL AS DATETIME)
,       hrs_toleratediet = CAST(NULL AS INT)
,       date_bowelfunction = CAST(NULL AS DATETIME)
,       hrs_tobowelfunction = CAST(NULL AS INT)
,       thoracic_epi = CAST(0 AS INT)
,       mm_pain = CAST (0 AS INT)
,       iv_totalvolume_intraop = CAST(NULL AS INT)
,       iv_intraop_threshold = CAST(NULL AS DECIMAL(13, 4))
,       goal_guidelines = CAST (NULL AS INT)
,       mm_antiemetic_intraop = CAST(0 AS INTEGER)
,       iv_fluid_dc_pod0 = CAST(0 AS INT)
,       iv_fluid_dc_pod1noon = CAST(0 AS INT)
,       iv_fluid_dc_pod2 = CAST(0 AS INT)
,       foleypod1 = CAST(0 AS INT)
,       foleycount = CAST(0 AS INT)
,       foleyremovedcount = CAST(0 AS INT)
,       date_last_painmed = CAST(NULL AS DATETIME)
,       hrs_last_painmed = CAST(NULL AS INT)
,		nameof_last_painmed= CAST(NULL AS VARCHAR(100))
,		last_painmed_adminby=CAST(NULL AS VARCHAR(100))

FROM ##allprocs  
)SELECT *
INTO radb.dbo.CRD_ERAS_YNHGI_Case
FROM basecase  
WHERE logseq=1;


--flag return to OR cases then delete return cases
WITH returnor AS(
SELECT harseq=ROW_NUMBER() OVER (PARTITION BY har ORDER BY surgery_date)
		,* 
FROM  radb.dbo.CRD_ERAS_YNHGI_Case
WHERE har IN (SELECT HAR FROM radb.dbo.CRD_ERAS_YNHGI_Case GROUP BY HAR HAVING COUNT(*)>1)
)--SELECT * FROM returnor
UPDATE returnor
SET ReturnToOR=1
WHERE logseq=1;


WITH returnor AS(
SELECT harseq=ROW_NUMBER() OVER (PARTITION BY har ORDER BY surgery_date)
		,* 
FROM  radb.dbo.CRD_ERAS_YNHGI_Case
WHERE har IN (SELECT HAR FROM radb.dbo.CRD_ERAS_YNHGI_Case GROUP BY HAR HAVING COUNT(*)>1)
)--SELECT * FROM returnor
DELETE returnor
WHERE harseq>1;



--update primary 
--validate all proc
IF object_id('tempdb..##procs') is not null
	drop table ##procs; 

WITH logbase AS(
SELECT log_id
   ,      ProcLineNumber
,PROC_DISPLAY_NAME
,ErasProcedure
                                                      ,      ProcedureCategory
                                                      ,      ProcedureSubCategory                                                   
                                                      ,      CPTCode												  
                                                      ,      OpenVsLaparoscopic
													  ,		 InCPTList
													  ,      category=CASE WHEN ProcedureCategory IS NOT NULL THEN ProcedureCategory ELSE null END
													  ,		 openlap =CASE WHEN OpenVsLaparoscopic IS NOT NULL THEN OpenVsLaparoscopic ELSE null END
FROM radb.dbo.CRD_ERAS_YNHGI_AllProc AS a
),rollit AS 
(SELECT log_id,
count(DISTINCT category) AS catcount,
COUNT(DISTINCT openlap) AS openlapcount
 FROM logbase
 GROUP BY LOG_ID
  )SELECT  l.*,r.catcount
        ,      r.openlapcount
INTO ##procs
 FROM logbase AS l
 JOIN rollit AS r ON l.LOG_ID=r.LOG_ID
ORDER BY l.LOG_ID,l.proclinenumber;


--update non duplicate cases
WITH nondups AS(
SELECT rid=ROW_NUMBER() OVER (PARTITION BY log_id ORDER BY log_id)
		,* 
FROM ##procs
WHERE InCPTList='Yes'
AND catcount=1 AND openlapcount=1
), clean AS ( SELECT * 
FROM nondups
WHERE rid=1
) --SELECT * FROM clean
UPDATE radb.dbo.CRD_ERAS_YNHGI_Case
SET PrimaryProcedureCategory=cl.ProcedureCategory
,PrimaryOpenVsLap=cl.OpenVsLaparoscopic
FROM radb.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN clean AS cl ON c.LOG_ID=cl.LOG_ID;


--update duplicate proc category cases
WITH cats AS(
SELECT rid=ROW_NUMBER() OVER (PARTITION BY log_id ORDER BY log_id)
		,* 
FROM ##procs
WHERE InCPTList='Yes'
AND (catcount>1 OR openlapcount>1)
), clean AS ( SELECT * 
FROM cats
WHERE rid=1
) --SELECT * FROM clean
UPDATE radb.dbo.CRD_ERAS_YNHGI_Case
SET PrimaryProcedureCategory=CASE WHEN cl.catcount>1 THEN 'Proctectomy' ELSE cl.ProcedureCategory END
,PrimaryOpenVsLap=CASE WHEN openlapcount>1 THEN 'Open'  ELSE cl.OpenVsLaparoscopic END
,MultCategories=CASE WHEN catcount>1 THEN 1 ELSE 0  END
,MultLapOpen=CASE WHEN MultLapOpen>1 THEN 1 ELSE 0 END	
FROM radb.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN clean AS cl ON c.LOG_ID=cl.LOG_ID;

--update ERAS case attribute

WITH erascase AS (
SELECT LOG_ID
FROM radb.dbo.CRD_ERAS_YNHGI_AllProc AS ceyap
WHERE ErasProcedure='ERAS Procedure'
)UPDATE radb.dbo.CRD_ERAS_YNHGI_Case
 SET ERASCase=CASE WHEN e.log_id IS NULL THEN 'Non-ERAS Case' 
				   WHEN e.log_id IS not NULL THEN 'ERAS Case' 
				   ELSE '*Unknown'
				   END
 FROM radb.dbo.CRD_ERAS_YNHGI_Case AS c
 LEFT JOIN erascase AS e ON c.LOG_ID=e.LOG_ID;


UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET CaseLength_hrs=DATEDIFF(HOUR,inroom,outofroom);

UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET CaseLength_min=DATEDIFF(MINUTE,inroom,outofroom);


IF object_id('RADB.dbo.CRD_ERAS_YNHGI_EncDim') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_YNHGI_EncDim;

WITH baseenc AS (
SELECT  
  rid=ROW_NUMBER() OVER (PARTITION BY peh.HSP_ACCOUNT_ID ORDER BY peh.HSP_ACCOUNT_ID),
  peh.PAT_ENC_CSN_ID,  
  peh.HSP_ACCOUNT_ID,
  p.PAT_NAME,
  p.PAT_MRN_ID,
  LOSDays=DATEDIFF(dd,peh.HOSP_ADMSN_TIME,peh.HOSP_DISCH_TIME)    ,
  LOSHours=DATEDIFF(hh,peh.HOSP_ADMSN_TIME,peh.HOSP_DISCH_TIME)    ,
  peh.HOSP_ADMSN_TIME,
  peh.HOSP_DISCH_TIME,    
  ec.SurgeonName,
  Discharge_DateKey=RADB.dbo.fn_Generate_DateKey(peh.HOSP_DISCH_TIME) ,
  peh.DISCH_DISP_C,
  zdd.name AS Enc_DischargeDisposition,
  hsp.PATIENT_STATUS_C,
  zcpat.NAME AS PatientStatus,
  peh.ADT_PAT_CLASS_C AS Enc_Pat_class_C,
  hsp.ACCT_BASECLS_HA_C,
  basecl.name AS BaseClass,
	ZC_PAT_CLASS_Enc.NAME AS Enc_Pat_Class,
	hsp.ADMISSION_TYPE_C,
  zadm.name AS [Admission Type],
  ra.HospitalWide_30DayReadmission_NUM,
  ra.HospitalWide_30DayReadmission_DEN,
  NumberofProcs=CAST(NULL AS INT),  
  CAST(0 AS INT) AS ED_revisit,
  CAST(0 AS INT ) AS reprocedured,
  cast (0 AS INT ) AS icuadmit,
  patient_weight_oz=CAST(NULL AS DECIMAL(13,4)),
  patient_weight_kg=CAST(NULL AS DECIMAL(13,4)),
  SurgeryCampus=ec.Campus,
  PrimaryProcedureCategory=ec.PrimaryProcedureCategory,
  PrimaryOpenVsLap=ec.PrimaryOpenVsLap,
  ReturnToOR=ec.ReturnToOR,
  ERASCase=ec.ERASCase

FROM clarity.dbo.PAT_ENC_HSP AS peh 
   JOIN  RADB.dbo.CRD_ERAS_YNHGI_Case AS ec ON ec.admissioncsn=peh.PAT_ENC_CSN_ID   
   LEFT JOIN clarity.dbo.HSP_ACCOUNT  AS hsp ON peh.HSP_ACCOUNT_ID=hsp.HSP_ACCOUNT_ID
   LEFT JOIN clarity.dbo.ZC_ACCT_BASECLS_HA AS basecl ON basecl.ACCT_BASECLS_HA_C=hsp.ACCT_BASECLS_HA_C
   LEFT JOIN clarity.dbo.ZC_MC_PAT_STATUS AS zcpat ON zcpat.PAT_STATUS_C=hsp.PATIENT_STATUS_C
   LEFT JOIN clarity.dbo.ZC_DISCH_DISP AS zdd ON zdd.DISCH_DISP_C=peh.DISCH_DISP_C
   LEFT JOIN radb.dbo.ReDiscovery_Costs AS rdc ON rdc.HSP_ACCOUNT_ID=peh.HSP_ACCOUNT_ID   
   LEFT OUTER JOIN CLARITY.dbo.PATIENT AS p ON (p.PAT_ID=peh.PAT_ID)
   LEFT JOIN radb.dbo.ReadmissionFact ra    
	ON CONVERT (varchar(30),peh.HSP_ACCOUNT_ID)=ra.IDX_VisitNum  
  LEFT OUTER JOIN clarity.dbo.ZC_MC_ADM_TYPE AS zadm ON zadm.ADMISSION_TYPE_C=hsp.ADMISSION_TYPE_C
  LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Enc ON (ZC_PAT_CLASS_Enc.ADT_PAT_CLASS_C=peh.ADT_PAT_CLASS_C )
  ) SELECT * 
  INTO RADB.dbo.CRD_ERAS_YNHGI_EncDim
  FROM baseenc
  WHERE rid=1;
   

  UPDATE RADB.dbo.CRD_ERAS_YNHGI_EncDim
  SET NumberofProcs=procct.ct
  FROM RADB.dbo.CRD_ERAS_YNHGI_EncDim AS e
  LEFT JOIN 
  ( SELECT admissioncsn,COUNT(*) AS ct
    FROM RADB.dbo.CRD_ERAS_YNHGI_Case 
	GROUP BY admissioncsn
	) AS procct ON procct.admissioncsn=e.PAT_ENC_CSN_ID;



	/*****************************************************************************************************************

	ED visit encounters

	-This can be used to flag an encounter as arriving through the ED
	-Also used to find if the patient reappeared in the ED following thier procedure

	*****************************************************************************************************************/

	IF OBJECT_ID(N'TEMPDB..#EDRevisit') IS NOT NULL
	BEGIN
	DROP TABLE #EDRevisit
	End
	
	--SELECT * FROM #Source WHERE PAT_ENC_CSN_ID = '131764493'

		SELECT 
		x.PAT_ENC_CSN_ID
	   ,x.Idx_CSN
	   ,x.ED_ARRIVAL_TIME
	   ,x.SURGERY_DATE
	   ,x.EDvisit
	   ,x.ARRIVAL_LOCATION
	   ,x.ED_DISPOSITION
		INTO #EDRevisit 
		FROM (
			 SELECT 
			 Ed.PAT_ENC_CSN_ID
			 ,s.admissioncsn'Idx_CSN'
			 ,ed.ED_ARRIVAL_TIME
			 ,s.SURGERY_DATE
			 ,DATEDIFF(DAY,s.SURGERY_DATE,ed.ED_ARRIVAL_TIME) 'EDvisit'
			 ,ED.ARRIVAL_LOCATION
			 ,ED.ED_DISPOSITION		
		

			 From
			 [RADB].[dbo].[vw_YNHHS_ED_DATA] ED
			 JOIN (SELECT admissioncsn, PAT_ID, SURGERY_DATE FROM radb.dbo.CRD_ERAS_YNHGI_Case AS ceyc GROUP BY admissioncsn, PAT_ID, SURGERY_DATE) S ON ED.PAT_ID = s.PAT_ID AND ed.ED_ARRIVAL_TIME > s.SURGERY_DATE
			 ) x
		JOIN radb.dbo.CRD_ERAS_YNHGI_Case s2 ON  s2.admissioncsn= x.Idx_CSN 
						--AND x.Idx_CSN = x.PAT_ENC_CSN_ID 
						--AND s2.AdmitType <> 'Emergency'
		WHERE EDvisit <= 30
				and	0 = CASE WHEN (x.PAT_ENC_CSN_ID = x.Idx_CSN AND s2.AdmitType = 'Emergency') THEN 1 ELSE 0 END 
				
	 
  UPDATE RADB.dbo.CRD_ERAS_YNHGI_EncDim
  SET ED_revisit=CASE WHEN ed.PAT_ENC_CSN_ID IS NOT NULL THEN 1 ELSE 0 END 
  FROM RADB.dbo.CRD_ERAS_YNHGI_EncDim AS e
  LEFT JOIN 
  ( SELECT PAT_ENC_CSN_ID
    FROM #EDRevisit 
	GROUP BY PAT_ENC_CSN_ID
	) AS ed ON ed.PAT_ENC_CSN_ID=e.PAT_ENC_CSN_ID;


/*****************************************************************************************************************
	
	Reprocedure

	Any time a patient returned for a procedure. ANY surgical procedure


	-/*Incorrect Definition - not long in use*/Any time a procedure is performed a second time 
	
	*****************************************************************************************************************/

	IF OBJECT_ID(N'TEMPDB..#RePo') IS NOT NULL
	BEGIN
	DROP TABLE #RePo
	End


	IF OBJECT_ID(N'TEMPDB..#Encounters2') IS NOT NULL
	BEGIN
	DROP TABLE #Encounters2
	END
		
	/*****************************************************************************************************************
	
	Get all Optime encounters not from the index encounters  
	
	*****************************************************************************************************************/
			SELECT
				ENC.PAT_ENC_CSN_ID
			   ,EncLink.OR_LINK_CSN
			   ,Or_Log.LOG_ID
			   ,CPT.REAL_CPT_CODE
			   ,OR_Proc.OR_PROC_ID
			   ,Or_Log.SURGERY_DATE
			   ,ENC.PAT_ID
			   ,Anes.AN_52_ENC_CSN_ID 'Anes_Enc_Csn_ID'
			INTO
				#Encounters2
			FROM
				Clarity.dbo.OR_LOG Or_Log
			LEFT JOIN Clarity.dbo.OR_LOG_ALL_PROC Lproc ON Or_Log.LOG_ID = Lproc.LOG_ID
			LEFT JOIN Clarity.dbo.OR_PROC OR_Proc ON ( Lproc.OR_PROC_ID = OR_Proc.OR_PROC_ID )
			LEFT JOIN Clarity.dbo.PAT_OR_ADM_LINK EncLink ON ( EncLink.LOG_ID = Or_Log.LOG_ID )
			LEFT JOIN Clarity.dbo.PAT_ENC_HSP ENC ON ( ENC.PAT_ENC_CSN_ID = EncLink.OR_LINK_CSN )
			LEFT JOIN Clarity.dbo.OR_PROC_CPT_ID CPT ON OR_Proc.OR_PROC_ID = CPT.OR_PROC_ID
			LEFT JOIN Clarity.dbo.F_AN_RECORD_SUMMARY Anes ON Anes.LOG_ID = Or_Log.LOG_ID
		
			WHERE		
				Or_Log.SURGERY_DATE >='1/1/2015'
				AND cpt.REAL_CPT_CODE IS NOT NULL
				AND Or_Log.STATUS_C <> 6
			


	SELECT 
	Idx_CSN
	,ReProcedure_CSN
	,RePoOrder
	,ReProcedureCase
	,PAT_MRN_ID
	,DATEDIFF(DAY,x.idx_SURGERY_DATE, x.RePo_SURGERY_DATE) 'DaysBetweenRePo'
	INTO #RePo
	FROM
	 (
		SELECT
			idx.admissioncsn 'Idx_CSN'
			,RePo.PAT_ENC_CSN_ID 'ReProcedure_CSN'
			,ROW_NUMBER() OVER	(PARTITION BY idx.admissioncsn ORDER BY RePo.SURGERY_DATE) 'RePoOrder'
			, 1 AS 'ReProcedureCase'
			,idx.PAT_MRN_ID
			,idx.SURGERY_DATE 'idx_SURGERY_DATE'
			,RePo.SURGERY_DATE 'RePo_SURGERY_DATE'

		FROM
			RADB.dbo.CRD_ERAS_YNHGI_Case AS idx
		JOIN #encounters2 RePo ON idx.PAT_ID = RePo.PAT_ID
							-- AND idx.REAL_CPT_CODE = RePo.REAL_CPT_CODE
							 AND idx.SURGERY_DATE < RePo.SURGERY_DATE
							 AND idx.admissioncsn <> RePo.PAT_ENC_CSN_ID
		) x
		WHERE x.RePoOrder = 1;

		UPDATE RADB.dbo.CRD_ERAS_YNHGI_EncDim
		SET ReProcedured=1
		FROM RADB.dbo.CRD_ERAS_YNHGI_EncDim AS e
		JOIN #RePo AS r ON e.PAT_ENC_CSN_ID=r.Idx_CSN;






/*****************************************************************************************************************
	
	Readmissions

	-Get the readmission cases
	
	*****************************************************************************************************************/

	IF OBJECT_ID(N'TEMPDB..#ReAd') IS NOT NULL
	BEGIN
	DROP TABLE #ReAd
	End
	

	SELECT
		RA.IDX_VisitNum
	   ,S.PAT_ENC_CSN_ID
	   ,RA.RA_PrimaryPatEncCSNID
	   ,CASE WHEN RA.DaysBetweenVisits <= 7 THEN 1
			 ELSE 0
		END 'HospitalWide_7DayReadmission'
	   ,RA.HospitalWide_30DayReadmission_NUM
	INTO
		#ReAd
	FROM
		(
		  SELECT
			PAT_ENC_CSN_ID
		  FROM
			RADB.dbo.CRD_ERAS_YNHGI_EncDim
		  GROUP BY
			PAT_ENC_CSN_ID
		) S
	JOIN Clarity.dbo.PAT_ENC_HSP hsp ON hsp.PAT_ENC_CSN_ID = S.PAT_ENC_CSN_ID
	JOIN RADB.dbo.ReadmissionFact RA ON RA.IDX_VisitNum = hsp.HSP_ACCOUNT_ID
										AND RA.HospitalWide_30DayReadmission_NUM = 1


		
/*****************************************************************************************************************

	ICU

	-Get the encounters of the set in which they went to the ICU, get initial transfer in time and last transfer out time

	*****************************************************************************************************************/

	IF OBJECT_ID(N'TEMPDB..#ICU') IS NOT NULL
	BEGIN
	DROP TABLE #ICU
	End
	
		;WITH Encounters AS
		(
			SELECT
				S.PAT_ENC_CSN_ID
			   ,hsp.HSP_ACCOUNT_ID
			   ,1 AS 'ICU_Admit'
			--   ,lh.Department_ID
			--   ,lh.Department_Name
			--INTO #ICU
			FROM
				RADB.dbo.vw_LocHierarchy_Department lh
			JOIN Clarity.dbo.F_IP_HSP_TRANSFER tfr ON lh.Department_ID = tfr.FROM_DEPT_ID
			JOIN Clarity.dbo.PAT_ENC_HSP hsp ON hsp.PAT_ENC_CSN_ID = tfr.PAT_ENC_CSN_ID
			JOIN RADB.dbo.CRD_ERAS_YNHGI_EncDim s ON s.PAT_ENC_CSN_ID = hsp.PAT_ENC_CSN_ID
			WHERE
				ICU_Department_YN = 'Y'
				--AND hsp.HOSP_DISCH_TIME >= '1/1/2014'
			GROUP BY
				S.PAT_ENC_CSN_ID
			   ,hsp.HSP_ACCOUNT_ID
			--  ,lh.Department_ID
			--   ,lh.Department_Name
		)
		,RAEncounters AS
			(
			SELECT
				S.PAT_ENC_CSN_ID
			   ,hsp.HSP_ACCOUNT_ID
			   ,1 AS 'ICU_Admit'
			--   ,lh.Department_ID
			--   ,lh.Department_Name
			--INTO #ICU
			FROM
				RADB.dbo.vw_LocHierarchy_Department lh
			JOIN Clarity.dbo.F_IP_HSP_TRANSFER tfr ON lh.Department_ID = tfr.FROM_DEPT_ID
			JOIN Clarity.dbo.PAT_ENC_HSP hsp ON hsp.PAT_ENC_CSN_ID = tfr.PAT_ENC_CSN_ID
			JOIN #ReAd s ON s.RA_PrimaryPatEncCSNID = hsp.PAT_ENC_CSN_ID
			WHERE
				ICU_Department_YN = 'Y'
				--AND hsp.HOSP_DISCH_TIME >= '1/1/2014'
			GROUP BY
				S.PAT_ENC_CSN_ID
			   ,hsp.HSP_ACCOUNT_ID
			--  ,lh.Department_ID
			--   ,lh.Department_Name
	
			)
		SELECT E.PAT_ENC_CSN_ID
			  ,E.HSP_ACCOUNT_ID
			  ,ISNULL(E.ICU_Admit,ra.ICU_Admit) 'ICU_Admit'
		INTO #ICU
		FROM Encounters E
		LEFT JOIN RAEncounters RA ON e.PAT_ENC_CSN_ID = RA.PAT_ENC_CSN_ID;

UPDATE RADB.dbo.CRD_ERAS_YNHGI_EncDim
SET icuadmit=1
FROM #ICU AS icu
INNER JOIN RADB.dbo.CRD_ERAS_YNHGI_EncDim AS e ON icu.PAT_ENC_CSN_ID=e.PAT_ENC_CSN_ID;

