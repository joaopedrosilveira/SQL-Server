-- Validando o nome dos arquivos 
SELECT 
    name AS nome_logico,
    physical_name
FROM sys.database_files;

--Validando o nome da conta SQLSERVER
SELECT 
    servicename,
    service_account
FROM sys.dm_server_services;

--Alterando o caminho do arquivo MDF
--Isso não move o arquivo ainda, só diz ao SQL Server onde ele vai procurar na próxima inicialização.
ALTER DATABASE AdventureWorks2019
MODIFY FILE (
    NAME = AdventureWorks2019,
    FILENAME = 'E:\PRD\AdventureWorks2019.mdf'
);

--Alterando o caminho do arquivo LDF
--Isso não move o arquivo ainda, só diz ao SQL Server onde ele vai procurar na próxima inicialização.
ALTER DATABASE AdventureWorks2019
MODIFY FILE (
    NAME = AdventureWorks2019_log,
    FILENAME = 'E:\PRD\AdventureWorks2019_log.ldf'
);

-- Colocando a base OFFLINE
ALTER DATABASE AdventureWorks2019 SET OFFLINE WITH ROLLBACK IMMEDIATE;

-- Mover os arquivos
Passar os arquivos MDF e LDF manualmente de uma pasta para outra

-- Colocando a base ONLINE ja com o caminho alterado
ALTER DATABASE AdventureWorks2019 SET ONLINE;
