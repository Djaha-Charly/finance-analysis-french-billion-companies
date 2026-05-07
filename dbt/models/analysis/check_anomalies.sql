SELECT
    'fact_finance' AS table_name,
    COUNT(*) AS nb_anomalies
FROM {{ ref('fact_finance') }}
WHERE anomalie_marge = 1

UNION ALL

SELECT
    'fact_finance_final' AS table_name,
    COUNT(*) AS nb_anomalies
FROM {{ ref('fact_finance_final') }}
WHERE anomalie_marge = 1