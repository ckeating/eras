[dbo].[CRD_ERASBHOrtho_Createfact]

--[dbo].[CRD_ERASBHOrtho_Masterload]

[dbo].[CRD_ERASBHOrtho_PullData]

sp_helptext [CRD_ERASBHOrtho_PullData]
 
 SELECT * FROM RADB.dbo.CRD_ERASOrtho_Cases
 SELECT * FROM radb.dbo.CRD_ERASOrtho_EncDim AS ceoed

CREATE PROCEDURE dbo.CRD_ERASBHOrtho_PullData --insert proc here
AS

SET NOCOUNT ON;
SET ANSI_WARNINGS OFF;


  DECLARE @Msg VARCHAR(200);
  DECLARE @Procname varchar(200);
  DECLARE @CompletionMessage VARCHAR(1000);
    
  SET @Procname='CRD_ERASBHOrtho_PullData';


	SET @Msg = 'Begin procedure ' + @Procname;
    EXEC radb.dbo.ynhhs_logmsg @piMessage = @Msg;


BEGIN TRY


-------- ***************************************** MAIN CODE **********************************************
--purpose:
--1. pull procedures done by CPT code
--2. pull procedure name from panel screen
--3. pull all tracking events (inroom, out of room, )
--4. include the anesthesia csn from F_AN_RECORD_SUMMARY 
--5. primary surgeon only


IF object_id('RADB.dbo.CRD_ERASOrtho_Cases') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERASOrtho_Cases;


SELECT
  --rid=ROW_NUMBER() OVER (PARTITION BY or_log.log_id,OR_LOG_ALL_PROC.LINE ORDER BY or_log.log_id,OR_LOG_ALL_PROC.LINE),

  CASE  WHEN clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE  IN ('27447', '27486', '27487') THEN 'TKA' 
		WHEN clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE  IN ('27125', '27130', '27132', '27134', '27137', '27138') THEN 'THA'
		ELSE '*Unknown Type' END
		AS ProcedureType,
		
					
  clarity.dbo.PATIENT.PAT_NAME,
  clarity.dbo.patient.PAT_MRN_ID,
  clarity.dbo.patient.pat_id,
    clarity.dbo.PAT_ENC_HSP.PAT_ENC_CSN_ID,
  clarity.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID,
  LOSDays=DATEDIFF(dd,clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME)    ,
  LOSHours=DATEDIFF(hh,clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME)    ,
  clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,
  clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME,    
   DateKey=CAST(
		DATEPART(
			YEAR, clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME
		) AS VARCHAR(4)) 
	   + RIGHT('00'+ 
				CAST(
					DATEPART(
						MONTH,Clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME
							) 
						AS VARCHAR(4)),
				2) 
		+ RIGHT('00' +
				 CAST(
					DATEPART(
						DAY,clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME
							) 
				AS VARCHAR(4)),
				2) ,
  clarity.dbo.HSP_ACCOUNT.ADMISSION_TYPE_C,
  zadm.name AS [Admission Type],
  clarity.dbo.hsp_account.PATIENT_STATUS_C,
  clarity.dbo.PAT_ENC_HSP.DISCH_DISP_C,
  zdd.name AS DischargeDisposition,
  clarity.dbo.ZC_MC_PAT_STATUS.NAME AS DischargeDisposition2,
  clarity.dbo.pat_enc_hsp.ADT_PAT_CLASS_C AS Enc_Pat_class_C,
	ZC_PAT_CLASS_Enc.NAME AS Enc_Pat_Class,
	  clarity.dbo.or_log.PAT_TYPE_C AS Surgery_pat_class_c,
  ZC_PAT_CLASS_Surg.NAME AS Surgery_Patient_Class,
  clarity.dbo.OR_LOG.LOG_ID,
  clarity.dbo.or_LOG.STATUS_C,
  zos.NAME AS LogStatus,
    clarity.dbo.or_log.CASE_CLASS_C ,
      zocc.NAME  AS [Case Classification],   
  clarity.dbo.or_log.NUM_OF_PANELS,
   clarity.dbo.OR_LOG_ALL_PROC.PROC_DISPLAY_NAME,   --added
  clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE,
  clarity.dbo.F_AN_RECORD_SUMMARY.AN_52_ENC_CSN_ID AS anescsn,
  clarity.dbo.PAT_OR_ADM_LINK.OR_LINK_CSN AS admissioncsn,
  clarity.dbo.PAT_OR_ADM_LINK.PAT_ENC_CSN_ID AS surgicalcsn,
  clarity.dbo.or_proc.proc_name AS procedurename,
   lrb.name AS Laterality,
  CLARITY_SER_LOG_ROOM.PROV_NAME AS Surgery_Room_Name,
  CLARITY_SER_Surg.prov_id AS SurgeonProvid,
  CLARITY_SER_Surg.PROV_NAME AS SurgeonName ,
  CLARITY.dbo.OR_LOG_ALL_SURG.ROLE_C  ,
  CLARITY.dbo.OR_LOG_ALL_SURG.PANEL  ,
   CLARITY.dbo.OR_LOG_ALL_PROC.ALL_PROCS_PANEL,
  --CLARITY_SER_Anthesia1.PROV_NAME,
  clarity.dbo.OR_LOG_ALL_PROC.LINE AS procline,
  clarity.dbo.ZC_OR_SERVICE.NAME AS SurgeryServiceName,  
  clarity.dbo.OR_LOG.SURGERY_DATE,
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
  floorhold.TRACKING_TIME_IN AS floorhold,
  flooroffhold.TRACKING_TIME_IN AS flooroffhold,
  ANES_START.TRACKING_TIME_IN AS anesstart,
  ANES_FINISH.TRACKING_TIME_IN AS anesfinish,
  PROC_START.TRACKING_TIME_IN AS procedurestart,
  PROC_FINISH.TRACKING_TIME_IN AS procedurefinish,
  proccarecomplete.TRACKING_TIME_IN AS procedurecarecomplete,
  postopday1_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,1,PROC_START.TRACKING_TIME_IN))),
  postopday2_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,2,PROC_START.TRACKING_TIME_IN))),
  postopday3_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,3,PROC_START.TRACKING_TIME_IN))),
  postopday4_begin=CONVERT(DATETIME,CONVERT(DATE,DATEADD(dd,3,PROC_START.TRACKING_TIME_IN))),
  timeinpacu=NULL,
  pacudelay=NULL,
  ra.HospitalWide_30DayReadmission_NUM,
  ra.HospitalWide_30DayReadmission_DEN,
  ambulatepod0=0,
  preopmultimodal=0,
  preopmultimodal_nummeds=0,
  intraop_spinalanes=0,
  intraop_intraartic=0,
  intraop_intraartic_nummeds=0,
  intraop_departure=0,
  postop_painmanage_parent=0,
  postop_antiemetics=0,
  foleycath=0
  
  
INTO RADB.dbo.CRD_ERASOrtho_Cases
--INTO ##erasproc

FROM    clarity.dbo.OR_LOG 
   left OUTER JOIN CLARITY.dbo.OR_LOG_ALL_PROC  ON clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.OR_LOG_ALL_PROC.LOG_ID   
   left OUTER JOIN CLARITY.dbo.OR_PROC  ON (CLARITY.dbo.OR_LOG_ALL_PROC.OR_PROC_ID=CLARITY.dbo.OR_PROC.OR_PROC_ID)
   LEFT OUTER JOIN CLARITY.dbo.OR_LOG_ALL_SURG ON (CLARITY.dbo.OR_LOG.LOG_ID=CLARITY.dbo.OR_LOG_ALL_SURG.LOG_ID)
   AND CLARITY.dbo.OR_LOG_ALL_SURG.PANEL=1
   AND CLARITY.dbo.OR_LOG_ALL_SURG.ROLE_C=1
  -- AND CLARITY.dbo.OR_LOG_ALL_SURG.LINE=1
  LEFT OUTER JOIN clarity.dbo.PAT_OR_ADM_LINK ON (CLARITY.dbo.PAT_OR_ADM_LINK.LOG_ID=CLARITY.dbo.OR_LOG.LOG_ID)
  LEFT OUTER JOIN clarity.dbo.ZC_OR_LRB AS lrb ON lrb.LRB_C=CLARITY.dbo.OR_LOG_ALL_PROC.LRB_C
   LEFT OUTER JOIN clarity.dbo.PAT_ENC_HSP ON (CLARITY.dbo.PAT_ENC_HSP.PAT_ENC_CSN_ID=CLARITY.dbo.PAT_OR_ADM_LINK.OR_LINK_CSN)
   LEFT JOIN clarity.dbo.HSP_ACCOUNT  ON CLARITY.dbo.PAT_ENC_HSP.HSP_ACCOUNT_ID=clarity.dbo.hsp_account.HSP_ACCOUNT_ID
   LEFT JOIN clarity.dbo.ZC_MC_PAT_STATUS ON clarity.dbo.ZC_MC_PAT_STATUS.PAT_STATUS_C=clarity.dbo.hsp_account.PATIENT_STATUS_C
   LEFT JOIN clarity.dbo.ZC_DISCH_DISP AS zdd
   ON zdd.DISCH_DISP_C=clarity.dbo.PAT_ENC_HSP.DISCH_DISP_C
   LEFT OUTER JOIN CLARITY.dbo.PATIENT ON (CLARITY.dbo.PATIENT.PAT_ID=CLARITY.dbo.PAT_ENC_HSP.PAT_ID)
   LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Surg ON (ZC_PAT_CLASS_Surg.ADT_PAT_CLASS_C=CLARITY.dbo.OR_LOG.PAT_TYPE_C)
   LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Enc ON (ZC_PAT_CLASS_Enc.ADT_PAT_CLASS_C=clarity.dbo.pat_enc_hsp.ADT_PAT_CLASS_C )
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zocc  ON zocc.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zoclog  ON zoclog.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
  LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_Surg ON (clarity.dbo.OR_LOG_ALL_SURG.SURG_ID=CLARITY_SER_Surg.PROV_ID)
   FULL OUTER JOIN clarity.dbo.F_AN_RECORD_SUMMARY ON (clarity.dbo.OR_LOG.LOG_ID=clarity.dbo.F_AN_RECORD_SUMMARY.AN_LOG_ID)
   LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_Anthesia1 ON (clarity.dbo.F_AN_RECORD_SUMMARY.AN_RESP_PROV_ID=CLARITY_SER_Anthesia1.PROV_ID)
   LEFT OUTER JOIN clarity.dbo.ZC_OR_SERVICE ON (clarity.dbo.ZC_OR_SERVICE.SERVICE_C=clarity.dbo.OR_LOG.SERVICE_C)
   LEFT OUTER JOIN clarity.dbo.CLARITY_SER  CLARITY_SER_LOG_ROOM ON (CLARITY_SER_LOG_ROOM.PROV_ID=CLARITY.dbo.OR_LOG.ROOM_ID)
   LEFT OUTER JOIN clarity.dbo.CLARITY_LOC ON (clarity.dbo.CLARITY_LOC.LOC_ID=clarity.dbo.OR_LOG.LOC_ID)
   LEFT OUTER JOIN clarity.dbo.ZC_OR_STATUS AS zos   ON zos.STATUS_C=clarity.dbo.OR_LOG.STATUS_C
   LEFT OUTER JOIN clarity.dbo.ZC_CASE_TYPE AS zct ON zct.CASE_TYPE_C=clarity.dbo.or_log.CASE_TYPE_C
   LEFT OUTER JOIN clarity.dbo.ZC_DISCH_DISP AS zdish ON zdish.DISCH_DISP_C=clarity.dbo.pat_enc_hsp.DISCH_DISP_C
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
( CASETIME .TRACKING_EVENT_C  = 830)
  )  AS Floorhold ON (Floorhold.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
  
  
   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 840)
  )  AS Flooroffhold ON (Flooroffhold.LOG_ID=clarity.dbo.OR_LOG.LOG_ID)
  
  
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

   LEFT OUTER JOIN ( 
  SELECT CASETIME .LOG_ID,
  CASETIME .TRACKING_TIME_IN
FROM
  clarity.dbo.OR_LOG_CASE_TIMES  CASETIME    
WHERE
( CASETIME .TRACKING_EVENT_C  = 180)
  )  AS proccarecomplete ON (proccarecomplete.LOG_ID=CLARITY.dbo.OR_LOG.LOG_ID)


  
WHERE --clarity.dbo.or_log.LOG_ID=436370
   --dbo.OR_LOG.SURGERY_DATE >='6/23/2015' -- for testing jean's patients
	--AND dbo.patient.PAT_MRN_ID IN ('MR9000797','MR9004344','MR9007891','MR9008532','MR9004514',
	--'MR9005155','MR9002249') 
 (CLARITY.dbo.pat_enc_hsp.HOSP_DISCH_TIME>'9/1/14' AND  CLARITY.dbo.pat_enc_hsp.HOSP_DISCH_TIME<='12/31/16')
 AND     clarity.dbo.CLARITY_LOC.LOC_NAME  IN  ( 'BH MAIN OR'  )
   
--   or_log.LOG_ID =446354 IN (SELECT  an_log_id FROM dbo.F_AN_RECORD_SUMMARY AS an WHERE an.AN_52_ENC_CSN_ID=117763167)
   AND clarity.dbo.or_log.STATUS_C IN (2,3,5)
   --AND   dbo.OR_LOG_ALL_SURG.ROLE_C  =  1
   --AND   dbo.OR_LOG_ALL_SURG.PANEL  IN  ( 1  )
AND clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE  IN       ('27447', '27130','27132')  
AND clarity.dbo.OR_LOG_ALL_PROC.line=1
ORDER BY clarity.dbo.or_log.LOG_ID,clarity.dbo.OR_LOG_ALL_PROC.line;

UPDATE  RADB.dbo.CRD_ERASOrtho_Cases
SET timeinpacu=DATEDIFF(mi,inpacu,outofpacu),
	pacudelay=CASE WHEN DATEDIFF(mi,inpacu,outofpacu)>0 THEN DATEDIFF(mi,floorhold,procedurecarecomplete)END ;

IF object_id('RADB.dbo.CRD_ERASOrtho_EncDim') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERASOrtho_EncDim;

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
	   DateKey,
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
       
FROM RADB.dbo.CRD_ERASOrtho_Cases

)SELECT *,
		ProcedureType =CAST(NULL AS VARCHAR(254))		
 INTO radb.dbo.CRD_ERASOrtho_EncDim  
 FROM encbuild AS e
 WHERE rid=1;


UPDATE radb.dbo.CRD_ERASOrtho_EncDim  
SET ProcedureType=CASE WHEN procs.ct=1 THEN procs.ProcedureType
 				       WHEN procs.ct>1 THEN 'Multiple Arthroplasty Procedures'
					   ELSE '*Unknown procedure type'
				  END
FROM radb.dbo.CRD_ERASOrtho_EncDim  e
LEFT JOIN (
			SELECT HSP_ACCOUNT_ID,ProcedureType,COUNT(*) AS ct 
			FROM RADB.dbo.CRD_ERASOrtho_Cases
			GROUP BY HSP_ACCOUNT_ID,ProcedureType
			
		  ) procs ON e.HSP_ACCOUNT_ID=procs.hsp_account_id;


UPDATE radb.dbo.CRD_ERASOrtho_EncDim  
SET CaseLaterality=CASE WHEN procs.procct=1 THEN procs.Laterality
 				       WHEN procs.procct>1 THEN 'Multiple Arthroplasty Procedures'
					   ELSE '*Unknown case laterality'
				  END
FROM radb.dbo.CRD_ERASOrtho_EncDim  e
LEFT JOIN (
			SELECT HSP_ACCOUNT_ID,Laterality,COUNT(*) AS procct
			FROM RADB.dbo.CRD_ERASOrtho_Cases
			GROUP BY HSP_ACCOUNT_ID,Laterality			
			
		  ) procs ON e.HSP_ACCOUNT_ID=procs.hsp_account_id;

		    
 

--begin code



--*********************************************************************************

-- Log the completion message (successful)
    
    SET @Msg =  @Procname + ' completed successfully'
    EXEC ynhhs_logmsg @piMessage = @Msg;

 -- Error handling

 END TRY
  
  BEGIN CATCH


-- Log error message

    SET @Msg = 'Error in procedure ' + @Procname ;
    EXEC ynhhs_logmsg @piMessage = @Msg;

  END CATCH




sp_helptext [CRD_ERASBHOrtho_Createfact]


CREATE PROCEDURE dbo.CRD_ERASBHOrtho_Createfact--insert proc here
AS

SET NOCOUNT ON;
SET ANSI_WARNINGS OFF;


  DECLARE @Msg VARCHAR(200);
  DECLARE @Procname varchar(200);
  DECLARE @CompletionMessage VARCHAR(1000);
    
  SET @Procname='CRD_ERASBHOrtho_Createfact';

BEGIN TRY

	

	SET @Msg = 'Begin procedure ' + @Procname;
    EXEC radb.dbo.ynhhs_logmsg @piMessage = @Msg;


--begin code
 /*CREATE flags AND main reporting tables  */


IF object_id('RADB.dbo.CRD_ERASOrtho_FlowDetail') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERASOrtho_FlowDetail;

WITH baseq AS (
  		
SELECT  
		b.LOG_ID
,		b.PAT_ENC_CSN_ID
,       ifm.FSD_ID
,		ifm.line
,       ifgd.FLO_MEAS_NAME
,		ifm.FLO_MEAS_ID
,       ifgd.DISP_NAME AS Flowsheet_DisplayName
,		ifm.MEAS_VALUE
,		MEAS_NUMERIC=CAST(NULL AS NUMERIC(13,4))
,       ifm.MEAS_COMMENT
,       ifm.RECORDED_TIME
,		ifm.ENTRY_TIME
,		ifm.ENTRY_USER_ID
,		empent.NAME AS Entry_Username
,		ifm.TAKEN_USER_ID
,		emptaken.NAME AS Taken_Username
,       ifgd.DUPLICATEABLE_YN
,       zvt.name AS ValueType
,       zrt.name AS RowType
,		IP_LDA_ID =CAST(NULL AS VARCHAR(18))
,		LDAName	=CAST(NULL AS VARCHAR(254))
,	    PLACEMENT_DTTM	=CAST(NULL AS datetime)
,		REMOVAL_DTTM =CAST(NULL AS DATETIME)
,		LDA_Description = CAST(NULL AS VARCHAR(254))
,		LDA_Properties = CAST(NULL AS VARCHAR(254))
,		admissioncsnflag=CAST(NULL AS INT)
,		anesthesiacsnflag=CAST(NULL AS INT)
,		b.pat_name
,		b.pat_mrn_id
	 --pt criteria      
     ,	pt_bedtochair=CAST(NULL AS INT)
	,	pt_chairtobed=CAST(NULL AS INT)
	,	pt_sidesteps=CAST(NULL AS INT)
	,	pt_5ft=CAST(NULL AS INT)	       
	,	pt_10ft=CAST(NULL AS INT)
	,	pt_15ft=CAST(NULL AS INT)
	,	pt_20ft=CAST(NULL AS INT)
	,	pt_25ft=CAST(NULL AS INT)
	,	pt_50ft=CAST(NULL AS INT)
	,	pt_75ft=CAST(NULL AS INT)
	,	pt_100ft=CAST(NULL AS INT)
	,	pt_150ft=CAST(NULL AS INT)
	,	pt_200ft=CAST(NULL AS INT)
	,	pt_250ft=CAST(NULL AS INT)
	,	pt_300ft=CAST(NULL AS INT)
	,	pt_350ft=CAST(NULL AS INT)
	,	pt_400ft=CAST(NULL AS INT)
	,	pt_x2=CAST(NULL AS INT)
	,	pt_x3	=CAST(NULL AS INT)
	,	ambulate_num=CAST(NULL AS INT)
	,	ambulate_den=CAST(NULL AS INT)
	,   preop=CAST(NULL AS INT)
	,   intraop=CAST(NULL AS INT)
	,   pacu=CAST(NULL AS INT)
	,   postop0=CAST(NULL AS INT)	
	,	postopday1=CAST(NULL AS INT)
	,	postopday2=CAST(NULL AS INT)
	,	postopday3=CAST(NULL AS INT)
	,	afterpostopday4=CAST(NULL AS INT)
	,   Postop_disch=CAST(NULL AS INT)
	,   PhaseofCare_id=CAST(NULL AS INT)
	,	PhaseofCare_desc= CAST(NULL AS VARCHAR(25))


FROM    clarity.dbo.IP_DATA_STORE AS ids
		--clarity.dbo.pat_enc_hsp AS ids
		JOIN radb.dbo.CRD_ERASOrtho_Cases AS  b ON ids.EPT_CSN = b.PAT_ENC_CSN_ID
        LEFT JOIN clarity.dbo.IP_FLWSHT_REC AS ifr ON ids.INPATIENT_DATA_ID = ifr.INPATIENT_DATA_ID
        LEFT JOIN clarity.dbo.IP_FLWSHT_MEAS AS ifm ON ifr.FSD_ID = ifm.FSD_ID
        LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd ON ifm.FLO_MEAS_ID = ifgd.FLO_MEAS_ID
        LEFT JOIN clarity.dbo.ZC_VAL_TYPE AS zvt ON zvt.VAL_TYPE_C = ifgd.VAL_TYPE_C
        LEFT JOIN clarity.dbo.ZC_ROW_TYP AS zrt ON zrt.ROW_TYP_C = ifgd.ROW_TYP_C
		LEFT JOIN clarity.dbo.CLARITY_EMP AS emptaken ON emptaken.USER_ID=ifm.TAKEN_USER_ID
		LEFT JOIN clarity.dbo.CLARITY_EMP AS empent ON empent.USER_ID=ifm.ENTRY_USER_ID
		
        WHERE          ifm.FLO_MEAS_ID IN ( '3047745',   --physical therapy Gait distance
										    '3040102774' --post void residual cath
												)		        
        AND ifm.MEAS_VALUE IS NOT NULL 
)
SELECT LOG_ID ,
       PAT_ENC_CSN_ID ,
       FSD_ID ,
       LINE ,
       FLO_MEAS_NAME ,
       FLO_MEAS_ID ,
       Flowsheet_DisplayName ,
       MEAS_VALUE ,
       MEAS_NUMERIC ,
       MEAS_COMMENT ,
       RECORDED_TIME ,
       ENTRY_TIME ,
       ENTRY_USER_ID ,
       Entry_Username ,
       TAKEN_USER_ID ,
       Taken_Username ,
       DUPLICATEABLE_YN ,
       ValueType ,
       RowType ,
       IP_LDA_ID ,
       LDAName ,
       PLACEMENT_DTTM ,
       REMOVAL_DTTM ,
       LDA_Description ,
       LDA_Properties ,
       admissioncsnflag ,
       anesthesiacsnflag ,
       PAT_NAME ,
       PAT_MRN_ID ,
       pt_bedtochair ,
       pt_chairtobed ,
       pt_sidesteps ,
       pt_5ft ,
       pt_10ft ,
       pt_15ft ,
       pt_20ft ,
       pt_25ft ,
       pt_50ft ,
       pt_75ft ,
       pt_100ft ,
       pt_150ft ,
       pt_200ft ,
       pt_250ft ,
       pt_300ft ,
       pt_350ft ,
       pt_400ft ,
       pt_x2 ,
       pt_x3 ,
       ambulate_num ,
	   ambulate_den,
       preop ,
       intraop ,
       pacu ,
       postop0 ,
       postopday1 ,
       postopday2 ,
       postopday3 ,
       afterpostopday4 ,
       Postop_disch ,
       PhaseofCare_id,
	   PhaseofCare_desc
INTO    RADB.dbo.CRD_ERASOrtho_FlowDetail
FROM baseq
ORDER BY pat_enc_csn_id,recorded_time;

UPDATE RADB.dbo.CRD_ERASOrtho_FlowDetail
SET		admissioncsnflag=0
,		anesthesiacsnflag=0
     ,	pt_bedtochair=0
	,	pt_chairtobed=0
	,	pt_sidesteps=0
	,	pt_5ft=0	       
	,	pt_10ft=0
	,	pt_15ft=0
	,	pt_20ft=0
	,	pt_25ft=0
	,	pt_50ft=0
	,	pt_75ft=0
	,	pt_100ft=0
	,	pt_150ft=0
	,	pt_200ft=0
	,	pt_250ft=0
	,	pt_300ft=0
	,	pt_350ft=0
	,	pt_400ft=0
	,	pt_x2=0
	,	pt_x3	=0
	,	ambulate_num=0
	,	ambulate_den=0
	,   preop=0
	,   intraop=0
	,   pacu=0
	,  postop0=0	
	,   Postop_disch=0
	,afterpostopday4=0;


WITH baseamb AS (
SELECT v.Value,s.fsd_id,s.line,
pt_bedtochair =  CASE WHEN RTRIM(LTRIM(value)) = 'bed to chair' THEN 1 ELSE 0 END,
pt_chairtobed =  CASE WHEN RTRIM(LTRIM(value)) = 'chair to bed' THEN 1 ELSE 0 END,
pt_sidesteps =  CASE WHEN RTRIM(LTRIM(value)) = 'sidesteps' THEN 1 ELSE 0 END,
pt_5ft =  CASE WHEN RTRIM(LTRIM(value)) = '5 feet' THEN 1 ELSE 0 END,
pt_10ft =  CASE WHEN RTRIM(LTRIM(value)) = '10 feet' THEN 1 ELSE 0 END,
pt_15ft =  CASE WHEN RTRIM(LTRIM(value)) = '15 feet' THEN 1 ELSE 0 END,
pt_20ft =  CASE WHEN RTRIM(LTRIM(value)) = '20 feet' THEN 1 ELSE 0 END,
pt_25ft =  CASE WHEN RTRIM(LTRIM(value)) = '25 feet' THEN 1 ELSE 0 END,
pt_50ft =  CASE WHEN RTRIM(LTRIM(value)) = '50 feet' THEN 1 ELSE 0 END,
pt_75ft =  CASE WHEN RTRIM(LTRIM(value)) = '75 feet' THEN 1 ELSE 0 END,
pt_100ft =  CASE WHEN RTRIM(LTRIM(value)) = '100 feet' THEN 1 ELSE 0 END,
pt_150ft =  CASE WHEN RTRIM(LTRIM(value)) = '150 feet' THEN 1 ELSE 0 END,
pt_200ft =  CASE WHEN RTRIM(LTRIM(value)) = '200 feet' THEN 1 ELSE 0 END,
pt_250ft =  CASE WHEN RTRIM(LTRIM(value)) = '250 feet' THEN 1 ELSE 0 END,
pt_300ft =  CASE WHEN RTRIM(LTRIM(value)) = '300 feet' THEN 1 ELSE 0 END,
pt_350ft =  CASE WHEN RTRIM(LTRIM(value)) = '350 feet' THEN 1 ELSE 0 END,
pt_400ft =  CASE WHEN RTRIM(LTRIM(value)) = '400 feet' THEN 1 ELSE 0 END,
pt_x2 =  CASE WHEN RTRIM(LTRIM(value)) = 'x2' THEN 1 ELSE 0 END,
pt_x3 =  CASE WHEN RTRIM(LTRIM(value)) = 'x3' THEN 1 ELSE 0 END

	  FROM RADB.dbo.CRD_ERASOrtho_FlowDetail s
		CROSS APPLY radb.dbo.YNHH_SplitToTable(meas_value,';') AS v
), rolled AS (SELECT 
fsd_id,
line,
pt_bedtochair=SUM(pt_bedtochair),
pt_chairtobed=SUM(pt_chairtobed),
pt_sidesteps=SUM(pt_sidesteps),
pt_5ft=SUM(pt_5ft),
pt_10ft=SUM(pt_10ft),
pt_15ft=SUM(pt_15ft),
pt_20ft=SUM(pt_20ft),
pt_25ft=SUM(pt_25ft),
pt_50ft=SUM(pt_50ft),
pt_75ft=SUM(pt_75ft),
pt_100ft=SUM(pt_100ft),
pt_150ft=SUM(pt_150ft),
pt_200ft=SUM(pt_200ft),
pt_250ft=SUM(pt_250ft),
pt_300ft=SUM(pt_300ft),
pt_350ft=SUM(pt_350ft),
pt_400ft=SUM(pt_400ft),
pt_x2=SUM(pt_x2),
pt_x3=SUM(pt_x3)
 
FROM baseamb
GROUP BY fsd_id,line
)
UPDATE RADB.dbo.CRD_ERASOrtho_FlowDetail
SET 
pt_chairtobed =   v.pt_chairtobed,
pt_sidesteps =   v.pt_sidesteps,
pt_bedtochair =   v.pt_bedtochair ,
pt_5ft =   v.pt_5ft,
pt_10ft =   v.pt_10ft,
pt_15ft =   v.pt_15ft,
pt_20ft =   v.pt_20ft,
pt_25ft =   v.pt_25ft,
pt_50ft =   v.pt_50ft,
pt_75ft =   v.pt_75ft,
pt_100ft =   v.pt_100ft,
pt_150ft =   v.pt_150ft,
pt_200ft =   v.pt_200ft,
pt_250ft =   v.pt_250ft,
pt_300ft =   v.pt_300ft,
pt_350ft =   v.pt_350ft,
pt_400ft =   v.pt_400ft,
pt_x2 =   v.pt_x2,
pt_x3 =   v.pt_x3
FROM RADB.dbo.CRD_ERASOrtho_FlowDetail a
JOIN rolled v ON a.fsd_id=v.fsd_id AND a.line=v.line;

UPDATE RADB.dbo.CRD_ERASOrtho_FlowDetail 
SET ambulate_num=CASE WHEN pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 
			>0 THEN 1 ELSE 0 END,
	ambulate_den=CASE WHEN FLO_MEAS_ID IN ( '3047745',   --physical therapy Gait distance
										    '3040102774' --post void residual cath
												)
										THEN 1 ELSE 0 END ;

WITH ldabase AS (
SELECT 
iln.LOG_ID
,peh.HOSP_ADMSN_TIME
,peh.HOSP_DISCH_TIME
,iln.PAT_ENC_CSN_ID
,p.PAT_NAME
,p.PAT_MRN_ID
,ifm.FLO_MEAS_ID AS Assesment_flo_meas_id
,ifgd.FLO_MEAS_NAME
,ifgd.DISP_NAME
,ifm.FSD_ID
,ifm.line 
,ifgd.DUPLICATEABLE_YN
,ifm.ENTRY_TIME
,ifm.RECORDED_TIME
,ifm.MEAS_VALUE
,ifm.MEAS_COMMENT
,zvt.NAME AS ValueType
,zrt.name AS RowType
,ifm.ENTRY_USER_ID
,emp_enter.NAME AS Entry_Username
,ifm.TAKEN_USER_ID
,emp_taken.name AS Taken_Username
--,'IP_LDA_NOADDSINGLE>>>>>'
,iln.ip_LDA_ID
,ifgdlda.DISP_NAME AS LDAName
,iln.PLACEMENT_INSTANT AS PLACEMENT_DTTM
,iln.REMOVAL_INSTANT   AS REMOVAL_DTTM
,iln.DESCRIPTION AS LDA_Description
,iln.PROPERTIES_DISPLAY AS LDA_Properties
--,'FLOWSHEETROWS>>>>>>>'
--,ifr.*
--,*
FROM (			SELECT iln.*,f.log_id 					
			FROM    RADB.dbo.ERAS_Ortho f
					JOIN clarity.dbo.IP_DATA_STORE AS ids
					ON ids.EPT_CSN=f.pat_enc_csn_id
					JOIN clarity.dbo.IP_LDA_INPS_USED AS iliu
					ON ids.INPATIENT_DATA_ID=iliu.INP_ID
					JOIN clarity.dbo.IP_LDA_NOADDSINGLE AS iln 
							ON iln.IP_LDA_ID=iliu.IP_LDA_ID		
	) AS iln

LEFT JOIN Clarity.dbo.IP_FLOWSHEET_ROWS AS ifr ON iln.IP_LDA_ID=ifr.IP_LDA_ID
LEFT JOIN clarity.dbo.PAT_ENC_HSP AS peh ON iln.PAT_ENC_CSN_ID=peh.PAT_ENC_CSN_ID
LEFT JOIN clarity.dbo.PATIENT AS p ON p.PAT_ID=peh.PAT_ID
LEFT join clarity.dbo.IP_FLWSHT_REC AS ifrec ON ifr.INPATIENT_DATA_ID=ifrec.INPATIENT_DATA_ID
LEFT JOIN clarity.dbo.IP_FLWSHT_MEAS AS ifm ON ifr.line=ifm.OCCURANCE AND ifrec.FSD_ID=ifm.FSD_ID
LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd ON ifgd.FLO_MEAS_ID=ifm.FLO_MEAS_ID
LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgdlda ON ifgdlda.FLO_MEAS_ID=iln.FLO_MEAS_ID
LEFT JOIN clarity.dbo.CLARITY_EMP AS emp_taken ON ifm.TAKEN_USER_ID=emp_taken.USER_ID
LEFT JOIN clarity.dbo.CLARITY_EMP AS emp_enter ON ifm.ENTRY_USER_ID=emp_enter.USER_ID
LEFT JOIN clarity.dbo.ZC_VAL_TYPE AS zvt ON zvt.VAL_TYPE_C = ifgd.VAL_TYPE_C
LEFT JOIN clarity.dbo.ZC_ROW_TYP AS zrt ON zrt.ROW_TYP_C = ifgd.ROW_TYP_C

WHERE iln.FLO_MEAS_ID IN (SELECT ifgd.FLO_MEAS_ID FROM clarity.dbo.IP_FLO_GP_DATA AS ifgd WHERE ifgd.DISP_NAME ='Urethral Catheter')     
AND ifm.FLO_MEAS_ID='661859'
--AND p.pat_mrn_id='MR4644318'
)INSERT radb.dbo.CRD_ERASOrtho_FlowDetail
        ( LOG_ID ,
          PAT_ENC_CSN_ID ,
          FSD_ID ,
          line ,
          FLO_MEAS_NAME ,
          FLO_MEAS_ID ,
          Flowsheet_DisplayName ,
          MEAS_VALUE ,
          MEAS_COMMENT ,
          RECORDED_TIME ,
          ENTRY_TIME ,
          ENTRY_USER_ID ,
          Entry_Username ,
          TAKEN_USER_ID ,
          Taken_Username ,
          DUPLICATEABLE_YN ,
          ValueType ,
          RowType ,
          IP_LDA_ID ,
          LDAName ,
          PLACEMENT_DTTM ,
          REMOVAL_DTTM ,
          LDA_Description ,
          LDA_Properties 
        )

SELECT LOG_ID ,
		PAT_ENC_CSN_ID ,
		FSD_ID ,
		LINE,
        FLO_MEAS_NAME ,        
		Assesment_flo_meas_id ,
		ldabase.DISP_NAME,
		ldabase.MEAS_VALUE ,
		ldabase.MEAS_COMMENT,
		ldabase.RECORDED_TIME ,
		ldabase.ENTRY_TIME ,
        ldabase.ENTRY_USER_ID ,
        ldabase.Entry_Username ,
        ldabase.TAKEN_USER_ID ,
        ldabase.Taken_Username ,
		ldabase.DUPLICATEABLE_YN,
		ldabase.ValueType,
		ldabase.RowType,
		ldabase.IP_LDA_ID ,
		ldabase.LDAName,
        ldabase.PLACEMENT_DTTM ,
        ldabase.REMOVAL_DTTM ,
        ldabase.LDA_Description ,
        ldabase.LDA_Properties 
		        
FROM ldabase
ORDER BY pat_enc_csn_id,RECORDED_TIME;



--update all meas_numeric field
UPDATE RADB.dbo.CRD_ERASOrtho_FlowDetail 
SET MEAS_NUMERIC=CAST(MEAS_VALUE AS NUMERIC(13,4))
WHERE ValueType='Numeric Type';

--update all timestamps

UPDATE RADB.dbo.CRD_ERASOrtho_FlowDetail 
SET preop=CASE WHEN fs.RECORDED_TIME>=eoc.inpreprocedure AND fs.RECORDED_TIME<=COALESCE(eoc.outofpreprocedure,eoc.anesstart) THEN 1 ELSE 0 END
	, intraop= CASE WHEN fs.RECORDED_TIME>=eoc.inroom AND fs.RECORDED_TIME<=eoc.outofroom THEN 1 ELSE 0 END
	, pacu = CASE WHEN fs.RECORDED_TIME>=eoc.inpacu AND fs.RECORDED_TIME<=eoc.outofpacu THEN 1 ELSE 0 END
	, postop0=CASE WHEN fs.RECORDED_TIME>=eoc.procedurestart AND fs.RECORDED_TIME<eoc.postopday1_begin THEN 1 ELSE 0 END
	, postopday1=CASE WHEN fs.RECORDED_TIME>=eoc.postopday1_begin AND fs.RECORDED_TIME <eoc.postopday2_begin THEN 1 ELSE 0 END
	, postopday2=CASE WHEN fs.RECORDED_TIME>=eoc.postopday2_begin AND fs.RECORDED_TIME <eoc.postopday3_begin THEN 1 ELSE 0 END
	, postopday3=CASE WHEN fs.RECORDED_TIME>=eoc.postopday3_begin AND fs.RECORDED_TIME <eoc.postopday4_begin THEN 1 ELSE 0 END	
	,afterpostopday4=CASE WHEN fs.RECORDED_TIME>=eoc.postopday4_begin THEN 1 ELSE 0 END	
	,postop_disch=CASE WHEN fs.RECORDED_TIME>=eoc.procedurefinish AND fs.RECORDED_TIME<=eoc.HOSP_DISCH_TIME THEN 1 ELSE 0 END     	

FROM RADB.dbo.CRD_ERASOrtho_FlowDetail fs
LEFT JOIN RADB.dbo.CRD_ERASOrtho_Cases AS eoc ON fs.PAT_ENC_CSN_ID=eoc.PAT_ENC_CSN_ID;

--update phase of care
UPDATE RADB.dbo.CRD_ERASOrtho_FlowDetail 
SET PhaseOfCare_id=CASE 
					 WHEN postop0=1 THEN 0
					 WHEN postopday1=1 THEN 1
					 WHEN postopday2=1 THEN 2
					 WHEN postopday3=1 THEN 3
					 WHEN afterpostopday4=1 THEN 4
					 WHEN preop=1 THEN 5
					 WHEN intraop=1 THEN 6
					 WHEN pacu=1 THEN 7
				END,


		PhaseOfCare_desc=CASE WHEN preop=1 THEN 'Preop'
					 WHEN intraop=1 THEN 'Intraop'
					 WHEN pacu=1 THEN 'PACU'
					 WHEN postop0=1 THEN 'POD0'
					 WHEN postopday1=1 THEN 'POD1'
					 WHEN postopday2=1 THEN 'POD2'
					 WHEN postopday3=1 THEN 'POD3'
					 WHEN afterpostopday4=1 THEN 'POD4 or later'
				END

					
					

UPDATE RADB.dbo.CRD_ERASOrtho_Cases
SET ambulatepod0=CASE WHEN fs.ambct>0 THEN 1 ELSE 0 end
FROM RADB.dbo.CRD_ERASOrtho_Cases f
JOIN	(SELECT pat_enc_csn_id,SUM(ambulate_num) AS ambct
		FROM radb.dbo.CRD_ERASOrtho_FlowDetail 
		WHERE ambulate_den=1 AND postop0=1
		GROUP BY pat_enc_csn_id) AS fs ON f.PAT_ENC_CSN_ID=fs.PAT_ENC_CSN_ID;




IF object_id('radb.dbo.CRD_ERASOrtho_GivenMeds') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERASOrtho_GivenMeds;

SELECT  mai.MAR_ENC_CSN AS pat_enc_csn_id
		,eo.LOG_ID
		,cm.MEDICATION_ID 
		,cm.NAME AS MedicationName
		,cm.FORM AS MedicationForm
		,om.ORDER_MED_ID
		,mai.line
		,rmt.MED_BRAND_NAME
		,empadmin.USER_ID AdminId
		,empadmin.NAME AS AdministeredBy
		,admindep.DEPARTMENT_NAME AS AdministeredDept
	--	,meddim.MedType
		,mai.TAKEN_TIME
		,zcact.NAME AS MarAction
		,mai.mar_action_c
		,mai.SIG AS GivenDose
		,zmu.NAME AS DoseUnit						
		,zar.Name AS Route		
		,mai.DOSE_UNIT_C		
		,preop=0
		,intraop=0
		,pacu=0
		,postop0=0
		,postopday1=CAST(NULL AS INT)
		,postopday2=CAST(NULL AS INT)
		,postopday3=CAST(NULL AS INT)
		,postop_disch=0
		,admissioncsn_flag=1
		,anescsn_flag=0
				

INTO RADB.dbo.CRD_ERASOrtho_GivenMeds		
from clarity.dbo.MAR_ADMIN_INFO AS mai
JOIN  radb.dbo.CRD_ERASOrtho_Cases AS eo
ON eo.PAT_ENC_CSN_ID=mai.MAR_ENC_CSN
LEFT JOIN clarity.dbo.clarity_emp AS empadmin ON empadmin.USER_ID=mai.USER_ID
LEFT join clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.ZC_MED_UNIT AS zmu
ON zmu.DISP_QTYUNIT_C=mai.DOSE_UNIT_C
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN clarity.dbo.clarity_dep AS admindep ON admindep.DEPARTMENT_ID=mai.MAR_ADMIN_DEPT_ID
LEFT JOIN CLARITY.dbo.RX_MED_THREE AS rmt ON rmt.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON meddim.medication_id=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
ON zcact.result_c=mai.mar_action_c
LEFT JOIN clarity.dbo.PATIENT AS p
ON om.PAT_ID=p.PAT_ID
LEFT JOIN clarity.dbo.ZC_ADMIN_ROUTE AS zar ON mai.ROUTE_C=zar.MED_ROUTE_C
WHERE mai.MAR_ACTION_C IN (1,102,113,118,119,134,137,142)

UNION ALL


SELECT  mai.MAR_ENC_CSN AS pat_enc_csn_id
		,eo.LOG_ID
		,cm.MEDICATION_ID 
		,cm.NAME AS MedicationName
		,cm.FORM AS MedicationForm
		,om.ORDER_MED_ID
		,mai.line
		,rmt.MED_BRAND_NAME
		,empadmin.USER_ID AdminId
		,empadmin.NAME AS AdministeredBy
		,admindep.DEPARTMENT_NAME AS AdministeredDept
	--	,meddim.MedType
		,mai.TAKEN_TIME
		,zcact.NAME AS MarAction
		,mai.mar_action_c
		,mai.SIG AS GivenDose
		,zmu.NAME AS DoseUnit						
		,zar.Name AS Route		
		,mai.DOSE_UNIT_C		
		,preop=0
		,intraop=0
		,pacu=0
		,postop0=0
		,postopday1=CAST(NULL AS INT)
		,postopday2=CAST(NULL AS INT)
		,postopday3=CAST(NULL AS INT)
		,postop_disch=0
		,admissioncsn_flag=0
		,anescsn_flag=1			


from clarity.dbo.MAR_ADMIN_INFO AS mai
JOIN  radb.dbo.CRD_ERASOrtho_Cases AS eo
ON eo.anescsn=mai.MAR_ENC_CSN
LEFT JOIN clarity.dbo.clarity_emp AS empadmin ON empadmin.USER_ID=mai.USER_ID
LEFT join clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.ZC_MED_UNIT AS zmu
ON zmu.DISP_QTYUNIT_C=mai.DOSE_UNIT_C
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN clarity.dbo.clarity_dep AS admindep ON admindep.DEPARTMENT_ID=mai.MAR_ADMIN_DEPT_ID
LEFT JOIN CLARITY.dbo.RX_MED_THREE AS rmt ON rmt.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON meddim.medication_id=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
ON zcact.result_c=mai.mar_action_c
LEFT JOIN clarity.dbo.PATIENT AS p
ON om.PAT_ID=p.PAT_ID
LEFT JOIN clarity.dbo.ZC_ADMIN_ROUTE AS zar ON mai.ROUTE_C=zar.MED_ROUTE_C
WHERE mai.MAR_ACTION_C IN (1,102,113,118,119,134,137,142);

--update given meds phase of care timestamps
UPDATE radb.dbo.CRD_ERASOrtho_GivenMeds
SET preop=CASE WHEN TAKEN_TIME>=c.inpreprocedure AND TAKEN_TIME<=COALESCE(c.outofpreprocedure,c.anesstart) THEN 1 ELSE 0 END
	, intraop= CASE WHEN TAKEN_TIME>=c.inroom AND TAKEN_TIME<=c.outofroom THEN 1 ELSE 0 END
	, pacu = CASE WHEN TAKEN_TIME>=c.inpacu AND TAKEN_TIME<=c.outofpacu THEN 1 ELSE 0 END
	, postop0=CASE WHEN med.TAKEN_TIME>=c.procedurestart AND med.TAKEN_TIME<c.postopday1_begin THEN 1 ELSE 0 END
	, postopday1=CASE WHEN med.TAKEN_TIME>=c.postopday1_begin AND med.TAKEN_TIME <c.postopday2_begin THEN 1 ELSE 0 END
	, postopday2=CASE WHEN med.TAKEN_TIME>=c.postopday2_begin AND med.TAKEN_TIME <c.postopday3_begin THEN 1 ELSE 0 END
	, postopday3=CASE WHEN med.TAKEN_TIME>=c.postopday3_begin AND med.TAKEN_TIME <c.postopday4_begin THEN 1 ELSE 0 END	
	 ,postop_disch=CASE WHEN TAKEN_TIME>=c.procedurefinish AND TAKEN_TIME<=c.HOSP_DISCH_TIME THEN 1 ELSE 0 END
      
FROM radb.dbo.CRD_ERASOrtho_GivenMeds med
JOIN radb.dbo.CRD_ERASOrtho_Cases AS c ON med.pat_enc_csn_id = CASE 
																WHEN med.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
																WHEN med.anescsn_flag=1 THEN c.anescsn
																END;




--preop multi modal anesthesia


WITH multibase AS(
SELECT rid=ROW_NUMBER() OVER(partition BY c.log_id ORDER BY c.log_id)
--,c.LOG_ID
,c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,givmed.*
,meddim.MedType
,meddim.InProtocol
,Acetaminophenct= CASE WHEN meddim.metricgrouper='Acetaminophen' THEN 1 ELSE 0 END
,Celebrexct = CASE WHEN meddim.metricgrouper='Celebrex' THEN 1 ELSE 0 END
,GabaLyrica =CASE WHEN meddim.metricgrouper='GabaLyrica' THEN 1 ELSE 0 END
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
 JOIN radb.dbo.CRD_ERASOrtho_GivenMeds AS givmed
ON CASE WHEN givmed.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
		WHEN givmed.anescsn_flag=1 THEN c.anescsn END =givmed.pat_enc_csn_id
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON givmed.MEDICATION_ID=meddim.medication_id
WHERE  meddim.MedType='Multi-Modal Analgesia'
AND preop=1
),
multifin AS(
SELECT multibase.pat_enc_csn_id,SUM( Acetaminophenct) AS acetct ,SUM(Celebrexct)AS celbrexct ,SUM(GabaLyrica) AS gabalyricact
FROM multibase
GROUP BY multibase.pat_enc_csn_id
) UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET preopmultimodal=1
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
JOIN  multifin AS fin ON c.PAT_ENC_CSN_ID=fin.pat_enc_csn_id
WHERE fin.acetct>0 AND fin.gabalyricact>0 AND fin.celbrexct>0;




--UPDATE radb.dbo.CRD_ERASOrtho_Cases
--  SET preopmultimodal_nummeds=b.medcount
--  FROM radb.dbo.CRD_ERASOrtho_Cases c
--  JOIN medcount AS b ON c.log_id=b.log_id;

--  UPDATE radb.dbo.CRD_ERASOrtho_Cases
--  SET preopmultimodal=1
--  WHERE preopmultimodal_nummeds=3;
  


--update spinal anesthesia intra-op
WITH base AS (
SELECT rid=ROW_NUMBER() OVER(partition BY c.log_id ORDER BY c.log_id)
--,c.LOG_ID
,c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,givmed.*
,meddim.MedType
,meddim.InProtocol
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
LEFT JOIN radb.dbo.CRD_ERASOrtho_GivenMeds AS givmed
ON CASE WHEN givmed.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
		WHEN givmed.anescsn_flag=1 THEN c.anescsn END =givmed.pat_enc_csn_id
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON givmed.MEDICATION_ID=meddim.medication_id
WHERE  meddim.MedType='Spinal Anesthesia'
 AND givmed.intraop=1
 ) , matches AS (SELECT log_id 
FROM base a 
GROUP BY log_id
) UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET  intraop_spinalanes=1 
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN matches AS m ON f.LOG_ID=m.log_id;


--update intraop departure from protocol
WITH base AS (
SELECT rid=ROW_NUMBER() OVER(partition BY c.log_id ORDER BY c.log_id)
--,c.LOG_ID
,c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,givmed.*
,meddim.MedType
,meddim.InProtocol
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
LEFT JOIN radb.dbo.CRD_ERASOrtho_GivenMeds AS givmed
ON CASE WHEN givmed.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
		WHEN givmed.anescsn_flag=1 THEN c.anescsn END =givmed.pat_enc_csn_id
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON givmed.MEDICATION_ID=meddim.medication_id
WHERE  meddim.MedType='Intra-op Departure from Protocol'
 AND givmed.intraop=1
 ) , matches AS (SELECT log_id 
FROM base a 
GROUP BY log_id
) UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET   intraop_departure=1
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN matches AS m ON f.LOG_ID=m.log_id;


--update intraop intra-articular
WITH base AS (
SELECT rid=ROW_NUMBER() OVER(partition BY c.log_id ORDER BY c.log_id)
--,c.LOG_ID
,c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,givmed.*
,meddim.MedType
,meddim.InProtocol
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
LEFT JOIN radb.dbo.CRD_ERASOrtho_GivenMeds AS givmed
ON CASE WHEN givmed.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
		WHEN givmed.anescsn_flag=1 THEN c.anescsn END =givmed.pat_enc_csn_id
JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON givmed.MEDICATION_ID=meddim.medication_id
WHERE  meddim.MedType='Intra-Articular Injections'
 AND givmed.intraop=1
 ) , matches AS (SELECT log_id ,COUNT(DISTINCT medication_id) AS nummeds
FROM base a 
GROUP BY log_id
) UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET   intraop_intraartic_nummeds=m.nummeds
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN matches AS m ON f.LOG_ID=m.log_id;

UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET   intraop_intraartic=1
WHERE intraop_intraartic_nummeds=3;



--update intraop departure from protocol
WITH base AS (
SELECT rid=ROW_NUMBER() OVER(partition BY c.log_id ORDER BY c.log_id)
--,c.LOG_ID
,c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,givmed.*
,meddim.MedType
,meddim.InProtocol
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
LEFT JOIN radb.dbo.CRD_ERASOrtho_GivenMeds AS givmed
ON CASE WHEN givmed.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
		WHEN givmed.anescsn_flag=1 THEN c.anescsn END =givmed.pat_enc_csn_id
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON givmed.MEDICATION_ID=meddim.medication_id
WHERE  givmed.MEDICATION_ID IN (149951,150104)
 AND givmed.postop_disch=1
 ) , matches AS (SELECT log_id 
FROM base a 
GROUP BY log_id
) 
UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET    postop_painmanage_parent=1
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN matches AS m ON f.LOG_ID=m.log_id;

--update postop antiemetics
WITH base AS (
SELECT rid=ROW_NUMBER() OVER(partition BY c.log_id ORDER BY c.log_id)
--,c.LOG_ID
,c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,givmed.*
,meddim.MedType
,meddim.InProtocol
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
JOIN radb.dbo.CRD_ERASOrtho_GivenMeds AS givmed
ON CASE WHEN givmed.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
		WHEN givmed.anescsn_flag=1 THEN c.anescsn END =givmed.pat_enc_csn_id
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON givmed.MEDICATION_ID=meddim.medication_id
WHERE  meddim.MedType='Antiemetics'
 AND givmed.postop_disch=1
 ) , matches AS (SELECT log_id 
FROM base a 
GROUP BY log_id
) --SELECT * FROM base ORDER BY log_id,taken_time
UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET   postop_antiemetics=1
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN matches AS m ON f.LOG_ID=m.log_id;


--Post-op Parenteral
--either Morphine IV Orderable (ERX-149951) 
--OR Hydromorphone IV Orderable (ERX 150104) 
--OR FENTANYL (PF) 50 MCG/ML INJECTION SOLUTION (ERX – 3037)

--update postop Parenteral
WITH base AS (
SELECT rid=ROW_NUMBER() OVER(partition BY c.log_id ORDER BY c.log_id)
--,c.LOG_ID
,c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,givmed.*
,meddim.MedType
,meddim.InProtocol
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
JOIN radb.dbo.CRD_ERASOrtho_GivenMeds AS givmed
ON CASE WHEN givmed.admissioncsn_flag=1 THEN c.PAT_ENC_CSN_ID
		WHEN givmed.anescsn_flag=1 THEN c.anescsn END =givmed.pat_enc_csn_id
LEFT JOIN radb.dbo.CRD_ERASOrtho_Med_Dim AS meddim ON givmed.MEDICATION_ID=meddim.medication_id
WHERE  meddim.MedType='Parenteral'
 AND givmed.postop_disch=1
 ) , matches AS (SELECT log_id 
FROM base a 
GROUP BY log_id
) --SELECT * FROM base ORDER BY log_id,taken_time
UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET   postop_painmanage_parent =1
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN matches AS m ON f.LOG_ID=m.log_id;




--update intermittent catheter
WITH cathvoid AS (
SELECT 
peh.HOSP_ADMSN_TIME
,peh.HOSP_DISCH_TIME
,iln.procedurefinish
,postopflag=CASE WHEN ifm.RECORDED_TIME>=iln.procedurefinish AND ifm.RECORDED_TIME<=peh.HOSP_DISCH_TIME THEN 1 ELSE 0 end
,iln.PAT_ENC_CSN_ID
,p.PAT_NAME
,p.PAT_MRN_ID
,ifm.FLO_MEAS_ID AS Assesment_flo_meas_id
,ifgd.FLO_MEAS_NAME
,ifgd.DISP_NAME
,ifm.FSD_ID
,ifm.line 
,ifgd.DUPLICATEABLE_YN
,ifm.ENTRY_TIME
,ifm.RECORDED_TIME
,ifm.MEAS_VALUE
,MEAS_NUMERIC=CAST(ifm.MEAS_VALUE AS INT)
,ifm.MEAS_COMMENT
,zvt.NAME AS ValueType
,zrt.name AS RowType
,ifm.ENTRY_USER_ID
,emp_enter.NAME AS Entry_Username
,ifm.TAKEN_USER_ID
,emp_taken.name AS Taken_Username
--,'IP_LDA_NOADDSINGLE>>>>>'
,iln.ip_LDA_ID
,ifgdlda.DISP_NAME AS LDAName
,iln.PLACEMENT_INSTANT AS PLACEMENT_DTTM
,iln.REMOVAL_INSTANT   AS REMOVAL_DTTM
,iln.DESCRIPTION AS LDA_Description
,iln.PROPERTIES_DISPLAY AS LDA_Properties
--,'FLOWSHEETROWS>>>>>>>'
--,ifr.*
--,*
FROM (			SELECT 
					   ceoc.procedurefinish,
						iln.*
			FROM    clarity.dbo.IP_DATA_STORE AS ids	
					JOIN radb.dbo.CRD_ERASOrtho_Cases AS ceoc ON ids.EPT_CSN=ceoc.PAT_ENC_CSN_ID
					JOIN clarity.dbo.IP_LDA_INPS_USED AS iliu
					ON ids.INPATIENT_DATA_ID=iliu.INP_ID
					JOIN clarity.dbo.IP_LDA_NOADDSINGLE AS iln 
						ON iln.IP_LDA_ID=iliu.IP_LDA_ID		
					
					
	) AS iln

LEFT JOIN Clarity.dbo.IP_FLOWSHEET_ROWS AS ifr ON iln.IP_LDA_ID=ifr.IP_LDA_ID
LEFT JOIN clarity.dbo.PAT_ENC_HSP AS peh ON iln.PAT_ENC_CSN_ID=peh.PAT_ENC_CSN_ID
LEFT JOIN clarity.dbo.PATIENT AS p ON p.PAT_ID=peh.PAT_ID
LEFT join clarity.dbo.IP_FLWSHT_REC AS ifrec ON ifr.INPATIENT_DATA_ID=ifrec.INPATIENT_DATA_ID
LEFT JOIN clarity.dbo.IP_FLWSHT_MEAS AS ifm ON ifr.line=ifm.OCCURANCE AND ifrec.FSD_ID=ifm.FSD_ID
LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd ON ifgd.FLO_MEAS_ID=ifm.FLO_MEAS_ID
LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgdlda ON ifgdlda.FLO_MEAS_ID=iln.FLO_MEAS_ID
LEFT JOIN clarity.dbo.CLARITY_EMP AS emp_taken ON ifm.TAKEN_USER_ID=emp_taken.USER_ID
LEFT JOIN clarity.dbo.CLARITY_EMP AS emp_enter ON ifm.ENTRY_USER_ID=emp_enter.USER_ID
LEFT JOIN clarity.dbo.ZC_VAL_TYPE AS zvt ON zvt.VAL_TYPE_C = ifgd.VAL_TYPE_C
LEFT JOIN clarity.dbo.ZC_ROW_TYP AS zrt ON zrt.ROW_TYP_C = ifgd.ROW_TYP_C

WHERE iln.flo_meas_id='3048148000'
AND ifm.FLO_MEAS_ID='661859'
) 
UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET   foleycath=1 
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN cathvoid AS m ON f.PAT_ENC_CSN_ID=m.PAT_ENC_CSN_ID;


EXEC radb.dbo.CRD_ERASOrtho_Create_DateDim;



--assess foley catheter utilization
--3/2/2016 -- modify this!!! to reflect correct LDA location
--WITH base AS (
--SELECT 
--c.pat_name
--,c.pat_mrn_id
--,c.HOSP_ADMSN_TIME
--,c.HOSP_DISCH_TIME
--,c.PAT_ENC_CSN_ID
--,flw.Flowsheet_DisplayName
--,flw.MEAS_NUMERIC
--FROM radb.dbo.CRD_ERASOrtho_Cases AS c
--JOIN radb.dbo.CRD_ERASOrtho_FlowDetail AS flw ON c.PAT_ENC_CSN_ID=flw.PAT_ENC_CSN_ID
--WHERE  flw.FLO_MEAS_ID IN ('661859','3040102774')
--AND flw.MEAS_NUMERIC>0 
--AND flw.Postop_disch=1
-- ) , sumit AS (SELECT a.PAT_ENC_CSN_ID,SUM(a.MEAS_NUMERIC) AS totoutput
--FROM base a 
--GROUP BY a.PAT_ENC_CSN_ID
--)-- SELECT * FROM sumit

--UPDATE radb.dbo.CRD_ERASOrtho_Cases
--SET   foleycath=1 
--FROM radb.dbo.CRD_ERASOrtho_Cases AS f
--JOIN sumit AS m ON f.PAT_ENC_CSN_ID=m.PAT_ENC_CSN_ID;




--*********************************************************************************

-- Log the completion message (successful)
    
    SET @Msg =  @Procname + ' completed successfully'
    EXEC ynhhs_logmsg @piMessage = @Msg;

 -- Error handling

 END TRY
  
  BEGIN CATCH


-- Log error message

    SET @Msg = 'Error in procedure ' + @Procname ;
    EXEC ynhhs_logmsg @piMessage = @Msg;

  END CATCH 
 








