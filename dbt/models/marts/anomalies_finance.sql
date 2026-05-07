{{ config(materialized='table') }}

SELECT
    siren,
    date_cloture_exercice,
    Chiffre_d_affaires,
    Resultat_net,
    marge_nette,
    type_bilan,
    confidentiality,
    segment_CA,
    croissance_CA
FROM {{ ref('fact_finance') }}
WHERE marge_nette IS NOT NULL
  AND marge_nette <= -1
ORDER BY marge_nette ASC