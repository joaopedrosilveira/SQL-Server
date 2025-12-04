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
