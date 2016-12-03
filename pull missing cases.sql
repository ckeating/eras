134481982 --CANESCHI,DONNA MARIE
SELECT *
FROM  ##ynhgireport
ORDER BY pat_mrn_id,log_id,ProcSequenceNum;

SELECT * 
FROM dbo.CRD_ERAS_Case AS cec
WHERE PAT_MRN_ID='MR2593886'








ORDER BY pat_mrn_id,log_id

SELECT * FROM dbo.vw_PatEnc AS vpe
WHERE PAT_ENC_CSN_ID=133485654


SELECT PAT_MRN_ID,* 
FROM clarity.dbo.PATIENT AS p
--WHERE PAT_MRN_ID='MR135497635'

WHERE PAT_NAME LIKE '%salvatore%'
AND PAT_LAST_NAME ='zerobi'
ORDER BY pat_name


SELECT * FROM RADB.dbo.CRD_ERAS_YNHGI_CptList


IF object_id('tempdb..##ynhgi') IS NOT NULL
	DROP TABLE ##ynhgi;


SELECT   
  clarity.dbo.OR_LOG.LOG_ID,
  ProcedureType=cptdim.ProcedureCategory,  
  clarity.dbo.PATIENT.PAT_NAME,
  clarity.dbo.patient.PAT_MRN_ID,
  clarity.dbo.patient.pat_id,  
  clarity.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID AS HAR,
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
  clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE,
  CASE WHEN cptdim.cptcode IS NULL THEN 'Missing CPT' ELSE 'Match CPT' END AS CPTMatch,
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
  postopday4_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,3,PROC_START.TRACKING_TIME_IN))),
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
  date_last_painmed=CAST(NULL AS DATETIME),
  hrs_last_painmed=cast( NULL AS int)

  
  
INTO ##ynhgi

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

AND CLARITY.dbo.PATIENT.PAT_MRN_ID IN ('MR579582',
'MR2264857',
'MR1805167',
'MR3099458',
'MR5672225',
'MR3547393',
'MR909718',
'MR2593886'
 );


IF object_id('tempdb..##ynhgireport') IS NOT NULL
	DROP TABLE ##ynhgireport;


SELECT SurgeryLocation,HOSP_ADMSN_TIME,hosp_disch_time,SurgeonName,pat_mrn_id,pat_name,admissioncsn,HAR,admittype,surgery_patient_class,baseclass,SURGERY_DATE,log_id,logstatus,
NUM_OF_PANELS,
real_cpt_code,
CPTMatch AS [In CPT list?],
procline AS ProcSequenceNum,
proc_display_name,
procedurename,
Surgery_Room_name,
SurgeryServiceName

INTO ##ynhgireport
FROM ##ynhgi
--WHERE PAT_MRN_ID <>'MR2593886'
ORDER BY pat_mrn_id,log_id,ProcSequenceNum;



IF object_id('tempdb..##srcorderset') IS NOT NULL
	DROP TABLE ##srcorderset;


SELECT DISTINCT PAT_MRN_ID,PAT_NAME,HOSP_ADMSN_TIME,HOSP_DISCH_TIME,admissioncsn AS pat_enc_csn_id
INTO ##srcorderset
FROM ##ynhgireport
where admissioncsn IN (134481982,133485654,135869429,134675991,134768032,135043502,135147758);


ALTER TABLE ##srcorderset
ADD FirstOS_ordernumber NUMERIC(18,0),
FirstOS_ordername VARCHAR(255),
FirstOS_orderdate DATETIME,
OrdersetFlag tinyint;



--orderset flag
WITH orderset AS (

SELECT 
rid=ROW_NUMBER() OVER (PARTITION BY om.PAT_ENC_CSN_ID ORDER BY order_dttm)
,ec.PAT_ENC_CSN_ID
,om.ORDER_DTTM
,om.ORDER_ID
,om.DISPLAY_NAME AS 'Order_Display_Name'
,om.ORDER_TYPE_C

FROM  ##srcorderset AS ec
LEFT JOIN  clarity.dbo.ORDER_METRICS AS om ON om.PAT_ENC_CSN_ID=ec.pat_enc_csn_id
											AND om.PRL_ORDERSET_ID=3040002508
) UPDATE ##srcorderset
SET FirstOS_ordernumber=o.ORDER_ID
,FirstOS_ordername=o.Order_Display_Name
,FirstOS_orderdate=o.ORDER_DTTM
,OrdersetFlag=1
FROM ##srcorderset AS enc
JOIN orderset AS o ON o.PAT_ENC_CSN_ID=enc.PAT_ENC_CSN_ID
WHERE o.rid=1;


