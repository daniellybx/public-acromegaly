# Acromegaly - SIASUS Data Analysis

Analysis of Brazilian public health system (SUS) data on acromegaly patients, built from **SIASUS** outpatient records: **APAC Medications (AM)** and **Outpatient Production (PA)**.

This repository focuses exclusively on the acromegaly cohort. It was split out from a larger multi-condition research repository (LEFAR/FS-UnB, CNPq) to keep the acromegaly data pipeline, notebooks, and results self-contained.

## What this repository contains

- Raw and processed SIASUS extracts (AM + PA) for acromegaly-related procedures/medications
- R notebooks that build the unified patient-level dataset, run demographic and medication-use analyses, and generate figures (Sankey and alluvial diagrams, flowcharts, tables)
- Python scripts used to download the raw data from DATASUS
- Exported tables and figures (`resultados/`)

## Repository structure

```
.
├── data/
│   ├── auxiliar/          # Reference lookup tables (e.g. municipality codes)
│   ├── raw/                # Raw SIASUS extracts downloaded from DATASUS (AM + PA)
│   └── processed/          # Cleaned/standardized CSVs, ready for analysis
│       ├── medicamentos/            # Processed APAC Medications (AM) data
│       └── producao_ambulatorial/   # Processed Outpatient Production (PA) data
├── notebooks/
│   ├── acromegalia_uniao_medicamentos.ipynb     # Main pipeline: AM+PA union, demographics, medication analysis, flowchart
│   ├── acromegalia_analise_medicamentos.ipynb   # Exploratory medication analysis
│   └── func/functions.R                          # Shared R helper functions
├── scripts/
│   ├── acromegalia_download_medicamentos.py             # Downloads APAC Medications (AM) data from DATASUS
│   └── acromegalia_download_producao_ambulatorial.py     # Downloads Outpatient Production (PA) data from DATASUS
├── resultados/             # Exported tables (.xlsx) and figures (.png)
└── requirements.txt        # Python dependencies for the download scripts
```

## Files excluded from this repository

All CSV, TXT, and XLSX data files in this repository are within GitHub's practical file-size limits and are tracked normally. The only files excluded via [.gitignore](.gitignore) are 10 PNG figures larger than 10MB, all located in `resultados/`. Each is a high-resolution export of one of the three patient-level alluvial flow diagrams built in section 7.4 (7.4.2, 7.4.3, 7.4.4) of [`notebooks/acromegalia_uniao_medicamentos.ipynb`](notebooks/acromegalia_uniao_medicamentos.ipynb), re-exported at different dates as the notebook was re-run; that is why several files share the same content but different filenames/dates. They are large because each renders hundreds of individual patient flow ribbons at high resolution.

To regenerate any of them locally, run the corresponding section of that notebook.

| File name | Path | Variables represented |
|---|---|---|
| `20251218_dados2024_acromegalia_grafico_alluvial.png` | `resultados/20251218_dados2024_acromegalia_grafico_alluvial.png` | **Mês** — calendar month (Jan–Dec 2024), one alluvial axis per month, including months with no treatment. **Medicamento padronizado** — standardized medication (active ingredient + dosage) each patient (`AP_CNSPCN`) was dispensed in that month. *(Section 7.4.2, early file naming.)* |
| `20251218_dados2024_acromegalia_grafico_alluvial_uso.png` | `resultados/20251218_dados2024_acromegalia_grafico_alluvial_uso.png` | **Mês** — calendar month (Jan–Dec 2024), restricted to months in which the patient was actually on treatment. **Medicamento padronizado** — standardized medication (active ingredient + dosage) each patient (`AP_CNSPCN`) was dispensed in that month. *(Section 7.4.3, early file naming.)* |
| `20251218_dados2024_acromegalia_alluvial_743.png` | `resultados/20251218_dados2024_acromegalia_alluvial_743.png` | Same as above — **Mês** (usage months only) and **Medicamento padronizado** per patient. *(Section 7.4.3.)* |
| `20251222_dados2024_acromegalia_alluvial_742.png` | `resultados/20251222_dados2024_acromegalia_alluvial_742.png` | **Mês** — calendar month (Jan–Dec 2024), including months with no treatment. **Medicamento padronizado** — standardized medication (active ingredient + dosage) per patient (`AP_CNSPCN`). *(Section 7.4.2.)* |
| `20251222_dados2024_acromegalia_alluvial_743.png` | `resultados/20251222_dados2024_acromegalia_alluvial_743.png` | **Mês** — calendar month, usage months only. **Medicamento padronizado** — standardized medication (active ingredient + dosage) per patient (`AP_CNSPCN`). *(Section 7.4.3.)* |
| `20260225_dados2024_acromegalia_alluvial_742.png` | `resultados/20260225_dados2024_acromegalia_alluvial_742.png` | **Mês** — calendar month, including months with no treatment. **Medicamento padronizado** — standardized medication (active ingredient + dosage) per patient (`AP_CNSPCN`). *(Section 7.4.2.)* |
| `20260225_dados2024_acromegalia_alluvial_743.png` | `resultados/20260225_dados2024_acromegalia_alluvial_743.png` | **Mês** — calendar month, usage months only. **Medicamento padronizado** — standardized medication (active ingredient + dosage) per patient (`AP_CNSPCN`). *(Section 7.4.3.)* |
| `20260720_dados2024_acromegalia_alluvial_742.png` | `resultados/20260720_dados2024_acromegalia_alluvial_742.png` | **Mês** — calendar month, including months with no treatment. **Medicamento padronizado** — standardized medication (active ingredient + dosage) per patient (`AP_CNSPCN`). *(Section 7.4.2.)* |
| `20260720_dados2024_acromegalia_alluvial_743.png` | `resultados/20260720_dados2024_acromegalia_alluvial_743.png` | **Mês** — calendar month, usage months only. **Medicamento padronizado** — standardized medication (active ingredient + dosage) per patient (`AP_CNSPCN`). *(Section 7.4.3.)* |
| `20260720_dados2024_acromegalia_alluvial_744.png` | `resultados/20260720_dados2024_acromegalia_alluvial_744.png` | **Mês** — calendar month, usage months only. **Medicamento grupo** — medications grouped by active ingredient only (Cabergoline / Lanreotide / Octreotide, dosage collapsed) per patient (`AP_CNSPCN`). *(Section 7.4.4.)* |

## Data source

Data is sourced from **DATASUS** (Brazilian Ministry of Health) via the [PySUS](https://github.com/AlertaDengue/PySUS) library, covering:

- **APAC Medications (AM)** - high-cost medication dispensing authorizations
- **Outpatient Production (PA)** - outpatient procedure records

Records are identified via SIGTAP procedure codes for acromegaly treatment medications (octreotide, lanreotide, cabergoline). Patient-level identifiers (CNS) are provided by DATASUS already de-identified/obfuscated in the source extracts.

## Getting started

### Python environment (data download)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Run the download scripts in `scripts/` to (re-)fetch raw data from DATASUS into `data/raw/`.

### R environment (analysis notebooks)

The notebooks run on an R (IRkernel) Jupyter kernel. Required packages:

```r
install.packages(c(
  "tidyverse", "lubridate", "openxlsx", "writexl",
  "ggalluvial", "ggplot2"
))
remotes::install_github("davidsjoberg/ggsankey")
```

Open `notebooks/acromegalia_uniao_medicamentos.ipynb` and run all cells, in order, from the `notebooks/` directory.

## Pipeline overview

1. **Import** - load raw AM and PA CSVs
2. **Standardize** - pad/format authorization codes, unit codes, and dates
3. **Union** - join AM and PA records by authorization, competência (billing period), and movement date
4. **Filter to 2024** - restrict the unified dataset to the analysis year
5. **Demographic analysis** - sex, age, race/ethnicity, state (UF), region
6. **Medication analysis** - combinations, most recent medication per patient, spending, Sankey/alluvial flow diagrams
7. **Discontinuation analysis** - monthly medication use, treatment abandonment
8. **Flowchart** - data construction flowchart summarizing record counts from raw load to final analytic sample

## License

This project is licensed under the GNU General Public License v3.0 - see [LICENSE](LICENSE) for details.
