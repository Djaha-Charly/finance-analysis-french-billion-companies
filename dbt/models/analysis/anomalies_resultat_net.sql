{{ config(materialized='view') }}

SELECT
    siren,
    date_cloture_exercice,
    Chiffre_d_affaires,
    Resultat_net,
    (Resultat_net / Chiffre_d_affaires) AS marge_nette
FROM {{ ref('fact_finance') }}
WHERE Resultat_net IS NOT NULL
  AND Resultat_net <= -1000000000
ORDER BY Resultat_net ASC