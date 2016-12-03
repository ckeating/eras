SELECT SUM(num)


SELECT met.MetricName
,	met.MetricDefinition
,met.MetricCalculation
,met.TrendOrd
,met.Grain
 md.full_date ,
 md.Day ,
 md.day_of_week ,
 md.day_num_in_month ,
 md.day_num_overall ,
 md.day_name ,
 md.day_abbrev ,
 md.weekday_flag ,
 md.week_num_in_year ,
 md.week_num_overall ,
 md.week_begin_date ,
 md.week_begin_date_key ,
 md.month ,
 md.month_num_overall ,
 md.month_name ,
 md.month_abbrev ,
 md.quarter ,
 md.year ,
 md.yearmo ,
 md.fiscal_month ,
 md.fiscal_quarter ,
 md.fiscal_year ,
 md.last_day_in_month_flag ,
 md.same_day_year_ago_date ,
 md.week_end_sat_date ,
 md.week_end_sat_date_key ,
 md.First_of_Month ,
 md.week_end_sun_date ,
 md.week_begin_date_sun,
 mf.Num,
 mf.Den,
 enc.

FROM radb.dbo.CRD_ERASOrtho_MetricDim AS met
JOIN radb.dbo.CRD_ERASOrtho_MetDate AS md ON met.ID=md.MetID 
LEFT JOIN radb.dbo.CRD_ERASOrtho_MetricFact AS mf ON mf.MetricKey=md.MetID AND mf.DateKey=md.date_key
LEFT JOIN radb.dbo.CRD_ERASOrtho_EncDim_vw AS enc ON enc.CSN=mf.PAT_ENC_CSN_ID
LEFT JOIN radb.dbo.CRD_ERASOrtho_Cases AS c ON c.PAT_ENC_CSN_ID=enc.csn
WHERE c.PAT_MRN_ID='mr38340'



SELECT *
FROM radb.dbo.CRD_ERASOrtho_EncDim_vw AS enc 
LEFT JOIN radb.dbo.CRD_ERASOrtho_Cases AS c ON c.PAT_ENC_CSN_ID=enc.csn
WHERE c.PAT_MRN_ID='mr531399'



SELECT * FROM radb.dbo.CRD_ERASOrtho_cases

EXEC radb.dbo.CRD_ERASOrtho_DateDim

sp_helptext CRD_ERASOrtho_CreateDateDim





SELECT *
--COUNT(DISTINCT pat_enc_csn_id)
INTO ##chi
from radb.dbo.CRD_ERASOrtho_MetricFact AS mf 
--LEFT JOIN radb.dbo.CRD_ERASOrtho_EncDim_vw AS enc ON enc.CSN=mf.PAT_ENC_CSN_ID
WHERE mf.MetricKey=38

WITH fixit AS (
SELECT	rid=ROW_NUMBER() OVER (PARTITION BY PAT_ENC_CSN_ID ORDER BY PAT_ENC_CSN_ID)
		,* 
FROM ##chi
)SELECT * 
FROM fixit 
WHERE fixit.PAT_ENC_CSN_ID IN (SELECT pat_enc_csn_id FROM fixit WHERE rid>1)


WITH fixit AS (
SELECT	rid=ROW_NUMBER() OVER (PARTITION BY csn ORDER BY csn)
		,* 
FROM radb.dbo.CRD_ERASOrtho_EncDim_vw
)SELECT * 
FROM fixit 
WHERE fixit.csn IN (SELECT csn FROM fixit WHERE rid>1)


WITH fixit AS (
SELECT	rid=ROW_NUMBER() OVER (PARTITION BY ceoc.PAT_ENC_CSN_ID ORDER BY ceoc.PAT_ENC_CSN_ID)
		,* 
FROM radb.dbo.CRD_ERASOrtho_Cases AS ceoc
)SELECT * 
FROM fixit 
WHERE fixit.PAT_ENC_CSN_ID IN (SELECT  PAT_ENC_CSN_ID  FROM fixit WHERE rid>1)





SELECT * 
FROM radb.dbo.CRD_ERASOrtho_MetricDim AS ceomd
WHERE me


SELECT --# encounters
		CAST('38' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   , NULL AS Log_ID
	   ,ah.DateKey
	   ,1 AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw AS  ah


SELECT [Discharge Disposition],COUNT(*)
FROM radb.dbo.CRD_ERASOrtho_EncDim_vw 
GROUP BY [Discharge Disposition]

SELECT * 
FROM dbo.CRD_ERASOrtho_Cases AS ceoc
WHERE ceoc.PAT_ENC_CSN_ID IN (SELECT PAT_ENC_CSN_ID FROM dbo.CRD_ERASOrtho_Cases GROUP BY PAT_ENC_CSN_ID HAVING COUNT(*)>1)


SELECT COUNT(*)
FROM radb.dbo.CRD_ERASOrtho_Cases AS ceoc

BEGIN tran
UPDATE dbo.CRD_ERASOrtho_MetricDim 
SET MetricCalculation='Average' WHERE id=22
SET trendord=CASE WHEN TrendOrd=-1 THEN 0 
				WHEN TrendOrd=1 THEN 1 END
ROLLBACK
				  
COMMIT

SELECT * FROM RADB.dbo.CRD_Asthma_MetDate [dbo].[CRD_Asthma_MetricDim]

USE [RADB]
GO

/****** Object:  Table [dbo].[CRD_Asthma_MetricDim]    Script Date: 1/25/2016 2:58:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[CRD_ERASOrtho_MetricDim](
	[ID] [INT]  NOT NULL,
	[MetricName] [VARCHAR](500) NULL,
	MetricDefinition VARCHAR(1000) NULL,
	[MetricCalculation] [VARCHAR](250) NULL,
	MetricType VARCHAR(250) NULL,
	[TrendOrd] [INT] NULL,
	Grain VARCHAR(250) NULL,
	Numerator VARCHAR(250) NULL,
	Denominator varchar(250) NULL,
    InProtocol varchar(250) null
) ON [PRIMARY]

GO


SELECT * FROM radb.dbo.CRD_ERASOrtho_MetricDim

TRUNCATE TABLE radb.dbo.CRD_ERASOrtho_MetricDim

SET ANSI_PADDING OFF
GO
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (1,'Median Length of stay','Median Length of stay','Median','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (2,'Average Length of stay','Average length of stay','Average','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (3,'30 day Hospital wide readmission rate','The 30 day hospital wide readmission rate','Ratio','Outcome','-1','Encounter','Total number of inpatient discharges who are eligible for readmission and who  have all-cause unplanned readmissions within 30-days of discharge.  ','Total number of inpatient discharges eligible for readmission','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (4,'# QVI – PE/DVT','The number of encounters with a QVI PE/DVT event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (5,'% QVI – PE/DVT','The percentage of encounters with a QVI PE/DVT event.','Ratio','Outcome','-1','Encounter','QVI-PE/DVT event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (6,'# QVI – Adverse Events','The number of encounters with a QVI Adverse Event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (7,'% QVI – Adverse Events','The percentage of total encounters with a QVI Adverse event','Ratio','Outcome','-1','Encounter','QVI-Adverse event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (8,'# Any QVI events','The number of encounters with any QVI event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (9,'% Any QVI events','The percentage of total encounters with any QVI  event','Ratio','Outcome','-1','Encounter','Any QVI event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (10,'# QVI – Falls Trauma','The number of encounters with a QVI Falls Trauma event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (11,'% QVI – Falls Trauma','The percentage of total encounters with a QVI Falls Trauma event','Ratio','Outcome','-1','Encounter','QVI Falls Trauma event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (12,'# QVI – Foreign Object Retained','The number of encounters with a QVI Foreign Object Retained event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (13,'% QVI – Foreign Object Retained','The percentage of total encounters with a QVI Foreign Object Retained event','Ratio','Outcome','-1','Encounter','QVI-Foreign Object Retained event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (14,'# QVI – Infection','The number of encounters with a QVI Infection event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (15,'% QVI – Infection','The percentage of total encounters with a QVI Infection event','Ratio','Outcome','-1','Encounter','QVI-Infection event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (16,'# QVI – Perforation Laceration','The number of encounters with a QVI Perforation Laceration event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (17,'% QVI – Perforation Laceration','The percentage of total encounters with a QVI Perforation Laceration event','Ratio','Outcome','-1','Encounter','QVI - Perforation Laceration event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (18,'# QVI – Pneumonia','The number of encounters with a QVI Pneumonia  event.','Sum','Outcome','-1','Encounter','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (19,'% QVI – Pneumonia','The percentage of total encounters with a QVI Pneumonia event','Ratio','Outcome','-1','Encounter','QVI Pneumonia event','Total unique encounters','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (20,'# Ambulate post op day 0','Total cases where patients are ambulated on post op day 0 ','Sum','Process','1','Case','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (21,'% Ambulate post op day 0','Total percent of cases ambulated on post op day 0 ','Ratio','Process','1','Case','Total cases patients ambulated post op day 0','Total unique cases','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (22,'Avg Transfer to Floor Delay','Time from floor hold to procedure care complete if patient time in PACU is greater than 90 minutes  ','Avg','Process','-1','Case','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (23,'# Pre-op multi modal','Total number of cases multi-modal medications are administered pre-op','Sum','Process','1','Case','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (24,'% Pre-op multi modal','Total percent of cases multi-modal medications are administred pre-op','Ratio','Process','1','Case','Total number of cases multi-modal medications are administered pre-op','Total unique cases','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (25,'# Intra-op spinal anesthesia','# of cases where spinal anesthesia administered intra-op','Sum','Process','1','Case','','','Yes')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (26,'% Intra-op spinal anesthesia','% of cases where spinal anesthesia administered intra-op','Ratio','Process','1','Case','Total cases spinal anesthesia administered','Total unique cases','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (27,'# Intra-op Intra-articular injections','Total number of cases an intra-articular injection occurred intra-op.','Sum','Process','1','Case','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (28,'% Intra-op Intra-articular injections','Total percent of cases an intra-articular injection occurred intra-op.','Ratio','Process','1','Case','Total number of cases an intra-articular injection occurred intra-op.','Total unique cases','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (29,'# Intra-op departure from protocol','# of cases either Morphine (ERX 77009) or Bupivacaine (ERX 166538) are administered intra-op.','Sum','Process','-1','Case','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (30,'% Intra-op departure from protocol','Total percent of  cases either Morphine (ERX 77009) or Bupivacaine (ERX 166538) are administered intra-op.','Ratio','Process','-1','Case','# Intra-op departure from protocol','Total unique cases','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (31,'# Post-op pain management-parenteral','Total number of cases where IV narcotics are administered post-op. ','Sum','Process','-1','Case','','','No')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (32,'% Post-op pain management-parenteral','Total percent of cases where IV narcotics are administered post-op','Ratio','Process','-1','Case','# Post op IV narcotics administered','Total unique cases','No')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (33,'# Anti-emetics post op','Total number of cases where anti-emetics are administered post-op. This is a departure from protocol, due to the specific anesthesia used','Sum','Process','-1','Case','','','No')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (34,'% Anti-emetics post op','Percent of cases where anti-emetics are administered post-op.','Ratio','Process','-1','Case','# anti emetics administered post-op','Total unique cases','no')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (35,'# Foley catheter utilization','# of cases a straight cath documented post-op','Sum','Process','1','Case','','','')
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (36,'% Foley catheter utilization','Percent of cases where a straight cati  is administered post-op.','Ratio','Process','1','Case','# straight cath documented','Total unique cases','')


INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (1,'Median Length of stay','Median Length of stay','Median','Outcome','-1','Encounter','','','')

INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (2,'Average Length of stay','Average length of stay','Average','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (3,'30 day Hospital wide readmission rate','The 30 day hospital wide readmission rate','Ratio','Outcome','-1','Encounter','Total number of inpatient discharges who are eligible for readmission and who  have all-cause unplanned readmissions within 30-days of discharge.  ','Total number of inpatient discharges eligible for readmission','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (4,'# QVI – PE/DVT','The number of encounters with a QVI PE/DVT event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (5,'% QVI – PE/DVT','The percentage of encounters with a QVI PE/DVT event.','Ratio','Outcome','-1','Encounter','QVI-PE/DVT event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (6,'# QVI – Adverse Events','The number of encounters with a QVI Adverse Event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (7,'% QVI – Adverse Events','The percentage of total encounters with a QVI Adverse event','Ratio','Outcome','-1','Encounter','QVI-Adverse event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (8,'# Any QVI events','The number of encounters with any QVI event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (9,'% Any QVI events','The percentage of total encounters with any QVI  event','Ratio','Outcome','-1','Encounter','Any QVI event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (10,'# QVI – Falls Trauma','The number of encounters with a QVI Falls Trauma event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (11,'% QVI – Falls Trauma','The percentage of total encounters with a QVI Falls Trauma event','Ratio','Outcome','-1','Encounter','QVI Falls Trauma event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (12,'# QVI – Foreign Object Retained','The number of encounters with a QVI Foreign Object Retained event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (13,'% QVI – Foreign Object Retained','The percentage of total encounters with a QVI Foreign Object Retained event','Ratio','Outcome','-1','Encounter','QVI-Foreign Object Retained event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (14,'# QVI – Infection','The number of encounters with a QVI Infection event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (15,'% QVI – Infection','The percentage of total encounters with a QVI Infection event','Ratio','Outcome','-1','Encounter','QVI-Infection event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (16,'# QVI – Perforation Laceration','The number of encounters with a QVI Perforation Laceration event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (17,'% QVI – Perforation Laceration','The percentage of total encounters with a QVI Perforation Laceration event','Ratio','Outcome','-1','Encounter','QVI - Perforation Laceration event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (18,'# QVI – Pneumonia','The number of encounters with a QVI Pneumonia  event.','Sum','Outcome','-1','Encounter','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (19,'% QVI – Pneumonia','The percentage of total encounters with a QVI Pneumonia event','Ratio','Outcome','-1','Encounter','QVI Pneumonia event','Total unique encounters','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (20,'# Ambulate post op day 0','Total cases where patients are ambulated on post op day 0 ','Sum','Process','1','Case','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (21,'% Ambulate post op day 0','Total percent of cases ambulated on post op day 0 ','Ratio','Process','1','Case','Total cases patients ambulated post op day 0','Total unique cases','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (22,'Avg Transfer to Floor Delay','Time from floor hold to procedure care complete if patient time in PACU is greater than 90 minutes  ','Avg','Process','-1','Case','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (23,'# Pre-op multi modal','Total number of cases multi-modal medications are administered pre-op','Sum','Process','1','Case','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (24,'% Pre-op multi modal','Total percent of cases multi-modal medications are administred pre-op','Ratio','Process','1','Case','Total number of cases multi-modal medications are administered pre-op','Total unique cases','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (25,'# Intra-op spinal anesthesia','# of cases where spinal anesthesia administered intra-op','Sum','Process','1','Case','','','Yes',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (26,'% Intra-op spinal anesthesia','% of cases where spinal anesthesia administered intra-op','Ratio','Process','1','Case','Total cases spinal anesthesia administered','Total unique cases','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (27,'# Intra-op Intra-articular injections','Total number of cases an intra-articular injection occurred intra-op.','Sum','Process','1','Case','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (28,'% Intra-op Intra-articular injections','Total percent of cases an intra-articular injection occurred intra-op.','Ratio','Process','1','Case','Total number of cases an intra-articular injection occurred intra-op.','Total unique cases','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (29,'# Intra-op departure from protocol','# of cases either Morphine (ERX 77009) or Bupivacaine (ERX 166538) are administered intra-op.','Sum','Process','-1','Case','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (30,'% Intra-op departure from protocol','Total percent of  cases either Morphine (ERX 77009) or Bupivacaine (ERX 166538) are administered intra-op.','Ratio','Process','-1','Case','# Intra-op departure from protocol','Total unique cases','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (31,'# Post-op pain management-parenteral','Total number of cases where IV narcotics are administered post-op. ','Sum','Process','-1','Case','','','No',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (32,'% Post-op pain management-parenteral','Total percent of cases where IV narcotics are administered post-op','Ratio','Process','-1','Case','# Post op IV narcotics administered','Total unique cases','No',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (33,'# Anti-emetics post op','Total number of cases where anti-emetics are administered post-op. This is a departure from protocol, due to the specific anesthesia used','Sum','Process','-1','Case','','','No',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (34,'% Anti-emetics post op','Percent of cases where anti-emetics are administered post-op.','Ratio','Process','-1','Case','# anti emetics administered post-op','Total unique cases','no',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (35,'# Foley catheter utilization','# of cases a straight cath documented post-op','Sum','Process','1','Case','','','',
INSERT INTO radb.dbo.CRD_ERASOrtho_MetricDim VALUES (36,'% Foley catheter utilization','Percent of cases where a straight cati  is administered post-op.','Ratio','Process','1','Case','# straight cath documented','Total unique cases','',



SELECT * FROM  radb.dbo.CRD_ERASOrtho_MetricDim

BEGIN tran
UPDATE radb.dbo.CRD_ERASOrtho_MetricDim
SET MetricDefinition='Total number of encounters'
WHERE id=38

COMMIT
sp_helptext CRD_Asthma_Build_DateDim

DECLARE @RC INT

/*******************************************************************

Rebuild the date table to incorporate any new metrics

*******************************************************************/

SELECT 'Building Date Dimension'
EXECUTE @RC = RADB.dbo.CRD_Asthma_Build_DateDim 
SELECT 'Complete - Building Date Dimension ' + CAST(@@ROWCOUNT AS VARCHAR(100)) + ' With RC: '+ CAST(@RC AS VARCHAR(10))

/*******************************************************************

Build the source Data

*******************************************************************/

IF @RC = 0
BEGIN
SELECT 'Building Data Source'
EXECUTE @RC = RADB.dbo.CRD_Asthma_Build_DataSource
SELECT 'Complete - Building Data Source ' + CAST(@@ROWCOUNT AS VARCHAR(100)) + ' With RC: '+ CAST(@RC AS VARCHAR(10))

END


/*******************************************************************

Build the Fact Table

*******************************************************************/

IF @RC = 0
BEGIN
SELECT 'Building Encounter Fact'
EXECUTE @RC = RADB.dbo.CRD_Asthma_Build_MetricFact
SELECT 'Complete - Building Encounter Fact ' + CAST(@@ROWCOUNT AS VARCHAR(100)) + ' With RC: '+ CAST(@RC AS VARCHAR(10))

END


SELECT @@ERROR
GO



--CREATE PROCEDURE dbo.CRD_Asthma_DateDim
as


/****** Script for SelectTopNRows command from SSMS  ******/


SELECT * FROM 	 RADB.dbo.CRD_ERASOrtho_MetDate 

/*I am going to recreate the date table everytime to cover for date dimension changes and metric additions / subtractions*/
IF OBJECT_ID('RADB.dbo.CRD_ERASOrtho_MetDate') IS NOT NULL
/*Then it exists*/
	DROP TABLE RADB.dbo.CRD_ERASOrtho_MetDate 

/*Recreate the table structure*/
		SELECT TOP 0 
		CAST(NULL AS INT) 'MetID'
		, CAST(NULL AS VARCHAR(500)) 'MetName'
		,DD.* 
		INTO RADB.dbo.CRD_ERASOrtho_MetDate   FROM [RADB].[dbo].[Dataview_Dim_Date] dd

/*Run the Cursor through the Metric Dim to give every metric a date in time (>=2012 <=2020).*/

		DECLARE @MetName VARCHAR(75)
		DECLARE @MetId AS int
		DECLARE Met_Cur CURSOR FOR 
		SELECT MetricName,ID FROM [RADB].[dbo].[CRD_ERASOrtho_MetricDim] ORDER BY ID
		OPEN Met_Cur

		FETCH NEXT FROM Met_Cur 
		INTO @MetName, @MetId

		WHILE @@FETCH_STATUS = 0
		BEGIN

		INSERT INTO RADB.dbo.CRD_ERASOrtho_MetDate
		SELECT 
		@MetId
		,@MetName
		,DD.*
		FROM [RADB].[dbo].[Dataview_Dim_Date] dd
		WHERE dd.full_date >= '1/1/2013' AND dd.full_date <= '1/1/2018'


			FETCH NEXT FROM Met_Cur 
			INTO @MetName, @MetId
		END 

		CLOSE Met_Cur;
		DEALLOCATE Met_Cur;



		--SELECT TOP 0 CAST(NULL AS INT) 'MetID', CAST(NULL AS VARCHAR(500)) 'MetName',* INTO RADB.dbo.CRD_Asthma_MetDate FROM [RADB].[dbo].[Dataview_Dim_Date] dd



		--SELECT * FROM RADB.dbo.CRD_Asthma_MetDate 


SELECT * FROM radb.dbo.CRD_ERASOrtho_Cases AS ceoc

--fact view

ALTER VIEW dbo.CRD_ERASOrtho_MetricFact
AS

SELECT --median los
		CAST('1' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.LOSDays AS Num
	   ,1 'Den'
	FROM
		dbo.CRD_ERASOrtho_EncDim_vw  ah
UNION ALL
SELECT --median los
		CAST('2' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.LOSDays AS Num
	   ,1 'Den'
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --readmission rate
		CAST('3' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.HospitalWide_30DayReadmission_NUM AS Num
	   ,ah.HospitalWide_30DayReadmission_DEN AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah


UNION ALL

SELECT --#QVI PED 
		CAST('4' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_DVTPTE AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --%QVI PED 
		CAST('5' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_DVTPTE AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --#QVI Adverse events 
		CAST('6' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_AdverseEffects AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --%QVI Adverse events
		CAST('7' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_AdverseEffects AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah



UNION ALL

SELECT --#QVI Any
		CAST('8' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_Any AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --%QVI Adverse events
		CAST('9' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_Any  AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah



UNION ALL

SELECT --#QVI Any
		CAST('10' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_FallsTrauma AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --%QVI Adverse events
		CAST('11' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_FallsTrauma AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah



UNION ALL

SELECT --#QVI Foreign object
		CAST('12' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_ForeignObjectRetained AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --#QVI Foreign object
		CAST('13' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_ForeignObjectRetained AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah


UNION ALL

SELECT --#QVI Infection
		CAST('14' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_Infection AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --%QVI Infection
		CAST('15' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_Infection AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah


UNION ALL

SELECT --#QVI Perforation/Laceration
		CAST('16' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_PerforationLaceration AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --%QVI Perforation/Laceration
		CAST('17' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_PerforationLaceration AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION 
		
SELECT --%QVI Pneumonia
		CAST('18' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_Pneumonia AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL
SELECT --#QVI Pneumonia
		CAST('19' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ah.DateKey
	   ,ah.qvi_Pneumonia AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw  ah

UNION ALL

SELECT --# ambulate day 0
		CAST('20' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.ambulatepod0 AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --% ambulate day 0
		CAST('21' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.ambulatepod0 AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --# AVG pacu delay
		CAST('22' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.pacudelay AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah


UNION ALL

SELECT --# pre op multi modal
		CAST('23' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.preopmultimodal AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --% pre op multi modal
		CAST('24' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.preopmultimodal AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah



UNION ALL

SELECT --# intra op spinal anesthesia
		CAST('25' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.intraop_spinalanes AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --% intra op spinal anesthesia
		CAST('26' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.intraop_spinalanes AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --# intra op intra articular injetions
		CAST('27' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.intraop_intraartic AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --# intra op intra articular injections
		CAST('28' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.intraop_intraartic AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

		

UNION ALL

SELECT --# intra op departure from protocol
		CAST('29' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.intraop_departure AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --% intra op departure from protocol
		CAST('30' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.intraop_departure AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah


UNION ALL

SELECT --# post op parenteral
		CAST('31' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.postop_painmanage_parent AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --% post op parenteral
		CAST('30' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.postop_painmanage_parent  AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --# post op anti emetics
		CAST('33' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.postop_antiemetics AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --% post op anti emetics
		CAST('34' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.postop_antiemetics  AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --# post op anti emetics
		CAST('35' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.foleycath AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL

SELECT --% post op anti emetics
		CAST('36' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,ah.foleycath AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL
SELECT --# cases
		CAST('37' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.PAT_ENC_CSN_ID,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ah.DateKey
	   ,1 AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_Cases AS ah

UNION ALL


SELECT --# encounters
		CAST('38' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   , NULL AS Log_ID
	   ,ah.DateKey
	   ,1 AS Num
	   ,1 AS Den
	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw AS  ah

UNION ALL

SELECT --% discharge to facility encounters
		CAST('39' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   , NULL AS Log_ID
	   ,ah.DateKey
	   ,CASE WHEN ah.[Discharge Disposition]='Discharge to Facility' THEN 1 ELSE 0 END AS Num
	   ,1 AS Den

	FROM
		radb.dbo.CRD_ERASOrtho_EncDim_vw AS  ah





		SELECT * FROM INFORMATION_SCHEMA.ROUTINES  WHERE ROUTINE_NAME LIKE '%CRD_ERASOrtho%'
		DROP PROCEDURE CRD_ERASOrtho_DateDim

CREATE PROCEDURE dbo.CRD_ERASOrtho_Create_DateDim
as
/****** Script for SelectTopNRows command from SSMS  ******/




/*I am going to recreate the date table everytime to cover for date dimension changes and metric additions / subtractions*/
IF OBJECT_ID('RADB.dbo.CRD_ERASOrtho_MetDate') IS NOT NULL
/*Then it exists*/
	DROP TABLE RADB.dbo.CRD_ERASOrtho_MetDate 

/*Recreate the table structure*/
		SELECT TOP 0 
		CAST(NULL AS INT) 'MetID'
		, CAST(NULL AS VARCHAR(500)) 'MetName'
		,DD.* 
		INTO RADB.dbo.CRD_ERASOrtho_MetDate   FROM [RADB].[dbo].[Dataview_Dim_Date] dd

/*Run the Cursor through the Metric Dim to give every metric a date in time (>=2012 <=2020).*/

		DECLARE @MetName VARCHAR(75)
		DECLARE @MetId AS int
		DECLARE Met_Cur CURSOR FOR 
		SELECT MetricName,ID FROM [RADB].[dbo].[CRD_ERASOrtho_MetricDim] ORDER BY ID
		OPEN Met_Cur

		FETCH NEXT FROM Met_Cur 
		INTO @MetName, @MetId

		WHILE @@FETCH_STATUS = 0
		BEGIN

		INSERT INTO RADB.dbo.CRD_ERASOrtho_MetDate
		SELECT 
		@MetId
		,@MetName
		,DD.*
		FROM [RADB].[dbo].[Dataview_Dim_Date] dd
		WHERE dd.full_date >= '1/1/2013' AND dd.full_date <= '1/1/2018'


			FETCH NEXT FROM Met_Cur 
			INTO @MetName, @MetId
		END 

		CLOSE Met_Cur;
		DEALLOCATE Met_Cur;

SELECT * FROM radb.dbo.CRD_ERASOrtho_Cases_vw

CREATE VIEW dbo.CRD_ERASOrtho_Cases_vw
AS
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
       DateKey ,
       ADMISSION_TYPE_C ,
       [Admission Type] ,
       PATIENT_STATUS_C ,
       DISCH_DISP_C ,
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
       [Case Classification] ,
       NUM_OF_PANELS ,
       PROC_DISPLAY_NAME ,
       REAL_CPT_CODE ,
       anescsn ,
       admissioncsn ,
       surgicalcsn ,
       procedurename ,
       Surgery_Room_Name ,
       SurgeonProvid ,
       SurgeonName ,
       ROLE_C ,
       PANEL ,
       ALL_PROCS_PANEL ,
       procline ,
       SurgeryServiceName ,
       SURGERY_DATE AS Surgery_DTTM,
	   CAST(SURGERY_DATE AS DATE) AS SurgeryDate,
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
       floorhold ,
       flooroffhold ,
       anesstart ,
       anesfinish ,
       procedurestart ,
       procedurefinish ,
       procedurecarecomplete ,
       postopday1_begin ,
       postopday2_begin ,
       postopday3_begin ,
       postopday4_begin ,
       timeinpacu ,
       pacudelay ,
       HospitalWide_30DayReadmission_NUM ,
       HospitalWide_30DayReadmission_DEN ,
       ambulatepod0 ,
       preopmultimodal ,
       preopmultimodal_nummeds ,
       intraop_spinalanes ,
       intraop_intraartic ,
       intraop_intraartic_nummeds ,
       intraop_departure ,
       postop_painmanage_parent ,
       postop_antiemetics ,
       foleycath 
FROM radb.dbo.CRD_ERASOrtho_Cases

SELECT * FROM INFORMATION_SCHEMA.VIEWS AS v WHERE v.TABLE_NAME LIKE '%ortho%'




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
       DateKey ,
       ADMISSION_TYPE_C ,
       [Admission Type] ,
       PATIENT_STATUS_C ,
       DISCH_DISP_C ,
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
       [Case Classification] ,
       NUM_OF_PANELS ,
       PROC_DISPLAY_NAME ,
       REAL_CPT_CODE ,
       anescsn ,
       admissioncsn ,
       surgicalcsn ,
       procedurename ,
       Surgery_Room_Name ,
       SurgeonProvid ,
       SurgeonName ,
       ROLE_C ,
       PANEL ,
       ALL_PROCS_PANEL ,
       procline ,
       SurgeryServiceName ,
       Surgery_DTTM ,
       SurgeryDate ,
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
       floorhold ,
       flooroffhold ,
       anesstart ,
       anesfinish ,
       procedurestart ,
       procedurefinish ,
       procedurecarecomplete ,
       postopday1_begin ,
       postopday2_begin ,
       postopday3_begin ,
       postopday4_begin ,
       timeinpacu ,
       pacudelay ,
       HospitalWide_30DayReadmission_NUM ,
       HospitalWide_30DayReadmission_DEN ,
       ambulatepod0 ,
       preopmultimodal ,
       preopmultimodal_nummeds ,
       intraop_spinalanes ,
       intraop_intraartic ,
       intraop_intraartic_nummeds ,
       intraop_departure ,
       postop_painmanage_parent ,
       postop_antiemetics ,
       foleycath 
FROM radb.dbo.CRD_ERASOrtho_Cases_vw
