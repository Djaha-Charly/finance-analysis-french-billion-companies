{{ config(materialized='table') }}

SELECT DISTINCT
    date_cloture_exercice AS date,
    EXTRACT(YEAR FROM date_cloture_exercice) AS annee,
    EXTRACT(MONTH FROM date_cloture_exercice) AS mois,
    CASE 
        WHEN EXTRACT(MONTH FROM date_cloture_exercice) IN (1,2,3) THEN 'T1'
        WHEN EXTRACT(MONTH FROM date_cloture_exercice) IN (4,5,6) THEN 'T2'
        WHEN EXTRACT(MONTH FROM date_cloture_exercice) IN (7,8,9) THEN 'T3'
        ELSE 'T4'
    END AS trimestre

FROM {{ ref('fact_finance') }}