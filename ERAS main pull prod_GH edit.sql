sp_helptext 


SELECT * FROM CRD_ERAS_EncDim  
FROM vw_CRD_ERAS_EncDim 



sp_help CRD_ERAS_Global_TimeWindows

SELECT * from
CRD_ERAS_Global_TimeWindows


CREATE VIEW dbo.vw_CRD_ERAS_EncDim 
AS
SELECT  f.PAT_ENC_CSN_ID AS CSN ,
        f.HSP_ACCOUNT_ID AS HAR ,
        f.pat_name AS PatientName ,
        f.pat_mrn_id AS MRN ,
        f.LOSDays ,
        f.LOSHours ,
        f.HOSP_ADMSN_TIME AS Admission_DTTM ,
        CONVERT(DATE, f.HOSP_ADMSN_TIME) AS Admission_DT ,
        f.HOSP_DISCH_TIME AS Discharge_DTTM ,
        CONVERT(DATE, f.HOSP_DISCH_TIME) AS Discharge_DT ,
        f.Discharge_DateKey ,
		ERASEncounter=   CASE WHEN erasflag.erascount>0 THEN 'Eras Case' ELSE 'Non-ERAS Case' END ,
        f.Enc_DischargeDisposition ,
        f.PatientStatus ,
        f.BaseClass ,
        f.Enc_Pat_Class ,
        f.[Admission Type] ,
        f.HospitalWide_30DayReadmission_NUM ,
        f.HospitalWide_30DayReadmission_DEN ,
        f.TotalDirectCost ,
        f.NumberofProcs ,
        qvi_Infection = CASE WHEN qvi_inf.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                             ELSE 0
                        END ,
        qvi_AdverseEffects = CASE WHEN qvi_adv.HSP_ACCOUNT_ID IS NOT NULL
                                  THEN 1
                                  ELSE 0
                             END ,
        qvi_FallsTrauma = CASE WHEN qvi_falls.HSP_ACCOUNT_ID IS NOT NULL
                               THEN 1
                               ELSE 0
                          END ,
        qvi_ForeignObjectRetained = CASE WHEN qvi_forobject.HSP_ACCOUNT_ID IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                    END ,
        qvi_PerforationLaceration = CASE WHEN qvi_perf.HSP_ACCOUNT_ID IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                    END ,
        qvi_DVTPTE = CASE WHEN qvi_dvtpte.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                          ELSE 0
                     END ,
        qvi_Pneumonia = CASE WHEN qvi_pne.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                             ELSE 0
                        END ,
        qvi_pneasp = CASE WHEN qvi_pneasp.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                          ELSE 0
                     END ,
        qvi_pnevent = CASE WHEN qvi_pnevent.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                           ELSE 0
                      END ,
        qvi_Shock = CASE WHEN qvi_shock.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                         ELSE 0
                    END ,

		qvi_thriat =  CASE WHEN qvi_thriat.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                         ELSE 0
                    END,

	qvi_thrpulm=  CASE WHEN qvi_thrpulm.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                         ELSE 0
                    END,
        qvi_Any = CASE WHEN qvi_any.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END
FROM    RADB.dbo.CRD_ERAS_EncDim AS f 
LEFT JOIN (SELECT AdmissionCSN,SUM(CASE WHEN ErasCase='Eras Case' THEN 1 ELSE 0 END) AS erascount
					FROM radb.dbo.vw_CRD_ERAS_Case AS vcec
					GROUP BY AdmissionCSN
		  ) AS erasflag ON erasflag.AdmissionCSN=f.pat_enc_csn_id
		  --QVI infection  
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 17, 18, 19 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_inf ON f.HSP_ACCOUNT_ID = qvi_inf.HSP_ACCOUNT_ID        
  
--adverse effects  
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 28 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_adv ON f.HSP_ACCOUNT_ID = qvi_adv.HSP_ACCOUNT_ID       
          
 --falls and trauma         
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 7 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_falls ON f.HSP_ACCOUNT_ID = qvi_falls.HSP_ACCOUNT_ID       
  
--foreign object retained  
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                      LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 3 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_forobject ON f.HSP_ACCOUNT_ID = qvi_forobject.HSP_ACCOUNT_ID       
          
   --thrombosis /embolism
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 9 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_dvtpte ON f.HSP_ACCOUNT_ID = qvi_dvtpte.HSP_ACCOUNT_ID       
  
    
--perforations and lacerations            
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 4 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_perf ON f.HSP_ACCOUNT_ID = qvi_perf.HSP_ACCOUNT_ID            
  
--pneumonia        
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 11, 12 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_pne ON f.HSP_ACCOUNT_ID = qvi_pne.HSP_ACCOUNT_ID           

--pneumonia ventilator assoc
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key = 52
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_pnevent ON f.HSP_ACCOUNT_ID = qvi_pnevent.HSP_ACCOUNT_ID           


--pneumonia aspiration
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key = 51
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_pneasp ON f.HSP_ACCOUNT_ID = qvi_pneasp.HSP_ACCOUNT_ID           
	
  
--shock        
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 16 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_shock ON f.HSP_ACCOUNT_ID = qvi_shock.HSP_ACCOUNT_ID        
  
--any qvi        
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_any ON f.HSP_ACCOUNT_ID = qvi_any.HSP_ACCOUNT_ID      
          
		  

--Thrombosis/Embolism: Pulmonary: Iatrogenic Condition
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 61 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_thriat ON qvi_thriat.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID



--Thrombosis/Embolism: Pulmonary: Pulmonary
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 60 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_thrpulm ON qvi_thriat.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID




SELECT * FROM RADB.dbo.CRD_ERAS_Case 

WHERE PAT_MRN_ID ='mr250245'

SELECT * FROM radb.dbo.vw_CRD_ERAS_EncDim AS vceed

SELECT * FROM radb.dbo.vw_CRD_ERAS_Case AS vcec

SELECT * FROM radb.dbo.CRD_ERASProject_Dim
SELECT * FROM CRD_ERAS_CPT_Dim

SELECT * FROM RADB.dbo.tmp_CRD_ERAS_Case ORDER BY surgery_date

	DECLARE @dn  VARCHAR(25), @erasproject VARCHAR(25)
	SET @dn='GH'
	SET @erasproject='GI'
	--SELECT ProjectID FROM radb.dbo.CRD_ERASProject_Dim WHERE DeliveryNetwork_ShortName=@dn AND ProjectShortName=@erasproject
	--SELECT ProjectID FROM radb.dbo.CRD_ERASProject_Dim WHERE DeliveryNetwork_ShortName=@dn AND ProjectShortName=@erasproject

IF object_id('RADB.dbo.tmp_CRD_ERAS_Case') IS NOT NULL
	DROP TABLE RADB.dbo.tmp_CRD_ERAS_Case;


SELECT 
  ProjectID=(SELECT ProjectID FROM radb.dbo.CRD_ERASProject_Dim WHERE DeliveryNetwork_ShortName=@dn AND ProjectShortName=@erasproject),
  clarity.dbo.OR_LOG.LOG_ID,
  ProcedureType=cptdim.ProcedureCategory,		
  clarity.dbo.PATIENT.PAT_NAME,
  clarity.dbo.patient.PAT_MRN_ID,
  clarity.dbo.patient.pat_id,  
  clarity.dbo.PAT_ENC_HSP.HOSP_DISCH_TIME,
  clarity.dbo.PAT_ENC_HSP.HOSP_ADMSN_TIME,
  clarity.dbo.or_log.PAT_TYPE_C AS Surgery_pat_class_c,
  ZC_PAT_CLASS_Surg.NAME AS Surgery_Patient_Class,  
  clarity.dbo.or_LOG.STATUS_C,
  zos.NAME AS LogStatus,
  clarity.dbo.or_log.CASE_CLASS_C ,
  zocc.NAME AS CASECLASS_DESCR,   
  clarity.dbo.or_log.NUM_OF_PANELS,
  clarity.dbo.OR_LOG_ALL_PROC.PROC_DISPLAY_NAME,   --added
  ErasCase=CASE WHEN LTRIM(clarity.dbo.OR_LOG_ALL_PROC.PROC_DISPLAY_NAME) LIKE 'ERAS%'  THEN 'Eras Case'
		ELSE 'Non-ERAS Case' END ,
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
  hrs_toleratediet=CAST(0 AS TINYINT)
  
INTO RADB.dbo.tmp_CRD_ERAS_Case

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
  LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Surg ON (ZC_PAT_CLASS_Surg.ADT_PAT_CLASS_C=CLARITY.dbo.OR_LOG.PAT_TYPE_C)   
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zocc  ON zocc.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.ZC_OR_CASE_CLASS AS zoclog  ON zoclog.CASE_CLASS_C=clarity.dbo.or_log.CASE_CLASS_C
  LEFT OUTER JOIN clarity.dbo.OR_PROC_CPT_ID ON clarity.dbo.OR_PROC.OR_PROC_ID=clarity.dbo.OR_PROC_CPT_ID.OR_PROC_ID
  JOIN RADB.dbo.CRD_ERAS_CPT_Dim AS cptdim ON cptdim.CPTCode=clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE
  												AND cptdim.DeliveryNetwork=@dn
												AND cptdim.ERASProject=@erasproject
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

  
WHERE  (clarity.dbo.OR_LOG.SURGERY_DATE>='7/1/2015' AND clarity.dbo.or_log.SURGERY_DATE<'3/17/2016')
 AND     clarity.dbo.CLARITY_LOC.LOC_NAME  IN  ( 'GH MAIN OR')
  
   AND clarity.dbo.or_log.STATUS_C IN (2,5)
   AND PAT_ENC_HSP.HOSP_DISCH_TIME IS NOT NULL
   


ORDER BY clarity.dbo.or_log.LOG_ID,clarity.dbo.OR_LOG_ALL_PROC.line;

UPDATE RADB.dbo.tmp_CRD_ERAS_Case
SET CaseLength_hrs=DATEDIFF(HOUR,inroom,outofroom);

UPDATE RADB.dbo.tmp_CRD_ERAS_Case
SET CaseLength_min=DATEDIFF(MINUTE,inroom,outofroom);

BEGIN tran
DELETE radb.dbo.CRD_ERAS_Case
FROM radb.dbo.CRD_ERAS_Case a
JOIN radb.dbo.tmp_CRD_ERAS_Case AS tmp ON tmp.LOG_ID=a.LOG_ID

rollback
BEGIN tran
INSERT radb.dbo.CRD_ERAS_Case
        ( ProjectID ,
          LOG_ID ,
          ProcedureType ,
          PAT_NAME ,
          PAT_MRN_ID ,
          pat_id ,
          HOSP_DISCH_TIME ,
          HOSP_ADMSN_TIME ,
          Surgery_pat_class_c ,
          Surgery_Patient_Class ,
          STATUS_C ,
          LogStatus ,
          CASE_CLASS_C ,
          CASECLASS_DESCR ,
          NUM_OF_PANELS ,
          PROC_DISPLAY_NAME ,
          ErasCase ,
          REAL_CPT_CODE ,
          anescsn ,
          admissioncsn ,
          surgicalcsn ,
          procedurename ,
          Surgery_Room_Name ,
          SurgeonName ,
          ROLE_C ,
          PANEL ,
          ALL_PROCS_PANEL ,
          procline ,
          SurgeryServiceName ,
          SURGERY_DATE ,
          DateKey ,
          SCHED_START_TIME ,
          SurgeryLocation ,
          setupstart ,
          setupend ,
          inroom ,
          outofroom ,
          cleanupstart ,
          cleanupend ,
          inpacu ,
          outofpacu ,
          inpreprocedure ,
          outofpreprocedure ,
          anesstart ,
          anesfinish ,
          procedurestart ,
          procedurefinish ,
          postopday1_begin ,
          postopday2_begin ,
          postopday3_begin ,
          postopday4_begin ,
          CaseLength_min ,
          CaseLength_hrs ,
          timeinpacu_min ,
          pacudelay ,
          preadm_counseling ,
          pacutemp ,
          NormalTempInPacu ,
          ambulatepod0 ,
          clearliquids_3ind ,
          clearliquids_pod0 ,
          ambulate_pod1 ,
          solidfood_pod1 ,
          ambulate_pod2 ,
          hrs_toleratediet
        )
		SELECT	ProjectID ,
                LOG_ID ,
                ProcedureType ,
                PAT_NAME ,
                PAT_MRN_ID ,
                pat_id ,
                HOSP_DISCH_TIME ,
                HOSP_ADMSN_TIME ,
                Surgery_pat_class_c ,
                Surgery_Patient_Class ,
                STATUS_C ,
                LogStatus ,
                CASE_CLASS_C ,
                CASECLASS_DESCR ,
                NUM_OF_PANELS ,
                PROC_DISPLAY_NAME ,
                ErasCase ,
                REAL_CPT_CODE ,
                anescsn ,
                admissioncsn ,
                surgicalcsn ,
                procedurename ,
                Surgery_Room_Name ,
                SurgeonName ,
                ROLE_C ,
                PANEL ,
                ALL_PROCS_PANEL ,
                procline ,
                SurgeryServiceName ,
                SURGERY_DATE ,
                DateKey ,
                SCHED_START_TIME ,
                SurgeryLocation ,
                setupstart ,
                setupend ,
                inroom ,
                outofroom ,
                cleanupstart ,
                cleanupend ,
                inpacu ,
                outofpacu ,
                inpreprocedure ,
                outofpreprocedure ,
                anesstart ,
                anesfinish ,
                procedurestart ,
                procedurefinish ,
                postopday1_begin ,
                postopday2_begin ,
                postopday3_begin ,
                postopday4_begin ,
                CaseLength_min ,
                CaseLength_hrs ,
                timeinpacu_min ,
                pacudelay ,
                preadm_counseling ,
                pacutemp ,
                NormalTempInPacu ,
                ambulatepod0 ,
                clearliquids_3ind ,
                clearliquids_pod0 ,
                ambulate_pod1 ,
                solidfood_pod1 ,
                ambulate_pod2 ,
                hrs_toleratediet
		FROM radb.dbo.tmp_CRD_ERAS_Case AS tcec



IF object_id('RADB.dbo.CRD_ERAS_EncDim') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_EncDim;


SELECT
  ec.ProjectID,
  peh.PAT_ENC_CSN_ID,  
  peh.HSP_ACCOUNT_ID,
  p.PAT_NAME,
  p.PAT_MRN_ID,
  LOSDays=DATEDIFF(dd,peh.HOSP_ADMSN_TIME,peh.HOSP_DISCH_TIME)    ,
  LOSHours=DATEDIFF(hh,peh.HOSP_ADMSN_TIME,peh.HOSP_DISCH_TIME)    ,
  peh.HOSP_ADMSN_TIME,
  peh.HOSP_DISCH_TIME,    
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
  rdc.TotalDirectCost

 INTO RADB.dbo.CRD_ERAS_EncDim
FROM clarity.dbo.PAT_ENC_HSP AS peh 
   JOIN  RADB.dbo.CRD_ERAS_Case AS ec ON ec.admissioncsn=peh.PAT_ENC_CSN_ID   
   LEFT JOIN clarity.dbo.HSP_ACCOUNT  AS hsp ON peh.HSP_ACCOUNT_ID=hsp.HSP_ACCOUNT_ID
   LEFT JOIN clarity.dbo.ZC_ACCT_BASECLS_HA AS basecl ON basecl.ACCT_BASECLS_HA_C=hsp.ACCT_BASECLS_HA_C
   LEFT JOIN clarity.dbo.ZC_MC_PAT_STATUS AS zcpat ON zcpat.PAT_STATUS_C=hsp.PATIENT_STATUS_C
   LEFT JOIN clarity.dbo.ZC_DISCH_DISP AS zdd ON zdd.DISCH_DISP_C=peh.DISCH_DISP_C
   LEFT JOIN radb.dbo.ReDiscovery_Costs AS rdc ON rdc.HSP_ACCOUNT_ID=peh.HSP_ACCOUNT_ID   
   LEFT OUTER JOIN CLARITY.dbo.PATIENT AS p ON (p.PAT_ID=peh.PAT_ID)
   LEFT JOIN radb.dbo.ReadmissionFact ra    
	ON CONVERT (varchar(30),peh.HSP_ACCOUNT_ID)=ra.IDX_VisitNum  
  LEFT OUTER JOIN clarity.dbo.ZC_MC_ADM_TYPE AS zadm ON zadm.ADMISSION_TYPE_C=hsp.ADMISSION_TYPE_C
  LEFT OUTER JOIN CLARITY.dbo.ZC_PAT_CLASS  ZC_PAT_CLASS_Enc ON (ZC_PAT_CLASS_Enc.ADT_PAT_CLASS_C=peh.ADT_PAT_CLASS_C );

  UPDATE RADB.dbo.CRD_ERAS_EncDim
  SET NumberofProcs=procct.ct
  FROM RADB.dbo.CRD_ERAS_EncDim AS e
  LEFT JOIN 
  ( SELECT admissioncsn,COUNT(*) AS ct
    FROM radb.dbo.CRD_ERAS_Case 
	GROUP BY admissioncsn
	) AS procct ON procct.admissioncsn=e.PAT_ENC_CSN_ID;












	