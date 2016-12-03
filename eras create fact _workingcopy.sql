--Roll out priority 1,2,5,8,9,11,12,14,16 first.
--done:
--1: pre admission counseling
--2: clear liquids up to 3 hours before induction
--5: Normal temp on PACU arrival
--8: ambulation pod0
--9: clear liquids given POD0
--11: ambulation pod1
--14: ambulation pod2

	
	
	SELECT * 
	FROM RADB.dbo.CRD_ERAS_FlowDetail
	WHERE  FLO_MEAS_ID IN ('1020100004','1217')
	ORDER BY PAT_ENC_CSN_ID

IF object_id('RADB.dbo.CRD_ERAS_FlowDetail') IS NOT NULL
	DROP TABLE RADB.dbo.CRD_ERAS_FlowDetail;

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
	,	anes_minus3=CAST(NULL AS TINYINT)
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


FROM    clarity.dbo.IP_DATA_STORE AS ids
		--clarity.dbo.pat_enc_hsp AS ids
		JOIN radb.dbo.CRD_ERAS_case   b ON ids.EPT_CSN = b.admissioncsn
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
											'1020100004',  -- date of last liquied
											'1217'  ,--time of last liquid
											'51'      --clear liquids - PO
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
	   anes_minus3,
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
	   PhaseofCare_desc
INTO    RADB.dbo.CRD_ERAS_FlowDetail
FROM baseq
ORDER BY pat_enc_csn_id,recorded_time;

UPDATE RADB.dbo.CRD_ERAS_FlowDetail
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

FROM RADB.dbo.CRD_ERAS_FlowDetail s
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
UPDATE RADB.dbo.CRD_ERAS_FlowDetail
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
FROM RADB.dbo.CRD_ERAS_FlowDetail a
JOIN rolled v ON a.fsd_id=v.fsd_id AND a.line=v.line;

									

--update all meas_numeric field
UPDATE RADB.dbo.CRD_ERAS_FlowDetail 
SET MEAS_NUMERIC=CAST(MEAS_VALUE AS NUMERIC(13,4))
WHERE ValueType IN ('Numeric Type','Temperature')

--update all timestamps
	
UPDATE RADB.dbo.CRD_ERAS_FlowDetail 
SET preop=CASE WHEN fs.RECORDED_TIME>=eoc.inpreprocedure AND fs.RECORDED_TIME<=COALESCE(eoc.outofpreprocedure,eoc.anesstart) THEN 1 ELSE 0 END
	,presurg=CASE WHEN fs.RECORDED_TIME>=eoc.HOSP_ADMSN_TIME AND fs.RECORDED_TIME<=eoc.SCHED_START_TIME THEN 1 ELSE 0 END
	, intraop= CASE WHEN fs.RECORDED_TIME>=eoc.inroom AND fs.RECORDED_TIME<=eoc.outofroom THEN 1 ELSE 0 END	
	, preadmit_tm = CASE WHEN fs.RECORDED_TIME>=DATEADD(DAY,-7,eoc.HOSP_ADMSN_TIME) AND fs.RECORDED_TIME < eoc.HOSP_ADMSN_TIME THEN 1 ELSE 0 end
	, anes_minus3 = CASE WHEN fs.RECORDED_TIME>= eoc.SURGERY_DATE AND fs.RECORDED_TIME <= DATEADD(HOUR,-3,eoc.anesstart) THEN 1 ELSE 0 end
	, pacu = CASE WHEN fs.RECORDED_TIME>=eoc.inpacu AND fs.RECORDED_TIME<=eoc.outofpacu THEN 1 ELSE 0 END
	, postop0=CASE WHEN fs.RECORDED_TIME>=COALESCE(eoc.procedurefinish,eoc.outofroom) AND fs.RECORDED_TIME<eoc.postopday1_begin THEN 1 ELSE 0 END
	, postopday1=CASE WHEN fs.RECORDED_TIME>=eoc.postopday1_begin AND fs.RECORDED_TIME <eoc.postopday2_begin THEN 1 ELSE 0 END
	, postopday2=CASE WHEN fs.RECORDED_TIME>=eoc.postopday2_begin AND fs.RECORDED_TIME <eoc.postopday3_begin THEN 1 ELSE 0 END
	, postopday3=CASE WHEN fs.RECORDED_TIME>=eoc.postopday3_begin AND fs.RECORDED_TIME <eoc.postopday4_begin THEN 1 ELSE 0 END	
	,afterpostopday4=CASE WHEN fs.RECORDED_TIME>=eoc.postopday4_begin THEN 1 ELSE 0 END	
	,postop_disch=CASE WHEN fs.RECORDED_TIME>=eoc.outofroom AND fs.RECORDED_TIME<=eoc.HOSP_DISCH_TIME THEN 1 ELSE 0 END     	


FROM RADB.dbo.CRD_ERAS_FlowDetail fs
LEFT JOIN RADB.dbo.CRD_ERAS_Case AS  eoc ON fs.PAT_ENC_CSN_ID=eoc.admissioncsn;

--update phase of care
UPDATE RADB.dbo.CRD_ERAS_FlowDetail 
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
				END




--Roll out priority 1,2,5,8,9,11,12,14,16 first.

--done
--1- preadmission
--5- NORMAL temp

--populate pacu temp and normal temp on pacu

UPDATE radb.dbo.CRD_ERAS_Case 
SET pacutemp=temp.temp
,NormalTempInPacu=CASE WHEN temp.temp>=96.8 THEN 1 ELSE 0 end
FROM radb.dbo.CRD_ERAS_Case c
JOIN (
SELECT rid=ROW_NUMBER() OVER(PARTITION BY PAT_ENC_CSN_ID ORDER BY RECORDED_TIME)
,PAT_ENC_CSN_ID ,RECORDED_TIME, MEAS_NUMERIC AS temp
FROM radb.dbo.CRD_ERAS_FlowDetail 
WHERE FLO_MEAS_ID='6'					
AND pacu=1
) temp ON temp.PAT_ENC_CSN_ID=c.admissioncsn
WHERE temp.rid=1


--populate time in pacu

UPDATE radb.dbo.CRD_ERAS_Case 
SET timeinpacu_min=DATEDIFF(MINUTE,inpacu,outofpacu);


--update preadmission counseling metric 
UPDATE radb.dbo.CRD_ERAS_Case 
SET preadm_counseling=1
FROM radb.dbo.CRD_ERAS_Case AS c
JOIN radb.dbo.CRD_ERAS_FlowDetail AS f ON c.anescsn=f.PAT_ENC_CSN_ID
WHERE f.preadmit_tm=1 AND f.FLO_MEAS_ID='10713938';


--populate last liquid metric
UPDATE radb.dbo.CRD_ERAS_Case 
SET clearliquids_3ind=1
FROM radb.dbo.CRD_ERAS_Case AS c
JOIN (
SELECT PAT_ENC_CSN_ID,COUNT(DISTINCT f.FLO_MEAS_ID) AS colcount
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
WHERE f.FLO_MEAS_ID IN ('1020100004','1217')
AND f.anes_minus3=1
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
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postop0=1
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod0
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=1
)UPDATE radb.dbo.CRD_ERAS_Case
 SET ambulatepod0=1
 FROM radb.dbo.CRD_ERAS_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;

--ambulate pod 1 metric 11
WITH ambpod1 AS(		  
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday1=1
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod1
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=2
)
UPDATE radb.dbo.CRD_ERAS_Case
 SET ambulate_pod1=1
 FROM radb.dbo.CRD_ERAS_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;

 
--ambulate pod 2 metric 14
WITH ambpod2 AS(		  
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday2=1
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod2
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=2
)UPDATE radb.dbo.CRD_ERAS_Case
 SET ambulate_pod2=1
 FROM radb.dbo.CRD_ERAS_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;


--update again for those where POD2 is discharge date
WITH ambpod2 AS(		  
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS cec ON f.PAT_ENC_CSN_ID=cec.admissioncsn
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday2=1
AND CONVERT(DATE,cec.HOSP_DISCH_TIME)=CONVERT(DATE,cec.postopday2_begin)
), ambtotal AS (SELECT PAT_ENC_CSN_ID,SUM(totalamb) AS totalamb
FROM ambpod2
GROUP BY PAT_ENC_CSN_ID
HAVING SUM(totalamb)>=1
)UPDATE radb.dbo.CRD_ERAS_Case
 SET ambulate_pod2=1
 FROM radb.dbo.CRD_ERAS_Case AS c
 JOIN ambtotal AS amb ON c.admissioncsn=amb.PAT_ENC_CSN_ID;

--update metric 9 clear liquids POD0

UPDATE radb.dbo.CRD_ERAS_Case
SET clearliquids_pod0=1
FROM radb.dbo.CRD_ERAS_Case AS c
JOIN (
SELECT PAT_ENC_CSN_ID
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
WHERE FLO_MEAS_ID='51'
AND PhaseofCare_desc='POD0'
GROUP BY PAT_ENC_CSN_ID
) AS liqpod0 ON liqpod0.PAT_ENC_CSN_ID=c.admissioncsn;



--update date dim
 EXEC radb.dbo.CRD_ERAS_Create_DateDim;