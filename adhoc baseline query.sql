


SELECT * FROM 
 (
SELECT CASE WHEN SurgeryDate<'5/1/2015' THEN 'Pre-Baseline'
			WHEN SurgeryDate>='5/1/2015' AND SurgeryDate<'5/1/2016' THEN 'Baseline'
			WHEN SurgeryDate>='5/1/2016' THEN 'Performance'
			ELSE '*Unknown Period'
			END AS ReportingPeriod
	,*
	,1 AS casecount
	,CASE WHEN SurgeryLocation LIKE 'YNH%' THEN 'YSC'
		  WHEN SurgeryLocation LIKE 'SRC%' THEN 'SRC'
		  ELSE '*Unknown campus'
		  END AS Campus
FROM radb.dbo.vw_CRD_ERAS_YNHGI_Report_Detail 
)x WHERE ReportingPeriod IN ('Baseline','Performance')



SELECT * FROM vw_CRD_ERAS_YNHGI_Report_Detail