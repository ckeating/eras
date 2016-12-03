
SELECT * 
FROM radb.dbo.ERAS_Ortho

SELECT patient_status_c,DischargeDisposition2 ,COUNT(*)
FROM radb.dbo.ERAS_Ortho
GROUP BY patient_status_c,DischargeDisposition2 
ORDER BY 1

SELECT 


SELECT * FROM dbo.HVCBedflow_MetricDim AS hbmd

SELECT * 
INTO radb.dbo.ERASOrtho_MetricDim
FROM dbo.HVCBedflow_MetricDim AS hbmd




--home

--01	Discharged to Home or Self Care (Routine Discharge)	65
--06	Discharged/transferred to Home Under Care of Organized Home Health Service Org	221

--facility
--02	Discharged/transferred to a Short-Term General Hospital for Inpatient Care	1
--03	Discharged/transferred to Skilled Nursing Facility (SNF) with Medicare Certification	318
--62	Discharged/transferred to an Inpatient Rehab Facility (IRF)	40
--63	Discharged/transferred to a Medicare Certified Long Term Care Hospital (LTCH)	2
--64	Discharged/transferred to a Nursing Fac Certified under Medicaid but not Medicare	47
--90	IP REHAB W PLANNED READMIT	2


--20	Expired	4




sp_helptext vw_ERASOrtho


SELECT * FROM vw_ERASOrtho



  
ALTER VIEW dbo.vw_ERASOrtho    
AS    
SELECT  f.PAT_MRN_ID AS MRN    
,       f.SurgeonName AS Surgeon    
,  f.LOG_ID     
,  f.HSP_ACCOUNT_ID AS HAR    
,  f.PAT_ENC_CSN_ID AS CSN    
,  f.ProcedureType    
,       f.REAL_CPT_CODE AS CPTCode    
,       f.LOSDays    
,       f.LOSHours    
,		[Discharge Disposition]=CASE 
			WHEN  f.patient_status_c IN ('01','06') THEN 'Discharge to Home'
			WHEN  f.patient_status_c IN ('02','03','62','63','64','90') THEN 'Discharge to Facility'
			ELSE f.DischargeDisposition2 end
			
,       f.DischargeDisposition2 AS [Patient Status]    
,  f.HospitalWide_30DayReadmission_DEN    
,  f.HospitalWide_30DayReadmission_NUM    
,  CONVERT(DATE,f.HOSP_ADMSN_TIME)  AS Admission_Date    
,  f.HOSP_ADMSN_TIME AS Admission_DTTM    
,  CONVERT(DATE,f.HOSP_DISCH_TIME) AS Discharge_Date    
,  f.HOSP_DISCH_TIME AS Discharge_DTTM    
,  qvi_Infection=CASE WHEN qvi_inf.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END         
,  qvi_AdverseEffects=CASE WHEN qvi_adv.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_FallsTrauma=CASE WHEN qvi_falls.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_ForeignObjectRetained=CASE WHEN qvi_forobject.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_PerforationLaceration=CASE WHEN qvi_perf.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_DVTPTE=CASE WHEN qvi_DVTPTE.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Pneumonia=CASE WHEN qvi_pne.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Shock=CASE WHEN qvi_shock.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Any=CASE WHEN qvi_any.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
    
FROM    radb.dbo.ERAS_Ortho AS f    
  
  
--QVI infection  
    LEFT JOIN (        
    SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f    
   LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
   ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
   WHERE d.QVI_Num IN (17,18,19)    
   GROUP BY f.HSP_ACCOUNT_ID    
  ) qvi_inf ON f.hsp_account_id=qvi_inf.HSP_ACCOUNT_ID        
  
--adverse effects  
LEFT JOIN (        
      SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f    
   LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
   ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
   WHERE d.QVI_Num IN (28)    
   GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_adv ON f.hsp_account_id=qvi_adv.HSP_ACCOUNT_ID       
          
 --falls and trauma         
 LEFT JOIN (        
      SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f    
   LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
   ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
   WHERE d.QVI_Num IN (7)    
   GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_falls ON f.hsp_account_id=qvi_falls.HSP_ACCOUNT_ID       
  
--foreign object retained  
       
  LEFT JOIN (        
      SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f    
   LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
   ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
   WHERE d.QVI_Num IN (3)    
   GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_forobject ON f.hsp_account_id=qvi_forobject.HSP_ACCOUNT_ID       
          
      
  LEFT JOIN (        
      SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f    
   LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
   ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
   WHERE d.QVI_Num IN (9)    
   GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_dvtpte ON f.hsp_account_id=qvi_dvtpte.HSP_ACCOUNT_ID       
  
  
  
--perforations and lacerations            
  LEFT JOIN (        
      SELECT f.HSP_ACCOUNT_ID    
  FROM radb.dbo.QVI_Fact f    
  LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
  ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
  WHERE d.QVI_Num IN (4)    
  GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_perf ON f.hsp_account_id=qvi_perf.HSP_ACCOUNT_ID            
  
--pneumonia        
  LEFT JOIN (        
      SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f    
   LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
   ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
   WHERE d.QVI_Num IN (11,12)    
   GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_pne ON f.hsp_account_id=qvi_pne.HSP_ACCOUNT_ID           
  
--shock        
  LEFT JOIN (        
    SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f    
   LEFT JOIN radb.dbo.QVI_Hierarchy_Dim AS d    
   ON f.QVI_Hierarchy_Key=d.QVI_Hierarchy_Key    
   WHERE d.QVI_Num IN (16)    
   GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_shock ON f.hsp_account_id=qvi_shock.HSP_ACCOUNT_ID        
  
--any qvi        
  LEFT JOIN (        
      SELECT f.HSP_ACCOUNT_ID    
   FROM radb.dbo.QVI_Fact f       
   GROUP BY f.HSP_ACCOUNT_ID    
    ) qvi_any ON f.hsp_account_id=qvi_any.HSP_ACCOUNT_ID      
          
      
      
      