


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
alter VIEW dbo.CRD_ERAS_YNHGI_MetricFact
AS

SELECT --median los
		CAST('1' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter AS ERASRptGrouper
	   , Discharge_DateKey AS DateKey
	   ,LOSDays AS Num
	   ,1 'Den'
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim
UNION ALL
SELECT --average los
		CAST('2' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,LOSDays AS Num
	   ,1 'Den'
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim

UNION ALL

SELECT --readmission rate
		CAST('3' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.HospitalWide_30DayReadmission_NUM AS Num
	   ,ah.HospitalWide_30DayReadmission_DEN AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah


UNION ALL

SELECT --#QVI pneumonia 
		CAST('19' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_Pneumonia AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah

UNION ALL



SELECT --#QVI pneumonia ventilator assoc 
		CAST('48' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_pnevent AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah

UNION ALL


SELECT --#QVI pneumonia aspiration
		CAST('49' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_pneasp AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah

UNION ALL


SELECT --#QVI thrombosis/embolism
		CAST('52' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_DVTPTE AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah

UNION ALL

SELECT --% QVI Thrombosis Embolism: Pulmonary:latrogenic condition
		CAST('50' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_thriat as Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah

UNION ALL

SELECT --% QVI Thrombosis Embolism: Pulmonary
		CAST('51' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_thrpulm as Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah



UNION ALL



SELECT --%QVI Any
		CAST('9' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus AS Campus
	   ,PrimaryProcedureCategory AS ProcedureCategory
	   ,PrimaryOpenVsLap AS OpenVsLaparoscopic
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_Any AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim ah

UNION ALL


SELECT --% ambulate day 0
		CAST('44' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.ambulatepod0,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName	   
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.ambulatepod0 AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah

UNION ALL

SELECT --ambulate pod 1
		CAST('45' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.ambulate_pod1 as Num
	   ,1 AS Den
		FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah


UNION ALL

SELECT --ambulate pod 2
		CAST('46' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.ambulate_pod2 as Num
	   ,1 AS Den
		FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah


UNION ALL

SELECT --preaadmission counseling
		CAST('41' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.preadm_counseling as Num
	   ,1 AS Den
		FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah

UNION ALL

SELECT --% liquids POD0
		CAST('47' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.clearliquids_pod0 AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah




UNION ALL

SELECT --% normal PACU temperature
		CAST('43' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.NormalTempInPacu AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah



UNION ALL

SELECT --% liquids 3 hrs before induction
		CAST('42' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.clearliquids_3ind AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah






UNION ALL
SELECT --# cases
		CAST('37' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , ah.LOG_ID AS Log_ID	   
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,1 AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_YNHGI_Case AS ah

UNION ALL

SELECT --# encounters
		CAST('38' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,1 AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim AS  ah


		


UNION ALL

SELECT --IQR hours to tolerate diet
		CAST('82' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,hrs_toleratediet AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 



UNION ALL

SELECT --IQR hours to return of bowel function
		CAST('83' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,hrs_tobowelfunction AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 



UNION ALL

SELECT --avg hours to tolerate diet
		CAST('67' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
  	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   ,Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,hrs_toleratediet AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 

UNION ALL

SELECT --avg hours to tolerate diet
		CAST('67' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,hrs_toleratediet AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 


UNION ALL

SELECT --median hours to tolerate diet
		CAST('68' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,hrs_toleratediet AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 



UNION ALL

SELECT --avg hours to bowel function
		CAST('69' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,hrs_tobowelfunction AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 



UNION ALL

SELECT --median hours to tolerate diet
		CAST('70' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,hrs_tobowelfunction AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 


UNION ALL

SELECT --ED revisit rate 
		CAST('71' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,ED_revisit AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 


UNION ALL

SELECT --QVI surgical site
		CAST('58' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_Surgsite AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 

UNION all


SELECT --ICU admissions rates
		CAST('78' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,  icuadmit AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 



UNION all


SELECT --reprocedured
		CAST('79' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'	   
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,  reprocedured AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 

UNION ALL


SELECT --thoracic epidural
		CAST('72' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName	   
   	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,thoracic_epi AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 



UNION ALL


SELECT --multimodal intraop antiemetics
		CAST('34' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,mm_antiemetic_intraop AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 


UNION ALL


SELECT --multimodal pain
		CAST('24' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , Log_ID
	   ,ErasCase
	   ,SurgeryDateKey
	   ,mm_pain AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 

UNION all

SELECT --QVI complication post op shock septic
		CAST('53' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_postopshock_septic AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 


UNION all

SELECT --QVI complication post op shock cardiogenic
		CAST('54' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_postopshock_cardiogenic AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 


UNION all

SELECT --QVI complication post op shock 
		CAST('55' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_postopshock AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 


UNION all

SELECT --QVI respiratory failure
		CAST('56' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_respfailure AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 

UNION all

SELECT --QVI infection cauti
		CAST('57' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectionCAUTI AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 



UNION all

SELECT --QVI infection sepsis shock
		CAST('59' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectionSepsisshock AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 



UNION all

SELECT --QVI infection sepsis shock
		CAST('59' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectionSepsisshock AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 


		

UNION all

SELECT --QVI infection sepsis severe
		CAST('60' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectionSepsissevere AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 


			

UNION all

SELECT --QVI infection sepsis 
		CAST('61' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectionSepsis AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 




			

UNION all

SELECT --QVI infection cdiff
		CAST('62' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectioncdiff AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 




UNION all

SELECT --QVI infection sepsis staph
		CAST('63' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectionstaph AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 




UNION all

SELECT --QVI infection SIRS
		CAST('64' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_infectionsirs AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 





UNION all

SELECT --QVI delirium
		CAST('65' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_delirium AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 



UNION all

SELECT --QVI post op dehiscence
		CAST('66' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
   	   ,SurgeryCampus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , NULL AS log_id
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,qvi_dehiscence AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_EncDim 




UNION all

SELECT --IV fluid dc pod 0
		CAST('73' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName	   
   	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , log_id
	   ,ErasCase
	   ,SurgeryDateKey
	   ,iv_fluid_dc_pod0 AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 



UNION all

SELECT --IV fluid dc pod1 noon
		CAST('74' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   ,  log_id
	   ,ErasCase
	   ,SurgeryDateKey
	   ,iv_fluid_dc_pod1noon AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 



UNION all

SELECT --IV fluid dc pod2
		CAST('75' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , log_id
	   ,ErasCase
	   ,SurgeryDateKey
	   ,iv_fluid_dc_pod2 AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case 

UNION all

SELECT --solid food pod1
		CAST('76' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , log_id
	   ,ErasCase
	   ,SurgeryDateKey
	   ,solidfood_pod1 AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case AS vceyc


UNION all

SELECT --foley
		CAST('77' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , log_id
	   ,ErasCase
	   ,SurgeryDateKey
	   ,foleypod1 AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case AS vceyc


UNION all

SELECT --goal directed therapjy
		CAST('36' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , log_id
	   ,ErasCase
	   ,SurgeryDateKey
	   ,goal_guidelines AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case AS vceyc


UNION all

SELECT --% return to OR
		CAST('84' AS INT) AS 'MetricKey'
	   ,ISNULL(AdmissionCSN,NULL) 'PAT_ENC_CSN_ID'
	   ,SurgeonName
	   ,Campus
	   ,PrimaryProcedureCategory
	   ,PrimaryOpenVsLap 
	   , log_id
	   ,ErasCase
	   ,SurgeryDateKey
	   ,ReturnToOR AS Num
	   ,1 AS Den
	FROM 
		radb.dbo.vw_CRD_ERAS_YNHGI_Case AS vceyc







		


