{{ config(materialized='table') }}

SELECT
    siren,
    date_cloture_exercice,
    annee_exercice,
    Chiffre_d_affaires,
    Resultat_net,
    marge_nette_clean,
    croissance_CA_clean,
    segment_CA,
    type_bilan,
    periode_analyse_valide,
    outlier_financier

FROM {{ ref('fact_finance_analysis') }}

WHERE periode_analyse_valide = 1
  AND outlier_financier = 0