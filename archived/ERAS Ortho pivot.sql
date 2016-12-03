
SELECT * FROM dbo.vw_PatEnc AS vpe
WHERE PAT_ENC_CSN_ID=105620904


SELECT *
FROM radb.dbo.vw_ERASOrtho  a
JOIN (SELECT csn 
	  FROM radb.dbo.vw_ERASOrtho 
	  GROUP BY csn HAVING COUNT(*)>1
	  ) d ON a.csn=d.csn
ORDER BY a.csn


SELECT  
a.LogStatus
,a.LOG_ID
,       a.HSP_ACCOUNT_ID
,       a.anescsn
,       a.admissioncsn
,       a.surgicalcsn
,       a.procedurename
,a.ProcedureType
,       a.PAT_NAME
,       a.PAT_MRN_ID
,       a.pat_id
,       a.PAT_ENC_CSN_ID

,       a.LOSDays
,       a.LOSHours
,       a.HOSP_ADMSN_TIME
,       a.HOSP_DISCH_TIME
,       a.DISCH_DISP_C
,       a.DischargeDisposition
,       a.DischargeDisposition2
,       a.Enc_Pat_class_C
,       a.Enc_Pat_Class
,       a.Surgery_pat_class_c
,       a.Surgery_Patient_Class
,       a.LOG_ID
,       a.STATUS_C
,       a.LogStatus
,       a.CASE_CLASS_C
,       a.CASECLASS_DESCR
,       a.NUM_OF_PANELS
,       a.PROC_DISPLAY_NAME
,       a.REAL_CPT_CODE
,       a.Surgery_Room_Name
,       a.SurgeonName
,       a.ROLE_C
,       a.PANEL
,       a.ALL_PROCS_PANEL
,       a.procline
,       a.SurgeryServiceName
,       a.SURGERY_DATE
,       a.SCHED_START_TIME
,       a.SurgeryLocation
,       a.setupstart
,       a.setupend
,       a.inroom
,       a.outofroom
,       a.cleanupstart
,       a.cleanupend
,       a.inpacu
,       a.outofpacu
,       a.inpreprocedure
,       a.outofpreprocedure
,       a.anesstart
,       a.anesfinish
,       a.procedurestart
,       a.procedurefinish
,       a.HospitalWide_30DayReadmission_NUM
,       a.HospitalWide_30DayReadmission_DEN
FROM radb.dbo.ERAS_Ortho AS a
JOIN (SELECT PAT_ENC_CSN_ID 
	  FROM radb.dbo.ERAS_Ortho 
	  GROUP BY PAT_ENC_CSN_ID HAVING COUNT(*)>1
	  ) d ON a.pat_enc_csn_id=d.pat_enc_csn_id
ORDER BY a.pat_enc_csn_id,a.LOG_ID


SELECT * 
FROM dbo.vw_PatEnc AS vpe
LEFT JOIN clarity.dbo.pat_enc pe ON vpe.PAT_ENC_CSN_ID=pe.PAT_ENC_CSN_ID
WHERE vpe.PAT_ENC_CSN_ID IN (106824746	,105620904	,105620509)




USE [RADB]
GO

--metrics
,       f.LOSDays    
,  f.HospitalWide_30DayReadmission_DEN    
,  f.HospitalWide_30DayReadmission_NUM    
,  qvi_Infection=CASE WHEN qvi_inf.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END         
,  qvi_AdverseEffects=CASE WHEN qvi_adv.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_FallsTrauma=CASE WHEN qvi_falls.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_ForeignObjectRetained=CASE WHEN qvi_forobject.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_PerforationLaceration=CASE WHEN qvi_perf.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_DVTPTE=CASE WHEN qvi_DVTPTE.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Pneumonia=CASE WHEN qvi_pne.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Shock=CASE WHEN qvi_shock.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Any=CASE WHEN qvi_any.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END    

SELECT * FROM dbo.vw_ERASOrtho AS veo

/****** Object:  View [dbo].[view_HVCBedFlow]    Script Date: 01/01/2016 20:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_ERASOrtho_pivot]      
as      
SELECT        
       csn
,  'O1' AS MetricID      
,   LOSDays AS value
,  1 AS Inclusion      
      
      
FROM radb.dbo.vw_ERASOrtho 
      
UNION ALL      
    
SELECT        
       csn
,  'O2' AS MetricID      
,   HospitalWide_30DayReadmission_DEN AS Value
,  HospitalWide_30DayReadmission_NUM AS Inclusion
      
      
FROM radb.dbo.vw_ERASOrtho 
    
UNION ALL    
      
SELECT        
       csn
,  'O3' AS MetricID      
,   IPAdmission AS VALUE      
,  1 AS Inclusion      

FROM radb.dbo.vw_ERASOrtho 
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E4' AS MetricID      
,   LOS_CTICU AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E5' AS MetricID      
,   LOS_CCU AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E6' AS MetricID      
,   LOS_54 AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E7' AS MetricID      
,   LOS_53 AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E8' AS MetricID      
,   LOS_52 AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E9' AS MetricID      
,   CostPerCase AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E10' AS MetricID      
,   CTICU_BounceBack AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E11' AS MetricID      
,   CCU_BounceBack AS VALUE      
,  1 AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E12' AS MetricID      
,  DISCH_52_9AM_NUM  AS VALUE      
,  DISCH_52_9AM_DEN AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E13' AS MetricID      
,  DISCH_53_9AM_NUM  AS VALUE      
,  DISCH_53_9AM_DEN  AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E14' AS MetricID      
,  DISCH_CCU_7AM_NUM  AS VALUE      
,  DISCH_CCU_7AM_DEN AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E15' AS MetricID      
,  DISCH_CTICU_7AM_NUM  AS VALUE      
,  DISCH_CTICU_7AM_DEN AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E16' AS MetricID      
,   Vascular52_NUM AS VALUE      
,  Vascular52_DEN AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E17' AS MetricID      
,   Cardiac52_NUM AS VALUE      
,  Cardiac52_DEN AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe 


UNION ALL
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E18' AS MetricID      
,  DISCH_52_6PM_NUM  AS VALUE      
,  DISCH_52_6PM_DEN AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E19' AS MetricID      
,  DISCH_53_6PM_NUM  AS VALUE      
,  DISCH_53_6PM_DEN  AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      

UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E20' AS MetricID      
,  DISCH_54_6PM_NUM  AS VALUE      
,  DISCH_54_6PM_DEN  AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      
UNION ALL      
      
SELECT        
       PAT_ENC_CSN_ID      
,  'E21' AS MetricID      
,  DISCH_53_9AM_NUM  AS VALUE      
,  DISCH_53_9AM_DEN  AS Inclusion      
FROM dbo.VW_HVCBEDFLOW_ENCOUNTERS AS vhe      
      


GO


