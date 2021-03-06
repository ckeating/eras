
SELECT * FROM RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact


USE [RADB]
GO
/****** Object:  StoredProcedure [dbo].[CRD_ERAS_YNHOBGYN_31893_Build_MetricFact]    Script Date: 7/11/2016 5:28:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CRD_ERAS_YNHOBGYN_31893_Build_MetricFact]
as

/*****************************************************************************************************************
Title: CRD_ERAS_YNHOBGYN_31893_MetricFact
Author: Busheydm
Created: 6/13/2016
Purpose: Gather all metrics into the value pair model for reporting

Description: This proceure applies the aggragation logic to tablulate metrics and slot them into a time period to be consumed by 
				the presentation layer (Tableau)


Updates:
	

*****************************************************************************************************************/



--RADB.[dbo].[CRD_ERAS_YNHOBGYN_31893_ProcessMetrics]
--RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact


IF OBJECT_ID(N'RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact') IS NOT NULL
BEGIN
TRUNCATE TABLE RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
End




/*****************************************************************************************************************

Outcome Metrics

*****************************************************************************************************************/
		/*****************************************************************************************************************

		Metric 1 - Average LOS

		*****************************************************************************************************************/
		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		1 'MetricKey'
		,PAT_ENC_CSN_ID
		,NULL
		,NULL
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,Discharge_DateKey 'DateKey'
		,LOS_Hours 'Num'
		,1 'Den'
		,proceduretype

		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			,MAX(LOS_Hours) 'LOS_Hours'
			,1 'Den'
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact
			GROUP BY 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			) x


		/*****************************************************************************************************************

		Metric 2 7 Day Readmission Rate

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		2 'MetricKey'
		,PAT_ENC_CSN_ID
		,NULL
		,NULL
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,Discharge_DateKey 'DateKey'
		,HospitalWide_7DayReadmission 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,MAX(HospitalWide_7DayReadmission) 'HospitalWide_7DayReadmission'
			,1 'Den'
			,prov_ID
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact
			GROUP BY 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			) x


		/*****************************************************************************************************************

		Metric 3 - 30 Day Readmission Rate

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		3 'MetricKey'
		,PAT_ENC_CSN_ID
		,NULL
		,NULL
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,Discharge_DateKey 'DateKey'
		,HospitalWide_30DayReadmission 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,MAX(HospitalWide_30DayReadmission) 'HospitalWide_30DayReadmission'
			,1 'Den'
			,prov_ID
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact
			GROUP BY 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			) x


		/*****************************************************************************************************************

		Metric 4 - ED Revisit Rate

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		4 'MetricKey'
		,PAT_ENC_CSN_ID
		,NULL
		,NULL
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,Discharge_DateKey 'DateKey'
		,ED_revisit 'Num'
		,1 'Den'
		,proceduretype

		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,MAX(ED_revisit) 'ED_revisit'
			,1 'Den'
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact
			GROUP BY 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			) x


		/*****************************************************************************************************************

		Metric 5 - QVI Infection Rate

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		5 'MetricKey'
		,PAT_ENC_CSN_ID
		,NULL
		,NULL
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,Discharge_DateKey 'DateKey'
		,QVI_Value 'Num'
		,1 'Den'
		,proceduretype

		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,MAX(QVI_Value) 'QVI_Value'
			,1 'Den'
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact
			GROUP BY 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			) x

		/*****************************************************************************************************************

		Metric 6 - ReProcedure Rate

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		6 'MetricKey'
		,PAT_ENC_CSN_ID
		,NULL
		,NULL
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,Discharge_DateKey 'DateKey'
		,ReProcedured 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,MAX(ReProcedured) 'ReProcedured'
			,1 'Den'
			,prov_ID
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact
			GROUP BY 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			) x


		/*****************************************************************************************************************

		Metric 7 - ICU Admission

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		7 'MetricKey'
		,PAT_ENC_CSN_ID
		,NULL
		,NULL
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,Discharge_DateKey 'DateKey'
		,ICU_Admit 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,MAX(ICU_Admit) 'ICU_Admit'
			,1 'Den'
			,proceduretype
			,prov_ID
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_OutcomeFact
			GROUP BY 
			PAT_ENC_CSN_ID
			,Discharge_DateKey
			,proceduretype
			,prov_ID
			) x

/*****************************************************************************************************************

Process Metrics

*****************************************************************************************************************/

		/*****************************************************************************************************************

		Metric 8 - PACU LOS

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		8 'MetricKey'
		,PAT_ENC_CSN_ID
		,LOG_ID
		,'Log_id'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PACU_LOS 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,proceduretype
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,DATEDIFF(HOUR,IN_PACU,OUT_OF_PACU) 'PACU_LOS'
			,1 'Den'
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,proceduretype
			,dbo.fn_Generate_DateKey(Surgery_date)
			,DATEDIFF(HOUR,IN_PACU,OUT_OF_PACU)
			,prov_id
			) x

	/*****************************************************************************************************************
	
	PreOp Metrics
	
	*****************************************************************************************************************/

		/*****************************************************************************************************************

		Metric 9 - Pamphlet Given

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		9 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PreOp_Pamphlet 'Num'
		,1 'Den'
		,proceduretype

		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,proceduretype
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PreOp_Pamphlet) 'PreOp_Pamphlet'
			,1 'Den'
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,proceduretype
			,dbo.fn_Generate_DateKey(Surgery_date)
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 10 - Gatorade / Apple Juice Intake

		*****************************************************************************************************************/



		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		10 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PreOp_Gatorade_AppleJuice 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,proceduretype
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PreOp_Gatorade_AppleJuice) 'PreOp_Gatorade_AppleJuice'
			,1 'Den'
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id
			) x

		/*****************************************************************************************************************

		Metric 11 - Antithrombotic Taken

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		11 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PreOp_AnthithromboticTaken 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,proceduretype
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PreOp_AnthithromboticTaken) 'PreOp_AnthithromboticTaken'
			,1 'Den'
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************
		
		Post-Op Metrics
		
		*****************************************************************************************************************/
		/*****************************************************************************************************************

		Metric 12 - post-op D0 fluid intake

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		12 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D0_FluidIntake 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D0_FluidIntake) 'PostOp_D0_FluidIntake'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x


		/*****************************************************************************************************************

		Metric 13 - POD0 Gum Chewed

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		13 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D0_GumChewed 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D0_GumChewed) 'PostOp_D0_GumChewed'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 14 - POD0 Document Diet Tolerance

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		14 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D0_DietTolerance 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D0_DietTolerance) 'PostOp_D0_DietTolerance'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 15 - POD0 Stool Ocurrence

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		15 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D0_StoolOccurrence 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D0_StoolOccurrence) 'PostOp_D0_StoolOccurrence'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 16 - PostOp_D1_SolidIntake

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		16 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D1_SolidIntake 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D1_SolidIntake) 'PostOp_D1_SolidIntake'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id
			) x

		/*****************************************************************************************************************

		Metric 17 - POD1 Fluid intake

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		17 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D1_FluidIntake 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D1_FluidIntake) 'PostOp_D1_FluidIntake'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x




		/*****************************************************************************************************************

		Metric 18 - POD1 Gum Chewed 

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		18 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D1_GumChewed 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D1_GumChewed) 'PostOp_D1_GumChewed'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 19 - POD1 Stool Occurrence  

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		19 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D1_StoolOccurrence 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D1_StoolOccurrence) 'PostOp_D1_StoolOccurrence'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 20 - POD2 Solid Intake >=75% 

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		20 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D2_DietTolerance 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D2_DietTolerance) 'PostOp_D2_DietTolerance'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x


		/*****************************************************************************************************************

		Metric 21 - POD2 11 AM Discharge

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		21 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D2_11AmDischarge 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D2_11AmDischarge) 'PostOp_D2_11AmDischarge'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id
			) x

		/*****************************************************************************************************************

		Metric 22 - POD2 11 Gum if discharged after 11am

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		22 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D2_GumChewed 'Num'
		,Den 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D2_GumChewed) 'PostOp_D2_GumChewed'
			,MAX(PostOp_D2_DischargeAfter11AM) 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			WHERE PostOp_D2_DischargeAfter11AM >= 1
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 23 - POD2 Fluid Intake

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		23 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D2_FluidIntake 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D2_FluidIntake) 'PostOp_D2_FluidIntake'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id
			) x

		/*****************************************************************************************************************

		Metric 24 - POD2 Diet Tolerance

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		24 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D2_StoolOccurrence 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D2_StoolOccurrence) 'PostOp_D2_StoolOccurrence'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id
			) x

		/*****************************************************************************************************************
		
		Post-Op Ambulation Metrics
		
		*****************************************************************************************************************/
		/*****************************************************************************************************************

		Metric 25 - post-op D0 Ambulation

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		25 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D0_Ambulation 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D0_Ambulation) 'PostOp_D0_Ambulation'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x


		/*****************************************************************************************************************

		Metric 26 - post-op D1 Ambulation

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		26 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D1_Ambulation 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D1_Ambulation) 'PostOp_D1_Ambulation'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x

		/*****************************************************************************************************************

		Metric 27 - post-op D1 Ambulation

		*****************************************************************************************************************/


		INSERT INTO RADB.dbo.CRD_ERAS_YNHOBGYN_31893_MetricFact	
		(		 MetricKey
			  ,PAT_ENC_CSN_ID
			  ,IDGroup2
			  ,IdGroup2Type
			  ,IDGroup3
			  ,IdGroup3Type
			  ,PAT_MRN_ID
			  ,DateKey
			  ,Num
			  ,Den
			  ,RptGroup1
			  )

		SELECT
		27 'MetricKey'
		,PAT_ENC_CSN_ID
		,log_ID 'IDGroup2'
		,'Log_ID' 'IdGroup2Type'
		,prov_ID
		,'Provider ID'
		,NULL 'PAT_MRN_ID'
		,x.Surgery_date 'DateKey'
		,PostOp_D2_Ambulation 'Num'
		,1 'Den'
		,proceduretype
		FROM 
			(
			SELECT 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date) 'Surgery_date'
			,MAX(PostOp_D2_Ambulation) 'PostOp_D2_Ambulation'
			,1 'Den'
			,proceduretype
			,prov_id
			From
			RADB.dbo.CRD_ERAS_YNHOBGYN_31893_ProcessMetrics
			GROUP BY 
			PAT_ENC_CSN_ID
			,LOG_ID
			,dbo.fn_Generate_DateKey(Surgery_date)
			,proceduretype
			,prov_id

			) x