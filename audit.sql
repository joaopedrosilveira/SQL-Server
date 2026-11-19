USE master;
GO

CREATE SERVER AUDIT SPECIFICATION [AUDIT_LOGINS]
FOR SERVER AUDIT [AUDIT_HMLG]

ADD (SUCCESSFUL_LOGIN_GROUP),
ADD (FAILED_LOGIN_GROUP),
ADD (SERVER_OBJECT_CHANGE_GROUP),
ADD (SERVER_PERMISSION_CHANGE_GROUP),
ADD (SERVER_PRINCIPAL_CHANGE_GROUP),
ADD (DATABASE_CHANGE_GROUP)

WITH (STATE = ON);
GO

SELECT
    name,
    is_state_enabled,
    type_desc,
    on_failure_desc
FROM sys.server_audits
WHERE name = 'AUDIT_HMLG';

SELECT
    sas.name AS specification_name,
    sas.is_state_enabled,
    sa.name AS audit_name
FROM sys.server_audit_specifications sas
INNER JOIN sys.server_audits sa
    ON sas.audit_guid = sa.audit_guid
WHERE sas.name = 'AUDIT_LOGINS';

SELECT
    sas.name AS specification_name,
    d.audit_action_name,
    d.audited_result
FROM sys.server_audit_specifications sas
INNER JOIN sys.server_audit_specification_details d
    ON sas.server_specification_id = d.server_specification_id
WHERE sas.name = 'AUDIT_LOGINS';

--------------------------------------------------

SELECT
    event_time,
    action_id,
    succeeded,
    session_server_principal_name AS login_name,
    server_principal_name,
    database_name,
    object_name,
    statement,
    additional_information,
    application_name,
    client_ip
FROM msdb.dbo.rds_fn_get_audit_file(
    'D:\rdsdbdata\SQLAudit\*.sqlaudit',
    DEFAULT,
    DEFAULT
)
--WHERE server_principal_name = 'karol.abreu'
ORDER BY event_time DESC;
------------------------------------------------
SELECT
    server_principal_name,action_id,COUNT(1) as 'Quantidade de Entradas'
FROM msdb.dbo.rds_fn_get_audit_file(
    'D:\rdsdbdata\SQLAudit\*.sqlaudit',
    DEFAULT,
    DEFAULT
)
GROUP BY server_principal_name,action_id
ORDER BY 1
------------------------------------------------


ALTER SERVER AUDIT [AUDIT_HMLG]
WITH (STATE = ON);
GO

ALTER SERVER AUDIT SPECIFICATION [AUDIT_LOGINS]
WITH (STATE = ON);
GO

USE PORTAL_SOLUCOES_HMLG

ALTER DATABASE AUDIT SPECIFICATION [AUDIT_DML_PORTAL]
WITH (STATE = ON);
GO

-------------------------------------------------

USE [PORTAL_SOLUCOES_HMLG];
GO

CREATE DATABASE AUDIT SPECIFICATION [AUDIT_DML_PORTAL]
FOR SERVER AUDIT [AUDIT_HMLG]

ADD (INSERT ON DATABASE::[PORTAL_SOLUCOES_HMLG] BY [public]),
ADD (UPDATE ON DATABASE::[PORTAL_SOLUCOES_HMLG] BY [public]),
ADD (DELETE ON DATABASE::[PORTAL_SOLUCOES_HMLG] BY [public])

WITH (STATE = ON);
GO


ALTER DATABASE AUDIT SPECIFICATION [AUDIT_DML_PORTAL]
WITH (STATE = OFF);
GO


-----------------------------------------------------
USE master;
GO

ALTER SERVER AUDIT [AUDIT_HMLG]
WHERE server_principal_name <> 'NT AUTHORITY\SYSTEM';
GO
