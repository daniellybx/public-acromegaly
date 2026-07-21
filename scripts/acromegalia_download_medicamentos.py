import glob
import os
import pandas as pd

from pysus.online_data.SIA import download

# Caminho base relativo à pasta onde está o script
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "data", "raw"))

# Parâmetros
ufs = ["AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"]
anos = (2023, 2024, 2025)
meses = list(range(1, 13))
cids = ("E22", "E220")

# Loop principal
for uf in ufs:
    for ano in anos:
        for mes in meses:
            try:
                download_pysus = download(states=uf, years=ano, months=mes, group="AM")
                pastas = [str(p) for p in download_pysus] if isinstance(download_pysus, list) else [str(download_pysus)]

                for pasta in pastas:
                    parquet_files = glob.glob(os.path.join(pasta, "*.parquet"))

                    if not parquet_files:
                        print(f"Não há arquivos .parquet na pasta {pasta}")
                        continue

                    df_list = [pd.read_parquet(f) for f in parquet_files]
                    df = pd.concat(df_list, ignore_index=True)

                    # Remover espaços e filtrar CID
                    df["AP_CIDPRI"] = df["AP_CIDPRI"].astype(str).str.strip()
                    df["AP_CIDSEC"] = df["AP_CIDSEC"].astype(str).str.strip()
                    df_filter = df[df["AP_CIDPRI"].isin(cids) | df["AP_CIDSEC"].isin(cids)]

                    if not df_filter.empty:
                        os.makedirs(base_dir, exist_ok=True)
                        output_file = os.path.join(base_dir, f"acromegalia_raw_medicamentos_{uf}_{ano}{str(mes).zfill(2)}.csv")
                        df_filter.to_csv(output_file, mode='a' if os.path.exists(output_file) else 'w', index=False, header=not os.path.exists(output_file))
                        print(f"Arquivo gerado com sucesso: {output_file}")
                    else:
                        print(f"Sem registros para {uf}, {ano}, {mes}")

            except Exception as e:
                print(f"Erro no download ou processamento para {uf}, {ano}, {mes}: {e}")
