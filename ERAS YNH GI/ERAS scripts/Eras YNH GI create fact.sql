

--SELECT * FROM clarity.dbo.IP_FLO_GP_DATA
--WHERE FLO_MEAS_NAME LIKE '%weight%'

--Roll out priority 1,2,5,8,9,11,12,14,16 first.
--done:
--1: pre admission counseling
--2: clear liquids up to 3 hours before induction
--5: Normal temp on PACU arrival
--8: ambulation pod0
--9: clear liquids given POD0
--11: ambulation pod1
--14: ambulation pod2

	--SELECT * 
	--FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail
	--WHERE  FLO_MEAS_ID IN ('1020100004','1217')
	--ORDER BY PAT_ENC_CSN_ID

IF object_id('RADB.dbo.CRD_ERAS_YNHGI_FlowDetail') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_YNHGI_FlowDetail;

WITH baseq AS (
  		
SELECT  
		b.LOG_ID
,		b.admissioncsn AS pat_enc_csn_id
,       ifm.FSD_ID
,		ifm.line
,       ifgd.FLO_MEAS_NAME
,		ifm.FLO_MEAS_ID
,       ifgd.DISP_NAME AS Flowsheet_DisplayName
,		ifm.MEAS_VALUE
,		MEAS_NUMERIC=CAST(NULL AS NUMERIC(13,4))
,		MEAS_DATE = cast (NULL AS DATETIME)
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
	--ambulation criteria
	,	amb_adlib=CAST(NULL AS TINYINT	)
	,	amb_bedtfchair=CAST(NULL AS TINYINT)
	,	amb_inroom=CAST(NULL AS TINYINT)
	,	amb_inhall=CAST(NULL AS TINYINT)	       
	,	amb_25ft=CAST(NULL AS TINYINT)
	,	amb_50ft=CAST(NULL AS TINYINT)
	,	amb_75ft=CAST(NULL AS TINYINT)
	,	amb_100ft=CAST(NULL AS TINYINT)
	,	amb_200ft=CAST(NULL AS TINYINT)
	
	--pt criteria      
     ,	pt_bedtochair=CAST(NULL AS TINYINT)
	,	pt_chairtobed=CAST(NULL AS TINYINT)
	,	pt_sidesteps=CAST(NULL AS TINYINT)
	,	pt_5ft=CAST(NULL AS TINYINT)	       
	,	pt_10ft=CAST(NULL AS TINYINT)
	,	pt_15ft=CAST(NULL AS TINYINT)
	,	pt_20ft=CAST(NULL AS TINYINT)
	,	pt_25ft=CAST(NULL AS TINYINT)
	,	pt_50ft=CAST(NULL AS TINYINT)
	,	pt_75ft=CAST(NULL AS TINYINT)
	,	pt_100ft=CAST(NULL AS TINYINT)
	,	pt_150ft=CAST(NULL AS TINYINT)
	,	pt_200ft=CAST(NULL AS TINYINT)
	,	pt_250ft=CAST(NULL AS TINYINT)
	,	pt_300ft=CAST(NULL AS TINYINT)
	,	pt_350ft=CAST(NULL AS TINYINT)
	,	pt_400ft=CAST(NULL AS TINYINT)
	,	pt_x2=CAST(NULL AS TINYINT)
	,	pt_x3	=CAST(NULL AS TINYINT)
	,	ambulate_num=CAST(NULL AS TINYINT)
	,	ambulate_den=CAST(NULL AS TINYINT)
	,	preadmit_tm=CAST(NULL AS TINYINT)
	,	anes_minus2=CAST(NULL AS TINYINT)
	,	presurg=CAST(NULL AS TINYINT)
	,   preop=CAST(NULL AS TINYINT)
	,   intraop=CAST(NULL AS TINYINT)
	,   pacu=CAST(NULL AS TINYINT)
	,   postop0=CAST(NULL AS TINYINT)	
	,	postopday1=CAST(NULL AS TINYINT)
	,	postopday2=CAST(NULL AS TINYINT)
	,	postopday3=CAST(NULL AS TINYINT)
	,	afterpostopday4=CAST(NULL AS TINYINT)
	,   Postop_disch=CAST(NULL AS TINYINT)
	,   PhaseofCare_id=CAST(NULL AS TINYINT)
	,	PhaseofCare_desc= CAST(NULL AS VARCHAR(25))
	,   ProcEnd=COALESCE(b.procedurefinish,b.outofroom)
	,	DischargeTime=b.HOSP_DISCH_TIME

FROM    clarity.dbo.IP_DATA_STORE AS ids
		--clarity.dbo.pat_enc_hsp AS ids
		JOIN RADB.dbo.CRD_ERAS_YNHGI_Case   b ON ids.EPT_CSN = b.admissioncsn
        LEFT JOIN clarity.dbo.IP_FLWSHT_REC AS ifr ON ids.INPATIENT_DATA_ID = ifr.INPATIENT_DATA_ID
        LEFT JOIN clarity.dbo.IP_FLWSHT_MEAS AS ifm ON ifr.FSD_ID = ifm.FSD_ID
        LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd ON ifm.FLO_MEAS_ID = ifgd.FLO_MEAS_ID
        LEFT JOIN clarity.dbo.ZC_VAL_TYPE AS zvt ON zvt.VAL_TYPE_C = ifgd.VAL_TYPE_C
        LEFT JOIN clarity.dbo.ZC_ROW_TYP AS zrt ON zrt.ROW_TYP_C = ifgd.ROW_TYP_C
		LEFT JOIN clarity.dbo.CLARITY_EMP AS emptaken ON emptaken.USER_ID=ifm.TAKEN_USER_ID
		LEFT JOIN clarity.dbo.CLARITY_EMP AS empent ON empent.USER_ID=ifm.ENTRY_USER_ID
		
        WHERE          ifm.FLO_MEAS_ID IN ( '3047745',   --physical therapy Gait distance
										    '3046874',   --ambulation distance
											'3040102774', --post void residual cath
											'10713938',  --pre admission counseling
											'6' ,         --temp
											'14',			--weight
											'1020100004',  -- date of last liquied
											'1217'  ,--time of last liquid
											'51',      --clear liquids - PO
											'5966',    -- % meals consumed)		      
											'5202',     --Last Bowel Movement Date
											'4423',    --GI Signs/Symptoms
											'304340',   --"Stool Occurrence"
											'305020',   --Stool
											'661980',	--Stool output
											'664202',   --flatus
											'304351',   --"Flatus Occurrence
											'4515')    --Diet/feeding tolerance)	  
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
	   MEAS_DATE,
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
	   amb_adlib,
	   amb_bedtfchair,
	   amb_inroom,
	   amb_inhall,
	   amb_25ft,
	   amb_50ft,
	   amb_75ft,
	   amb_100ft,
	   amb_200ft,
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
	   preadmit_tm,
	   anes_minus2,
	   presurg,
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
	   PhaseofCare_desc,
   	   ProcEnd,
	   DischargeTime

INTO    RADB.dbo.CRD_ERAS_YNHGI_FlowDetail
FROM baseq
ORDER BY pat_enc_csn_id,recorded_time;

UPDATE RADB.dbo.CRD_ERAS_YNHGI_FlowDetail
SET		admissioncsnflag=0
,		anesthesiacsnflag=0
		,amb_adlib=0
	   ,amb_bedtfchair=0
	   ,amb_inroom=0
	   ,amb_inhall=0
	   ,amb_25ft=0
	   ,amb_50ft=0
	   ,amb_75ft=0
	   ,amb_100ft=0
	   ,amb_200ft=0
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
	,   presurg=0
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
pt_x3 =  CASE WHEN RTRIM(LTRIM(value)) = 'x3' THEN 1 ELSE 0 END,
amb_adlib =CASE WHEN RTRIM(LTRIM(value)) = 'ambulate ad lib' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_bedtfchair=CASE WHEN RTRIM(LTRIM(value)) = 'ambulate bed to/from chair' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_inroom=CASE WHEN RTRIM(LTRIM(value)) = 'ambulate in room' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_inhall=CASE WHEN RTRIM(LTRIM(value)) = 'ambulate in hall' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_25ft=CASE WHEN RTRIM(LTRIM(value)) = '25 ft' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_50ft=CASE WHEN RTRIM(LTRIM(value)) = '50 ft' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_75ft=CASE WHEN RTRIM(LTRIM(value)) = '75 ft' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_100ft=CASE WHEN RTRIM(LTRIM(value)) = '100 ft' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END,
amb_200ft=CASE WHEN RTRIM(LTRIM(value)) = '200 ft' AND s.flo_meas_id='3046874' THEN 1 ELSE 0 END

FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail s
CROSS APPLY radb.dbo.YNHH_SplitToTable(meas_value,';') AS v
WHERE s.FLO_MEAS_ID IN ('3047745','3046874')
), rolled AS (SELECT 
fsd_id,
line,
amb_adlib=SUM(amb_adlib),
amb_bedtfchair=SUM(amb_bedtfchair),
amb_inroom=SUM(amb_inroom),
amb_inhall=SUM(amb_inhall),
amb_25ft=SUM(amb_25ft),
amb_50ft=SUM(amb_50ft),
amb_75ft=SUM(amb_75ft),
amb_100ft=SUM(amb_100ft),
amb_200ft=SUM(amb_200ft),
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
UPDATE RADB.dbo.CRD_ERAS_YNHGI_FlowDetail
SET 
amb_adlib=v.amb_adlib,
amb_bedtfchair=v.amb_bedtfchair,
	   amb_inroom=v.amb_inroom,
	   amb_inhall=v.amb_inhall,
	   amb_25ft=v.amb_25ft,
	   amb_50ft=v.amb_50ft,
	   amb_75ft=v.amb_75ft,
	   amb_100ft=v.amb_100ft,
	   amb_200ft=v.amb_200ft,
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
FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail a
JOIN rolled v ON a.fsd_id=v.fsd_id AND a.line=v.line;

									

--update all meas_numeric field
UPDATE RADB.dbo.CRD_ERAS_YNHGI_FlowDetail 
SET MEAS_NUMERIC=CAST(MEAS_VALUE AS NUMERIC(13,4))
WHERE ValueType IN ('Numeric Type','Temperature')

--update all meas_numeric field
UPDATE RADB.dbo.CRD_ERAS_YNHGI_FlowDetail 
SET MEAS_DATE=DATEADD(DAY,CAST(MEAS_VALUE AS INT),'12/31/1840')
WHERE ValueType ='Date'


--update all timestamps
	
UPDATE RADB.dbo.CRD_ERAS_YNHGI_FlowDetail 
SET preop=CASE WHEN fs.RECORDED_TIME>=eoc.inpreprocedure AND fs.RECORDED_TIME<=COALESCE(eoc.outofpreprocedure,eoc.anesstart) THEN 1 ELSE 0 END
	,presurg=CASE WHEN fs.RECORDED_TIME>=eoc.HOSP_ADMSN_TIME AND fs.RECORDED_TIME<=eoc.SCHED_START_TIME THEN 1 ELSE 0 END
	, intraop= CASE WHEN fs.RECORDED_TIME>=eoc.inroom AND fs.RECORDED_TIME<=eoc.outofroom THEN 1 ELSE 0 END	
	, preadmit_tm = CASE WHEN fs.RECORDED_TIME>=DATEADD(DAY,-7,eoc.HOSP_ADMSN_TIME) AND fs.RECORDED_TIME < eoc.HOSP_ADMSN_TIME THEN 1 ELSE 0 end
	, anes_minus2 = CASE WHEN fs.RECORDED_TIME>= eoc.SURGERY_DATE AND fs.RECORDED_TIME <= DATEADD(HOUR,-2,eoc.anesstart) THEN 1 ELSE 0 end
	, pacu = CASE WHEN fs.RECORDED_TIME>=eoc.inpacu AND fs.RECORDED_TIME<=eoc.outofpacu THEN 1 ELSE 0 END
	, postop0=CASE WHEN fs.RECORDED_TIME>=COALESCE(eoc.procedurefinish,eoc.outofroom) AND fs.RECORDED_TIME<eoc.postopday1_begin THEN 1 ELSE 0 END
	, postopday1=CASE WHEN fs.RECORDED_TIME>=eoc.postopday1_begin AND fs.RECORDED_TIME <eoc.postopday2_begin THEN 1 ELSE 0 END
	, postopday2=CASE WHEN fs.RECORDED_TIME>=eoc.postopday2_begin AND fs.RECORDED_TIME <eoc.postopday3_begin THEN 1 ELSE 0 END
	, postopday3=CASE WHEN fs.RECORDED_TIME>=eoc.postopday3_begin AND fs.RECORDED_TIME <eoc.postopday4_begin THEN 1 ELSE 0 END	
	,afterpostopday4=CASE WHEN fs.RECORDED_TIME>=eoc.postopday4_begin THEN 1 ELSE 0 END	
	,postop_disch=CASE WHEN fs.RECORDED_TIME>=eoc.outofroom AND fs.RECORDED_TIME<=eoc.HOSP_DISCH_TIME THEN 1 ELSE 0 END     	


FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail fs
LEFT JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS  eoc ON fs.PAT_ENC_CSN_ID=eoc.admissioncsn;

--update phase of care
UPDATE RADB.dbo.CRD_ERAS_YNHGI_FlowDetail 
SET PhaseOfCare_id=CASE 
					 WHEN postop0=1 THEN 0
					 WHEN postopday1=1 THEN 1
					 WHEN postopday2=1 THEN 2
					 WHEN postopday3=1 THEN 3
					 WHEN afterpostopday4=1 THEN 4
					 WHEN preop=1 THEN 5
					 WHEN intraop=1 THEN 6
					 WHEN pacu=1 THEN 7
					 WHEN presurg=1 THEN 8
				END,


		PhaseOfCare_desc=CASE WHEN preop=1 THEN 'Preop'
					 WHEN intraop=1 THEN 'Intraop'
					 WHEN pacu=1 THEN 'PACU'
					 WHEN postop0=1 THEN 'POD0'
					 WHEN postopday1=1 THEN 'POD1'
					 WHEN postopday2=1 THEN 'POD2'
					 WHEN postopday3=1 THEN 'POD3'
					 WHEN afterpostopday4=1 THEN 'POD4 or later'
					 WHEN presurg=1 THEN 'PreSurg'
				END;




--Roll out priority 1,2,5,8,9,11,12,14,16 first.

--done
--1- preadmission
--5- NORMAL temp


--update patient weight - first documented in encounter

WITH patweight AS (
select rid=row_number() over(partition by pat_enc_csn_id order by recorded_time)
,cast(meas_value as decimal(13,2)) as weight_oz
,cast(meas_value as decimal(13,2)) * 0.0283495 AS weight_kg
,PAT_ENC_CSN_ID
from RADB.dbo.CRD_ERAS_YNHGI_FlowDetail
where flo_meas_id='14'
)UPDATE RADB.dbo.CRD_ERAS_YNHGI_EncDim
SET patient_weight_oz=wgt.weight_oz
,patient_weight_kg=wgt.weight_kg
FROM RADB.dbo.CRD_ERAS_YNHGI_EncDim AS e
JOIN patweight AS wgt ON wgt.PAT_ENC_CSN_ID = e.PAT_ENC_CSN_ID
WHERE wgt.rid=1;


 
--populate pacu temp and normal temp on pacu

UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET pacutemp=temp.temp
,NormalTempInPacu=CASE WHEN temp.temp>=96.8 THEN 1 ELSE 0 end
FROM RADB.dbo.CRD_ERAS_YNHGI_Case c
JOIN (
SELECT rid=ROW_NUMBER() OVER(PARTITION BY PAT_ENC_CSN_ID ORDER BY RECORDED_TIME)
,PAT_ENC_CSN_ID ,RECORDED_TIME, MEAS_NUMERIC AS temp
FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail 
WHERE FLO_MEAS_ID='6'					
AND pacu=1
) temp ON temp.PAT_ENC_CSN_ID=c.admissioncsn
WHERE temp.rid=1


--populate time in pacu

UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET timeinpacu_min=DATEDIFF(MINUTE,inpacu,outofpacu);


--update preadmission counseling metric 
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET preadm_counseling=1
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS f ON c.admissioncsn=f.PAT_ENC_CSN_ID
WHERE f.FLO_MEAS_ID='10713938';



--populate last liquid metric
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET clearliquids_3ind=1
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN (
SELECT PAT_ENC_CSN_ID,COUNT(DISTINCT f.FLO_MEAS_ID) AS colcount
FROM  RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS f
WHERE f.FLO_MEAS_ID IN ('1020100004','1217')
--AND f.anes_minus3=1
GROUP BY PAT_ENC_CSN_ID
) AS lastliq ON lastliq.PAT_ENC_CSN_ID=c.admissioncsn
WHERE lastliq.colcount=2; --both time and date columns need to be populated

--ambulation pod0 metric 8


WITH ambpod0 AS(		  
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_adlib +      amb_bedtfchair +  amb_inroom + amb_inhall + amb_25ft + amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postop0=1
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod0
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=1
)UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
 SET ambulatepod0=1
 FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;

--ambulate pod 1 metric 11
WITH ambpod1 AS(		  
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday1=1
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod1
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=2
)
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
 SET ambulate_pod1=1
 FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;

 
--ambulate pod 2 metric 14
WITH ambpod2 AS(		  
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday2=1
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod2
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=2
)UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
 SET ambulate_pod2=1
 FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;


--update again for those where POD2 is discharge date
WITH ambpod2 AS(		  
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS  f
LEFT JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS cec ON f.PAT_ENC_CSN_ID=cec.admissioncsn
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday2=1
AND CONVERT(DATE,cec.HOSP_DISCH_TIME)=CONVERT(DATE,cec.postopday2_begin)
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod2
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=1
)UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
 SET ambulate_pod2=1
 FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;

--update metric 9 clear liquids POD0

UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET clearliquids_pod0=1
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN (
SELECT PAT_ENC_CSN_ID
FROM  RADB.dbo.CRD_ERAS_YNHGI_FlowDetail 
WHERE FLO_MEAS_ID='51'
AND PhaseofCare_desc='POD0'
GROUP BY PAT_ENC_CSN_ID
) AS liqpod0 ON liqpod0.PAT_ENC_CSN_ID=c.admissioncsn;


--solid food POD1
WITH food AS (
SELECT 
		pcteaten=CASE WHEN ISNUMERIC(REPLACE(meas_value,'%',''))=1 THEN CONVERT(INT,REPLACE(meas_value,'%','')) ELSE NULL end
		,*
FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS cefd
WHERE FLO_MEAS_ID='5966'
AND postopday1=1
)UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET solidfood_pod1=1
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN (
SELECT PAT_ENC_CSN_ID 
 FROM food
 WHERE pcteaten>=50
 GROUP BY PAT_ENC_CSN_ID 
 ) AS pod0food ON pod0food.PAT_ENC_CSN_ID=c.admissioncsn;



 UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
 SET date_bowelfunction=NULL,hrs_tobowelfunction=NULL;

 --return of bowel function
 WITH basebow AS (
 SELECT PAT_ENC_CSN_ID,CASE WHEN flo_meas_id IN ('304340','305020', '661980','304351') THEN RECORDED_TIME
							WHEN flo_meas_id IN ('5202') THEN MEAS_DATE
							END AS RECORDED_TIME,
							ProcEnd,
							DischargeTime

FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS cefd
WHERE FLO_MEAS_ID IN ('5202',     --Last Bowel Movement Date    - date value
					 '304340',   --"Stool Occurrence" -->0
					'305020',   --Stool -->0
					'661980',	--Stool output   ---> 0				
					'304351')    --- >0
	  AND ((flo_meas_id IN ('304340','305020','661980','304351') AND meas_numeric>0)
	      OR (FLO_MEAS_ID='5202' AND ISDATE(meas_date) =1)		  
		  )
	  
),basebow2 AS (
	SELECT *
	FROM basebow
	WHERE RECORDED_TIME>=ProcEnd AND RECORDED_TIME<=DischargeTime
	)
,bowrolled AS (
SELECT pat_enc_csn_id
,MIN(recorded_time) AS mindt
FROM basebow2
GROUP BY PAT_ENC_CSN_ID
),baseflat AS (
SELECT  v.Value
,       s.FSD_ID
,       s.LINE
,       FLO_MEAS_ID
,       PAT_ENC_CSN_ID
,       RECORDED_TIME
,		GIFlatus=CASE WHEN flo_meas_id='4423' AND value='passing flatus' THEN 1 ELSE 0 END
,		StomaFlatus=CASE WHEN flo_meas_id='664202' AND value='flatus' THEN 1 ELSE 0 END
FROM    RADB.dbo.CRD_ERAS_YNHGI_FlowDetail s
        CROSS APPLY RADB.dbo.YNHH_SplitToTable(MEAS_VALUE, ';') AS v
WHERE   FLO_MEAS_ID IN ( '664202', '4423' )
AND (s.RECORDED_TIME>=s.ProcEnd AND s.RECORDED_TIME<=s.DischargeTime)
--AND PAT_ENC_CSN_ID=107451704
--ORDER BY RECORDED_TIME
), flatrolled AS (SELECT pat_enc_csn_id
,MIN(RECORDED_TIME) AS mindt
 FROM baseflat
 WHERE (GIFlatus=1 OR StomaFlatus=1)
GROUP BY pat_enc_csn_id
), unionstation AS (SELECT 'bow' AS src,PAT_ENC_CSN_ID,mindt
 FROM bowrolled
 UNION ALL 
 SELECT 'flat' AS src,pat_enc_csn_id,mindt
 FROM flatrolled
 ),final AS (
 SELECT u.PAT_ENC_CSN_ID,MIN(u.mindt) AS mindt
 FROM unionstation AS u
 GROUP BY PAT_ENC_CSN_ID
 )
 UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET date_bowelfunction=f.mindt
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
JOIN  final AS f ON f.PAT_ENC_CSN_ID=c.admissioncsn;

--update hours to return of bowel function
 UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET hrs_tobowelfunction=DATEDIFF(HOUR,COALESCE(procedurefinish,outofroom),date_bowelfunction);


--tolerating diet

 WITH basediet AS (
 SELECT PAT_ENC_CSN_ID,
							recorded_time,
							FSD_ID,
							line,
							FLO_MEAS_ID,
							pcteaten=CASE WHEN flo_meas_id ='5966' AND ISNUMERIC(REPLACE(meas_value,'%',''))=1 THEN CONVERT(INT,REPLACE(meas_value,'%','')) ELSE NULL END,							
							toleranceflag=CASE WHEN FLO_MEAS_ID='4515' AND (MEAS_VALUE LIKE '%fair%' OR MEAS_VALUE LIKE '%good%') THEN 1 ELSE 0 END,
							ProcEnd,
							DischargeTime,
							MEAS_VALUE,
							MEAS_NUMERIC,
							cefd.ValueType,
							Postop_disch

FROM RADB.dbo.CRD_ERAS_YNHGI_FlowDetail AS cefd
WHERE FLO_MEAS_ID IN ('4515',    --Diet/feeding tolerance
					  '5966'    -- % meals consumed
						)
				  ),base2 AS
				  (SELECT *
						,pcteatenflag=CASE WHEN pcteaten>=75 THEN 1 ELSE 0 end
				   FROM basediet
				   WHERE Postop_disch=1
				   ),			   
				   fin AS (SELECT PAT_ENC_CSN_ID,SUM(pcteatenflag) AS totconsumed,SUM(toleranceflag) AS totaltolerance
				   FROM base2
				   GROUP BY PAT_ENC_CSN_ID
				   HAVING SUM(pcteatenflag)>0 AND SUM(toleranceflag)>0
				   ) , finaldetail AS (
				   SELECT  base.*
				   FROM fin AS f
				   join base2 AS base
				   ON f.PAT_ENC_CSN_ID=base.PAT_ENC_CSN_ID
				   ) , flagged AS
                   (
				   SELECT * 
						  ,rid=ROW_NUMBER() OVER (PARTITION BY PAT_ENC_CSN_ID,FLO_MEAS_ID ORDER BY PAT_ENC_CSN_ID,RECORDED_TIME)
				   FROM finaldetail				   				   
				   ), dietfinal AS 
				   (SELECT PAT_ENC_CSN_ID,MAX(RECORDED_TIME) AS dietdate
				   FROM flagged
				   WHERE rid=1
				   GROUP BY PAT_ENC_CSN_ID
				   )
				   --SELECT *
				   --FROM flagged
				   --ORDER BY PAT_ENC_CSN_ID,FLO_MEAS_ID,RECORDED_TIME
				   UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
				   SET date_toleratediet=d.dietdate
				   FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
				   JOIN dietfinal AS d ON c.admissioncsn=d.PAT_ENC_CSN_ID;


--update hours until first tolerating diet
 UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET hrs_toleratediet=DATEDIFF(HOUR,COALESCE(procedurefinish,outofroom),date_toleratediet);


--Metric 3.2 Lumbar epidural

IF object_id('radb.dbo.TMP_epi') IS NOT NULL
	DROP TABLE radb.dbo.TMP_epi;


WITH basesmart AS (	
SELECT  ev.HLV_ID
,		op.PAT_ENC_CSN_ID
,		cc.ABBREVIATION AS ElementName
,		sed.ELEMENT_ID
,		ev.SMRTDTA_ELEM_VALUE
,       serauth.PROV_NAME AS AuthProvider
,       serrefer.prov_name AS ReferringProv
,		serperform.PROV_NAME AS PerformingProv
,		p.PAT_MRN_ID
,		p.PAT_NAME
,		op.ORDER_PROC_ID
,        op.ORDER_TIME
,		op.PROC_ID
--,op.*
,       op.PROC_CODE
,       op.DESCRIPTION
--,ev.*
--INTO RADB.dbo.ERAS_Smartform_onepatient
FROM         Clarity.dbo.Smrtdta_Elem_Data sed               
		   JOIN   (SELECT op.*
			       from CLarity.dbo.Order_Proc op			       
			       JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS f
				   ON f.anescsn=op.PAT_ENC_CSN_ID				   
					)op
        ON sed.record_id_numeric = op.order_proc_id
        JOIN Clarity.dbo.Smrtdta_Elem_Value ev ON sed.HLV_Id = ev.HLV_Id
        LEFT join clarity.dbo.CLARITY_CONCEPT AS cc ON sed.ELEMENT_ID = cc.CONCEPT_ID
        LEFT JOIN clarity.dbo.clarity_ser serauth ON serauth.PROV_ID = op.AUTHRZING_PROV_ID
        LEFT JOIN clarity.dbo.clarity_ser serrefer ON serrefer.PROV_ID = op.REFERRING_PROV_ID
        LEFT JOIN clarity.dbo.clarity_ser serperform ON serperform.PROV_ID = op.PROC_PERF_PROV_ID
        LEFT JOIN clarity.dbo.patient AS p          
        ON p.pat_id=op.PAT_ID
WHERE   context_name = 'ORDER'
        AND CUR_VALUE_SOURCE = 'SmartForm 11227803'
       AND ELEMENT_ID IN ( 'EPIC#12678','EPIC#19699') --including 
        AND SMRTDTA_ELEM_VALUE='thoracic'
		)
		SELECT DISTINCT pat_enc_csn_id
		INTO radb.dbo.TMP_epi
		FROM basesmart;

UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET thoracic_epi=CASE WHEN epi.pat_enc_csn_id IS NOT NULL THEN 1 ELSE 0 end
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS c
LEFT JOIN radb.dbo.TMP_epi AS epi ON c.anescsn=epi.pat_enc_csn_id;



IF object_id('radb.dbo.CRD_ERAS_YNHGI_GivenMeds') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_YNHGI_GivenMeds;

SELECT  mai.MAR_ENC_CSN AS pat_enc_csn_id
		,eo.LOG_ID
		,cm.MEDICATION_ID 
		,meddim.MetricNumber
		,meddim.MetricDescription
		,meddim.MedType
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
		,maract.MarReportAction
		,mai.mar_action_c
		,mai.SIG AS GivenDose
		,zmu.NAME AS DoseUnit	
		,mai.ROUTE_C					
		,zar.Name AS Route		
		,CASE WHEN meddim.MedType='Analgesia' THEN
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
		
				

INTO RADB.dbo.CRD_ERAS_YNHGI_GivenMeds		
from clarity.dbo.MAR_ADMIN_INFO AS mai
JOIN  RADB.dbo.CRD_ERAS_YNHGI_Case  AS eo
ON eo.admissioncsn=mai.MAR_ENC_CSN
JOIN radb.dbo.CRD_ERAS_YNHGI_MarAction AS maract ON maract.RESULT_C=mai.MAR_ACTION_C
LEFT JOIN clarity.dbo.clarity_emp AS empadmin ON empadmin.USER_ID=mai.USER_ID
LEFT join clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.ZC_MED_UNIT AS zmu
ON zmu.DISP_QTYUNIT_C=mai.DOSE_UNIT_C
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN clarity.dbo.clarity_dep AS admindep ON admindep.DEPARTMENT_ID=mai.MAR_ADMIN_DEPT_ID
LEFT JOIN CLARITY.dbo.RX_MED_THREE AS rmt ON rmt.MEDICATION_ID=cm.MEDICATION_ID
INNER JOIN radb.dbo.CRD_ERAS_YNHGI_MedList AS meddim ON meddim.erx=cm.MEDICATION_ID
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
		,CASE WHEN meddim.MedType='Analgesia' THEN
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
JOIN radb.dbo.CRD_ERAS_YNHGI_MarAction AS maract ON maract.RESULT_C=mai.MAR_ACTION_C
LEFT JOIN clarity.dbo.clarity_emp AS empadmin ON empadmin.USER_ID=mai.USER_ID
LEFT join clarity.dbo.ORDER_MED AS om
ON mai.ORDER_MED_ID=om.ORDER_MED_ID
LEFT JOIN clarity.dbo.ZC_MED_UNIT AS zmu
ON zmu.DISP_QTYUNIT_C=mai.DOSE_UNIT_C
LEFT JOIN clarity.dbo.clarity_medication cm
ON om.medication_id=cm.medication_id
LEFT JOIN clarity.dbo.clarity_dep AS admindep ON admindep.DEPARTMENT_ID=mai.MAR_ADMIN_DEPT_ID
LEFT JOIN CLARITY.dbo.RX_MED_THREE AS rmt ON rmt.MEDICATION_ID=cm.MEDICATION_ID
inner JOIN radb.dbo.CRD_ERAS_YNHGI_MedList AS meddim ON meddim.erx=cm.MEDICATION_ID
LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
ON zcact.result_c=mai.mar_action_c
LEFT JOIN clarity.dbo.PATIENT AS p
ON om.PAT_ID=p.PAT_ID
LEFT JOIN clarity.dbo.ZC_ADMIN_ROUTE AS zar ON mai.ROUTE_C=zar.MED_ROUTE_C;


--update given meds phase of care timestamps
UPDATE RADB.dbo.CRD_ERAS_YNHGI_GivenMeds
SET preop=CASE WHEN TAKEN_TIME>=c.inpreprocedure AND TAKEN_TIME<=c.inroom THEN 1 ELSE 0 END
	, intraop= CASE WHEN TAKEN_TIME>=c.inroom AND TAKEN_TIME<=c.outofroom THEN 1 ELSE 0 END
	, pacu = CASE WHEN TAKEN_TIME>=c.inpacu AND TAKEN_TIME<=c.outofpacu THEN 1 ELSE 0 END
	, postop0=CASE WHEN med.TAKEN_TIME>=c.procedurestart AND med.TAKEN_TIME<c.postopday1_begin THEN 1 ELSE 0 END
	, preproc_inroom=CASE WHEN med.TAKEN_TIME>=c.inpreprocedure AND med.TAKEN_TIME<=c.inroom THEN 1 ELSE 0 END
	, preproc_outroom=CASE WHEN med.TAKEN_TIME>=c.inpreprocedure AND med.TAKEN_TIME<c.outofroom THEN 1 ELSE 0 END
	, postopday1=CASE WHEN med.TAKEN_TIME>=c.postopday1_begin AND med.TAKEN_TIME <c.postopday2_begin THEN 1 ELSE 0 END
	, postopday1_noon=CASE WHEN med.TAKEN_TIME>=c.postopday1_begin AND med.TAKEN_TIME <=DATEADD(HOUR,12,c.postopday1_begin) THEN 1 ELSE 0 END
	, postopday2=CASE WHEN med.TAKEN_TIME>=c.postopday2_begin AND med.TAKEN_TIME <c.postopday3_begin THEN 1 ELSE 0 END
	, postopday3=CASE WHEN med.TAKEN_TIME>=c.postopday3_begin AND med.TAKEN_TIME <c.postopday4_begin THEN 1 ELSE 0 END	
	 ,postop_disch=CASE WHEN TAKEN_TIME>=c.procedurefinish AND TAKEN_TIME<=c.HOSP_DISCH_TIME THEN 1 ELSE 0 END
	 ,pacu_disch=CASE WHEN TAKEN_TIME>=c.inpacu AND TAKEN_TIME<=c.HOSP_DISCH_TIME THEN 1 ELSE 0 end
     ,admit_discharge =CASE WHEN TAKEN_TIME>=c.HOSP_ADMSN_TIME AND TAKEN_TIME<=c.HOSP_DISCH_TIME THEN 1 ELSE 0 end

FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
																WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
																WHEN med.anescsn_flag=1 THEN c.anescsn
																END;



--metric 4 multimodal pain
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET mm_pain=1
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
								WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
								WHEN med.anescsn_flag=1 THEN c.anescsn
									END
WHERE preop=1 AND metricnumber=4 AND med.MarReportAction='Given';


--metric  multimodal pain
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET mm_antiemetic_intraop=1
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
								WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
								WHEN med.anescsn_flag=1 THEN c.anescsn
									END
WHERE med.intraop=1 AND MedType='Antiemetic' AND med.MarReportAction='Given';



--IV fluids stopped POD0 
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET iv_fluid_dc_pod0=1
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
								WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
								WHEN med.anescsn_flag=1 THEN c.anescsn
									END
WHERE med.postop0=1 AND MedType='IV Fluids' AND med.MarReportAction='Stopped';


--IV fluids stopped POD0 
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET iv_fluid_dc_pod0=1
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
								WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
								WHEN med.anescsn_flag=1 THEN c.anescsn
									END
WHERE med.postop0=1 AND MedType='IV Fluids' AND med.MarReportAction='Stopped';


--IV fluids stopped POD1 by noon 
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET iv_fluid_dc_pod1noon=1
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
								WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
								WHEN med.anescsn_flag=1 THEN c.anescsn
									END
WHERE med.postopday1_noon=1 AND MedType='IV Fluids' AND med.MarReportAction='Stopped';


--IV fluids stopped POD2
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case 
SET iv_fluid_dc_pod2=1
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
								WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
								WHEN med.anescsn_flag=1 THEN c.anescsn
									END
WHERE med.postopday2=1 AND MedType='IV Fluids' AND med.MarReportAction='Stopped';




IF object_id('radb.dbo.TMP_ivintraop') IS NOT NULL
	DROP TABLE radb.dbo.TMP_ivintraop;

WITH baseiv AS (
SELECT  
--b.PAT_NAME
       b.PAT_MRN_ID
	   ,b.admissioncsn
--,       b.HOSP_ADMSN_TIME
--,       b.HOSP_DISCH_TIME
--,       zvt.name AS ValueType
--,       zrt.name AS RowType
,      	 ifgd.FLO_MEAS_NAME
       , ids.INPATIENT_DATA_ID
,       ifgd.DISP_NAME
,       ifm.FSD_ID
,		ifm.FLO_MEAS_ID
,       ifm.MEAS_VALUE
,		CAST(ifm.MEAS_VALUE AS NUMERIC(13,4) ) AS volume
,       ifgd.DUPLICATEABLE_YN
,		ifm.LINE
,		ifm.OCCURANCE
,		ifm.ENTRY_TIME
,       ifm.MEAS_COMMENT
,	emptaken.name AS TakenUser
,	empentry.name AS EnterByUser
,	ipx.GROUP_LINE
,	ipx.IX_FLOW_RW_ORD_ID
,	om.ORDERING_DATE
,	om.ORDER_START_TIME
,	om.ORDER_END_TIME
,	om.DISCON_TIME
,	om.ORDERING_MODE_C
,	zoc.NAME AS OrderClass
,	zos.name AS OrderStatus
,	om.DESCRIPTION AS OrderDesc
,	zar.NAME AS MedRoute
,		b.anescsn AS pat_enc_csn_id
,       ifm.RECORDED_TIME
,	CASE WHEN ifm.RECORDED_TIME>=b.inpreprocedure AND ifm.RECORDED_TIME<=b.outofroom
	THEN 1 ELSE 0 END AS intraopflag
,	b.caselength_hrs
,   b.inpreprocedure 
,	b.outofroom

FROM    clarity.dbo.IP_DATA_STORE AS ids
        JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS b
        ON ids.EPT_CSN=b.anescsn
        LEFT JOIN clarity.dbo.PATIENT AS p ON b.PAT_ID = p.PAT_ID
        LEFT JOIN Clarity.dbo.IP_FLWSHT_REC AS ifr ON ids.INPATIENT_DATA_ID = ifr.INPATIENT_DATA_ID
        LEFT JOIN Clarity.dbo.IP_FLWSHT_MEAS AS ifm ON ifr.FSD_ID = ifm.FSD_ID
        LEFT JOIN Clarity.dbo.IP_FLO_GP_DATA AS ifgd ON ifm.FLO_MEAS_ID = ifgd.FLO_MEAS_ID
        LEFT JOIN Clarity.dbo.ZC_VAL_TYPE AS zvt ON zvt.VAL_TYPE_C = ifgd.VAL_TYPE_C
        LEFT JOIN Clarity.dbo.ZC_ROW_TYP AS zrt ON zrt.ROW_TYP_C = ifgd.ROW_TYP_C
		LEFT JOIN Clarity.dbo.clarity_emp emptaken
		ON emptaken.USER_ID=ifm.TAKEN_USER_ID
		LEFT JOIN Clarity.dbo.clarity_emp empentry
		ON empentry.USER_ID=ifm.ENTRY_USER_ID
		LEFT JOIN Clarity.dbo.IP_FS_ORD_IX_ID ipx 
		ON ipx.INPATIENT_DATA_ID=ifr.INPATIENT_DATA_ID
		AND ifm.OCCURANCE=ipx.GROUP_LINE
		LEFT JOIN clarity.dbo.order_med AS om
		ON om.ORDER_MED_ID=ipx.IX_FLOW_RW_ORD_ID
		--link to clarity_medication from order_med
		--if needed add filter for therapeutic or pharm class
		LEFT JOIN clarity.dbo.ZC_ORDER_CLASS AS zoc
		ON zoc.ORDER_CLASS_C=om.ORDER_CLASS_C
		LEFT JOIN clarity.dbo.ZC_ADMIN_ROUTE AS zar
		ON zar.MED_ROUTE_C=om.MED_ROUTE_C
		LEFT JOIN clarity.dbo.ZC_ORDER_STATUS AS zos
		ON zos.ORDER_STATUS_C=om.ORDER_STATUS_C
		--whERE b.pat_mrn_id ='MR9000797'
		--and ifgd.DISP_NAME LIKE '%volume%'
		--and ifm.FLO_MEAS_ID='7070009'
		where ifm.FLO_MEAS_ID='7070009'
		AND om.MEDICATION_ID   IN ('4318',--lactated ringers
								  '9814',--D5 1/2s
								  '9815',--D5 NS
								  '27838',--sodium chloride 0.9%								  
								  '9799', --GH D5 NS
								  '9801' 
								  )
), i AS 
(SELECT f.* 
,e.patient_weight_oz AS weight_oz
,e.patient_weight_kg AS weight_kg
,SUM(f.volume) OVER(PARTITION BY f.pat_enc_csn_id) AS totalvolume
,SUM(CASE WHEN f.intraopflag=1 THEN f.volume ELSE 0 END) OVER(PARTITION BY f.pat_enc_csn_id) AS totalvolume_intraop
FROM baseiv f
JOIN RADB.dbo.CRD_ERAS_YNHGI_EncDim AS e
ON f.admissioncsn=e.PAT_ENC_CSN_ID
) , fin AS(
SELECT i.*
,i.weight_kg*caselength_hrs*8 AS threshold
FROM i
),firstcsn AS
(SELECT rid=ROW_NUMBER() OVER(PARTITION BY pat_enc_csn_id ORDER BY pat_enc_csn_id) 
 ,* 
 FROM fin
 )SELECT * 
  INTO radb.dbo.TMP_ivintraop
  FROM firstcsn
  WHERE rid=1;

--update metric on temp table
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET goal_guidelines=1
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS f
JOIN radb.dbo.TMP_ivintraop AS i
ON f.anescsn=i.pat_enc_csn_id
WHERE i.totalvolume_intraop<i.threshold;

--update fact table
UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET iv_totalvolume_intraop=i.totalvolume_intraop
,IV_intraop_threshold=i.threshold
FROM RADB.dbo.CRD_ERAS_YNHGI_Case f
JOIN radb.dbo.TMP_ivintraop AS i
ON i.pat_enc_csn_id=f.anescsn;


----- ****** goal directed therapy end

--foley removed on pod1


IF object_id('tempdb..#foley') is not null
	drop table #foley; 

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
WHERE   iln.FLO_MEAS_ID IN ( '3048148000', '8148', '8151' )
AND f.rid=1
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
WHERE   iln.FLO_MEAS_ID IN ( '3048148000', '8148', '8151' )
AND f.rid=1
)SELECT * 
INTO #foley
FROM baseq;


UPDATE RADB.dbo.CRD_ERAS_YNHGI_Case
SET foleycount=f.foleycount
,foleyremovedcount=f.foleysremoved
,foleypod1=CASE WHEN f.foleycount=f.foleysremoved THEN 1 ELSE 0 end
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS cec
JOIN 
(SELECT LOG_ID,COUNT(*) AS foleycount,SUM(removalflag) AS foleysremoved
FROM #foley AS f
WHERE PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=outofroom
GROUP BY LOG_ID) AS f ON cec.LOG_ID=f.LOG_ID



EXEC radb.dbo.CRD_ERAS_Create_DateDim;

--IF object_id('radb.dbo.TMP_epi') IS NOT NULL
--	DROP TABLE radb.dbo.TMP_epi;


--WITH basesmart AS (	
--SELECT  ev.HLV_ID
--,		op.PAT_ENC_CSN_ID
--,		cc.ABBREVIATION AS ElementName
--,		sed.ELEMENT_ID
--,		ev.SMRTDTA_ELEM_VALUE
--,       serauth.PROV_NAME AS AuthProvider
--,       serrefer.prov_name AS ReferringProv
--,		serperform.PROV_NAME AS PerformingProv
--,		p.PAT_MRN_ID
--,		p.PAT_NAME
--,		op.ORDER_PROC_ID
--,        op.ORDER_TIME
--,		op.PROC_ID
----,op.*
--,       op.PROC_CODE
--,       op.DESCRIPTION
----,ev.*
----INTO RADB.dbo.ERAS_Smartform_onepatient
--FROM         Clarity.dbo.Smrtdta_Elem_Data sed               
--		   JOIN   (SELECT op.*
--			       from CLarity.dbo.Order_Proc op			       
--			       JOIN RADB.dbo.CRD_ERAS_YNHGI_Case AS f
--				   ON anescsn=op.PAT_ENC_CSN_ID				   
--					)op
--        ON sed.record_id_numeric = op.order_proc_id
--        JOIN Clarity.dbo.Smrtdta_Elem_Value ev ON sed.HLV_Id = ev.HLV_Id
--        LEFT join clarity.dbo.CLARITY_CONCEPT AS cc ON sed.ELEMENT_ID = cc.CONCEPT_ID
--        LEFT JOIN clarity.dbo.clarity_ser serauth ON serauth.PROV_ID = op.AUTHRZING_PROV_ID
--        LEFT JOIN clarity.dbo.clarity_ser serrefer ON serrefer.PROV_ID = op.REFERRING_PROV_ID
--        LEFT JOIN clarity.dbo.clarity_ser serperform ON serperform.PROV_ID = op.PROC_PERF_PROV_ID
--        LEFT JOIN clarity.dbo.patient AS p          
--        ON p.pat_id=op.PAT_ID
--WHERE   context_name = 'ORDER'
--        AND CUR_VALUE_SOURCE = 'SmartForm 11227803'
--       AND ELEMENT_ID IN ( 'EPIC#12678','EPIC#19699') --including 
--        --EPIC#19699 cervical,thoracic,lumbar   EPIC#12678 - block type: epidural, intrathecal, caudal
--        --AND p.PAT_MRN_ID='MR86772'
--        --AND ELEMENT_ID IN ( 'YNHHS#019', 'EPIC#2818', 'YNHHS#020', 'YNHHS#021' )
----AND op.ORDER_TIME>='6/1/2015'
----        AND op.ORDER_PROC_ID = 1
--), t1 AS 
--(SELECT CASE  
--			WHEN b.PAT_ENC_CSN_ID=f.anescsn THEN 'Anescsn'
--			WHEN b.PAT_ENC_CSN_ID=f.admissioncsn THEN 'Admissioncsn'
--			WHEN b.PAT_ENC_CSN_ID=f.surgicalcsn THEN 'Surgicalcsn'
--			ELSE '*Unknown csn'
--			END AS CsnType
--	,b.* 
----	,f.*
--FROM basesmart b
--JOIN radb.dbo.TMP_erasfact f
--ON b.pat_enc_csn_id=f.pat_enc_csn_id
--), blocktype AS
--(SELECT * 
-- FROM t1
-- WHERE element_id='EPIC#12678'
-- ),
--  spinelevel AS
--(SELECT * 
-- FROM t1
-- WHERE element_id='EPIC#19699'
-- )SELECT b.Pat_enc_csn_id,b.pat_mrn_id,b.pat_name,b.smrtdta_elem_value AS blocktype,
-- s.smrtdta_elem_value AS spinelevel
-- INTO radb.dbo.TMP_epi
--  FROM blocktype AS b
--  JOIN spinelevel AS s
--  ON b.pat_enc_csn_id=s.pat_enc_csn_id;
 

--IF object_id('radb.dbo.TMP_blockstart') IS NOT NULL
--	DROP TABLE radb.dbo.TMP_blockstart;

--  select eipi.PAT_CSN,eiei.event_id,eiei.line,eiei.EVENT_TYPE,eiei.EVENT_DISPLAY_NAME
-- ,eiei.EVENT_TIME,eiei.EVENT_RECORD_TIME
--INTO radb.dbo.TMP_blockstart
-- FROM clarity.dbo.F_AN_RECORD_SUMMARY fsum
--  JOIN clarity.dbo.ED_IEV_PAT_INFO AS eipi
-- ON fsum.AN_52_ENC_CSN_ID=eipi.PAT_CSN
--  JOIN clarity.dbo.ED_IEV_EVENT_INFO AS eiei
-- ON eiei.EVENT_ID=eipi.EVENT_ID 
--  AND eiei.EVENT_TYPE='1120000059'
-- --WHERE fsum.AN_52_ENC_CSN_ID=116823639 --prod test case
-- WHERE  fsum.AN_52_ENC_CSN_ID IN (SELECT pat_enc_csn_id FROM radb.dbo.TMP_epi);

----UPDATE radb.dbo.ERAS_CaseFact SET blocktime=NULL,blocktype=NULL,spinelevel=null
--UPDATE radb.dbo.ERAS_CaseFact 
--SET blocktime=epidim.blockstart
--,blocktype=epidim.blocktype
--,spinelevel=epidim.spinelevel
--FROM radb.dbo.ERAS_CaseFact f
--JOIN 
--(SELECT e.pat_enc_csn_id,blocktype,spinelevel,b.EVENT_TIME AS blockstart
--FROM radb.dbo.TMP_epi AS e
--LEFT join radb.dbo.TMP_blockstart AS b
--ON e.pat_enc_csn_id=b.pat_csn) epidim
--ON epidim.pat_enc_csn_id=f.admissioncsn;

--UPDATE radb.dbo.ERAS_CaseFact 
--SET blocktime=epidim.blockstart
--,blocktype=epidim.blocktype
--,spinelevel=epidim.spinelevel
--FROM radb.dbo.ERAS_CaseFact f
--JOIN 
--(SELECT e.pat_enc_csn_id,blocktype,spinelevel,b.EVENT_TIME AS blockstart
--FROM radb.dbo.TMP_epi AS e
--LEFT join radb.dbo.TMP_blockstart AS b
--ON e.pat_enc_csn_id=b.pat_csn) epidim
--ON epidim.pat_enc_csn_id=f.anescsn;


--UPDATE radb.dbo.ERAS_CaseFact 
--SET blocktime=epidim.blockstart
--,blocktype=epidim.blocktype
--,spinelevel=epidim.spinelevel
--FROM radb.dbo.ERAS_CaseFact f
--JOIN 
--(SELECT e.pat_enc_csn_id,blocktype,spinelevel,b.EVENT_TIME AS blockstart
--FROM radb.dbo.TMP_epi AS e
--LEFT join radb.dbo.TMP_blockstart AS b
--ON e.pat_enc_csn_id=b.pat_csn) epidim
--ON epidim.pat_enc_csn_id=f.surgicalcsn;

--UPDATE radb.dbo.ERAS_CaseFact 
--SET met3=1
--WHERE blocktype='epidural' AND spinelevel='thoracic' 
--AND ( blocktime>=anesstart AND blocktime<procedurestart);

--UPDATE radb.dbo.ERAS_CaseFact 
--SET met3=0
--WHERE met3 <>1 OR met3 IS NULL;


			   
--				   --SELECT * FROM flagged
--				   --WHERE pat_enc_csn_id=108254253
--				   --ORDER BY PAT_ENC_CSN_ID,FLO_MEAS_ID,RECORDED_TIME

--				   -- SELECT * FROM dietfinal
--				   --ORDER BY PAT_ENC_CSN_ID
				   
				   
--				   --FROM base2
--				   --WHERE pat_enc_csn_id=108254253
--				   --ORDER BY PAT_ENC_CSN_ID,RECORDED_TIME
				   

----update date dim
-- EXEC radb.dbo.CRD_ERAS_Create_DateDim;
 



--SELECT  CASE WHEN mai.TAKEN_TIME>=pod0_start AND mai.TAKEN_TIME<pod1_start THEN 1 ELSE 0 END AS givenpod0
--,	CASE WHEN mai.TAKEN_TIME>=pod1_start AND mai.TAKEN_TIME<pod2_start THEN 1 ELSE 0 END AS givenpod1
--,	CASE WHEN mai.TAKEN_TIME>=pod2_start AND mai.TAKEN_TIME<pod3_start THEN 1 ELSE 0 END AS givenpod2
--,	CASE WHEN mai.TAKEN_TIME>=inpreprocedure AND mai.TAKEN_TIME<=outofpreprocedure THEN 1 ELSE 0 END AS givenpreproc
--,	CASE WHEN mai.TAKEN_TIME>=hosP_admsn_time AND mai.TAKEN_TIME<sched_start_time THEN 1 ELSE 0 END AS presurg
--,	CASE WHEN mai.taken_time >pod2_start THEN 1 ELSE 0 END AS pod2on
--		,mai.TAKEN_TIME
--		,mai.mar_action_c
--		,zcact.NAME AS MarAction
--		,cm.MEDICATION_ID 
--		,cm.NAME AS MedicationName
--  		,eb.*	
--		--,om.*
----INTO  ##met4
--from clarity.dbo.MAR_ADMIN_INFO AS mai
--JOIN radb.dbo.TMP_erasfact AS eb
--ON eb.pat_enc_csn_id=mai.MAR_ENC_CSN
--JOIN clarity.dbo.ORDER_MED AS om
--ON mai.ORDER_MED_ID=om.ORDER_MED_ID
--LEFT JOIN clarity.dbo.clarity_medication cm
--ON om.medication_id=cm.medication_id
--LEFT JOIN clarity.dbo.zc_mar_rslt AS zcact
--ON zcact.result_c=mai.mar_action_c
--WHERE mai.MAR_ACTION_C=1
--and om.MEDICATION_ID IN (SELECT MEDICATION_ID FROM radb.dbo.ERAS_Medications WHERE MetricNumber=4)
--AND mai.TAKEN_TIME>=inpreprocedure AND mai.TAKEN_TIME<=COALESCE(outofpreprocedure,anesstart)




