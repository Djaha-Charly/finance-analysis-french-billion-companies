SELECT COUNT(DISTINCT siren) AS nb_entreprises
FROM {{ ref('fact_finance') }}