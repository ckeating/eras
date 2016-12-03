
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
,		iln.FLO_MEAS_ID
,       iln.PLACEMENT_INSTANT
,       iln.REMOVAL_INSTANT
,		CASE WHEN (PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=outofroom )
				  AND (REMOVAL_INSTANT>=f.procedurefinish AND REMOVAL_INSTANT<DATEADD(HOUR,7,f.postopday2_begin)) THEN 1 ELSE 0 end	AS removalflag
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
,		iln.FLO_MEAS_ID
,       iln.PLACEMENT_INSTANT
,       iln.REMOVAL_INSTANT
,		CASE WHEN (PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=f.procedurefinish )
				  AND (REMOVAL_INSTANT>f.procedurefinish AND REMOVAL_INSTANT<DATEADD(HOUR,7,f.postopday2_begin)) THEN 1 ELSE 0 end	AS removalflag
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
(SELECT LOG_ID,COUNT(*) AS foleycount,SUM(removalflag) AS foleysremoved,
	SUM(CASE WHEN flo
FROM #foley AS f
WHERE PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=outofroom
GROUP BY LOG_ID) AS f ON cec.LOG_ID=f.LOG_ID

SELECT *
FROM dbo.vw_FlowSheet_Metadata AS vfsm
WHERE FLO_MEAS_ID IN ( '3048148000', '8148', '8151' )
WITH foleyrec AS (
select 
cec.LOG_ID
,cec.HAR
,cec.admissioncsn
,cec.PAT_MRN_ID
,cec.HOSP_ADMSN_TIME
,cec.HOSP_DISCH_TIME
,foleycount=f.foleycount
,foleyremovedcount=f.foleysremoved
,foleypod1=CASE WHEN f.foleycount=f.foleysremoved THEN 1 ELSE 0 END
,suprapubic_count=f.suprapubic
FROM RADB.dbo.CRD_ERAS_YNHGI_Case AS cec
JOIN 
(SELECT LOG_ID,COUNT(*) AS foleycount,SUM(removalflag) AS foleysremoved,SUM(CASE WHEN FLO_MEAS_ID ='8151' THEN 1 ELSE 0 END ) AS suprapubic
FROM #foley AS f
WHERE PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=outofroom
GROUP BY LOG_ID) AS f ON cec.LOG_ID=f.LOG_ID
)SELECT fr.LOG_ID
 ,      fr.HAR
 ,      fr.admissioncsn
 ,      fr.PAT_MRN_ID
 ,      fr.HOSP_ADMSN_TIME
 ,      fr.HOSP_DISCH_TIME
 ,      fr.foleycount
 ,      fr.foleyremovedcount
 ,      fr.foleypod1
 ,      fr.suprapubic_count
 ,f.PLACEMENT_INSTANT
 ,f.REMOVAL_INSTANT
 ,f.FLO_MEAS_ID
 ,f.DISP_NAME
 ,f.FLO_MEAS_NAME
 ,vlt.PROCEDURE_START_DTTM,vlt.PROCEDURE_COMP_DTTM
FROM foleyrec AS fr
LEFT JOIN #foley AS f ON f.log_id=fr.log_id
LEFT JOIN clarity.dbo.V_LOG_TIMING_EVENTS AS vlt ON vlt.LOG_ID=fr.LOG_ID
WHERE fr.suprapubic_count=0 AND fr.foleycount>1
ORDER BY fr.LOG_ID,f.PLACEMENT_INSTANT

SELECT *
,postopday2_7am_begin=DATEADD(HOUR,7,postopday2_begin)
FROM #foley 
WHERE PAT_ENC_CSN_ID=112483580

SELECT * FROM dbo.CRD_ERAS_YNHGI_Case AS ceyc WHERE LOG_ID=384464

SELECT * FROM radb.dbo.vw_PatEnc AS vpe
WHERE PAT_ENC_CSN_ID=108842903




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
,		iln.FLO_MEAS_ID
,       iln.PLACEMENT_INSTANT
,       iln.REMOVAL_INSTANT
,		CASE WHEN (PLACEMENT_INSTANT >HOSP_ADMSN_TIME AND PLACEMENT_INSTANT <=outofroom )
				  AND (REMOVAL_INSTANT>=f.procedurefinish AND REMOVAL_INSTANT<DATEADD(HOUR,7,f.postopday2_begin)) THEN 1 ELSE 0 end	AS removalflag
,		CASE WHEN iln.PLACEMENT_INSTANT<f.HOSP_ADMSN_TIME THEN '*Before Admission'
			 WHEN iln.PLACEMENT_INSTANT>=f.HOSP_ADMSN_TIME AND iln.PLACEMENT_INSTANT<f.inroom THEN '*Before In room'
			 WHEN iln.PLACEMENT_INSTANT>=f.inroom AND iln.PLACEMENT_INSTANT<=f.outofroom THEN '*In room'
			 WHEN iln.PLACEMENT_INSTANT>f.outofroom THEN '*After Outofroom' END AS PlacementWindow

,		CASE WHEN iln.REMOVAL_INSTANT<f.HOSP_ADMSN_TIME THEN '*Before Admission'
			 WHEN iln.REMOVAL_INSTANT>=f.HOSP_ADMSN_TIME AND iln.REMOVAL_INSTANT<f.inroom THEN '*Before In room'
			 WHEN iln.REMOVAL_INSTANT>=f.inroom AND iln.REMOVAL_INSTANT<=f.outofroom THEN '*In room'
			 WHEN iln.REMOVAL_INSTANT>f.outofroom THEN '*After Outofroom' END AS RemovalWindow
,f.procedurestart
,f.procedurefinish
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
AND f.admissioncsn=116476396

SELECT *
FROM clarity.dbo.IP_LDA_NOADDSINGLE
WHERE IP_LDA_ID=1896153

--try to find assessment rows

SELECT fsd_id,line,OCCURANCE
FROM (
SELECT iln.IP_LDA_ID,iln.PLACEMENT_INSTANT,iln.REMOVAL_INSTANT,iln.PROPERTIES_DISPLAY,
ifm.FSD_ID,ifm.LINE,ifm.OCCURANCE,ifm.RECORDED_TIME,ifm.ENTRY_TIME,ifgd.FLO_MEAS_ID,ifgd.FLO_MEAS_NAME,ifm.MEAS_VALUE,ifm.MEAS_COMMENT
FROM clarity.dbo.IP_LDA_NOADDSINGLE AS iln
 JOIN clarity.dbo.IP_FLOWSHEET_ROWS AS ifr ON iln.IP_LDA_ID=ifr.IP_LDA_ID
 JOIN clarity.dbo.IP_FLWSHT_REC AS ifrec ON ifrec.INPATIENT_DATA_ID=ifr.INPATIENT_DATA_ID
 JOIN clarity.dbo.IP_FLWSHT_MEAS AS ifm ON ifm.FSD_ID=ifrec.FSD_ID
											AND ifr.line=ifm.OCCURANCE
 LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd ON ifgd.FLO_MEAS_ID=ifm.FLO_MEAS_ID
WHERE iln.IP_LDA_ID=1896153
)x GROUP BY fsd_id,line,OCCURANCE HAVING COUNT(*)>1


11386376