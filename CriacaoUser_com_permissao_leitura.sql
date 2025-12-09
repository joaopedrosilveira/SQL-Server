DECLARE @DB SYSNAME;
DECLARE @SQL NVARCHAR(MAX);

DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master','tempdb','model','msdb')
      AND state_desc = 'ONLINE';

OPEN db_cursor;
FETCH NEXT FROM db_cursor INTO @DB;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '
    USE [' + @DB + '];

    -- Cria o usuário se não existir
    IF NOT EXISTS (
        SELECT 1 FROM sys.database_principals 
        WHERE name = ''karol.abreu''
    )
    BEGIN
        CREATE USER [karol.abreu] FOR LOGIN [karol.abreu];
        PRINT ''Usuário criado em ' + @DB + ''';
    END
    ELSE
    BEGIN
        PRINT ''Usuário já existia em ' + @DB + ''';
    END

    -- Adiciona ao db_datareader se ainda não for membro
    IF NOT EXISTS (
        SELECT 1
        FROM sys.database_role_members drm
        JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
        JOIN sys.database_principals m ON drm.member_principal_id = m.principal_id
        WHERE r.name = ''db_datareader''
          AND m.name = ''karol.abreu''
    )
    BEGIN
        ALTER ROLE [db_datareader] ADD MEMBER [karol.abreu];
        PRINT ''Adicionado ao db_datareader em ' + @DB + ''';
    END
    ELSE
    BEGIN
        PRINT ''Já era membro de db_datareader em ' + @DB + ''';
    END
    ';

    EXEC(@SQL);

    FETCH NEXT FROM db_cursor INTO @DB;
END

CLOSE db_cursor;
DEALLOCATE db_cursor;
