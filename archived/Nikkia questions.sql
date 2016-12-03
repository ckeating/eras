SELECT * FROM dbo.QVI_Fact AS qf
WHERE qf.HSP_ACCOUNT_ID=300855223



--mr886676  post op wound infection

USE RADB


SELECT f.*
FROM radb.dbo.ReadmissionFact f
WHERE f.IDX_VisitNum=300873633

SELECT *
FROM radb.dbo.vw_PatEnc AS vpe
WHERE vpe.HSP_ACCOUNT_ID IN (300855223--index 
							,300891005 --ra
							)
AND vpe.encounterType='hospital encounter'


SELECT * 
FROM radb.dbo.QVI_Dim AS qd
WHERE qd.Diag_Code IN 
(
SELECT ref_bill_code FROM 
(
SELECT hspdx.HSP_ACCOUNT_ID,peh.HOSP_ADMSN_TIME,peh.HOSP_DISCH_TIME,p.PAT_NAME,p.PAT_MRN_ID,hspdx.line AS CodedDiagnosis_SeqNum,edg.REF_BILL_CODE,edg.Ref_Bill_Code_Set,edg.DX_NAME 
FROM Clarity..HSP_ACCT_DX_LIST hspdx 
   JOIN      (
	--ICD Diagnosis Data Source
                                      SELECT    edg.DX_ID
                                              , edg.REF_BILL_CODE
                                              , zc.NAME AS Ref_Bill_Code_Set
                                              , edg.DX_NAME
                                      FROM      clarity.dbo.clarity_edg AS edg
                                      JOIN      Clarity.dbo.ZC_EDG_CODE_SET zc
                                      ON        edg.REF_BILL_CODE_SET_C = zc.EDG_CODE_SET_C
                                    ) edg ON edg.dx_id=hspdx.DX_ID
LEFT JOIN clarity.dbo.HSP_ACCOUNT AS hsp ON hsp.HSP_ACCOUNT_ID=hspdx.HSP_ACCOUNT_ID
LEFT JOIN clarity.dbo.PAT_ENC_HSP AS peh ON peh.HSP_ACCOUNT_ID=hsp.HSP_ACCOUNT_ID
LEFT JOIN clarity.dbo.PATIENT AS p ON peh.PAT_ID=p.PAT_ID

WHERE hspdx.HSP_ACCOUNT_ID IN (300873633,
								300895503
							)


WHERE hspdx.HSP_ACCOUNT_ID IN (300855223--index 
							,300891005 --ra
							)

)x
)


SELECT * FROM dbo.QVI_Fact AS qf
WHERE qf.HSP_ACCOUNT_ID IN (300855223--index 
							,300891005 --ra
							)

300873633
300895503

SELECT rf.IDX_VisitNum,rf.IDX_AdmitDatm,rf.IDX_DischDatm,rf.RA_AdmitDatm,rf.RA_DischDatm,rf.RA_VisitNum,c.* 
FROM dbo.CRD_ERASOrtho_Cases AS c
LEFT JOIN radb.dbo.ReadmissionFact AS rf ON c.HSP_ACCOUNT_ID=rf.IDX_VisitNum
WHERE c.PAT_MRN_ID='mr280322'


SELECT * 

FROM dbo.CRD_ERASOrtho_Cases AS ceoc
WHERE ceoc.PAT_MRN_ID='mr280322'

SELECT * FROM 

SELECT * FROM dbo.vw_ERASOrtho AS veo
WHERE mrn='mr280322'


sp_helptext vw_ERASOrtho 