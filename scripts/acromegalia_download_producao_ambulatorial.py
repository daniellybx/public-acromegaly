import os
import glob
import pandas as pd
from pysus.online_data.SIA import download

# Caminho base para salvar os dados
base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "data", "raw"))

# Parâmetros
ufs = ["AC", "AL", "AM", "AP", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"]
anos = (2023, 2024, 2025)
meses = list(range(1, 13))
cids = ("E22", "E220")

# Garantir que a pasta de destino exista
os.makedirs(base_dir, exist_ok=True)

# Loop principal
for uf in ufs:
    for ano in anos:
        for mes in meses:
            try:
                download_result = download(states=uf, years=ano, months=mes, group="PA")
                arquivos = [download_result] if not isinstance(download_result, (list, tuple)) else list(download_result)

                for caminho in arquivos:
                    parquet_files = []

                    # Se for uma tupla de arquivos
                    if isinstance(caminho, tuple):
                        for subcaminho in caminho:
                            if os.path.isdir(subcaminho):
                                parquet_files.extend(glob.glob(os.path.join(subcaminho, "*.parquet")))
                            elif subcaminho.endswith('.parquet') and os.path.isfile(subcaminho):
                                parquet_files.append(subcaminho)
                    # Se for um caminho só
                    elif isinstance(caminho, str):
                        if os.path.isdir(caminho):
                            parquet_files.extend(glob.glob(os.path.join(caminho, "*.parquet")))
                        elif caminho.endswith('.parquet') and os.path.isfile(caminho):
                            parquet_files.append(caminho)
                    else:
                        print(f"Caminho inválido ou inesperado: {caminho}")
                        continue

                    if not parquet_files:
                        print(f"Não há arquivos .parquet para processar no caminho {caminho}")
                        continue

                    # Agora: processar cada arquivo individualmente
                    for parquet_file in parquet_files:
                        print(f"Lendo arquivo: {parquet_file}")  # 👈 Mostra cada arquivo sendo lido

                        df = pd.read_parquet(parquet_file)

                        # Filtrar CIDs
                        df["PA_CIDPRI"] = df["PA_CIDPRI"].astype(str).str.strip()
                        df["PA_CIDSEC"] = df["PA_CIDSEC"].astype(str).str.strip()
                        df_filtrado = df[df["PA_CIDPRI"].isin(cids) | df["PA_CIDSEC"].isin(cids)]

                        if not df_filtrado.empty:
                            output_file = os.path.join(base_dir, f"acromegalia_raw_producao_ambulatorial_{uf}_{ano}{str(mes).zfill(2)}.csv")
                            df_filtrado.to_csv(output_file, mode='a' if os.path.exists(output_file) else 'w', index=False, header=not os.path.exists(output_file))
                            print(f"Arquivo gerado (dados encontrados): {output_file}")
                        else:
                            print(f"Sem registros de interesse no arquivo: {parquet_file}")

            except Exception as e:
                print(f"Erro para {uf} - {ano}/{mes:02d}: {e}")
