{{ config(materialized='table') }}

WITH source_data AS (

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
        confidentiality
    FROM read_csv_auto('../data/ratios_inpi_bce.csv')

),

filtered AS (

    SELECT *
    FROM source_data
    WHERE Chiffre_d_affaires IS NOT NULL
      AND Chiffre_d_affaires > 1000000000

),

ranked AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY siren, date_cloture_exercice
            ORDER BY
                CASE
                    WHEN type_bilan = 'K' THEN 1
                    WHEN type_bilan = 'C' THEN 2
                    WHEN type_bilan = 'S' THEN 3
                    ELSE 4
                END
        ) AS rn
    FROM filtered

)

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
    confidentiality
FROM ranked
WHERE rn = 1