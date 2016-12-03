SELECT * FROM radb.dbo.ERAS_Ortho AS eo 
WHERE eo.admissioncsn=115721164
WHERE eo.SURGERY_DATE>'7/5/2015'

SELECT * FROM radb.dbo.YNHH_HVCBedflow_Procedures

SELECT * 
FROM dbo.HSP_ACCOUNT hsp
LEFT JOIN dbo.PAT_ENC pe ON hsp.PRIM_ENC_CSN_ID=pe.PAT_ENC_CSN_ID
WHERE hsp.HSP_ACCOUNT_ID=300492298

SELECT lnk.PAT_ENC_CSN_ID AS surgicalcsn,fan.AN_52_ENC_CSN_ID AS anescsn
,lnk.OR_LINK_CSN AS admissioncsn,fan.AN_53_ENC_CSN_ID AS aneseventcsn
FROM dbo.OR_LOG AS orl
LEFT JOIN  PAT_OR_ADM_LINK AS lnk ON orl.LOG_ID=lnk.LOG_ID
FULL OUTER JOIN clarity.dbo.F_AN_RECORD_SUMMARY  AS fan
ON orl.LOG_ID=fan.AN_LOG_ID
WHERE orl.LOG_ID=422502

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name IN ('pat_enc','pat_enc_hsp','hsp_account')
AND COLUMN_NAME LIKE '%csn%'


SELECT * FROM radb.dbo.vw_PatEnc
WHERE PAT_ENC_CSN_ID=110114051


SELECT  
--CASE WHEN mai.TAKEN_TIME>=pod0_start AND mai.TAKEN_TIME<pod1_start THEN 1 ELSE 0 END AS givenpod0
--,	CASE WHEN mai.TAKEN_TIME>=pod1_start AND mai.TAKEN_TIME<pod2_start THEN 1 ELSE 0 END AS givenpod1
--,	CASE WHEN mai.TAKEN_TIME>=pod2_start AND mai.TAKEN_TIME<pod3_start THEN 1 ELSE 0 END AS givenpod2
--,	CASE WHEN mai.TAKEN_TIME>=inpreprocedure AND mai.TAKEN_TIME<=outofpreprocedure THEN 1 ELSE 0 END AS givenpreproc
--,	CASE WHEN mai.TAKEN_TIME>=hosP_admsn_time AND mai.TAKEN_TIME<sched_start_time THEN 1 ELSE 0 END AS presurg
--,	CASE WHEN mai.taken_time >pod2_start THEN 1 ELSE 0 END AS pod2on
		mai.TAKEN_TIME
		,mai.mar_action_c
		,zcact.NAME AS MarAction
		,cm.MEDICATION_ID 
		,cm.NAME AS MedicationName
		,md.*
--  		,eb.*	
		--,om.*
--INTO  ##met4
from clarity.dbo.MAR_ADMIN_INFO AS mai
--JOIN radb.dbo.ERAS_Ortho AS eo ON eo.surgicalcsn=mai.MAR_ENC_CSN
JOIN clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN radb.dbo.YNHHS_ERASOrtho_Med_Dim AS md ON md.medication_id=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
ON zcact.result_c=mai.mar_action_c
WHERE mai.MAR_ACTION_C=1
--AND mai.TAKEN_TIME>='2015-08-11 06:33:00.000' AND mai.TAKEN_TIME<'2015-08-11 06:58:00.000'
AND 
--mai.MAR_ENC_CSN=118373769 --anesthesia
 --mai.MAR_ENC_CSN=115720854 --surgical
--mai.MAR_ENC_CSN=115721164 --admission
-- mai.MAR_ENC_CSN=118373768 --anes event
2015-08-11 06:33:00.000	2015-08-11 06:58:00.000
surgicalcsn	anescsn	admissioncsn	aneseventcsn
115720854	118373769	115721164	118373768


--and om.MEDICATION_ID IN (SELECT MEDICATION_ID FROM radb.dbo.YNHHS_ERASOrtho_Med_Dim WHERE MedType='Antiemetics')
--AND mai.MAR_ENC_CSN=116219380 --anesthesia
--AND mai.MAR_ENC_CSN=116208422 --surgical
AND mai.MAR_ENC_CSN=110114051 --admission

SELECT * FROM radb.dbo.YNHHS_ERASOrtho_Med_Dim AS yeomd
SELECT * FROM radb.dbo.ERAS_Ortho AS eo

110114051	108667275	108667143

anescsn	admissioncsn	surgicalcsn
116219380	116192550	116208422
109601357	107739475	107738013
105323454	104184784	104184146
112816800	112814915	112816006
116638834	116350694	116349604
115379568	115027025	115026569
114182954	113376761	113376236
106339301	104959044	104958658
110147931	108665403	108665223
106675295	105071511	105070177








SELECT * FROM dbo.V_LOG_TIMING_EVENTS AS vlte
WHERE LOG_ID='362715'

SELECT * FROM radb.dbo.ERAS_Ortho AS eo
WHERE log_id='280054'

SELECT  ProcedureType
,       PAT_NAME
,       PAT_MRN_ID
,       pat_id
,       PAT_ENC_CSN_ID
,       HSP_ACCOUNT_ID
,       LOSDays
,       LOSHours
,       HOSP_ADMSN_TIME
,       HOSP_DISCH_TIME
,       DISCH_DISP_C
,       PATIENT_STATUS_C
,       DischargeDisposition
,       DischargeDisposition2
,       Enc_Pat_class_C
,       Enc_Pat_Class
,       Surgery_pat_class_c
,       Surgery_Patient_Class
,       LOG_ID
,       STATUS_C
,       LogStatus
,       CASE_CLASS_C
,       CASECLASS_DESCR
,       NUM_OF_PANELS
,       PROC_DISPLAY_NAME
,       REAL_CPT_CODE
,       anescsn
,       admissioncsn
,       surgicalcsn
,       procedurename
,       Surgery_Room_Name
,       SurgeonName
,       ROLE_C
,       PANEL
,       ALL_PROCS_PANEL
,       procline
,       SurgeryServiceName
,       SURGERY_DATE
,       SCHED_START_TIME
,       SurgeryLocation
,       setupstart
,       setupend
,       inroom
,       outofroom
,       cleanupstart
,       cleanupend
,       inpacu
,       outofpacu
,       inpreprocedure
,       outofpreprocedure
,       anesstart
,       anesfinish
,       procedurestart
,       procedurefinish
,       HospitalWide_30DayReadmission_NUM
,       HospitalWide_30DayReadmission_DEN 
FROM radb.dbo.ERAS_Ortho 




SELECT  
--CASE WHEN mai.TAKEN_TIME>=pod0_start AND mai.TAKEN_TIME<pod1_start THEN 1 ELSE 0 END AS givenpod0
--,	CASE WHEN mai.TAKEN_TIME>=pod1_start AND mai.TAKEN_TIME<pod2_start THEN 1 ELSE 0 END AS givenpod1
--,	CASE WHEN mai.TAKEN_TIME>=pod2_start AND mai.TAKEN_TIME<pod3_start THEN 1 ELSE 0 END AS givenpod2
--,	CASE WHEN mai.TAKEN_TIME>=inpreprocedure AND mai.TAKEN_TIME<=outofpreprocedure THEN 1 ELSE 0 END AS givenpreproc
--,	CASE WHEN mai.TAKEN_TIME>=hosP_admsn_time AND mai.TAKEN_TIME<sched_start_time THEN 1 ELSE 0 END AS presurg
--,	CASE WHEN mai.taken_time >pod2_start THEN 1 ELSE 0 END AS pod2on
		mai.TAKEN_TIME
		,mai.mar_action_c
		,zcact.NAME AS MarAction
		,cm.MEDICATION_ID 
		,cm.NAME AS MedicationName
		,md.*
--  		,eb.*	
		--,om.*
--INTO  ##met4
from clarity.dbo.MAR_ADMIN_INFO AS mai
JOIN radb.dbo.ERAS_Ortho AS eo ON eo.surgicalcsn=mai.MAR_ENC_CSN
JOIN clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN radb.dbo.YNHHS_ERASOrtho_Med_Dim AS md ON md.medication_id=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
ON zcact.result_c=mai.mar_action_c
WHERE mai.MAR_ACTION_C=1
--and om.MEDICATION_ID IN (SELECT MEDICATION_ID FROM radb.dbo.YNHHS_ERASOrtho_Med_Dim WHERE MedType='Antiemetics')
--AND mai.MAR_ENC_CSN=116219380 --anesthesia
--AND mai.MAR_ENC_CSN=116208422 --surgical
AND mai.MAR_ENC_CSN=110114051 --admission

SELECT * FROM radb.dbo.YNHHS_ERASOrtho_Med_Dim AS yeomd
SELECT * FROM radb.dbo.ERAS_Ortho AS eo

110114051	108667275	108667143

anescsn	admissioncsn	surgicalcsn
116219380	116192550	116208422
109601357	107739475	107738013
105323454	104184784	104184146
112816800	112814915	112816006
116638834	116350694	116349604
115379568	115027025	115026569
114182954	113376761	113376236
106339301	104959044	104958658
110147931	108665403	108665223
106675295	105071511	105070177