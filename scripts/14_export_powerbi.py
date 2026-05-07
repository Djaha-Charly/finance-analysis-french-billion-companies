import duckdb
from pathlib import Path

# chemin base
db_path = Path("finance.duckdb")

# dossier export
output_dir = Path("exports_powerbi")
output_dir.mkdir(exist_ok=True)

con = duckdb.connect(db_path)

tables = [
    "fact_finance_clean_for_bi",
    "dim_entreprise_enrichie_final",
    "dim_temps"
]

for table in tables:
    df = con.execute(f"SELECT * FROM {table}").fetchdf()
    file_path = output_dir / f"{table}.csv"
    df.to_csv(file_path, index=False)
    print(f"{table} exportée vers {file_path}")