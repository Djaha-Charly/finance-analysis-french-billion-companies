{{ config(materialized='table') }}

WITH base AS (

    SELECT *
    FROM {{ ref('fact_finance_final') }}

),

cleaned AS (

    SELECT
        *,

        EXTRACT(year FROM date_cloture_exercice) AS annee_exercice,

        CASE
            WHEN Chiffre_d_affaires IS NULL
              OR Chiffre_d_affaires = 0
            THEN NULL
            ELSE Resultat_net / Chiffre_d_affaires
        END AS marge_nette_clean,

        CASE
            WHEN CA_annee_precedente IS NULL
              OR CA_annee_precedente = 0
            THEN NULL
            ELSE (Chiffre_d_affaires - CA_annee_precedente) / CA_annee_precedente
        END AS croissance_CA_clean

    FROM base

),

flagged AS (

    SELECT
        *,

        CASE 
            WHEN annee_exercice BETWEEN 2016 AND 2024 
            THEN 1 ELSE 0 
        END AS periode_analyse_valide,

        CASE 
            WHEN Chiffre_d_affaires IS NULL
              OR Chiffre_d_affaires < 0
              OR Chiffre_d_affaires > 1000000000000      -- > 1 000 Md€

              OR Resultat_net > 100000000000             -- > 100 Md€
              OR Resultat_net < -100000000000            -- < -100 Md€

              OR marge_nette_clean > 1                   -- > 100%
              OR marge_nette_clean < -1                  -- < -100%

              OR croissance_CA_clean > 2                 -- > 200%
              OR croissance_CA_clean < -1                -- < -100%

            THEN 1 ELSE 0 
        END AS outlier_financier

    FROM cleaned

)

SELECT *
FROM flagged