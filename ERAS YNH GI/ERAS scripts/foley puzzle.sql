--Distribution:
--PlacementWindow	(No column name)
--*In room	1097
-- NULL	10
--*Before Admission	69
--*After Outofroom	200
--*Before In room	8




SELECT 
f.LOG_ID
,f.PAT_NAME
,f.PAT_MRN_ID
,f.anescsn
,f.admissioncsn
,f.surgicalcsn
,f.HOSP_ADMSN_TIME
,f.HOSP_DISCH_TIME
,f.surgery_date
,       iln.PLACEMENT_INSTANT
,		CASE WHEN iln.REMOVAL_INSTANT>=f.postopday1_begin AND iln.REMOVAL_INSTANT< f.postopday2_begin THEN 1 ELSE 0 END AS removalflag
,       iln.REMOVAL_INSTANT
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
		 FROM RADB.dbo.CRD_ERASYNHGI_Case 		
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
AND f.admissioncsn=124479071
AND f.rid=1




SELECT 
       iln.PAT_ENC_CSN_ID AS ldacsn
,	   ids.EPT_CSN AS datastore_csn

,       iln.IP_LDA_ID
,       iln.DESCRIPTION
,       iln.PROPERTIES_DISPLAY
,		iln.FSD_ID
,		ifgd.DUPLICATEABLE_YN
,		ifgd.FLO_MEAS_NAME
,		ifgd.DISP_NAME
,		rowtype=zrt.name


FROM    clarity.dbo.IP_DATA_STORE AS ids
		JOIN clarity.dbo.IP_LDA_INPS_USED AS iliu
		ON ids.INPATIENT_DATA_ID=iliu.INP_ID
		JOIN clarity.dbo.IP_LDA_NOADDSINGLE AS iln 
				ON iln.IP_LDA_ID=iliu.IP_LDA_ID				        
		LEFT JOIN clarity.dbo.IP_FLO_GP_DATA AS ifgd
		ON iln.FLO_MEAS_ID=ifgd.FLO_MEAS_ID				
		LEFT JOIN clarity.dbo.ZC_ROW_TYP AS zrt
		ON ifgd.ROW_TYP_C=zrt.ROW_TYP_C              
WHERE   iln.FLO_MEAS_ID IN ( '3048148000', '8148', '8151' )
AND ids.EPT_CSN IN (115581632,115719674)

AND ids.EPT_CSN IN (115581632)

SELECT * 
FROM clarity.dbo.IP_DATA_STORE
WHERE EPT_CSN=119692457

SELECT * 
FROM clarity.dbo.IP_LDA_INPS_USED 
WHERE IP_LDA_ID=2107697
WHERE inp_id=20775575
--anes 119879272
--admission 119692457
--duplicate IP_LDA_ID
2107697


SELECT * 
FROM clarity.dbo.IP_LDA_NOADDSINGLE
WHERE IP_LDA_ID=2107697

SELECT *
FROM RADB.dbo.CRD_ERASYNHGI_Case f
WHERE admissioncsn=124479071