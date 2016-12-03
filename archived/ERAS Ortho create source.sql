--ortho objects
CRD_ERASOrtho_MetricDim
CRD_ERASOrtho_MetDate
CRD_ERASOrtho_MetricFact
CRD_ERASOrtho_Cases
CRD_ERASOrtho_EncDim_vw

sp_helptext CRD_ERASOrtho_MetricFact


SELECT * FROM CRD_ERASOrtho_MetricDim

EXEC [dbo].[CRD_ERASOrtho_DateDim]


SELECT * FROM dbo.CRD_ERASOrtho_EncDim_vw AS ceoedv

ALTER TABLE 

SELECT postop_painmanage_parent FROM radb.dbo.CRD_ERASOrtho_Cases

SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE c.TABLE_NAME='CRD_ERASOrtho_Cases'
AND c.COLUMN_NAME LIKE '%Parent%'

SELECT * 
FROM radb.dbo.CRD_ERASOrtho_Med_Dim
ORDER BY medtype,MedShortName


SELECT * FROM dbo.CLARITY_MEDICATION AS cm WHERE cm.MEDICATION_ID IN (24500,24501)


WHERE  MedType='Parenteral'
WHERE medication_id IN (149951,150104,3037)
ORDER BY medtype



SELECT COUNT(*) 
SELECT *
FROM  radb.dbo.CRD_ERASOrtho_Cases
WHERE erascase='eras case'


SELECT * FROM radb.dbo.ERAS_CaseFact AS ecf
SELECT COUNT(*) FROM radb.dbo.ERAS_CaseFact AS ecf
--WHERE erascase='eras case'
WHERE case_class_c IS NOT NULL and erascase='eras case'
ORDER BY hosp_disch_time


SELECT * 
FROM  clarity.dbo.zc_mar_rslt AS zcact
WHERE title LIKE '%given%' AND title NOT LIKE '%not%'


--Post-op Parenteral
--either Morphine IV Orderable (ERX-149951) 
--OR Hydromorphone IV Orderable (ERX 150104) 
--OR FENTANYL (PF) 50 MCG/ML INJECTION SOLUTION (ERX – 3037)

SELECT * 
FROM radb.dbo.CRD_ERASOrtho_Med_Dim
WHERE medication_id IN (149951,150104,3037)
ORDER BY medtype

BEGIN TRAN COMMIT
update radb.dbo.CRD_ERASOrtho_Med_Dim
SET medtype='Parenteral'
WHERE medication_id IN (149951,150104,3037)



ALTER table
radb.dbo.CRD_ERASOrtho_Med_Dim
ADD metricname VARCHAR(50)


sp_help CRD_ERASOrtho_Med_Dim

ORDER BY MedType,MedShortName

SELECT * FROM radb.dbo.CRD_ERASOrtho_MetricDim AS ceomd



 SELECT * FROM RADB.dbo.CRD_ERASOrtho_FlowDetail



 /***************************** production code below  */


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
	,	ambulate=CAST(NULL AS INT)
	,   preop=CAST(NULL AS INT)
	,   intraop=CAST(NULL AS INT)
	,   pacu=CAST(NULL AS INT)
	,   postop0=CAST(NULL AS INT)	
	,	postopday1=CAST(NULL AS INT)
	,	postopday2=CAST(NULL AS INT)
	,	postopday3=CAST(NULL AS INT)
	,   Postop_disch=CAST(NULL AS INT)


FROM    clarity.dbo.IP_DATA_STORE AS ids
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
SELECT * 
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
	,	ambulate=0
	,   preop=0
	,   intraop=0
	,   pacu=0
	,   postop0=0	
	,   Postop_disch=0;


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
SET ambulate=CASE WHEN pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 
			>0 THEN 1 ELSE 0 END;

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
	,postop_disch=CASE WHEN fs.RECORDED_TIME>=eoc.procedurefinish AND fs.RECORDED_TIME<=eoc.HOSP_DISCH_TIME THEN 1 ELSE 0 END     

	
FROM RADB.dbo.CRD_ERASOrtho_FlowDetail fs
JOIN RADB.dbo.CRD_ERASOrtho_Cases AS eoc ON fs.PAT_ENC_CSN_ID=eoc.PAT_ENC_CSN_ID;

UPDATE RADB.dbo.CRD_ERASOrtho_Cases
SET ambulatepod0=CASE WHEN fs.ambulate=1 AND fs.postop0=1 THEN 1 ELSE 0 end
FROM RADB.dbo.CRD_ERASOrtho_Cases f
JOIN radb.dbo.CRD_ERASOrtho_FlowDetail AS fs ON f.PAT_ENC_CSN_ID=fs.PAT_ENC_CSN_ID;




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
WHERE  meddim.MedType='Multi-Modal Analgesia'
 AND givmed.preop=1
 ),medcount AS (
 SELECT log_id,medcount=COUNT(DISTINCT base.MEDICATION_ID)
FROM base
GROUP BY log_id
)


UPDATE radb.dbo.CRD_ERASOrtho_Cases
  SET preopmultimodal_nummeds=b.medcount
  FROM radb.dbo.CRD_ERASOrtho_Cases c
  JOIN medcount AS b ON c.log_id=b.log_id;

  UPDATE radb.dbo.CRD_ERASOrtho_Cases
  SET preopmultimodal=1
  WHERE preopmultimodal_nummeds=3;
  


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


--assess foley catheter utilization
--update postop antiemetics
WITH base AS (
SELECT 
c.pat_name
,c.pat_mrn_id
,c.HOSP_ADMSN_TIME
,c.HOSP_DISCH_TIME
,c.PAT_ENC_CSN_ID
,flw.Flowsheet_DisplayName
,flw.MEAS_NUMERIC
FROM radb.dbo.CRD_ERASOrtho_Cases AS c
JOIN radb.dbo.CRD_ERASOrtho_FlowDetail AS flw ON c.PAT_ENC_CSN_ID=flw.PAT_ENC_CSN_ID
WHERE  flw.FLO_MEAS_ID IN ('661859','3040102774')
AND flw.MEAS_NUMERIC>0 
AND flw.Postop_disch=1
 ) , sumit AS (SELECT a.PAT_ENC_CSN_ID,SUM(a.MEAS_NUMERIC) AS totoutput
FROM base a 
GROUP BY a.PAT_ENC_CSN_ID
)-- SELECT * FROM sumit

UPDATE radb.dbo.CRD_ERASOrtho_Cases
SET   foleycath=1 
FROM radb.dbo.CRD_ERASOrtho_Cases AS f
JOIN sumit AS m ON f.PAT_ENC_CSN_ID=m.PAT_ENC_CSN_ID;


SELECT * FROM 
either Morphine IV Orderable (ERX-149951) OR Hydromorphone IV Orderable (ERX 150104) OR FENTANYL (PF) 50 MCG/ML INJECTION SOLUTION (ERX – 3037)
1.	
2.	MAR given time  >= Procedure End and MAR given time <= hospital discharge time

SELECT * from
RADB.dbo.CRD_ERASOrtho_GivenMeds		
WHERE MEDICATION_ID IN (149951,150104,3037)

