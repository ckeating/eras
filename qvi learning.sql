SELECT  f.HSP_ACCOUNT_ID
                    FROM    RADB.dbo.QVI_Fact f
                            LEFT JOIN RADB.dbo.QVI_Hierarchy_Dim AS d ON f.QVI_Hierarchy_Key = d.QVI_Hierarchy_Key
                    WHERE   d.QVI_Num IN ( 17, 18, 19 )


					SELECT * 
					FROM RADB.dbo.QVI_Hierarchy_Dim
					ORDER BY QVI_Num