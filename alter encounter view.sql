SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
alter VIEW dbo.vw_CRD_ERAS_EncDim 
AS
SELECT  
		f.PAT_ENC_CSN_ID AS CSN ,
        f.HSP_ACCOUNT_ID AS HAR ,
        f.pat_name AS PatientName ,
        f.pat_mrn_id AS MRN ,
        f.LOSDays ,
        f.LOSHours ,
        f.HOSP_ADMSN_TIME AS Admission_DTTM ,
        CONVERT(DATE, f.HOSP_ADMSN_TIME) AS Admission_DT ,
        f.HOSP_DISCH_TIME AS Discharge_DTTM ,
        CONVERT(DATE, f.HOSP_DISCH_TIME) AS Discharge_DT ,
        f.Discharge_DateKey ,
		ERASEncounter=   CASE WHEN erasflag.erascount>0 THEN 'Eras Case' ELSE 'Non-ERAS Case' END ,
        f.Enc_DischargeDisposition ,
        f.PatientStatus ,
        f.BaseClass ,
        f.Enc_Pat_Class ,
        f.[Admission Type] ,
        f.HospitalWide_30DayReadmission_NUM ,
        f.HospitalWide_30DayReadmission_DEN ,        
        f.NumberofProcs ,
		f.ED_revisit,
		f.icuadmit,
		f.reprocedured,
        qvi_Infection = CASE WHEN qvi_inf.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                             ELSE 0
                        END ,
        qvi_AdverseEffects = CASE WHEN qvi_adv.HSP_ACCOUNT_ID IS NOT NULL
                                  THEN 1
                                  ELSE 0
                             END ,
        qvi_FallsTrauma = CASE WHEN qvi_falls.HSP_ACCOUNT_ID IS NOT NULL
                               THEN 1
                               ELSE 0
                          END ,
        qvi_ForeignObjectRetained = CASE WHEN qvi_forobject.HSP_ACCOUNT_ID IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                    END ,
        qvi_PerforationLaceration = CASE WHEN qvi_perf.HSP_ACCOUNT_ID IS NOT NULL
                                         THEN 1
                                         ELSE 0
                                    END ,
        qvi_DVTPTE = CASE WHEN qvi_dvtpte.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                          ELSE 0
                     END ,
        qvi_Pneumonia = CASE WHEN qvi_pne.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                             ELSE 0
                        END ,
        qvi_pneasp = CASE WHEN qvi_pneasp.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                          ELSE 0
                     END ,
        qvi_pnevent = CASE WHEN qvi_pnevent.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                           ELSE 0
                      END ,
        qvi_Shock = CASE WHEN qvi_shock.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                         ELSE 0
                    END ,

		qvi_thriat =  CASE WHEN qvi_thriat.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                         ELSE 0
                    END,

	qvi_thrpulm=  CASE WHEN qvi_thrpulm.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                         ELSE 0
                    END,
qvi_Surgsite = CASE WHEN qvi_surgsite.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,



        qvi_Any = CASE WHEN qvi_any.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,


		qvi_postopshock_septic=CASE WHEN 		qvi_postopshock_septic.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,

	   
		qvi_postopshock_cardiogenic=CASE WHEN 		qvi_postopshock_cardiogenic.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,



		qvi_postopshock=CASE WHEN 		qvi_postopshock.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,


		qvi_respfailure=CASE WHEN 		qvi_respfailure.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,

		qvi_infectionCAUTI=CASE WHEN 		qvi_infectionCAUTI.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,


		qvi_infectionSepsisshock=CASE WHEN 		qvi_infectionSepsisshock.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,

		qvi_infectionSepsissevere =CASE WHEN 		qvi_infectionSepsissevere .HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,


		qvi_infectionSepsis =CASE WHEN 		qvi_infectionSepsis.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,


		qvi_infectioncdiff =CASE WHEN 		qvi_infectioncdiff.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,

		qvi_infectionstaph =CASE WHEN 		qvi_infectionstaph.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,

		qvi_infectionsirs =CASE WHEN 		qvi_infectionsirs.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,
		
		qvi_delirium =CASE WHEN 		qvi_delirium.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END,

	qvi_dehiscence=CASE WHEN 		qvi_dehiscence.HSP_ACCOUNT_ID IS NOT NULL THEN 1
                       ELSE 0
                  END
		
		





FROM    RADB.dbo.CRD_ERAS_EncDim AS f 


LEFT JOIN (SELECT AdmissionCSN,SUM(CASE WHEN ErasCase='Eras Case' THEN 1 ELSE 0 END) AS erascount

					FROM radb.dbo.vw_CRD_ERAS_Case AS vcec
					GROUP BY AdmissionCSN
		  ) AS erasflag ON erasflag.AdmissionCSN=f.pat_enc_csn_id
		  --QVI infection  
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 17, 18, 19 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_inf ON f.HSP_ACCOUNT_ID = qvi_inf.HSP_ACCOUNT_ID        
  
--adverse effects  
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 28 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_adv ON f.HSP_ACCOUNT_ID = qvi_adv.HSP_ACCOUNT_ID       
          
 --falls and trauma         
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 7 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_falls ON f.HSP_ACCOUNT_ID = qvi_falls.HSP_ACCOUNT_ID       
  
--foreign object retained  
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                      LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 3 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_forobject ON f.HSP_ACCOUNT_ID = qvi_forobject.HSP_ACCOUNT_ID       
          
   --thrombosis /embolism
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 9 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_dvtpte ON f.HSP_ACCOUNT_ID = qvi_dvtpte.HSP_ACCOUNT_ID       
  
    
--perforations and lacerations            
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 4 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_perf ON f.HSP_ACCOUNT_ID = qvi_perf.HSP_ACCOUNT_ID            
  
--pneumonia        
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 11, 12 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_pne ON f.HSP_ACCOUNT_ID = qvi_pne.HSP_ACCOUNT_ID           

--pneumonia ventilator assoc
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key = 52
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_pnevent ON f.HSP_ACCOUNT_ID = qvi_pnevent.HSP_ACCOUNT_ID           


--pneumonia aspiration
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key = 51
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_pneasp ON f.HSP_ACCOUNT_ID = qvi_pneasp.HSP_ACCOUNT_ID           
	
  
--shock        
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 16 )
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_shock ON f.HSP_ACCOUNT_ID = qvi_shock.HSP_ACCOUNT_ID        
  
--any qvi        
        LEFT JOIN ( SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                    GROUP BY f.HSP_ACCOUNT_ID
                  ) qvi_any ON f.HSP_ACCOUNT_ID = qvi_any.HSP_ACCOUNT_ID      
          
		  

--Thrombosis/Embolism: Pulmonary: Iatrogenic Condition
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 61 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_thriat ON qvi_thriat.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID



--Thrombosis/Embolism: Pulmonary: Pulmonary
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 60 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_thrpulm ON qvi_thriat.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI surgical site
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 42 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_surgsite ON qvi_surgsite.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI complication - post op shock: septic
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 9 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_postopshock_septic ON qvi_postopshock_septic.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI complication - post op shock: cardiogenic
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 11 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_postopshock_cardiogenic ON qvi_postopshock_cardiogenic.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI complication - post op shock 
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 8 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_postopshock ON qvi_postopshock.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID



--QVI respiratory failure
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 55 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_respfailure ON qvi_respfailure.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID

--QVI infection CAUTI
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 65 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_infectionCAUTI ON qvi_infectionCAUTI.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI infection sepsis shock
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 39 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_infectionSepsisshock ON qvi_infectionSepsisshock.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI infection sepsis severe
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 38 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_infectionSepsissevere ON qvi_infectionSepsissevere.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID

--QVI infection sepsis 
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 37 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_infectionSepsis ON qvi_infectionSepsis.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID
		   
--QVI infection C DIFFICLE
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 36 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_infectioncdiff ON qvi_infectioncdiff.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI infection Sepsis Staph
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 40 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_infectionstaph ON qvi_infectionstaph.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI infection SIRS
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 41 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_infectionsirs ON qvi_infectionsirs.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI delirium
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 26 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_delirium ON qvi_delirium.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID


--QVI post p wound dehiscence
		LEFT JOIN (SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Hierarchy_Key IN ( 63 )
                    GROUP BY f.HSP_ACCOUNT_ID
				   ) AS qvi_dehiscence ON qvi_dehiscence.HSP_ACCOUNT_ID = f.HSP_ACCOUNT_ID



