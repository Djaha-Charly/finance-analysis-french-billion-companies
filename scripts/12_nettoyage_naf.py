from pathlib import Path
import pandas as pd
import re

project_root = Path(__file__).resolve().parents[1]
file_path = project_root / "data" / "codes_naf_complet.xls"
output_path = project_root / "finance_project" / "seeds" / "dim_naf.csv"

df = pd.read_excel(file_path)

# Renommer les colonnes utiles
df = df.rename(columns={
    "Code": "code_naf",
    " Intitulés de la  NAF rév. 2, version finale ": "libelle_naf"
})

# Garder seulement les colonnes utiles
df = df[["code_naf", "libelle_naf"]].copy()

# Nettoyage espaces
df["code_naf"] = df["code_naf"].astype(str).str.strip()
df["libelle_naf"] = df["libelle_naf"].astype(str).str.strip()

# Garder seulement les codes NAF complets du type 01.11Z
pattern = r"^\d{2}\.\d{2}[A-Z]$"
df = df[df["code_naf"].str.match(pattern, na=False)]

# Supprimer doublons éventuels
df = df.drop_duplicates(subset=["code_naf"])

# Export pour dbt seed
df.to_csv(output_path, index=False, encoding="utf-8")

print("Fichier dim_naf.csv créé avec succès.")
print("Nombre de codes NAF conservés :", len(df))
print(df.head(10))