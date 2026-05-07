import duckdb

con = duckdb.connect("finance.duckdb")

df = con.execute("""
    SELECT 
        f.siren,
        s.denominationUniteLegale,
        s.activitePrincipaleUniteLegale,
        s.categorieEntreprise
    FROM (
        SELECT DISTINCT siren FROM fact_finance
    ) f
    LEFT JOIN read_parquet('data/StockUniteLegale_utf8.parquet') s
    ON f.siren = s.siren
""").fetchdf()

print(df.head())
print("Nombre total entreprises :", len(df))
nb_null = df['denominationUniteLegale'].isna().sum()

print("Nombre d'entreprises NON enrichies :", nb_null)
print("Taux de couverture :", (len(df) - nb_null) / len(df))
df.to_csv("finance_project/seeds/dim_entreprise_enrichie.csv", index=False)