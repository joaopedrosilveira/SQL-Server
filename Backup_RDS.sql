-- Declara as variáveis
DECLARE @NomeBanco varchar(50),
        @CaminhoBackup varchar(200),
        @Data varchar(20);

-- Recupera o valor da data que o backup foi realizado
SET @Data = FORMAT(GETDATE(), 'yyyy_MM_dd');

-- Declara o cursor
DECLARE db_cursor CURSOR FOR
SELECT name
FROM sys.databases
WHERE name NOT IN ('master', 'msdb', 'tempdb', 'model', 'rdsadmin');

-- Abre o cursor
OPEN db_cursor;

-- Percorre a tabela
FETCH NEXT FROM db_cursor INTO @NomeBanco;

-- Loop
WHILE @@FETCH_STATUS = 0
BEGIN

-- Define o caminho do backup passando o ARN do bucket + data + nome do arquivo, construindo um caminho
SET @CaminhoBackup = 'arn:aws:s3:::cnseg-sql-hml/' + @Data + '/' + @NomeBanco + '.BAK';
 
-- Executar o backup com o nome do banco e o caminho dinâmico
    EXEC msdb.dbo.rds_backup_database
        @source_db_name = @NomeBanco,
        @s3_arn_to_backup_to = @CaminhoBackup,
        @type = 'FULL';

    FETCH NEXT FROM db_cursor INTO @NomeBanco;
END;

-- Fecha e desaloca
CLOSE db_cursor;
DEALLOCATE db_cursor;
