SELECT * FROM CRD_ERASOrtho_MetricFact

SELECT * FROM dbo.ERX_GROUPER_ONE AS egf
SELECT * FROM dbo.GROUPER_ITEMS AS gi
WHERE gi.CONTEXT_INI='erx'

SELECT 
cm.MEDICATION_ID AS ERX_ID
,mf.medication_id ,
 mf.MedType ,
 mf.MedBrandName ,
 cm.FORM,
cm.route,
 mf.MedShortName ,
 mf.EpicMedName ,
 mf.MedOrderSource ,
 mf.AdminTime ,
 mf.InProtocol
,cm.NAME AS MedicationName
,cm.GENERIC_NAME
,cm.STRENGTH
,ztc.NAME  AS TherapeuticClass
,zpc.name AS PharmClass
,zps.name AS PharmSubClass
--,rmo.*
,cm.*
FROM radb.dbo.CRD_ERASOrtho_Med_Dim AS mf
LEFT JOIN clarity.dbo.CLARITY_MEDICATION  AS cm ON cm.MEDICATION_ID=mf.medication_id
LEFT JOIN clarity.dbo.ZC_THERA_CLASS AS ztc ON ztc.THERA_CLASS_C=cm.THERA_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_CLASS AS zpc ON zpc.PHARM_CLASS_C=cm.PHARM_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_SUBCLASS AS zps ON zps.PHARM_SUBCLASS_C=cm.PHARM_SUBCLASS_C
LEFT JOIN clarity.dbo.RX_MED_ONE AS rmo ON rmo.MEDICATION_ID=cm.MEDICATION_ID
--ORDER BY mf.MedType,MedicationName
--WHERE cm.MEDICATION_ID=150104
ORDER BY MedicationName

SELECT *
FROM radb.dbo.CRD_ERASOrtho_Med_Dim
WHERE medication_id IN (33653,42162,42163,42164)

INSERT radb.dbo.CRD_ERASOrtho_Med_Dim
        ( medication_id ,
          MedType ,
          MedBrandName ,
          MedShortName ,
          EpicMedName ,
          MedOrderSource ,
          AdminTime ,
          InProtocol
        )

SELECT 
cm.MEDICATION_ID AS ERX_ID
,'Multi-Modal Analgesia'
,rmo3.MED_BRAND_NAME
,rmo2.SHORT_NAME
,cm.NAME AS MedicationName
,NULL
,NULL
,null
FROM  clarity.dbo.CLARITY_MEDICATION  AS cm 
LEFT JOIN clarity.dbo.ZC_THERA_CLASS AS ztc ON ztc.THERA_CLASS_C=cm.THERA_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_CLASS AS zpc ON zpc.PHARM_CLASS_C=cm.PHARM_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_SUBCLASS AS zps ON zps.PHARM_SUBCLASS_C=cm.PHARM_SUBCLASS_C
LEFT JOIN clarity.dbo.RX_MED_ONE AS rmo ON rmo.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.RX_MED_TWO AS rmo2 ON rmo2.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.RX_MED_Three AS rmo3 ON rmo3.MEDICATION_ID=cm.MEDICATION_ID
WHERE cm.MEDICATION_ID IN 
(33653,42162,42163,42164)


SELECT * 
FROM radb.dbo.CRD_ERASOrtho_Med_Dim AS mf


SELECT * 
FROM radb.dbo.CRD_ERASOrtho_Med_Dim AS mf
WHERE mf.medication_id IN (101,102,150145 )

SELECT * FROM 
ZC_MAR_RSLT


SELECT 
cm.MEDICATION_ID AS ERX_ID
,cm.NAME AS MedicationName
,cm.GENERIC_NAME
,cm.STRENGTH
,rmo3.MED_BRAND_NAME
,cm.FORM
,cm.route
,ztc.NAME  AS TherapeuticClass
,zpc.name AS PharmClass
,zps.name AS PharmSubClass
--,rmo.*
--,cm.*
FROM  clarity.dbo.CLARITY_MEDICATION  AS cm 
LEFT JOIN clarity.dbo.ZC_THERA_CLASS AS ztc ON ztc.THERA_CLASS_C=cm.THERA_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_CLASS AS zpc ON zpc.PHARM_CLASS_C=cm.PHARM_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_SUBCLASS AS zps ON zps.PHARM_SUBCLASS_C=cm.PHARM_SUBCLASS_C
LEFT JOIN clarity.dbo.RX_MED_ONE AS rmo ON rmo.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.RX_MED_TWO AS rmo2 ON rmo2.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.RX_MED_Three AS rmo3 ON rmo3.MEDICATION_ID=cm.MEDICATION_ID
WHERE cm.MEDICATION_ID IN 
(421040, 400030, 400495, 40820023, 3294, 3295, 3296)



SELECT *
FROM clarity.dbo.RX_MED_THREE AS rmt
WHERE MEDICATION_ID=18308



Furosemide eRx for IVPush/IVPB doses 421040, IVCI 400030, 400495, & 40820023; oral tablets-3294, 3295, 3296
Torsemide oral tablets-402030, 18292, 18294, 18293, 18295
Bumetanide eRx for IVPush/IVPB doses 40810334 (current eRx 9308 & 411301), IVCI 416009, oral tabs 9309, 9310, 9311
Chlorothiazide eRx for IVpush 9526
Metolazone oral tabs-10586, 10587, 10588 
Ethracrynic acid IV 9979; oral tabs 9980




sp_helptext CRD_ERASOrtho_MetricFact


SELECT * 
FROM radb.dbo.CRD_ERASOrtho_Med_Dim AS ceomd
ORDER BY ceomd.MedType,ceomd.MedShortName
--WHERE ceomd.medication_id IN (SELECT medication_id FROM radb.dbo.CRD_ERASOrtho_Med_Dim GROUP BY medication_id HAVING COUNT(*)>1)

--update med table
INSERT 





SELECT * FROM 
[dbo].[CRD_ERASOrtho_Med_Dim]


SELECT * FROM dbo.CLARITY_SER AS cs
WHERE prov_name LIKE '%brennan%'


 SELECT * FROM  radb.dbo.QVI_Hierarchy_Dim AS d    [dbo].[CRD_ERASOrtho_Med_Dim]
   
   WHERE d.QVI_Num IN (17,18,19)    



sp_helptext 'crd_erasortho_encdim_vw'



SELECT COUNT(DISTINCT e.HSP_ACCOUNT_ID) 

SELECT ProcedureType,COUNT(DISTINCT HSP_ACCOUNT_ID)
FROM radb.dbo.CRD_ERASOrtho_EncDim  e
GROUP BY e.ProcedureType
JOIN  RADB.dbo.CRD_ERASOrtho_Cases c ON e.HSP_ACCOUNT_ID=c.HSP_ACCOUNT_ID
WHERE e.ProcedureType='Multiple Arthroplasty Procedures'


SELECT * 
FROM RADB.dbo.CRD_ERASOrtho_Cases
WHERE HSP_ACCOUNT_ID IN (SELECT HSP_ACCOUNT_ID FROM RADB.dbo.CRD_ERASOrtho_Cases GROUP BY HSP_ACCOUNT_ID 




SELECT * 
,outofpacu
,floorhold
,procedurecarecomplete
FROM radb.dbo.ERAS_Ortho      
WHERE DATEDIFF(mi,inpacu,outofpacu)>90
WHERE floorhold IS null

SELECT * FROM ZC_OR_PAT_EVENTS

--sandlot shit

WITH cases AS (
SELECT rid=ROW_NUMBER() OVER(PARTITION BY LOG_ID ORDER BY log_id)
		,* 
FROM radb.dbo.ERAS_Ortho      
)SELECT * FROM cases WHERE rid>1


SELECT ProcedureType ,
       PAT_NAME ,
       PAT_MRN_ID ,
       pat_id ,
       PAT_ENC_CSN_ID ,
       HSP_ACCOUNT_ID ,
       LOSDays ,
       LOSHours ,
       HOSP_ADMSN_TIME ,
       HOSP_DISCH_TIME ,
       DISCH_DISP_C ,
       PATIENT_STATUS_C ,
       DischargeDisposition ,
       DischargeDisposition2 ,
       Enc_Pat_class_C ,
       Enc_Pat_Class ,
       Surgery_pat_class_c ,
       Surgery_Patient_Class ,
       LOG_ID ,
       STATUS_C ,
       LogStatus ,
       CASE_CLASS_C ,
       CASECLASS_DESCR ,
       NUM_OF_PANELS ,
       PROC_DISPLAY_NAME ,
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
       HospitalWide_30DayReadmission_NUM ,
       HospitalWide_30DayReadmission_DEN 
FROM radb.dbo.ERAS_Ortho      
WHERE pat_enc_csn_id IN (SELECT pat_enc_csn_id FROM radb.dbo.ERAS_Ortho    GROUP BY PAT_ENC_CSN_ID HAVING COUNT(*)>1)  

--log stuff only
ProcedureType ,
       PAT_NAME ,
       PAT_MRN_ID ,
       pat_id ,
       PAT_ENC_CSN_ID ,
       HSP_ACCOUNT_ID ,
       LOSDays ,
       LOSHours ,
       HOSP_ADMSN_TIME ,
       HOSP_DISCH_TIME ,
       DISCH_DISP_C ,
       PATIENT_STATUS_C ,
       DischargeDisposition ,
       DischargeDisposition2 ,
       Enc_Pat_class_C ,
       Enc_Pat_Class ,
       Surgery_pat_class_c ,
       Surgery_Patient_Class ,
       LOG_ID ,
       STATUS_C ,
       LogStatus ,
       CASE_CLASS_C ,
       CASECLASS_DESCR ,
       NUM_OF_PANELS ,
       PROC_DISPLAY_NAME ,
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
       HospitalWide_30DayReadmission_NUM ,
       HospitalWide_30DayReadmission_DEN


USE radb

SELECT * from radb.dbo.ERAS_Ortho AS f    


SELECT * FROM vw_ERASOrtho

sp_helptext vw_ERASOrtho

CREATE TABLE dbo.CRD_ERASOrtho_MedDim
(MetricID INT,
 MedType VARCHAR(200),
 MedShortName VARCHAR(200),
 EpicMedName VARCHAR(200),
 MedOrderSource VARCHAR(200),
 AdminTime VARCHAR(200),
 InProtocol VARCHAR(25)
 )

 SELECT * FROM radb.dbo.YNHHS_ERASOrtho_Med_Dim

TRUNCATE TABLE  radb.dbo.YNHHS_ERASOrtho_Med_Dim

INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (24500,'Multi-Modal Analgesia','Celecoxib ','Celecoxib ','Order set','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (24501,'Multi-Modal Analgesia','Celecoxib ','Celecoxib ','Order set','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (150333,'Multi-Modal Analgesia','Gabapentin','Gabapentin','Order set','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (18309,'Multi-Modal Analgesia','Gabapentin','Gabapentin','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (18308,'Multi-Modal Analgesia','Gabapentin','Gabapentin','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (18307,'Multi-Modal Analgesia','Gabapentin','Gabapentin','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (25855,'Multi-Modal Analgesia','Gabapentin','Gabapentin','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (25856,'Multi-Modal Analgesia','Gabapentin','Gabapentin','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (161735,'Multi-Modal Analgesia','Acetaminophen  injection','Acetaminophen  injection','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (400498,'Multi-Modal Analgesia','Acetaminophen  injection','Acetaminophen  injection','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (400497,'Multi-Modal Analgesia','Acetaminophen  injection','Acetaminophen  injection','Orderable','Pre-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (9316,'Spinal Anesthesia','Bupivacaine 0.75%  in 8.25% Dextrose','Bupivacaine 0.75%  in 8.25% Dextrose','Order set','Intra-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (1224,'Spinal Anesthesia','Bupivacaine 0.75%  injection','Bupivacaine 0.75%  injection','Order set','Intra-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (77009,'Spinal Anesthesia','Morphine (PF) - Duramorph 10mg/ml (PF) injection','Morphine (PF) - Duramorph 10mg/ml (PF) injection','Order set','Intra-Op','n')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (14984,'Intra-Articular Injections','Bupivacaine 0.5% + Epinephrine  = 45','Bupivacaine 0.5% + Epinephrine  = 45','Order set','Intra-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (15852,'Intra-Articular Injections','Morphine sulfate, 1mg/ml   =  10ml','Morphine sulfate, 1mg/ml   =  10ml','Order set','Intra-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (22473,'Intra-Articular Injections','Ketorolac  30mg/ml               =  1 ml','Ketorolac  30mg/ml               =  1 ml','Order set','Intra-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (166538,'Intra-Articular Injections','Bupivacaine, Liposomal (Exparel) 266mg/20ml ','Bupivacaine, Liposomal (Exparel) 266mg/20ml ','Order set','Intra-Op','n')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (3037,'Analgesia','Fentanyl ','Fentanyl ','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (150104,'Analgesia','Hydromorphone ','Hydromorphone ','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (3758,'Analgesia','Hydromorphone ','Hydromorphone ','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (108299,'Analgesia','Hydromorphone ','Hydromorphone ','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (3759,'Analgesia','Hydromorphone ','Hydromorphone ','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (1066764,'Analgesia','Hydromorphone ','Hydromorphone ','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (10224,'Analgesia','Hydromorphone ','Hydromorphone ','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (149951,'Analgesia','Morphine IV ','Morphine IV Orderable','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (420924,'PCA','Morphine PCA','Morphine PCA 50/mg/50ml','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (420925,'PCA','Morphine PCA','Morphine PCA 250/mg/50ml','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (420926,'PCA','Hydromorphone PCA','Hydromorphone PCA 10mg/50ml ','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (420927,'PCA','Hydromorphone PCA','Hydromorphone PCA 50mg/50ml ','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (40810076,'PCA','Hydromorphone 10 mcg/ml + Bupivacaine 0.031%                           ','Hydromorphone 10 mcg/ml + Bupivacaine 0.031%                           ','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (27697,'Antiemetics','Ondansetron','Ondansetron 4mg ODT','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (94096,'Antiemetics','Ondansetron','Ondansetron 4mg injectionODT','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (27698,'Antiemetics','Ondansetron','Ondansetron 8mg ODT','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (18877,'Antiemetics','Ondansetron','Ondansetron 4mg/5ml slution','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (5006,'Antiemetics','Metoclopramide','Metoclopramide 5 mg tablet','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (5002,'Antiemetics','Metoclopramide','Metoclopramide 5 mg/ml injection','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (5005,'Antiemetics','Metoclopramide','Metoclopramide 10 mg tablet','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (77725,'Antiemetics','Metoclopramide','Metoclopramide 5 mg/ml oral solution','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (6583,'Antiemetics','Prochlorperazine','Prochlorperazine 5mg tablet','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (165974,'Antiemetics','Prochlorperazine','Prochlorperazine 5 mg/ml injection','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (6582,'Antiemetics','Prochlorperazine','Prochlorperazine 10 mg tablet','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (11138,'Antiemetics','Prochlorperazine','Prochlorperazine 25 mg suppository','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (156672,'Antiemetics','Dexamethasone','Dexamethasone IV push orderable','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (114322,'Antiemetics','Dexamethasone','Dexamethasone 10mg/ml injection','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (2331,'Antiemetics','Dexamethasone','Dexamethasone 10mg/ml (PF) injection','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (2332,'Antiemetics','Dexamethasone','Dexamethasone 4mg/ml injection ','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (2483,'Antiemetics','Dimenhydrinate','Dimenhydrinate 50mg/ml injection ','Order set','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (401723,'Antiemetics','Dimenhydrinate','Dimenhydrinate 25mg half-tab','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (2485,'Antiemetics','Dimenhydrinate','Dimenhydrinate 50mg tablet','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (2508,'Antiemetics','Diphenhydramine','Diphenhydramine','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (2509,'Antiemetics','Diphenhydramine','Diphenhydramine','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (2510,'Antiemetics','Diphenhydramine','Diphenhydramine','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (12556,'Antiemetics','Diphenhydramine','Diphenhydramine','Orderable','Post-Op','y')
INSERT INTO radb.dbo.YNHHS_ERASOrtho_Med_Dim VALUES (27696,'Antiemetics','Scopolamine patch','Scopolamine patch','Order set','Post-Op','y')

SELECT * FROM dbo.vw_ERASOrtho_Medication
ORDER BY medtype,epicmedname

alter VIEW dbo.vw_ERASOrtho_Medication
as
SELECT  a.medication_id AS ERX
,       a.MedType
,       a.MedShortName AS [Med Short Name]
,       cm.name  AS [Epic Med Name]
,       a.MedOrderSource AS [Med Order Source]
,       a.AdminTime
,       a.InProtocol	  
FROM radb.dbo.CRD_ERASOrtho_Med_Dim a
LEFT JOIN clarity.dbo.CLARITY_MEDICATION AS cm
ON a.medication_id=cm.MEDICATION_ID


sp_rename 'YNHHS_ERASOrtho_Med_Dim','CRD_ERASOrtho_Med_Dim'

SELECT *
FROM radb.dbo.CRD_ERASOrtho_Med_Dim
ORDER BY a.MedType,a.EpicMedName
WHERE medication_id=1066764


update radb.dbo.YNHHS_ERASOrtho_Med_Dim 
SET medication_id=106676
WHERE medication_id=1066764



SELECT * FROM radb.dbo.vw_erasortho_medication
--ORDER BY MedType,[epic med name]
WHERE erx IS null

SELECT * FROM clarity.dbo.CLARITY_MEDICATION AS cm
WHERE name LIKE '%Hydromorphone%'
AND STRENGTH LIKE '%4%'
WHERE MEDICATION_ID=1066764


WITH chk AS 
(
SELECT  rid=row_number () OVER(partition BY csn ORDER BY csn)
,*
FROM dbo.CRD_ERASOrtho_EncDim_vw
)
SELECT * FROM chk WHERE rid>1

ALTER VIEW dbo.CRD_ERASOrtho_EncDim_vw
AS    
SELECT  f.PAT_MRN_ID AS MRN    
,  f.HSP_ACCOUNT_ID AS HAR    
,  f.PAT_ENC_CSN_ID AS CSN    
,       f.LOSDays    
,       f.LOSHours    
,		[Discharge Disposition]=CASE 
			WHEN  f.patient_status_c IN ('01','06') THEN 'Discharge to Home'
			WHEN  f.patient_status_c IN ('02','03','62','63','64','90') THEN 'Discharge to Facility'
			ELSE ISNULL(f.DischargeDisposition2,'*Unknown') END
			
,       f.DischargeDisposition2 AS [Patient Status]    
,  f.HospitalWide_30DayReadmission_DEN    
,  f.HospitalWide_30DayReadmission_NUM    
,  CONVERT(DATE,f.HOSP_ADMSN_TIME)  AS Admission_Date    
,  f.HOSP_ADMSN_TIME AS Admission_DTTM    
,  CONVERT(DATE,f.HOSP_DISCH_TIME) AS Discharge_Date    
,  f.HOSP_DISCH_TIME AS Discharge_DTTM    
,  DateKey
,  qvi_Infection=CASE WHEN qvi_inf.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END         
,  qvi_AdverseEffects=CASE WHEN qvi_adv.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_FallsTrauma=CASE WHEN qvi_falls.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_ForeignObjectRetained=CASE WHEN qvi_forobject.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_PerforationLaceration=CASE WHEN qvi_perf.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_DVTPTE=CASE WHEN qvi_DVTPTE.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Pneumonia=CASE WHEN qvi_pne.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Shock=CASE WHEN qvi_shock.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
,  qvi_Any=CASE WHEN qvi_any.HSP_ACCOUNT_ID IS NOT NULL THEN 1 ELSE 0 END        
    
FROM     RADB.dbo.CRD_ERASOrtho_EncDim AS f

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
          
      
      

















SELECT * 
FROM clarity.dbo.CLARITY_MEDICATION AS cm
WHERE MEDICATION_ID IN (14984,15852,22473)

SELECT 
cm.MEDICATION_ID AS ERX_ID
,cm.NAME AS MedicationName
,cm.GENERIC_NAME
,cm.STRENGTH
,cm.FORM
,cm.route
,ztc.NAME  AS TherapeuticClass
,zpc.name AS PharmClass
,zps.name AS PharmSubClass
--,cm.*
FROM clarity.dbo.CLARITY_MEDICATION  AS cm
LEFT JOIN clarity.dbo.ZC_THERA_CLASS AS ztc ON ztc.THERA_CLASS_C=cm.THERA_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_CLASS AS zpc ON zpc.PHARM_CLASS_C=cm.PHARM_CLASS_C
LEFT JOIN clarity.dbo.ZC_PHARM_SUBCLASS AS zps ON zps.PHARM_SUBCLASS_C=cm.PHARM_SUBCLASS_C
WHERE cm.MEDICATION_ID IN 
(
9316,1224,166538
)

SELECT *
FROM dbo.CLARITY_EAP AS ce
WHERE PROC_CODE IN 
('27447',
'27486',
'27487',
'27125',
'27130',
'27132',
'27134',
'27137',
'27138')



sp_helptext vw_ERASOrtho

SELECT * FROM dbo.CLARITY_MEDICATION AS cm
WHERE MEDICATION_ID=149951


SELECT * FROM ZC_OR_PAT_EVENTS
WHERE title LIKE '%pacu%'
--WHERE title LIKE '%recovery%'
ORDER BY name

SELECT * 
FROM radb.dbo.QVI_Hierarchy_Dim AS qhd
WHERE QVI_Name LIKE '%post%'

USE RADB


SELECT * from radb.dbo.Dataview_Fact_QVI_Hier1_DDB 
WHERE 

SELECT DISTINCT QVI_Num,QVI_Hierarchy_Level_1 
FROM radb.dbo.Dataview_Fact_QVI_Hier1_DDB 
ORDER BY 1

SELECT DISTINCT  QVI_Name
FROM radb.dbo.Dataview_Fact_QVI_Hier1_DDB 
ORDER BY 1


SELECT * FROM clarity.dbo.ZC_DISCH_DISP AS zdd


SELECT  
FROM clarity.dbo.PAT_ENC_HSP AS peh

WHERE


sp_helptext vw_ERASOrtho

select * from radb.dbo.vw_ERASOrtho
SELECT * FROM radb.dbo.ERAS_Ortho AS eo

CREATE VIEW dbo.vw_ERASOrtho
AS
  SELECT * FROM dbo.vw_ERASOrtho AS veo
  
CREATE VIEW dbo.vw_ERASOrtho    
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
,       f.DischargeDisposition2 AS [Discharge Disposition Long]    
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
          



      
            
      

SELECT COUNT(*),COUNT(DISTINCT log_id),COUNT(DISTINCT pat_enc_csn_id),COUNT(DISTINCT hsp_account_id) ,SUM(HospitalWide_30DayReadmission_DEN),SUM(HospitalWide_30DayReadmission_NUM)
FROM radb.dbo.ERAS_Ortho


SELECT *
FROM radb.dbo.ERAS_CaseFact AS ecf



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
AND clarity.dbo.OR_PROC_CPT_ID.REAL_CPT_CODE  IN       ('27447', '27130')  
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
       HospitalWide_30DayReadmission_DEN 
       
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

  
