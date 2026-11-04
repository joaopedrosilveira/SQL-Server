USE master;
GO

--Colocar Database Online no RDS SQL Server
EXEC rdsadmin.dbo.rds_set_database_online
    N'NOME_DA_BASE';
GO
  
--Dropar Database no RDS SQL Server
EXEC msdb.dbo.rds_drop_database
    'NOME_DA_BASE';
GO

