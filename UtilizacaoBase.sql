-- Valida quanto tempo uma base não foi utilizada desde a ultima vez que a instância foi reiniciada
SELECT 
    d.name AS DatabaseName,
    MAX(s.last_request_end_time) AS LastAccessTime,
    DATEDIFF(
        DAY,
        MAX(s.last_request_end_time),
        GETDATE()
    ) AS DaysWithoutUse
FROM sys.databases d
LEFT JOIN sys.dm_exec_sessions s
    ON s.database_id = d.database_id
    AND s.is_user_process = 1
GROUP BY 
    d.name
ORDER BY 
    DaysWithoutUse DESC;


-- Versão mais completa
;WITH LastAccess AS (
    SELECT 
        s.session_id,
        s.database_id,
        s.login_name,
        s.last_request_end_time,
        c.most_recent_sql_handle
    FROM sys.dm_exec_sessions s
    LEFT JOIN sys.dm_exec_connections c
        ON s.session_id = c.session_id
    WHERE
        s.is_user_process = 1
        AND s.database_id IS NOT NULL
),
Commands AS (
    SELECT
        la.database_id,
        la.login_name,
        la.last_request_end_time,
        la.most_recent_sql_handle,
        t.text AS LastCommand
    FROM LastAccess la
    OUTER APPLY sys.dm_exec_sql_text(la.most_recent_sql_handle) t
)
SELECT
    d.name AS 'Nome da Base',
    MAX(c.last_request_end_time) AS 'Ultimo Acesso',
    MAX(c.login_name) AS 'Usuário',
        CASE 
        WHEN MAX(c.last_request_end_time) IS NULL THEN NULL
        ELSE DATEDIFF(DAY, MAX(c.last_request_end_time), GETDATE())
    END AS DaysWithoutUse
FROM sys.databases d
LEFT JOIN Commands c
    ON d.database_id = c.database_id
GROUP BY 
    d.name
ORDER BY 
    DaysWithoutUse DESC, d.name;


