
sp_helptext vw_CRD_ERAS_YNHGI_Report



SELECT *
FROM radb.dbo.CRD_ERAS_YNHGI_28536_MetricFact AS ceymf


-- current architecture
--********************************

--review current structure
--do I need to revamp?
--do I need multiple date dim tables
-- separate structures for each project?
--

--tableau view
SELECT * FROM radb.dbo.vw_CRD_ERAS_BHGI_Report AS vcebr

SELECT * FROM radb.dbo.vw_CRD_ERAS_GHGI_Report AS vcegr

--metric dim


--dim tables



--master cpt list by project
SELECT * 
FROM radb.dbo.CRD_ERAS_CPT_Dim 
WHERE DeliveryNetwork='GH'

--medlist by project
SELECT m.MED_BRAND_NAME,cem.*
FROM radb.dbo.CRD_ERAS_Medlist AS cem
LEFT JOIN radb.dbo.vw_Medications AS m ON cem.ERX=m.MEDICATION_ID
ORDER BY ErasProject,DeliveryNetwork,MetricNumber


--metric dim by project
SELECT * 
FROM radb.dbo.CRD_ERAS_MetricDim AS cemd
WHERE MetricName LIKE '%foley%'
ORDER BY MetricType,MetricName
WHERE MetricName LIKE '%day%'




--flowsheet detail - can probably drop after creating.....
SELECT * 
FROM radb.dbo.CRD_ERAS_FlowDetail 

--metric date dim
SELECT *
FROM radb.dbo.CRD_ERAS_MetDate AS cemd

--base table
SELECT * 
FROM radb.dbo.CRD_ERAS_Case AS cec

--base table
SELECT * 
FROM radb.dbo.CRD_ERAS_EncDim AS ceed

--contains all the QVI's and dates
SELECT * 
FROM radb.dbo.vw_CRD_ERAS_EncDim AS vceed

--comparison between base table and case view
SELECT * 
FROM radb.dbo.CRD_ERAS_Case AS cec

--include only relevant fields for reporting 
--and user-friendly names
SELECT *
FROM radb.dbo.vw_CRD_ERAS_Case AS vcec

--metric fact
SELECT * FROM radb.dbo.CRD_ERAS_MetricDim AS cemd AS cemf


SELECT * 
FROM dbo.vw_CRD_ERAS_Report AS vcer



SELECT *
FROM radb.dbo.CRD_ERAS_YNHGI_Medlist AS ceym








--metric 17 pain
SELECT MetricNumber,MetricDescription,Route,COUNT(*)
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds
GROUP BY MetricNumber,MetricDescription,Route
ORDER BY 1,2,3


SELECT * 
FROM radb.dbo.CRD_ERAS_YNHGI_Medlist AS ceym
WHERE ERX IN (SELECT erx FROM radb.dbo.CRD_ERAS_YNHGI_Medlist GROUP BY erx HAVING COUNT(*)>1)


SELECT * 
FROM RADB.dbo.CRD_ERASYNHGI_Case



--multiple procedures detail 
SELECT NumberofProcs=COUNT(*) OVER(PARTITION BY LOG_ID),Log_ID
                                                              ,      PatientName
                                                               ,      MRN
                                                               ,      Surgery_Patient_Class
                                                               ,      OrLog_Status_C
                                                               ,      LogStatus
                                                               ,      CASE_CLASS_C
                                                               ,      CASECLASS_DESCR
                                                               ,      NUM_OF_PANELS
                                                               ,      ProcedureDisplayName
                                                               ,      ErasCase
                                                               ,      CPT_Code
															   	   ,ProcedureCategory
																	, CPTDescription
																	 ,ProcedureSubCategory
																	  ,ProcedureType								
                                                               ,      AnesCSN
                                                               ,      AdmissionCSN
                                                               ,      SurgicalCSN
                                                               ,      ProcedureName
                                                               ,      Surgery_Room_Name
                                                               ,      SurgeonName
                                                               ,      Surgeon_Role_C
                                                               ,      SurgeonRole
                                                               ,      Panel
                                                               ,      ALL_PROCS_PANEL
                                                               ,      procline
                                                               ,      SurgeryServiceName
                                                               ,      SurgeryDate
                                                               ,      SurgeryDateKey
                                                               ,      Sched_Start_Time
                                                               ,      SurgeryLocation
                                                               ,      setupstart
                                                               ,      setupend
                                                               ,      inroom
                                                               ,      outofroom
                                                               ,      cleanupstart
                                                               ,      cleanupend
                                                               ,      inpacu
                                                               ,      outofpacu
                                                               ,      inpreprocedure
                                                               ,      outofpreprocedure
                                                               ,      anesstart
                                                               ,      anesfinish
                                                               ,      procedurestart
                                                               ,      procedurefinish
                                                               ,      postopday1_begin
                                                               ,      postopday2_begin
                                                               ,      postopday3_begin
                                                               ,      postopday4_begin
                                                               ,      CaseLength_min
                                                               ,      CaseLength_hrs
                                                               ,      timeinpacu_min
                                                               
INTO ##cpt
FROM radb.dbo.vw_CRD_ERAS_YNHGI_Case
WHERE LOG_ID IN (SELECT log_id FROM radb.dbo.CRD_ERAS_YNHGI_Case GROUP BY log_Id HAVING COUNT(*)>1)
ORDER BY Log_ID







SELECT *
FROM crd_eras_case


SELECT  
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds med
JOIN RADB.dbo.CRD_ERASYNHGI_Case AS c ON med.pat_enc_csn_id = CASE 
																WHEN med.admissioncsn_flag=1 THEN c.admissioncsn
																WHEN med.anescsn_flag=1 THEN c.anescsn
																END
WHERE med.TAKEN_TIME>c.procedurefinish																
AND  med.MetricNumber=17







SELECT HOSP_ADMSN_TIME,HOSP_DISCH_TIME,NumProcs=COUNT(*) OVER(PARTITION BY LOG_ID),
LOG_ID,REAL_CPT_CODE,ProcedureType,proc_display_name,procedurename,panel,ALL_PROCS_PANEL,procline 
FROM crd_erasynhgi_case
WHERE LOG_ID IN (SELECT LOG_ID FROM crd_erasynhgi_case GROUP BY LOG_ID HAVING COUNT(*)>1)
ORDER BY LOG_ID,procline

CREATE TABLE radb.dbo.CRD_ERAS_YNHGI_MarAction
(RESULT_C INTEGER,
 MarAction VARCHAR(254),
 MarReportAction VARCHAR(254)
 )

 insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (1,'Given','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (6,'New Bag','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (7,'Restarted','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (9,'Rate Change','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (102,'Given by Other','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (105,'New Syringe/Bag','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (117,'Bolus from Bag','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (118,'Given by Other.','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (119,'Given During Downtime.','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (121,'Anesthesia Bolus','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (122,'Bolus from Syringe','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (123,'Bolus from Pump','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (124,'Bolus from Bottle','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (126,'LIP Administered','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (129,'Dose Change','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (131,'Apheresis Dual Sign','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (132,'Apheresis New Bag','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (147,'Bolus from Vial','Given')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (2,'Missed','Stopped')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (3,'Refused','Stopped')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (4,'Canceled Entry','Stopped')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (5,'Held','Stopped')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (16,'Paused','Stopped')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (99,'Automatically Held','Stopped')
insert into radb.dbo.CRD_ERAS_YNHGI_MarAction VALUES (103,'Not Given','Stopped')




SELECT *
FROM radb.dbo.CRD_ERAS_YNHGI_MedList
ORDER BY MetricNumber


SELECT *
FROM crd_eras_case

SELECT * 
FROM RADB.dbo.CRD_ERAS_YNHGI_GivenMeds


BEGIN TRAN COMMIT

WITH base AS (
SELECT rid=ROW_NUMBER() OVER(PARTITION BY erx ORDER BY erx),* 
FROM radb.dbo.CRD_ERAS_YNHGI_MedList
WHERE erx IN (
SELECT erx
FROM radb.dbo.CRD_ERAS_YNHGI_MedList
GROUP BY ERX
HAVING COUNT(*)>1
))SELECT * FROM  base
  WHERE rid>1


 SELECT *
FROM radb.dbo.


ORDER BY erx

SELECT *
FROM dbo.CRD_ERAS_YNHOBGYN_31893_MedDim AS ceymd




SELECT * FROM  radb.dbo.CRD_ERAS_YNHGI_MedList
WHERE MetricNumber=17

SELECT MetricNumber,MetricDescription,Route,COUNT(*)
FROM radb.dbo.CRD_ERAS_YNHGI_GivenMeds AS ceygm
GROUP BY MetricNumber,MetricDescription,Route
ORDER BY 1,2,3



SELECT postopday1_begin,DATEADD(HOUR,12,postopday1_begin) 
FROM crd_eras_case

IF object_id('radb.dbo.CRD_ERAS_YNHGI_Medlist') is not null
	drop table radb.dbo.CRD_ERAS_YNHGI_Medlist; 

SELECT ErasProject
,      DeliveryNetwork
,      ERX
,	   CAST( NULL AS VARCHAR(255)) AS MedType
,      MetricNumber
,      MetricDescription
,      MedicationName
,      GenericName
,      Strength
,      Route
,      Form
,      TherapeuticClass
,      PharmClass
,      PharmSubClass
,      MED_BRAND_NAME 
INTO   dbo.CRD_ERAS_YNHGI_Medlist
FROM dbo.CRD_ERAS_Medlist AS cem
WHERE ErasProject='Colon'
AND DeliveryNetwork='YNH'

SELECT *
FROM dbo.CRD_ERAS_YNHGI_Medlist
ORDER BY MetricNumber


UPDATE dbo.CRD_ERAS_YNHGI_Medlist
SET MedType='Analgesia'
WHERE MetricNumber=17

SELECT *
FROM dbo.CRD_ERAS_BHGYN_MedList AS cebml


SELECT * 
FROM RADB.dbo.CRD_ERAS_YNHGI_CptList
WHERE CPTCode IN ('45160','45126','45130')

BEGIN tran
DELETE RADB.dbo.CRD_ERAS_YNHGI_CptList
WHERE CPTCode IN ('45160','45126','45130')
COMMIT

--adhoc analysis

SELECT * 
FROM radb.dbo.CRD_ERAS_Case AS cec
WHERE LOG_ID IN (SELECT LOG_ID
FROM radb.dbo.CRD_ERAS_Case AS cecx`
GROUP BY LOG_ID HAVING COUNT(*)>1)



-- current architecture
--********************************

--review current structure
--do I need to revamp?
--do I need multiple date dim tables
-- separate structures for each project?
--


--tableau view
SELECT * FROM radb.dbo.vw_CRD_ERAS_YNHGI_Report

--metric dim


--dim tables



--master cpt list by project
SELECT * 
FROM radb.dbo.CRD_ERAS_CPT_Dim 
WHERE DeliveryNetwork='GH'

--medlist by project
SELECT m.MED_BRAND_NAME,cem.*
FROM radb.dbo.CRD_ERAS_Medlist AS cem
LEFT JOIN radb.dbo.vw_Medications AS m ON cem.ERX=m.MEDICATION_ID
ORDER BY ErasProject,DeliveryNetwork,MetricNumber


--metric dim by project
SELECT * 
FROM radb.dbo.CRD_ERAS_MetricDim AS cemd
WHERE MetricName LIKE '%foley%'
ORDER BY MetricType,MetricName
WHERE MetricName LIKE '%day%'




--flowsheet detail - can probably drop after creating.....
SELECT * 
FROM radb.dbo.CRD_ERAS_FlowDetail 

--metric date dim
SELECT *
FROM radb.dbo.CRD_ERAS_MetDate AS cemd

--base table
SELECT * 
FROM radb.dbo.CRD_ERAS_Case AS cec

--base table
SELECT * 
FROM radb.dbo.CRD_ERAS_EncDim AS ceed

--contains all the QVI's and dates
SELECT * 
FROM radb.dbo.vw_CRD_ERAS_EncDim AS vceed

--comparison between base table and case view
SELECT * 
FROM radb.dbo.CRD_ERAS_Case AS cec

--include only relevant fields for reporting 
--and user-friendly names
SELECT *
FROM radb.dbo.vw_CRD_ERAS_Case AS vcec

--metric fact
SELECT * FROM radb.dbo.CRD_ERAS_MetricFact AS cemf


SELECT * 
FROM dbo.vw_CRD_ERAS_Report AS vcer



SELECT *
FROM radb.dbo.CRD_ERAS_YNHGI_Medlist AS ceym



SELECT CPTCode
FROM dbo.CRD_ERAS_YNHGI_CptList AS a
GROUP BY CPTCode
HAVING COUNT(*)>1

--reconciliation
--all cpt codes captured?

SELECT c.*, ISNULL(d.NumberofCases,0) AS NumberofCases
FROM radb.dbo.CRD_ERAS_YNHGI_CptList AS c
LEFT JOIN (

SELECT DISTINCT REAL_CPT_CODE,COUNT(*) AS NumberofCases
FROM radb.dbo.CRD_ERAS_Case AS cec
GROUP BY REAL_CPT_CODE
) AS d ON c.CPTCode=d.REAL_CPT_CODE
ORDER BY 5 desc

SELECT *
FROM dbo.CRD_ERAS_YNHGI_CptList AS a
LEFT OUTER JOIN dbo.CRD_ERAS_CPT_Dim AS b ON a.CPTCode=b.CPTCode
					AND b.DeliveryNetwork='YNH'
					AND b.ERASProject='GI'

TRUNCATE TABLE CRD_ERAS_YNHGI_CptList 

INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44140','PR PART REMOVAL COLON W ANASTOMOSIS','Other Partial Colectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44141','PR PART REMOVAL COLON W COLOSTOMY','Colectomy and Colos w/Anas')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44143','PR PART REMOVAL COLON W END COLOSTOMY','Colectomy and Colos, No Anas')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44144','PR PART REMOVAL COLON W OSTOMY/MUCOFIST','Colectomy and Colos, No Anas')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44145','PR PART REMOVAL COLON W COLOPROCTOSTOMY','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44146','PR PART REMOVAL COLON W COLOPROC,COLOST','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44147','PR PART REMOVAL COLON,ABD/TRANSANAL APP','Perineal Proctectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44150','PR REMOVAL COLON/ILEOSTOMY','Colectomy and Colos, No Anas')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44151','PR REMOVAL COLON/ILEOSTOMY,CONTINENT','Colectomy and Colos, No Anas')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44160','PR REMVL COLON & TERM ILEUM W/ILEOCOLOSTOMY','Right Colectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44204','PR LAP,SURG,COLECTOMY, PARTIAL, W/ANAST','Other Partial Colectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44205','PR LAP,SURG,COLECTOMY,W/REMVL TERM ILEUM','Right Colectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44206','PR LAP,SURG,COLECTOMY,W/END COLOST & CLOSUR','Colectomy and Colos, No Anas')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44207','PR LAP,SURG,COLECTOMY,W/ANAST','Other Partial Colectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44208','PR LAP,SURG,COLECTOMY,W/ANAST,W/COLOSTOMY','Colectomy and Colos w/Anas')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44210','PR LAP,SURG,COLECTOMY,TOTAL,W/O PROCTECTOMY','TotalColectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44620','PR CLOSE ENTEROSTOMY','Ostomy Reversal')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44625','PR CLOSE ENTEROSTOMY,RESEC+ANAST','Ostomy Reversal')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Colectomy','44626','PR CLOSE ENTEROSTOMY,RESEC+COLOREC ANAS','Ostomy Reversal')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','44155','PR REMOVAL COLON/PROCTECTOMY/ILEOSTOMY','TotalColectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','44156','PR REMOVAL COLON/PROCTEC/ILEOSTOMY CONT','TotalColectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','44157','PR REMOVAL COLON/PROCTEC/ ILEOANAL ANAST','TotalColectomyIleoAnal')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','44158','PR REMOVAL COLON/PROCTEC/ILEOANAL ANAST POUCH','TotalColectomyIleoAnal')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','44211','PR LAP,SURG,COLECTOMY,TOTAL,W/PROCTECTOMY','TotalColectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','44212','PR LAP,SURG,COLECT,TOT,W/PROCTECT,W/ILEOST','TotalColectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45110','PR PROCTECTOMY,AP RESECT+OSTOMY','APR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45111','PR PROCTECTOMY,PARTIAL','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45112','PR PROCTECTOMY,AP RESEC,PULL-THRU','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45113','PR PROCTECTOMY,PART,ILEAL RESERV','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45114','PR PROCTECTOMY,PARTIAL,ANASTOMISIS','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45116','PR PROCTECTOMY,PART,ANAST,TRANSACRL','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45119','PR PROCTECTOMY,A-P PULLTHRU W/RESERVOIR','Other')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45120','PR PROCTECTOMY,COMPLT,PULL-THRU,ANAST','Other')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45121','PR PROCTECTOMY,COMPL,COLECTOMY,BX''S','APR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45123','PR PROCTECTOMY,PART,NO ANAST,PERINEAL','APR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45126','PR PELVIC EXENTERATION','APR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45130','PR EXCIS RECTAL PROLAPSE,PERINEAL','Perineal Proctectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45135','PR EXCIS RECTAL PROLAPSE,ABD/PERINL','LAR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45160','PR EXCIS RECTAL LESION','Other')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45395','PR LAP, SURG PROCTECTOMY W COLOSTOMY','APR')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45397','PR LAP, SURG PROCTECTOMY W J-POUCH','Other')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45402','PR LAP, SURG PROCTOPEXY W/SIG RESECT','Other Partial Colectomy')
INSERT INTO dbo.CRD_ERAS_YNHGI_CptList VALUES ('Proctectomy','45550','PR REPAIR RECTUM; REMOVE SIGMOID','Other Partial Colectomy')





SELECT *
FROM radb.dbo.CRD_ERAS_BHGYN_Case 
WHERE log_id IN 
(SELECT LOG_ID
FROM radb.dbo.CRD_ERAS_BHGYN_Case AS cec
GROUP BY LOG_ID HAVING COUNT(*)>1)
ORDER BY LOG_ID


SELECT * 
FROM radb.dbo.CRD_ERAS_Medlist AS cem




SELECT *
FROM radb.dbo.CRD_ERAS_Case AS cec
WHERE log_id IN 
(SELECT LOG_ID
FROM radb.dbo.CRD_ERAS_Case AS cec
GROUP BY LOG_ID HAVING COUNT(*)>1)

SELECT * 
FROM clarity.dbo.V_LOG_TIMING_EVENTS AS vlte
WHERE LOG_ID IN (SELECT LOG_ID FROM radb.dbo.CRD_ERAS_Case_GHGI )



SELECT * FROM radb.dbo.vw_CRD_ERAS_YNHGI_Report

SELECT *
FROM radb.dbo.vw_CRD_ERAS_YNHGI_Report_Detail AS vceyrd

SELECT * FROM radb.dbo.CRD_IRTAT_Providerdim AS cip





CREATE VIEW dbo.CRD_ERAS_MetricFact
AS

SELECT --median los
		CAST('1' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter AS ERASRptGrouper
	   ,Discharge_DateKey AS DateKey
	   ,LOSDays AS Num
	   ,1 'Den'
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim
UNION ALL
SELECT --average los
		CAST('2' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,LOSDays AS Num
	   ,1 'Den'
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim

UNION ALL

SELECT --readmission rate
		CAST('3' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.HospitalWide_30DayReadmission_NUM AS Num
	   ,ah.HospitalWide_30DayReadmission_DEN AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah


--feed into Tableau

vw_CRD_ERAS_Report 


CREATE VIEW dbo.vw_CRD_ERAS_Report
as
SELECT m.MetricName
,m.MetricNumber
,m.MetricDefinition
,m.MetricCalculation
,m.MetricType
,m.TrendOrd
,dt.full_date
,dt.week_begin_date
,f.ERASRptGrouper
,f.Num
,f.Den
,c.Log_ID ,
 c.ProcedureType ,
 c.Surgery_Patient_Class ,
 c.OrLog_Status_C ,
 c.LogStatus ,
 c.CASE_CLASS_C ,
 c.CASECLASS_DESCR ,
 c.NUM_OF_PANELS ,
 c.ProcedureDisplayName ,
 c.ErasCase ,
 c.CPT_Code ,
 c.AnesCSN ,
 c.AdmissionCSN ,
 c.SurgicalCSN ,
 c.ProcedureName ,
 c.Surgery_Room_Name ,
 c.SurgeonName ,
 c.Surgeon_Role_C ,
 c.Panel ,
 c.ALL_PROCS_PANEL ,
 c.procline ,
 c.SurgeryServiceName ,
 c.SurgeryDate ,
  c.Sched_Start_Time ,
 c.SurgeryLocation ,
 c.setupstart ,
 c.setupend ,
 c.inroom ,
 c.outofroom ,
 c.cleanupstart ,
 c.cleanupend ,
 c.inpacu ,
 c.outofpacu ,
 c.inpreprocedure ,
 c.outofpreprocedure ,
 c.anesstart ,
 c.anesfinish ,
 c.procedurestart ,
 c.procedurefinish ,
 c.postopday1_begin ,
 c.postopday2_begin ,
 c.postopday3_begin ,
 c.postopday4_begin ,
 c.CaseLength_min ,
 c.CaseLength_hrs ,
 c.timeinpacu_min ,
 c.pacudelay ,
 c.preadm_counseling ,
 c.[Received pre admission counseling?] ,
 c.TemperatureInPacu ,
 c.[Normal temp on arrival to PACU?] ,
 c.NormalTempInPacu ,
 c.[Ambulate POD0?] ,
 c.ambulatepod0 ,
 c.clearliquids_3ind ,
 c.[Clear liq 3 hrs before induction?] ,
 c.clearliquids_pod0 ,
 c.[Clear liq given POD0?] ,
 c.ambulate_pod1 ,
 c.[Ambulate POD1?] ,
 c.solidfood_pod1 ,
 c.[Solid food POD1?] ,
 c.ambulate_pod2 ,
 c.[Ambulate POD2?] ,
 c.hrs_toleratediet,
 e.CSN ,
 e.HAR ,
 e.PatientName,
 e.MRN,	
 e.LOSDays ,
 e.LOSHours ,
 e.Admission_DTTM ,
 e.Admission_DT ,
 e.Discharge_DTTM ,
 e.Discharge_DT ,
 e.Discharge_DateKey ,
 e.Enc_DischargeDisposition ,
 e.PatientStatus ,
 e.BaseClass ,
 e.Enc_Pat_Class ,
 e.[Admission Type] ,
 e.HospitalWide_30DayReadmission_NUM ,
 e.HospitalWide_30DayReadmission_DEN ,
 e.NumberofProcs ,
 e.qvi_Infection ,
 e.qvi_AdverseEffects ,
 e.qvi_FallsTrauma ,
 e.qvi_ForeignObjectRetained ,
 e.qvi_PerforationLaceration ,
 e.qvi_DVTPTE ,
 e.qvi_Pneumonia ,
 e.qvi_Shock ,
 e.qvi_Any
FROM radb.dbo.CRD_ERAS_MetricDim AS m
JOIN radb.dbo.CRD_ERAS_MetDate AS dt ON m.id=dt.MetID
LEFT JOIN radb.dbo.CRD_ERAS_MetricFact AS f ON f.DateKey=dt.date_key
											AND f.MetricKey=dt.MetID
LEFT JOIN radb.dbo.vw_CRD_ERAS_Case AS c ON c.LOG_ID=f.Log_ID
LEFT JOIN radb.dbo.vw_CRD_ERAS_EncDim AS e ON e.CSN=f.PAT_ENC_CSN_ID







SELECT * FROM radb.dbo.CRD_ERAS_CPT_Dim AS cecd

--validation

SELECT * FROM radb.dbo.CRD_ERAS_Global_TimeWindows_vw 
sp_helptext CRD_ERAS_Global_TimeWindows_vw 




SELECT * FROM radb.dbo.vw_Medications AS vm
WHERE MedicationName LIKE '%decadron%'
AND route='Transdermal'
ORDER BY MedicationName

WHERE MEDICATION_ID IN (
101,
102,
150333,
18309,
18308,
18307,
25855,
25856)



SELECT * FROM radb.dbo.vw_Medications AS vm
WHERE MEDICATION_ID IN (


--BH GYN antiemetics
--zofran
27697
,94096
,27698
,18877

--scopolomine patch
,27696
,150210

--decadron:
,158712
,2151)


SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE TABLE_NAME ='vw_CRD_ERAS_EncDim'


--total cases by month year
SELECT ErasCase,YEAR(SurgeryDate),MONTH(SurgeryDate), COUNT(AdmissionCSN)
FROM radb.dbo.vw_CRD_ERAS_Case 
GROUP BY ErasCase,YEAR(SurgeryDate),MONTH(SurgeryDate)
ORDER BY 1,2,3


SELECT * 
FROM radb.dbo.CRD_ERAS_MetricFact AS cemf

sp_helptext CRD_ERAS_MetricFact



alter VIEW dbo.CRD_ERAS_MetricFact
AS

SELECT --median los
		CAST('1' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter AS ERASRptGrouper
	   ,Discharge_DateKey AS DateKey
	   ,LOSDays AS Num
	   ,1 'Den'
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim
UNION ALL
SELECT --average los
		CAST('2' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,Discharge_DateKey
	   ,LOSDays AS Num
	   ,1 'Den'
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim

UNION ALL

SELECT --readmission rate
		CAST('3' AS INT) AS 'MetricKey'
	   ,ISNULL(csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.HospitalWide_30DayReadmission_NUM AS Num
	   ,ah.HospitalWide_30DayReadmission_DEN AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah


UNION ALL

SELECT --#QVI pneumonia 
		CAST('19' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_Pneumonia AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah

UNION ALL



SELECT --#QVI pneumonia ventilator assoc 
		CAST('48' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_pnevent AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah

UNION ALL


SELECT --#QVI pneumonia aspiration
		CAST('49' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_pneasp AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah

UNION ALL


SELECT --#QVI thrombosis/embolism
		CAST('52' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_DVTPTE AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah

UNION ALL

SELECT --% QVI Thrombosis Embolism: Pulmonary:latrogenic condition
		CAST('50' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_thriat as Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah

UNION ALL

SELECT --% QVI Thrombosis Embolism: Pulmonary
		CAST('51' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_thrpulm as Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah



UNION ALL



SELECT --%QVI Any
		CAST('9' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   ,NULL AS Log_ID
	   ,ERASEncounter
	   ,ah.Discharge_DateKey
	   ,ah.qvi_Any AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim ah

UNION ALL


SELECT --% ambulate day 0
		CAST('44' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.ambulatepod0,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.ambulatepod0 AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah

UNION ALL

SELECT --ambulate pod 1
		CAST('45' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.ambulate_pod1 as Num
	   ,1 AS Den
		FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah


UNION ALL

SELECT --ambulate pod 2
		CAST('46' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.ambulate_pod2 as Num
	   ,1 AS Den
		FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah


UNION ALL

SELECT --preaadmission counseling
		CAST('41' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.preadm_counseling as Num
	   ,1 AS Den
		FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah

UNION ALL

SELECT --% liquids POD0
		CAST('47' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.clearliquids_pod0 AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah




UNION ALL

SELECT --% normal PACU temperature
		CAST('43' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.NormalTempInPacu AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah



UNION ALL

SELECT --% liquids 3 hrs before induction
		CAST('42' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,ah.clearliquids_3ind AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah






UNION ALL
SELECT --# cases
		CAST('37' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.admissioncsn,NULL) 'PAT_ENC_CSN_ID'
	   , ah.LOG_ID AS Log_ID	   
	   ,ErasCase
	   ,ah.SurgeryDateKey
	   ,1 AS Num
	   ,1 AS Den
	FROM
		 radb.dbo.vw_CRD_ERAS_Case AS ah

UNION ALL

SELECT --# encounters
		CAST('38' AS INT) AS 'MetricKey'
	   ,ISNULL(ah.csn,NULL) 'PAT_ENC_CSN_ID'
	   , NULL AS Log_ID
	   ,eras
	   ,ah.Discharge_DateKey
	   ,1 AS Num
	   ,1 AS Den
	FROM
		radb.dbo.vw_CRD_ERAS_EncDim AS  ah








SELECT * FROM dbo.CRD_ERAS_MetricDim AS cemd
ORDER BY ID




_helptext CRD_ERAS_MetricFact


SELECT * 
FROM clarity.dbo.IP_FLO_GP_DATA AS ifgd
WHERE FLO_MEAS_ID IN ('4515','5966')

SELECT * FROM radb.dbo.CRD_ERAS_Case AS cec
WHERE ErasCase='Eras case'





--SELECT * FROM RADB.dbo.CRD_ERAS_Case WHERE PAT_MRN_ID ='mr250245'




---fact musings
SELECT * 
FROM Clarity.dbo.ZC_OR_TIMING_EVENT 


				   SELECT * FROM finaldata
				   ORDER BY pat_enc_csn_id


				  SELECT * FROM base

ORDER BY PAT_ENC_CSN_ID

107674203	2015-02-03 11:00:00.000
107976406	2015-01-10 10:00:00.000
108254253	2015-01-26 08:28:00.000
108387319	2015-01-10 11:00:00.000
108512861	2015-01-07 18:00:00.000


SELECT * 
FROM radb.dbo.CRD_ERAS_Case

SELECT * FROM INFORMATION_SCHEMA.COLUMNS AS c
WHERE TABLE_NAME='CRD_ERAS_Case'



 SELECT admissioncsn,outofroom,procedurefinish,date_bowelfunction,hrs_tobowelfunction
  FROM radb.dbo.CRD_ERAS_Case
WHERE hrs_tobowelfunction<0 
 
 
 SELECT * 
 INTO ##tst
 FROM final


DECLARE @tstac AS INT=113689928

SELECT *
FROM ##tst AS t
WHERE PAT_ENC_CSN_ID=@tstac

 --return of bowel function
 SELECT *
FROM radb.dbo.CRD_ERAS_FlowDetail AS cefd
WHERE FLO_MEAS_ID IN (					'5202',     --Last Bowel Movement Date
											'4423',    --GI Signs/Symptoms
											'304340',   --"Stool Occurrence"
											'305020',   --Stool
											'661980',	--Stool output
											'664202',   --flatus
											'304351')    --"Flatus Occurrence)	  
AND PAT_ENC_CSN_ID=@tstac
ORDER BY PAT_ENC_CSN_ID,RECORDED_TIME					   
	  

	  SELECT * FROM dbo.CRD_ERAS_Case  WHERE admissioncsn=113689928


-- --return of bowel function
 SELECT *
FROM radb.dbo.CRD_ERAS_FlowDetail AS cefd
WHERE FLO_MEAS_ID IN (					'5202')

ORDER BY pat_enc_csn_id,RECORDED_TIME					   
	  


	  SELECT * from
radb.dbo.CRD_ERAS_Case










---data explations

SELECT full_date,ErasCase,MetricName,Num 
FROM radb.dbo.vw_CRD_ERAS_Report AS vcer
WHERE ErasCase='Eras Case'
AND MetricName='Total Cases'



SELECT * FROM dbo.vw_CRD_ERAS_Case AS vcec
WHERE MRN IN ('mr1284123','mr250245')

--metric 2why last liquid consumption is low - too many are too close to anes start

--the vast majority of documentations are 2 hours before anes start or closer

SELECT timediff
,count(*)
FROM (
SELECT PAT_ENC_CSN_ID,FLO_MEAS_ID,Flowsheet_DisplayName,RECORDED_TIME,anes_minus3,c.SURGERY_DATE,c.anesstart,c.anesfinish,DATEADD(HOUR,-3,c.anesstart) AS anesminus3,DATEDIFF(HOUR,anesstart,f.recorded_time) AS timediff
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE FLO_MEAS_ID IN ('1020100004','1217')) x
GROUP BY timediff
ORDER BY 1

'1020100004',  -- date of last liquied
											'1217'  ,--time of last liquid
SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 +
		  amb_adlib +      amb_bedtfchair +  amb_inroom + amb_inhall + amb_25ft + amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,*
FROM 			RADB.dbo.CRD_ERAS_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postop0=1

--pod ambulation very few pod0 ambulations
SELECT PhaseofCare_desc,COUNT(*)
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
GROUP BY PhaseofCare_desc

--PhaseofCare_desc	(No column name)
--POD0	39
--PreSurg	306
--PACU	1
--POD4 or later	1439
--POD1	358
--POD2	386

SELECT FLO_MEAS_ID,Flowsheet_DisplayName,COUNT(*)
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
GROUP BY FLO_MEAS_ID,Flowsheet_DisplayName

SELECT anes_minus3,COUNT(*)
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
GROUP BY anes_minus3

--**************************************************** end data mining

---********** end basic data analysis












SELECT COUNT(*),COUNT(DISTINCT admissioncsn) 
FROM radb.dbo.CRD_ERAS_Case AS cec
--WHERE SURGERY_DATE>='1/1/2015' AND surgery_date<'2/1/2015'
WHERE HOSP_DISCH_TIME>='1/1/2015' AND HOSP_DISCH_TIME<'2/1/2015'


SELECT * 
FROM radb.dbo.vw_LocHierarchy_Department AS vlhd
WHERE Department_Name LIKE 'ynh%' AND Department_Name LIKE '%61%'



SELECT PhaseofCare_desc,COUNT(*)
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
WHERE FLO_MEAS_ID='51'
GROUP BY PhaseofCare_desc

SELECT PAT_ENC_CSN_ID
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
WHERE FLO_MEAS_ID='51'
AND PhaseofCare_desc='POD0'
GROUP BY PAT_ENC_CSN_ID


SELECT * FROM radb.dbo.CRD_ERAS_Case AS cec



UPDATE radb.dbo.CRD_ERAS_Case 
SET clearliquids_3ind=NULL,
	clearliquids_pod0=null


SELECT * FROM radb.dbo.CRD_ERAS_Case AS cec
WHERE PAT_MRN_ID='MR3607077'


SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,c.postopday1_begin,
		totalamb=pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 +
		  amb_adlib +      amb_bedtfchair +  amb_inroom + amb_inhall + amb_25ft + amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME,c.SURGERY_DATE,c.HOSP_ADMSN_TIME,c.inroom,c.procedurefinish,c.SCHED_START_TIME,c.outofroom,
		  CASE WHEN f.RECORDED_TIME>=c.HOSP_ADMSN_TIME AND f.RECORDED_TIME<c.SCHED_START_TIME THEN 'PreSurgery' END,
		  f.*
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND (PhaseofCare_desc IS NULL OR PhaseofCare_desc ='')

UPDATE RADB.dbo.CRD_ERAS_FlowDetail 
SET =CASE WHEN pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 
			>0 THEN 1 ELSE 0 END,
	ambulate_den=CASE WHEN FLO_MEAS_ID IN ( '3047745'   --physical therapy Gait distance
										     --post void residual cath
												)
										THEN 1 ELSE 0 END ;


SELECT SCHED_START_TIME,inroom,outofroom,procedurestart,procedurefinish ,*
FROM radb.dbo.CRD_ERAS_Case AS cec

SELECT timediff
,count(*)
FROM (
SELECT PAT_ENC_CSN_ID,FLO_MEAS_ID,Flowsheet_DisplayName,RECORDED_TIME,anes_minus3,c.SURGERY_DATE,c.anesstart,c.anesfinish,DATEADD(HOUR,-3,c.anesstart) AS anesminus3,DATEDIFF(HOUR,anesstart,f.recorded_time) AS timediff
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE FLO_MEAS_ID IN ('1020100004','1217')) x
GROUP BY timediff


SELECT * FROM dbo.CRD_ERAS_Case AS cec
WHERE admissioncsn=118373732

--debug time window flowsheet entries

SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 +
		  amb_adlib +      amb_bedtfchair +  amb_inroom + amb_inhall + amb_25ft + amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME,c.SURGERY_DATE,c.HOSP_ADMSN_TIME,c.inroom,c.procedurefinish,c.SCHED_START_TIME,c.outofroom,
		  CASE WHEN f.RECORDED_TIME>=c.HOSP_ADMSN_TIME AND f.RECORDED_TIME<c.SCHED_START_TIME THEN 'PreSurgery' END,
		  f.*
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND (PhaseofCare_desc IS NULL OR PhaseofCare_desc ='')



SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 +
		  amb_adlib +      amb_bedtfchair +  amb_inroom + amb_inhall + amb_25ft + amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME,c.SURGERY_DATE,c.HOSP_ADMSN_TIME,c.inroom,c.procedurefinish,c.SCHED_START_TIME,c.outofroom,
		  CASE WHEN f.RECORDED_TIME>=c.HOSP_ADMSN_TIME AND f.RECORDED_TIME<c.SCHED_START_TIME THEN 'PreSurgery' END,
		  f.*
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')



SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_chairtobed +pt_sidesteps +pt_bedtochair+pt_5ft +pt_10ft 
		  +pt_15ft +pt_20ft +pt_25ft +pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +pt_x2 +pt_x3 +
		  amb_adlib +      amb_bedtfchair +  amb_inroom + amb_inhall + amb_25ft + amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME




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

 



SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME,cec.HOSP_DISCH_TIME,cec.postopday2_begin
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS cec ON f.PAT_ENC_CSN_ID=cec.admissioncsn
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday2=1
AND CONVERT(DATE,cec.HOSP_DISCH_TIME)=CONVERT(DATE,cec.postopday2_begin)



SELECT  PAT_ENC_CSN_ID,PhaseofCare_desc,
		totalamb=pt_50ft +pt_75ft +pt_100ft +pt_150ft +pt_200ft +pt_250ft +pt_300ft +pt_350ft +pt_400ft +
		  +amb_50ft + amb_75ft + amb_100ft +amb_200ft 
		  ,f.RECORDED_TIME
FROM RADB.dbo.CRD_ERAS_FlowDetail AS  f
WHERE f.FLO_MEAS_ID IN ('3047745','3046874')
AND postopday1=1



--select flowsheet entries for 
--'1020100004',  -- date of last liquid
--'1217'  --time of last liquid
-- give credit only where entries was in time frame - anes_minus3=1 - between midnight of surgery date
--and less than 3 hours before anesthesia start
--the count distinct flo_meas_id means both rows have to be documented
WITH baseliq AS (
SELECT PAT_ENC_CSN_ID,FLO_MEAS_ID,Flowsheet_DisplayName,RECORDED_TIME,anes_minus3,c.SURGERY_DATE,c.anesstart,c.anesfinish,DATEADD(HOUR,-3,c.anesstart) AS anesminus3,DATEDIFF(HOUR,anesstart,f.recorded_time) AS timediff
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE FLO_MEAS_ID IN ('1020100004','1217')
),rollit AS (SELECT  pat_enc_csn_id,COUNT(DISTINCT flo_meas_id) AS ct
FROM baseliq
WHERE anes_minus3=1
GROUP BY pat_enc_csn_id
)SELECT * FROM rollit


SELECT PAT_ENC_CSN_ID,FLO_MEAS_ID,Flowsheet_DisplayName,RECORDED_TIME,anes_minus3,c.SURGERY_DATE,c.anesstart,c.anesfinish,DATEADD(HOUR,-3,c.anesstart) AS anesminus3,DATEDIFF(HOUR,anesstart,f.recorded_time) AS timediff
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE FLO_MEAS_ID IN ('1020100004','1217')
ORDER BY PAT_ENC_CSN_ID,RECORDED_TIME


SELECT *
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE PAT_ENC_CSN_ID=112368792
and f.FLO_MEAS_ID IN ('1020100004','1217')
AND f.anes_minus3=1

se
112368792



SELECT PAT_ENC_CSN_ID,COUNT(DISTINCT f.FLO_MEAS_ID)
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
WHERE f.FLO_MEAS_ID IN ('1020100004','1217')
AND f.anes_minus3=1
GROUP BY PAT_ENC_CSN_ID


SELECT * 
FROM radb.dbo.CRD_ERAS_Case AS cec







---*************************************










SELECT * 
FROM radb.dbo.CRD_ERAS_Case AS cec


sp_help CRD_ERAS_FlowDetail 

SELECT * 
FROM RADB.dbo.CRD_ERAS_Case					


SELECT e.HOSP_ADMSN_TIME,f.* 
FROM RADB.dbo.CRD_ERAS_FlowDetail  AS f
LEFT JOIN radb.dbo.CRD_ERAS_EncDim AS e ON f.PAT_ENC_CSN_ID=e.PAT_ENC_CSN_ID
WHERE FLO_MEAS_ID='10713938'

SELECT ValueType ,COUNT(*)
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
GROUP BY ValueType 



SELECT FLO_MEAS_ID,Flowsheet_DisplayName,COUNT(*)
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
GROUP BY FLO_MEAS_ID,Flowsheet_DisplayName

SELECT anes_minus3,COUNT(*)
FROM  RADB.dbo.CRD_ERAS_FlowDetail 
GROUP BY anes_minus3

--why last liquid consumption is low - too many are too close to anes start
--the vast majority of documentations are 2 hours before anes start or closer

SELECT timediff
,count(*)
FROM (
SELECT PAT_ENC_CSN_ID,FLO_MEAS_ID,Flowsheet_DisplayName,RECORDED_TIME,anes_minus3,c.SURGERY_DATE,c.anesstart,c.anesfinish,DATEADD(HOUR,-3,c.anesstart) AS anesminus3,DATEDIFF(HOUR,anesstart,f.recorded_time) AS timediff
FROM  RADB.dbo.CRD_ERAS_FlowDetail AS f
LEFT JOIN radb.dbo.CRD_ERAS_Case AS c ON f.PAT_ENC_CSN_ID=c.admissioncsn
WHERE FLO_MEAS_ID IN ('1020100004','1217')) x
GROUP BY timediff

ORDER BY PAT_ENC_CSN_ID,RECORDED_TIME



SELECT * FROM ZC_OR_STATUS

select HSP_ACCOUNT_ID,PRIM_ENC_CSN_ID FROM clarity.dbo.HSP_ACCOUNT AS ha
WHERE HSP_ACCOUNT_ID=504672871

SELECT * FROM dbo.vw_PatEnc AS vpe
WHERE PAT_ENC_CSN_ID=123501972

SELECT allsurg.*
	FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
	JOIN (SELECT log_Id,MAX(line) AS maxline
		  FROM CLARITY.dbo.OR_LOG_ALL_SURG AS allsurg
		  WHERE PANEL=1
		  AND  ROLE_C=1 
		  GROUP BY log_id   ) AS maxsurg ON maxsurg.LOG_ID=allsurg.LOG_ID
											AND maxsurg.maxline=allsurg.line
	SELECT * FROM RADB.dbo.ERAS_GIall
	WHERE PROC_DISPLAY_NAME LIKE '%eras%' OR procedurename LIKE '%eras%';


	SELECT * FROM 
	RADB.dbo.CRD_ERAS_CPT_Dim 


	SELECT COUNT(*),COUNT(DISTINCT HSP_ACCOUNT_ID)

SELECT *
	FROM 
	RADB.dbo.CRD_ERAS_Case


	SELECT SURGERY_DATE,
								postopday1_begin ,
                                         postopday2_begin ,
                                         postopday3_begin ,
                                         postopday4_begin
	FROM RADB.dbo.CRD_ERAS_Case

SELECT * FROM RADB.dbo.CRD_ERAS_Case
SELECT * FROM radb.dbo.CRD_ERAS_EncDim  

--ambulation nonsense

SELECT LOG_ID ,
       PAT_ENC_CSN_ID ,
       FSD_ID ,
       LINE ,
       FLO_MEAS_ID ,
       Flowsheet_DisplayName ,
       MEAS_VALUE ,
       MEAS_NUMERIC ,
       MEAS_COMMENT ,
       RECORDED_TIME ,       
amb_adlib ,
       amb_bedtfchair ,
       amb_inroom ,
       amb_inhall ,
       amb_25ft ,
       amb_50ft ,
       amb_75ft ,
       amb_100ft ,
       amb_200ft ,
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
       ambulate_den ,
       preadmit_tm ,
       anes_minus3 ,
       preop ,
       intraop ,
       pacu ,
       postop0 ,
       postopday1 ,
       postopday2 ,
       postopday3 ,
       afterpostopday4 ,
       Postop_disch ,
       PhaseofCare_id ,
       PhaseofCare_desc,
	   admissioncsnflag ,
       anesthesiacsnflag 
FROM radb.dbo.CRD_ERAS_FlowDetail AS cefd
WHERE FLO_MEAS_ID IN ('3047745')
,'3046874')



SELECT FLO_MEAS_ID,FLO_MEAS_NAME,MEAS_VALUE,COUNT(*) FROM radb.dbo.CRD_ERAS_FlowDetail AS cefd
WHERE FLO_MEAS_ID IN ('3047745','3046874')
GROUP BY FLO_MEAS_ID,FLO_MEAS_NAME,MEAS_VALUE
ORDER BY 1,3


SELECT v.Value,s.fsd_id,s.line,
pt_bedtochair =  CASE WHEN RTRIM(LTRIM(value)) = 'bed to chair' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_chairtobed =  CASE WHEN RTRIM(LTRIM(value)) = 'chair to bed' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_sidesteps =  CASE WHEN RTRIM(LTRIM(value)) = 'sidesteps' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_5ft =  CASE WHEN RTRIM(LTRIM(value)) = '5 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_10ft =  CASE WHEN RTRIM(LTRIM(value)) = '10 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_15ft =  CASE WHEN RTRIM(LTRIM(value)) = '15 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_20ft =  CASE WHEN RTRIM(LTRIM(value)) = '20 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_25ft =  CASE WHEN RTRIM(LTRIM(value)) = '25 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_50ft =  CASE WHEN RTRIM(LTRIM(value)) = '50 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_75ft =  CASE WHEN RTRIM(LTRIM(value)) = '75 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_100ft =  CASE WHEN RTRIM(LTRIM(value)) = '100 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_150ft =  CASE WHEN RTRIM(LTRIM(value)) = '150 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_200ft =  CASE WHEN RTRIM(LTRIM(value)) = '200 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_250ft =  CASE WHEN RTRIM(LTRIM(value)) = '250 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_300ft =  CASE WHEN RTRIM(LTRIM(value)) = '300 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_350ft =  CASE WHEN RTRIM(LTRIM(value)) = '350 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_400ft =  CASE WHEN RTRIM(LTRIM(value)) = '400 feet' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_x2 =  CASE WHEN RTRIM(LTRIM(value)) = 'x2' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
pt_x3 =  CASE WHEN RTRIM(LTRIM(value)) = 'x3' AND s.flo_meas_id='3047745' THEN 1 ELSE 0 END,
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
		WHERE FLO_MEAS_ID IN ('3047745','3046874')


--purpose:
--1. pull procedures done by CPT code
--2. pull procedure name from panel screen
--3. pull all tracking events (inroom, out of room, )
--4. include the anesthesia csn from F_AN_RECORD_SUMMARY 
--5. primary surgeon only


SELECT procedurefinish,SURGERY_DATE,postopday1_begin FROM radb.dbo.CRD_ERAS_Case AS cec
SELECT * FROM 


SELECT * INTO RADB.dbo.CRD_ERAS_Case_bak FROM  RADB.dbo.CRD_ERAS_Case;


--************************* Main pull
 	
	SELECT * FROM radb.dbo.CRD_ERASProject_Dim AS cepd
	SELECT * FROM RADB.dbo.CRD_ERAS_Case


	SELECT pr.ProjectID ,
		   pr.DeliveryNetwork,
		   pr.ProjectName,
           LOG_ID ,
           ProcedureType ,
           PAT_NAME ,
           PAT_MRN_ID ,
           pat_id ,
           Surgery_pat_class_c ,
           Surgery_Patient_Class ,
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
           DateKey ,
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
           postopday1_begin ,
           postopday2_begin ,
           postopday3_begin ,
           postopday4_begin ,
           CaseLength_min ,
           CaseLength_hrs ,
           timeinpacu ,
           pacudelay ,
           preadm_counseling ,
           pacutemp ,
           ambulatepod0 ,
           clearliquids_pod0 ,
           ambulate_pod1 ,
           solidfood_pod1 ,
           ambulate_pod2 ,
           hrs_toleratediet 
	FROM RADB.dbo.CRD_ERAS_Case AS c
	LEFT JOIN radb.dbo.CRD_ERASProject_Dim AS pr ON c.ProjectID=pr.ProjectID

SELECT * 
FROM radb.dbo.CRD_ERAS_FlowDetail 
WHERE FLO_MEAS_ID='51'






sp_helptext vw_CRD_ERAS_Case

IF object_id('tempdb..#lda') is not null
	drop table #lda; 

--foley
SELECT  p.PAT_NAME
,       p.PAT_MRN_ID
,f.HOSP_ADMSN_TIME
,f.HOSP_DISCH_TIME
,f.postopday1_begin
,f.postopday2_begin
,       iln.PAT_ENC_CSN_ID
,       iln.IP_LDA_ID
,       iln.PLACEMENT_INSTANT
,		CASE WHEN iln.REMOVAL_INSTANT< f.postopday2_begin THEN 1 ELSE 0 END AS removalflag
,		CASE  WHEN CONVERT(DATE,iln.placement_instant)<CONVERT(DATE,f.hosp_admsn_time) THEN 'Pre-Adm'
			  WHEN CONVERT(DATE,iln.placement_instant)=CONVERT(DATE,f.hosp_admsn_time) THEN 'Adm'
			  WHEN CONVERT(DATE,iln.placement_instant)>CONVERT(DATE,f.hosp_admsn_time) 
					AND  CONVERT(DATE,iln.placement_instant)<CONVERT(DATE,f.postopday1_begin) THEN 'pre-pod1'
			  WHEN CONVERT(DATE,iln.placement_instant)=CONVERT(DATE,f.postopday1_begin) THEN 'pod1'
			  WHEN CONVERT(DATE,iln.placement_instant)=CONVERT(DATE,f.postopday2_begin) THEN 'pod2'
			  WHEN CONVERT(DATE,iln.placement_instant)=CONVERT(DATE,f.postopday3_begin) THEN 'pod3'
			  WHEN CONVERT(DATE,iln.placement_instant)=CONVERT(DATE,f.postopday4_begin) THEN 'pod4'
			  WHEN CONVERT(DATE,iln.placement_instant)>CONVERT(DATE,f.postopday4_begin)   
					AND CONVERT(DATE,iln.placement_instant)<CONVERT(DATE,f.HOSP_DISCH_TIME)  	THEN 'postpod4'
				WHEN CONVERT(DATE,iln.placement_instant)=CONVERT(DATE,f.HOSP_DISCH_TIME)   		THEN 'Disch'
				WHEN CONVERT(DATE,iln.placement_instant)>CONVERT(DATE,f.HOSP_DISCH_TIME)   		THEN 'PostDischarge'

				END AS placement_window
,		CASE  WHEN CONVERT(DATE,iln.removal_instant)<CONVERT(DATE,f.hosp_admsn_time) THEN 'Pre-Adm'			  
				WHEN CONVERT(DATE,iln.removal_instant)=CONVERT(DATE,f.hosp_admsn_time) THEN 'Adm'			  
					WHEN CONVERT(DATE,iln.REMOVAL_INSTANT)>CONVERT(DATE,f.hosp_admsn_time) 
					AND  CONVERT(DATE,iln.REMOVAL_INSTANT)<CONVERT(DATE,f.postopday1_begin) THEN 'pre-pod1'
			  WHEN CONVERT(DATE,iln.removal_instant)=CONVERT(DATE,f.postopday1_begin) THEN 'pod1'
			  WHEN CONVERT(DATE,iln.removal_instant)=CONVERT(DATE,f.postopday2_begin) THEN 'pod2'
			  WHEN CONVERT(DATE,iln.removal_instant)=CONVERT(DATE,f.postopday3_begin) THEN 'pod3'
			  WHEN CONVERT(DATE,iln.removal_instant)=CONVERT(DATE,f.postopday4_begin) THEN 'pod4'
			  WHEN CONVERT(DATE,iln.removal_instant)>CONVERT(DATE,f.postopday4_begin)   
					AND CONVERT(DATE,iln.removal_instant)<CONVERT(DATE,f.HOSP_DISCH_TIME)  	THEN 'postpod4'
				WHEN CONVERT(DATE,iln.removal_instant)=CONVERT(DATE,f.HOSP_DISCH_TIME)   		THEN 'Disch'
				WHEN CONVERT(DATE,iln.removal_instant)>CONVERT(DATE,f.HOSP_DISCH_TIME)   		THEN 'PostDischarge'
				END AS removal_window

				
,       iln.REMOVAL_INSTANT
,       iln.DESCRIPTION
,       iln.PROPERTIES_DISPLAY
,		iln.FSD_ID
,		ifgd.DUPLICATEABLE_YN
,		ifgd.FLO_MEAS_NAME
,		ifgd.DISP_NAME
,		rowtype=zrt.name
INTO #lda
FROM    radb.dbo.crd_eras_case f
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
       LEFT JOIN clarity.dbo.pat_enc_hsp AS peh ON f.admissioncsn = peh.PAT_ENC_CSN_ID
       JOIN clarity.dbo.PATIENT AS p ON peh.pat_id = p.PAT_ID
WHERE   iln.FLO_MEAS_ID IN ( '3048148000', '8148', '8151' )



SELECT PAT_ENC_CSN_ID,MAX(REMOVAL_INSTANT) 
FROM #lda AS l
WHERE PAT_ENC_CSN_ID IN (SELECT PAT_ENC_CSN_ID FROM #lda GROUP BY PAT_ENC_CSN_ID HAVING COUNT(*)>1)
GROUP BY PAT_ENC_CSN_ID
ORDER BY PAT_ENC_CSN_ID


SELECT *
FROM #lda AS l
WHERE PAT_ENC_CSN_ID IN (SELECT PAT_ENC_CSN_ID FROM #lda GROUP BY PAT_ENC_CSN_ID HAVING COUNT(*)>1)
ORDER BY PAT_ENC_CSN_ID,PLACEMENT_INSTANT

