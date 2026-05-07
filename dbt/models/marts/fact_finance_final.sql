{{ config(materialized='table') }}

SELECT *
FROM {{ ref('fact_finance') }}
WHERE anomalie_marge = 0