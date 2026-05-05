-- FULL
exec msdb.dbo.rds_restore_database
    @restore_db_name = 'BAJ_PRD',
    @s3_arn_to_restore_from = 'arn:aws:s3:::cnseg-sql-hml/BAJ_PRD_FULL.bak',
	-- @with_norecovery = 1
	@type = 'FULL';

-- LOG 1
exec msdb.dbo.rds_restore_log
    @restore_db_name = 'BAJ_PRD',
    @s3_arn_to_restore_from = 'arn:aws:s3:::.../LOG_01.trn',
    @with_norecovery = 1;

-- LOG 2
exec msdb.dbo.rds_restore_log
    @restore_db_name = 'BAJ_PRD',
    @s3_arn_to_restore_from = 'arn:aws:s3:::.../LOG_02.trn',
    @with_norecovery = 1;

-- LOG 3 (último)
exec msdb.dbo.rds_restore_log
    @restore_db_name = 'BAJ_PRD',
    @s3_arn_to_restore_from = 'arn:aws:s3:::.../LOG_03.trn';


-- Verificando o andamento do Backup/Restore
exec msdb.dbo.rds_task_status;
