SELECT MIN(surgery_date),MAX(surgery_date)
FROM RADB.dbo.CRD_ERAS_YNHGI_Case 



SELECT * FROM dbo.CRD_ERAS_YNHGI_Case AS ceyc
WHERE PAT_NAME LIKE '%ains%'
PAT_MRN_ID='MR1817016 '

SELECT * FROM dbo.CRD_ERAS_YNHGI_Medlist AS c

eym



SELECT *
FROM radb.dbo.CRD_ERAS_YNHGI_MarAction

INSERT radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES(8,'Stopped','Stopped')


IF object_id('tempdb..##given') is not null
	drop table ##given; 

SELECT  mai.MAR_ENC_CSN AS pat_enc_csn_id
		,eo.LOG_ID
		,cm.MEDICATION_ID 
		,meddim.MetricNumber
		,meddim.MetricDescription
		,meddim.MedType
		,cm.NAME AS MedicationName
		,cm.FORM AS MedicationForm
		,om.ORDER_MED_ID
		,om.DISPLAY_NAME 
		,mai.line
		,rmt.MED_BRAND_NAME
		,empadmin.USER_ID AdminId
		,empadmin.NAME AS AdministeredBy
		,admindep.DEPARTMENT_NAME AS AdministeredDept
	--	,meddim.MedType
		,mai.TAKEN_TIME
		,zcact.NAME AS MarAction
		,maract.MarReportAction
		,mai.mar_action_c
		,mai.SIG AS GivenDose
		,zmu.NAME AS DoseUnit	
		,mai.ROUTE_C					
		,zar.Name AS Route		
		,meddim.PharmClass
		,CASE WHEN meddim.PharmClass='ANALGESICS, NARCOTICS' THEN
			CASE WHEN mai.route_c IN (15) THEN 'Oral'
				 WHEN mai.route_c IN (155,6,11) THEN 'Parental'
				 ELSE '*Unknown route type'
			END
		END AS Pain_Route
		,mai.DOSE_UNIT_C		
		,preop=0
		,intraop=0
		,pacu=0
		,postop0=0
		,admit_discharge =CAST(NULL AS INT)
		,pacu_disch=CAST(NULL AS INT)  
		,postopday1=CAST(NULL AS INT)
		,postopday1_noon=CAST(NULL AS int)
		,postopday2=CAST(NULL AS INT)
		,postopday3=CAST(NULL AS INT)
		,postop_disch=0
		,admissioncsn_flag=1
		,anescsn_flag=0
		,preproc_inroom=0
		,preproc_outroom=0
		
				

INTO ##given
from clarity.dbo.MAR_ADMIN_INFO AS mai
JOIN  RADB.dbo.CRD_ERAS_YNHGI_Case  AS eo
ON eo.admissioncsn=mai.MAR_ENC_CSN
LEFT JOIN radb.dbo.CRD_ERAS_YNHGI_MarAction AS maract ON maract.RESULT_C=mai.MAR_ACTION_C
LEFT JOIN clarity.dbo.clarity_emp AS empadmin ON empadmin.USER_ID=mai.USER_ID
LEFT join clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.ZC_MED_UNIT AS zmu
ON zmu.DISP_QTYUNIT_C=mai.DOSE_UNIT_C
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN clarity.dbo.clarity_dep AS admindep ON admindep.DEPARTMENT_ID=mai.MAR_ADMIN_DEPT_ID
LEFT JOIN CLARITY.dbo.RX_MED_THREE AS rmt ON rmt.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN radb.dbo.CRD_ERAS_YNHGI_MedList AS meddim ON meddim.erx=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
ON zcact.result_c=mai.mar_action_c
LEFT JOIN clarity.dbo.PATIENT AS p
ON om.PAT_ID=p.PAT_ID
LEFT JOIN clarity.dbo.ZC_ADMIN_ROUTE AS zar ON mai.ROUTE_C=zar.MED_ROUTE_C


UNION ALL


SELECT  mai.MAR_ENC_CSN AS pat_enc_csn_id
		,eo.LOG_ID
		,cm.MEDICATION_ID 
		,meddim.MetricNumber
		,meddim.MetricDescription
		,meddim.MedType
		,cm.NAME AS MedicationName
		,cm.FORM AS MedicationForm
		,om.ORDER_MED_ID
		,om.DISPLAY_NAME
		,mai.line
		,rmt.MED_BRAND_NAME
		,empadmin.USER_ID AdminId
		,empadmin.NAME AS AdministeredBy
		,admindep.DEPARTMENT_NAME AS AdministeredDept
	--	,meddim.MedType
		,mai.TAKEN_TIME
		,zcact.NAME AS MarAction
		,maract.MarReportAction
		,mai.mar_action_c
		,mai.SIG AS GivenDose
		,zmu.NAME AS DoseUnit						
		,mai.ROUTE_C
		,zar.Name AS Route		
		,meddim.PharmClass
		,CASE WHEN meddim.PharmClass='ANALGESICS, NARCOTICS' THEN
			CASE WHEN mai.route_c IN (15) THEN 'Oral'
				 WHEN mai.route_c IN (155,6,11) THEN 'Parental'
				 ELSE '*Unknown route type'
			END
		END AS Pain_Route
		,mai.DOSE_UNIT_C		
		,preop=0
		,intraop=0
		,pacu=0
		,postop0=0		
		,admit_discharge =CAST(NULL AS INT)
		,pacu_disch=CAST(NULL AS INT)  
		,postopday1=CAST(NULL AS INT)
		,postopday1_noon=CAST(NULL AS int)
		,postopday2=CAST(NULL AS INT)
		,postopday3=CAST(NULL AS INT)
		,postop_disch=0
		,admissioncsn_flag=0
		,anescsn_flag=1			
		,preproc_inroom=0
		,preproc_outroom=0

from clarity.dbo.MAR_ADMIN_INFO AS mai
JOIN  RADB.dbo.CRD_ERAS_YNHGI_Case   AS eo
ON eo.anescsn=mai.MAR_ENC_CSN
LEFT JOIN radb.dbo.CRD_ERAS_YNHGI_MarAction AS maract ON maract.RESULT_C=mai.MAR_ACTION_C
LEFT JOIN clarity.dbo.clarity_emp AS empadmin ON empadmin.USER_ID=mai.USER_ID
LEFT join clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.ZC_MED_UNIT AS zmu
ON zmu.DISP_QTYUNIT_C=mai.DOSE_UNIT_C
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN clarity.dbo.clarity_dep AS admindep ON admindep.DEPARTMENT_ID=mai.MAR_ADMIN_DEPT_ID
LEFT JOIN CLARITY.dbo.RX_MED_THREE AS rmt ON rmt.MEDICATION_ID=cm.MEDICATION_ID
LEFT JOIN radb.dbo.CRD_ERAS_YNHGI_MedList AS meddim ON meddim.erx=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
ON zcact.result_c=mai.mar_action_c
LEFT JOIN clarity.dbo.PATIENT AS p
ON om.PAT_ID=p.PAT_ID
LEFT JOIN clarity.dbo.ZC_ADMIN_ROUTE AS zar ON mai.ROUTE_C=zar.MED_ROUTE_C;







--IV fluids stopped POD0 
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET iv_fluid_dc_pod0=1

SELECT *
--FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
FROM ##given AS med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
								WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
								WHEN med.anescsn_flag=1 THEN c.anescsn
									END
--WHERE MedType='IV Fluids' 
--AND PAT_MRN_ID='MR1817016'
WHERE PAT_MRN_ID='MR1817016'
AND DISPLAY_NAME LIKE '%NS%'

WHERE med.postop0=1 AND MedType='IV Fluids' AND med.MarReportAction='Stopped';




--lda view

IF object_id('tempdb..##lda') is not null
	drop table #lda; 

WITH baseq AS (
SELECT  
'AdmissionCSN' AS EncounterType
,f.LOG_ID
,f.PAT_NAME
,f.PAT_MRN_ID
,f.anescsn
,f.admissioncsn
,f.surgicalcsn
,f.HOSP_ADMSN_TIME
,f.HOSP_DISCH_TIME
,f.surgery_date
,       iln.PLACEMENT_INSTANT
,       iln.REMOVAL_INSTANT
,		CASE WHEN (PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=outofroom )
				  AND (REMOVAL_INSTANT>=f.procedurefinish AND REMOVAL_INSTANT<f.postopday2_begin ) THEN 1 ELSE 0 end	AS removalflag
,		CASE WHEN iln.PLACEMENT_INSTANT<f.HOSP_ADMSN_TIME THEN '*Before Admission'
			 WHEN iln.PLACEMENT_INSTANT>=f.HOSP_ADMSN_TIME AND iln.PLACEMENT_INSTANT<f.inroom THEN '*Before In room'
			 WHEN iln.PLACEMENT_INSTANT>=f.inroom AND iln.PLACEMENT_INSTANT<=f.outofroom THEN '*In room'
			 WHEN iln.PLACEMENT_INSTANT>f.outofroom THEN '*After Outofroom' END AS PlacementWindow

,		CASE WHEN iln.REMOVAL_INSTANT<f.HOSP_ADMSN_TIME THEN '*Before Admission'
			 WHEN iln.REMOVAL_INSTANT>=f.HOSP_ADMSN_TIME AND iln.REMOVAL_INSTANT<f.inroom THEN '*Before In room'
			 WHEN iln.REMOVAL_INSTANT>=f.inroom AND iln.REMOVAL_INSTANT<=f.outofroom THEN '*In room'
			 WHEN iln.REMOVAL_INSTANT>f.outofroom THEN '*After Outofroom' END AS RemovalWindow
,f.inroom
,f.outofroom
,f.postopday1_begin
,f.postopday2_begin
,f.postopday3_begin
,f.postopday4_begin
,       iln.PAT_ENC_CSN_ID
,       iln.IP_LDA_ID
,       iln.DESCRIPTION
,       iln.PROPERTIES_DISPLAY
,		iln.FSD_ID
,		ifgd.DUPLICATEABLE_YN
,		ifgd.FLO_MEAS_NAME
,		ifgd.DISP_NAME
,		rowtype=zrt.name
FROM    (SELECT rid=ROW_NUMBER() OVER(PARTITION BY admissioncsn ORDER BY admissioncsn)
		,*
		 FROM RADB.dbo.CRD_ERAS_YNHGI_Case 		
		) AS f
		JOIN clarity.dbo.IP_DATA_STORE AS ids
		ON ids.EPT_CSN=f.admissioncsn
		JOIN clarity.dbo.IP_LDA_INPS_USED AS iliu
		ON ids.INPATIENT_DATA_ID=iliu.INP_ID
		JOIN clarity.dbo.IP_LDA_NOADDSINGLE AS iln 
				ON iln.IP_LDA_ID=iliu.IP_LDA_ID				        
		LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd
		ON iln.FLO_MEAS_ID=ifgd.FLO_MEAS_ID				
		LEFT JOIN clarity.dbo.ZC_ROW_TYP AS zrt
		ON ifgd.ROW_TYP_C=zrt.ROW_TYP_C       
--WHERE   iln.FLO_MEAS_ID IN ( '3048148000', '8148', '8151' )
--AND f.rid=1
UNION ALL
SELECT  
'AnesCSN' AS EncounterType
,f.LOG_ID
,f.PAT_NAME
,f.PAT_MRN_ID
,f.anescsn
,f.admissioncsn
,f.surgicalcsn
,f.HOSP_ADMSN_TIME
,f.HOSP_DISCH_TIME
,f.surgery_date
,       iln.PLACEMENT_INSTANT
,       iln.REMOVAL_INSTANT
,		CASE WHEN (PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=outofroom )
				  AND (REMOVAL_INSTANT>=f.procedurefinish AND REMOVAL_INSTANT<f.postopday2_begin ) THEN 1 ELSE 0 end	AS removalflag
,		CASE WHEN iln.PLACEMENT_INSTANT<f.HOSP_ADMSN_TIME THEN '*Before Admission'
			 WHEN iln.PLACEMENT_INSTANT>=f.HOSP_ADMSN_TIME AND iln.PLACEMENT_INSTANT<f.inroom THEN '*Before In room'
			 WHEN iln.PLACEMENT_INSTANT>=f.inroom AND iln.PLACEMENT_INSTANT<=f.outofroom THEN '*In room'
			 WHEN iln.PLACEMENT_INSTANT>f.outofroom THEN '*After Outofroom' END AS PlacementWindow
,		CASE WHEN iln.REMOVAL_INSTANT<f.HOSP_ADMSN_TIME THEN '*Before Admission'
			 WHEN iln.REMOVAL_INSTANT>=f.HOSP_ADMSN_TIME AND iln.REMOVAL_INSTANT<f.inroom THEN '*Before In room'
			 WHEN iln.REMOVAL_INSTANT>=f.inroom AND iln.REMOVAL_INSTANT<=f.outofroom THEN '*In room'
			 WHEN iln.REMOVAL_INSTANT>f.outofroom THEN '*After Outofroom' END AS RemovalWindow


,f.inroom
,f.outofroom
,f.postopday1_begin
,f.postopday2_begin
,f.postopday3_begin
,f.postopday4_begin
,       iln.PAT_ENC_CSN_ID
,       iln.IP_LDA_ID
,       iln.DESCRIPTION
,       iln.PROPERTIES_DISPLAY
,		iln.FSD_ID
,		ifgd.DUPLICATEABLE_YN
,		ifgd.FLO_MEAS_NAME
,		ifgd.DISP_NAME
,		rowtype=zrt.name
FROM    (SELECT rid=ROW_NUMBER() OVER(PARTITION BY anescsn ORDER BY anescsn)
		,*
		 FROM RADB.dbo.CRD_ERAS_YNHGI_Case 		
		) AS f
		JOIN clarity.dbo.IP_DATA_STORE AS ids
		ON ids.EPT_CSN=f.anescsn
		JOIN clarity.dbo.IP_LDA_INPS_USED AS iliu
		ON ids.INPATIENT_DATA_ID=iliu.INP_ID
		JOIN clarity.dbo.IP_LDA_NOADDSINGLE AS iln 
				ON iln.IP_LDA_ID=iliu.IP_LDA_ID				        
		LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd
		ON iln.FLO_MEAS_ID=ifgd.FLO_MEAS_ID				
		LEFT JOIN clarity.dbo.ZC_ROW_TYP AS zrt
		ON ifgd.ROW_TYP_C=zrt.ROW_TYP_C              
--WHERE   iln.FLO_MEAS_ID IN ( '3048148000', '8148', '8151' )
--AND f.rid=1
)SELECT * 
INTO ##lda
FROM baseq;

SELECT *
FROM ##lda
WHERE PAT_MRN_ID='MR1817016'

