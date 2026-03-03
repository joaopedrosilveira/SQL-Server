-- Criando o linked server da instancia nomeada para a instancia default
EXEC sp_addlinkedserver  
    @server = 'LS_DEFAULT',
    @srvproduct = '',
    @provider = 'MSOLEDBSQL',
    @datasrc = 'localhost';

--Commands completed successfully.
--Completion time: 2026-03-03T16:42:46.3410968-03:00

--Configurando o login
EXEC sp_addlinkedsrvlogin  
    @rmtsrvname = 'LS_DEFAULT',
    @useself = 'false',
    @rmtuser = 'sa',
    @rmtpassword = 'Jo@o23041996';

--Commands completed successfully.
--Completion time: 2026-03-03T16:48:38.2025066-03:00

--Habilitando o RPC
EXEC sp_serveroption 'LS_DEFAULT', 'rpc out', 'true';
EXEC sp_serveroption 'LS_DEFAULT', 'data access', 'true';

--Testando o Linked Server
SELECT * 
FROM LS_DEFAULT.master.sys.databases;
