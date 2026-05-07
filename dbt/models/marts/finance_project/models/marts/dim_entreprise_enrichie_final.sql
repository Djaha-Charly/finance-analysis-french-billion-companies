    {{ config(materialized='table') }}

SELECT
    e.siren,
    e.denominationUniteLegale,
    e.activitePrincipaleUniteLegale,
    e.categorieEntreprise,
    n.libelle_naf
FROM {{ ref('dim_entreprise_enrichie') }} e
LEFT JOIN {{ ref('dim_naf') }} n
    ON e.activitePrincipaleUniteLegale = n.code_naf