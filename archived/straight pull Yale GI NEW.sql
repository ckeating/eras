SELECT * FROM ZC_OR_STATUS

SELECT allsurg.*
	FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
	JOIN (SELECT log_Id,MAX(line) AS maxline
		  FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
		  WHERE PANEL=1
		  AND  ROLE_C=1 
		  GROUP BY log_id   ) AS maxsurg ON maxsurg.LOG_ID=allsurg.LOG_ID
											AND maxsurg.maxline=allsurg.line
	SELECT * FROM RADB.dbo.ERAS_GIall
	WHERE PROC_DISPLAY_NAME LIKE '%eras%' OR procedurename LIKE '%eras%';


	SELECT * FROM 
	RADB.dbo.CRD_ERAS_CPT_Dim 


	SELECT COUNT(*),COUNT(DISTINCT HSP_ACCOUNT_ID)
	FROM 
	RADB.dbo.CRD_ERAS_Case


	SELECT SURGERY_DATE,
								postopday1_begin ,
                                         postopday2_begin ,
                                         postopday3_begin ,
                                         postopday4_begin
	FROM RADB.dbo.CRD_ERAS_Case

SELECT * FROM RADB.dbo.CRD_ERAS_Case
SELECT * FROM radb.dbo.CRD_ERAS_EncDim  

--purpose:
--1. pull procedures done by CPT code
--2. pull procedure name from panel screen
--3. pull all tracking events (inroom, out of room, )
--4. include the anesthesia csn from F_AN_RECORD_SUMMARY 
--5. primary surgeon only


SELECT procedurefinish,SURGERY_DATE,postopday1_begin FROM radb.dbo.CRD_ERAS_Case AS cec
SELECT * FROM 


--************************* Main pull


IF object_id('RADB.dbo.CRD_ERAS_Case') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_Case;


SELECT
   ProcedureType=cptdim.ProcedureCategory,		
  clarity.dbo.PATIENT.PAT_NAME,
  clarity.dbo.patient.PAT_MRN_ID,
  clarity.dbo.patient.pat_id,
    clarity.dbo.PAT_ENC_HSP.PAT_ENC_CSN_ID,
	clarity.dbo.HSP_ACCOUNT.ACCT_BASECLS_HA_C,
  clarity.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID,
  LOSDays=DATEDIFF(dd,clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME)    ,
  LOSHours=DATEDIFF(hh,clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME)    ,
  clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,
  clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME,    
  clarity.dbo.PAT_ENC_HSP.DISCH_DISP_C,
  zdd.name AS DischargeDisposition,
  clarity.dbo.HSP_ACCOUNT.PATIENT_STATUS_C,
  clarity.dbo.ZC_MC_PAT_STATUS.NAME AS DischargeDisposition2,
  clarity.dbo.pat_enc_hsp.ADT_PAT_CLASS_C AS Enc_Pat_class_C,
  basecl.name AS BaseClass,
	ZC_PAT_CLASS_Enc.NAME AS Enc_Pat_Class,
	  clarity.dbo.or_log.PAT_TYPE_C AS Surgery_pat_class_c,
  ZC_PAT_CLASS_Surg.NAME AS Surgery_Patient_Class,
  clarity.dbo.OR_LOG.LOG_ID,
  clarity.dbo.or_LOG.STATUS_C,
  clarity.dbo.HSP_ACCOUNT.ADMISSION_TYPE_C,
  zadm.name AS [Admission Type],
  zos.NAME AS LogStatus,
    clarity.dbo.or_log.CASE_CLASS_C ,
      zocc.NAME AS CASECLASS_DESCR,   
  clarity.dbo.or_log.NUM_OF_PANELS,
   clarity.dbo.OR_LOG_ALL_PROC.PROC_DISPLAY_NAME,   --added
  clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE,
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
  ra.HospitalWide_30DayReadmission_NUM,
  ra.HospitalWide_30DayReadmission_DEN,
  postopday1_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,1,PROC_START.TRACKING_TIME_IN))),
  postopday2_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,2,PROC_START.TRACKING_TIME_IN))),
  postopday3_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,3,PROC_START.TRACKING_TIME_IN))),
  postopday4_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,3,PROC_START.TRACKING_TIME_IN))),
  CaseLength_min=CAST(NULL AS int),
  CaseLength_hrs=CAST(NULL AS NUMERIC(13,4)),
  timeinpacu=NULL,
  pacudelay=NULL,
  --begin process metrics
  preadm_counseling=0,
  pacutemp=CAST(NULL AS NUMERIC(13,2)),
  ambulatepod0=CAST(0 AS TINYINT),
  clearliquids_pod0=CAST(0 AS TINYINT),
  ambulate_pod1=CAST(0 AS TINYINT),
  solidfood_pod1=CAST(0 AS TINYINT),
  ambulate_pod2=CAST(0 AS TINYINT),
  hrs_toleratediet=CAST(0 AS TINYINT)
  
INTO RADB.dbo.CRD_ERAS_Case

FROM    clarity.dbo.OR_LOG 
   left OUTER JOIN CLARITY.dbo.OR_LOG_ALL_PROC  ON clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.OR_LOG_ALL_PROC.LOG_ID   AND clarity.dbo.OR_LOG_ALL_PROC.line=1
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
   LEFT JOIN clarity.dbo.HSP_ACCOUNT  ON CLARITY.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID=clarity.dbo.hsp_account.HSP_ACCOUNT_ID
   LEFT JOIN clarity.dbo.ZC_ACCT_BASECLS_HA AS basecl ON basecl.ACCT_BASECLS_HA_C=clarity.dbo.hsp_account.ACCT_BASECLS_HA_C
   LEFT JOIN clarity.dbo.ZC_MC_PAT_STATUS ON clarity.dbo.ZC_MC_PAT_STATUS.PAT_STATUS_C=clarity.dbo.hsp_account.PATIENT_STATUS_C
   LEFT JOIN clarity.dbo.ZC_DISCH_DISP AS zdd
   ON zdd.DISCH_DISP_C=clarity.dbo.PAT_ENC_HSP.DISCH_DEST_C
   LEFT OUTER JOIN CLARITY.dbo.PATIENT ON (CLARITY.dbo.PATIENT.PAT_ID=CLARITY.dbo.PAT_ENC_HSP.PAT_ID)
   LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Surg ON (ZC_PAT_CLASS_Surg.ADT_PAT_CLASS_C=CLARITY.dbo.OR_LOG.PAT_TYPE_C)
   LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Enc ON (ZC_PAT_CLASS_Enc.ADT_PAT_CLASS_C=clarity.dbo.pat_enc_hsp.ADT_PAT_CLASS_C )
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zocc  ON zocc.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zoclog  ON zoclog.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
   JOIN RADB.dbo.CRD_ERAS_CPT_Dim AS cptdim ON cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE
  												AND cptdim.DeliveryNetwork='YNH'
												AND cptdim.ERASProject='GI'
  
  LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_Surg ON (allsurg.SURG_ID=CLARITY_SER_Surg.PROV_ID)
   FULL OUTER JOIN clarity.dbo.F_AN_RECORD_SUMMARY ON (clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.F_AN_RECORD_SUMMARY.AN_LOG_ID)
   LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_Anthesia1 ON (clarity.dbo.F_AN_RECORD_SUMMARY.AN_RESP_PROV_ID=CLARITY_SER_Anthesia1.PROV_ID)
   LEFT OUTER JOIN clarity.dbo.ZC_OR_SERVICE ON (clarity.dbo.ZC_OR_SERVICE.SERVICE_C=clarity.dbo.OR_LOG.SERVICE_C)
   LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_LOG_ROOM ON (CLARITY_SER_LOG_ROOM.PROV_ID=CLARITY.dbo.OR_LOG.ROOM_ID)
   LEFT OUTER JOIN clarity.dbo.CLARITY_LOC ON (clarity.dbo.CLARITY_LOC.LOC_ID=clarity.dbo.OR_LOG.LOC_ID)
   LEFT OUTER JOIN clarity.dbo.ZC_OR_STATUS AS zos   ON zos.STATUS_C=clarity.dbo.OR_LOG.STATUS_C
   LEFT OUTER JOIN clarity.dbo.ZC_CASE_TYPE AS zct ON zct.CASE_TYPE_C=clarity.dbo.or_log.CASE_TYPE_C
   LEFT OUTER JOIN clarity.dbo.ZC_MC_ADM_TYPE AS zadm ON zadm.ADMISSION_TYPE_C=clarity.dbo.hsp_account.ADMISSION_TYPE_C
   LEFT JOIN radb.dbo.ReadmissionFact ra    
	ON CONVERT (varchar(30),clarity.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID)=ra.IDX_VisitNum  
  
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
 AND     clarity.dbo.CLARITY_LOC.LOC_NAME  IN  ( 'YNH NORTH PAVILION OR','YNH EAST PAVILION OR','YNH SOUTH PAVILION OR')
  
   AND clarity.dbo.or_log.STATUS_C IN (2,5)
   AND PAT_ENC_HSP.HOSP_DISCH_TIME IS NOT null

ORDER BY clarity.dbo.or_log.LOG_ID,clarity.dbo.OR_LOG_ALL_PROC.line;

UPDATE radb.dbo.CRD_ERAS_Case
SET CaseLength_hrs=DATEDIFF(HOUR,inroom,outofroom);

UPDATE radb.dbo.CRD_ERAS_Case
SET CaseLength_min=DATEDIFF(MINUTE,inroom,outofroom);




IF object_id('RADB.dbo.CRD_ERAS_EncDim') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_EncDim;

WITH encbuild AS (
SELECT rid=ROW_NUMBER() OVER (PARTITION BY pat_enc_csn_id ORDER BY pat_enc_csn_id),
	   PAT_ENC_CSN_ID ,
	   HSP_ACCOUNT_ID ,
	   [Admission Type],
       PAT_NAME ,
       PAT_MRN_ID ,
       pat_id ,
       HOSP_ADMSN_TIME ,
       HOSP_DISCH_TIME ,
	   DateKey=RADB.dbo.fn_Generate_DateKey(HOSP_DISCH_TIME) ,
       DISCH_DISP_C ,
       PATIENT_STATUS_C ,
       DischargeDisposition ,
       DischargeDisposition2 ,
       Enc_Pat_class_C ,
       Enc_Pat_Class ,       
       LOSDays ,
       LOSHours ,
       HospitalWide_30DayReadmission_NUM ,
       HospitalWide_30DayReadmission_DEN ,
	   CaseLaterality=CAST(  NULL AS varchar(20))
       
FROM RADB.dbo.CRD_ERAS_Case

)SELECT *,
		ProcedureType =CAST(NULL AS VARCHAR(254))		
 INTO radb.dbo.CRD_ERAS_EncDim  
 FROM encbuild AS e
 WHERE rid=1;

