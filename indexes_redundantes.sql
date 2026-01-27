WITH IndexCols AS (
    SELECT
        i.object_id,
        i.index_id,
        i.name AS index_name,
        i.type_desc,
        ic.key_ordinal,
        c.name AS column_name
    FROM sys.indexes i
    JOIN sys.index_columns ic
        ON i.object_id = ic.object_id
       AND i.index_id  = ic.index_id
    JOIN sys.columns c
        ON ic.object_id = c.object_id
       AND ic.column_id = c.column_id
    WHERE i.index_id > 0
      AND ic.is_included_column = 0
      AND i.is_hypothetical = 0
),
IndexDef AS (
    SELECT
        ic1.object_id,
        ic1.index_id,
        ic1.index_name,
        ic1.type_desc,
        STUFF((
            SELECT ',' + ic2.column_name
            FROM IndexCols ic2
            WHERE ic2.object_id = ic1.object_id
              AND ic2.index_id  = ic1.index_id
            ORDER BY ic2.key_ordinal
            FOR XML PATH(''), TYPE
        ).value('.', 'nvarchar(max)'), 1, 1, '') AS key_columns,
        COUNT(*) AS key_count
    FROM IndexCols ic1
    GROUP BY ic1.object_id, ic1.index_id, ic1.index_name, ic1.type_desc
),
IndexUsage AS (
    SELECT
        object_id,
        index_id,
        ISNULL(user_seeks,0)   AS seeks,
        ISNULL(user_scans,0)   AS scans,
        ISNULL(user_lookups,0) AS lookups,
        ISNULL(user_updates,0) AS updates
    FROM sys.dm_db_index_usage_stats
    WHERE database_id = DB_ID()
)
SELECT
    OBJECT_SCHEMA_NAME(a.object_id) AS schema_name,
    OBJECT_NAME(a.object_id)        AS table_name,
 
    a.index_name AS smaller_index,
    b.index_name AS larger_index,
 
    a.key_columns AS smaller_keys,
    b.key_columns AS larger_keys,
 
    ISNULL(iu.seeks,0) + ISNULL(iu.scans,0) + ISNULL(iu.lookups,0) AS total_reads,
    ISNULL(iu.updates,0) AS total_updates,
 
    CASE
        WHEN (ISNULL(iu.seeks,0) + ISNULL(iu.scans,0) + ISNULL(iu.lookups,0)) = 0
             AND ISNULL(iu.updates,0) > 0 THEN 100
        WHEN (ISNULL(iu.seeks,0) + ISNULL(iu.scans,0) + ISNULL(iu.lookups,0)) < 10 THEN 80
        WHEN (ISNULL(iu.seeks,0) + ISNULL(iu.scans,0) + ISNULL(iu.lookups,0)) < 100 THEN 60
        ELSE 20
    END AS removal_score,
 
    CASE
        WHEN (ISNULL(iu.seeks,0) + ISNULL(iu.scans,0) + ISNULL(iu.lookups,0)) = 0
             AND ISNULL(iu.updates,0) > 0 THEN 'FORTE candidato à remoção'
        WHEN (ISNULL(iu.seeks,0) + ISNULL(iu.scans,0) + ISNULL(iu.lookups,0)) < 10 THEN 'Candidato à remoção'
        WHEN (ISNULL(iu.seeks,0) + ISNULL(iu.scans,0) + ISNULL(iu.lookups,0)) < 100 THEN 'Avaliar'
        ELSE 'Manter'
    END AS recommendation
 
FROM IndexDef a
JOIN IndexDef b
    ON a.object_id = b.object_id
   AND a.type_desc = b.type_desc
   AND b.key_columns LIKE a.key_columns + ',%'
   AND a.key_count < b.key_count
   AND a.index_id <> b.index_id
LEFT JOIN IndexUsage iu
    ON a.object_id = iu.object_id
   AND a.index_id  = iu.index_id
ORDER BY removal_score DESC, schema_name, table_name;
 
