{{ config(materialized='table') }}

SELECT DISTINCT
    siren
FROM {{ ref('fact_finance') }}