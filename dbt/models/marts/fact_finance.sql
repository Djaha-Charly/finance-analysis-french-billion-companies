{{ config(materialized='table') }}

WITH base AS (

    SELECT *
    FROM {{ ref('stg_ratios_finance') }}

),

enriched AS (

    SELECT
        siren,
        date_cloture_exercice,
        Chiffre_d_affaires,
        Marge_brute,
        EBE,
        EBIT,
        Resultat_net,
        Taux_d_endettement,
        Ratio_de_liquidite,
        Autonomie_financiere,
        Capacite_de_remboursement,
        Marge_EBE,
        type_bilan,
        confidentiality,

        LAG(Chiffre_d_affaires) OVER (
            PARTITION BY siren
            ORDER BY date_cloture_exercice
        ) AS CA_annee_precedente,

        (Chiffre_d_affaires - LAG(Chiffre_d_affaires) OVER (
            PARTITION BY siren
            ORDER BY date_cloture_exercice
        )) / NULLIF(LAG(Chiffre_d_affaires) OVER (
            PARTITION BY siren
            ORDER BY date_cloture_exercice
        ), 0) AS croissance_CA,

        Resultat_net / NULLIF(Chiffre_d_affaires, 0) AS marge_nette,

        CASE
            WHEN Chiffre_d_affaires > 5000000000 THEN 'Très grande entreprise'
            WHEN Chiffre_d_affaires > 2000000000 THEN 'Grande entreprise'
            ELSE 'Entreprise milliardaire'
        END AS segment_CA,

        CASE
            WHEN Resultat_net / NULLIF(Chiffre_d_affaires, 0) <= -1 THEN 1
            ELSE 0
        END AS anomalie_marge

    FROM base

)

SELECT *
FROM enriched