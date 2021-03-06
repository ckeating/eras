EXEC CRD_ERASYNHGI_Masterload

SELECT * FROM dbo.CRD_ERAS_YNHGI_Case AS ceyc



USE [RADB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Purpose: create reporting data source for Clinical Redesign Yale ERAS GI dashboard
Author: Craig Keating
Date: 10/17/2016

*/

CREATE PROCEDURE [dbo].[CRD_ERASYNHGI_Masterload]--insert proc here
AS

SET NOCOUNT ON;
SET ANSI_WARNINGS OFF;


  DECLARE @Msg VARCHAR(200);
  DECLARE @Procname varchar(200);
  DECLARE @CompletionMessage VARCHAR(1000);
    
  SET @Procname='CRD_ERASYNHGI_Masterload';

BEGIN TRY

	SET @Msg = 'Begin procedure ' + @Procname;
    EXEC radb.dbo.ynhhs_logmsg @piMessage = @Msg;


--begin code

EXEC radb.dbo.CRD_ERASYNHGI_PullData;
EXEC radb.dbo.CRD_ERASYNHGI_Createfact;


--*********************************************************************************

-- Log the completion message (successful)
    
    SET @Msg =  @Procname + ' completed successfully'
    EXEC ynhhs_logmsg @piMessage = @Msg;

 -- Error handling

 END TRY
  
  BEGIN CATCH


-- Log error message

    SET @Msg = 'Error in procedure ' + @Procname ;
    EXEC ynhhs_logmsg @piMessage = @Msg;

  END CATCH



