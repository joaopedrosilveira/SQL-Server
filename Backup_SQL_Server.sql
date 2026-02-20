-- Comando sql server que faz o backup de todas as bases do servidor 
-- Declara as variáveis
DECLARE @NomeBanco SYSNAME,
        @CaminhoBackup NVARCHAR(400),
        @SQL NVARCHAR(MAX);

-- Cursor com os bancos
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name not in ('master','model','msdb','tempdb','DB_CNSEG','AUDITORIA_PORTAL_PRD','PORTAL_SOLUCOES_PRD')
  AND state_desc = 'ONLINE';

-- Abre o cursor
OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @NomeBanco;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Caminho do backup (somente nome do banco)
    SET @CaminhoBackup = 
        'G:\Backup_2042_20_02_2026\' + @NomeBanco + '.bak';

    -- Comando de backup
    SET @SQL = '
    BACKUP DATABASE [' + @NomeBanco + ']
    TO DISK = N''' + @CaminhoBackup + '''
    WITH 
        INIT,
        COMPRESSION,
        CHECKSUM,
        STATS = 10;
    ';

    -- Executa
    EXEC sys.sp_executesql @SQL;

    FETCH NEXT FROM db_cursor INTO @NomeBanco;
END;

-- Finaliza
CLOSE db_cursor;
DEALLOCATE db_cursor;
