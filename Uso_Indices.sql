SELECT
    i.name AS indice,
    i.type_desc AS tipo,
    COALESCE(us.user_seeks, 0) AS seeks,
    COALESCE(us.user_scans, 0) AS scans,
    COALESCE(us.user_lookups, 0) AS lookups,
    COALESCE(us.user_updates, 0) AS updates,
    us.last_user_seek,
    us.last_user_scan,
    us.last_user_lookup,
    us.last_user_update
FROM sys.indexes AS i
LEFT JOIN sys.dm_db_index_usage_stats AS us
    ON us.database_id = DB_ID()
   AND us.object_id = i.object_id
   AND us.index_id = i.index_id
WHERE i.object_id = OBJECT_ID('dbo.SIVVE_G3')
  AND i.index_id > 0
ORDER BY
    COALESCE(us.user_seeks, 0)
  + COALESCE(us.user_scans, 0)
  + COALESCE(us.user_lookups, 0) DESC
