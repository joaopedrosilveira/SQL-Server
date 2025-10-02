SELECT 
    at.transaction_id,
    at.transaction_begin_time,
    at.name AS transaction_name,
    es.session_id,
    es.login_name,
    es.status AS session_status,
    r.command,
    r.status AS request_status,
    r.blocking_session_id,
    r.wait_type,
    r.wait_time,
    r.last_wait_type
FROM sys.dm_tran_active_transactions at
JOIN sys.dm_tran_session_transactions st ON at.transaction_id = st.transaction_id
JOIN sys.dm_exec_sessions es ON st.session_id = es.session_id
LEFT JOIN sys.dm_exec_requests r ON es.session_id = r.session_id
ORDER BY at.transaction_begin_time;
