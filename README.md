# Acromegaly - SIASUS Data Analysis

Analysis of Brazilian public health system (SUS) data on acromegaly patients, built from **SIASUS** outpatient records: **APAC Medications (AM)** and **Outpatient Production (PA)**.

This repository focuses exclusively on the acromegaly cohort. It was split out from a larger multi-condition research repository (LEFAR/FS-UnB, CNPq) to keep the acromegaly data pipeline, notebooks, and results self-contained.

## What this repository contains

- Raw and processed SIASUS extracts (AM + PA) for acromegaly-related procedures/medications
- R notebooks that build the unified patient-level dataset and produce the tables and figures of the manuscript (cohort flowchart, demographics, rates by state of residence, medication categories, monthly dispensing, socioeconomic equity table)
- Python scripts used to download the raw data from DATASUS
- Municipal reference data for the equity analysis (HDI/SVI from the IPEA Atlas, IFDM from Ipeadata)
- Exported tables and figures (`resultados/third_review/`)

## Repository structure

```
.
├── data/
│   ├── auxiliar/           # Reference data
│   │   ├── MUNICBR.CNV                        # Municipality codes (DATASUS)
│   │   ├── atlasivs_dadosbrutos_pt_v2.xlsx    # IPEA Atlas: municipal HDI and SVI, 2010 (Git LFS)
│   │   └── ipeadata[29-08-2025-04-00].csv     # FIRJAN IFDM 2023, obtained from Ipeadata
│   ├── raw/                # Raw SIASUS extracts downloaded from DATASUS (AM + PA)
│   └── processed/          # Cleaned/standardized CSVs, ready for analysis
│       ├── medicamentos/            # Processed APAC Medications (AM) data
│       └── producao_ambulatorial/   # Processed Outpatient Production (PA) data
├── notebooks/
│   ├── acromegalia_uniao_medicamentos.ipynb    # Main pipeline: AM+PA linkage, cohort, demographics, medications, Figures 1 and 2
│   ├── acromegalia_analise_medicamentos.ipynb  # Demographics, geography (rates by residence, maps) and medication analyses
│   ├── acromegalia_analise_equidade.ipynb      # Rebuilds the 2024 cohort and produces the equity table (Table 3)
│   └── func/
│       ├── functions.R                          # Shared R helper functions
│       └── translation_en.R                     # English labels and file names for exported outputs
├── scripts/
│   ├── acromegalia_download_medicamentos.py             # Downloads APAC Medications (AM) data from DATASUS
│   └── acromegalia_download_producao_ambulatorial.py     # Downloads Outpatient Production (PA) data from DATASUS
├── resultados/
│   └── third_review/       # Current tables (.xlsx) and figures (.png) supporting the manuscript
└── requirements.txt        # Python dependencies for the download scripts
```

## Large files

All CSV, TXT and XLSX files are tracked normally, except the IPEA Atlas (`data/auxiliar/atlasivs_dadosbrutos_pt_v2.xlsx`, ~99 MB), which is stored with [Git LFS](https://git-lfs.com/). Without Git LFS, the clone contains only a small pointer file, and the equity notebook fails with `zip file ... cannot be opened`. See *Getting started* below.

Older dated outputs, generated before the third review, were removed from `resultados/`; they remain available in the git history. Each notebook writes its outputs with the run date as a prefix (`YYYYMMDD_`), so re-running a notebook adds a new dated set of files to `resultados/third_review/`.

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

### Git LFS (equity analysis)

```bash
brew install git-lfs   # or see https://git-lfs.com/ for other systems
git lfs install
git lfs pull
```

### R environment (analysis notebooks)

The notebooks run on an R 4.6.0 (IRkernel) Jupyter kernel. Required packages:

```r
install.packages(c(
  "tidyverse", "lubridate", "openxlsx", "writexl", "readxl",
  "ggalluvial", "ggplot2", "scales", "sf", "geobr"
))
remotes::install_github("davidsjoberg/ggsankey")
```

Run each notebook with "Restart & Run All" from the `notebooks/` directory:

1. `acromegalia_uniao_medicamentos.ipynb`
2. `acromegalia_analise_medicamentos.ipynb`
3. `acromegalia_analise_equidade.ipynb` (writes only `resultados/third_review/tabela_equidade.xlsx`)

## Pipeline overview

1. **Import** - load raw AM and PA CSVs
2. **Standardize** - pad/format authorization codes, unit codes, and dates
3. **Union** - join AM and PA records by authorization, competência (billing period), and movement date
4. **Filter to 2024** - restrict the unified dataset to the analysis year
5. **Exclude records without a patient identifier** and deduplicate patients by encrypted CNS (4,231 patients)
6. **Demographic analysis** - sex and age (race/colour is computed as a supplementary table and is not reported in the manuscript)
7. **Geography** - patients and rates per million by state and region of residence (exact Poisson 95% CI; TabNet/DATASUS 2024 population estimates), compared with the dispensing location
8. **Medication analysis** - mutually exclusive medication categories (Table 4), combinations, most recent medication, spending, recorded monthly dispensing (Figure 2), discontinuation
9. **Flowchart** - data construction flowchart (Figure 1)
10. **Equity** - patients by HDI, IFDM and SVI of the dispensing and residence municipalities, by region (Table 3; separate notebook)

## Third review (07/09/2026)

Corrections made to the notebooks in response to the third review of the manuscript (AcroSUS). All outputs are in [`resultados/third_review/`](resultados/third_review/). The [folder README](resultados/third_review/README.md) maps each review item to its files.

Main changes:

- **Cohort**: records without a patient identifier (`AP_CNSPCN`) were excluded from all patient-level analyses (434 records, 282 authorizations). The final cohort has **4,231 patients**, not 4,232.
- **AM + PA linkage**: PA is aggregated to one row per key (authorization + competence month + processing month) before the join, and the join is enforced as one-to-one. The linkage no longer multiplies records.
- **Geography**: rates per million (exact Poisson 95% CI) are calculated by the patient's **residence** (`AP_MUNPCN`, complete in AM). The facility municipality (`AP_UFMUN`) is used only to count dispensing locations. In the paired comparison, 99.55% of patients are dispensed in their own region of residence.
- **Case definition**: the exact match on `E22`/`E220` in `AP_CIDPRI`/`AP_CIDSEC` was kept and documented. No patient was included only through code `E22`, and 1 patient was included only through the secondary diagnosis.
- **Missing data**: the 468 patients without age and race/colour in PA are the patients not linked to PA; 98.7% of them live in the Southeast. AM fields were used to assess the direction of bias.
- **Figures and tables**: Figure 2 now shows recorded monthly dispensing (with combinations and a "No dispensing record" category); the flowchart (Figure 1) was rebuilt; Table 4 uses mutually exclusive categories; the SIGTAP code table, the extraction window and age percentages with both denominators were added.
- **Error fix**: race/colour codes 03 and 04 (Brown/Asian) were swapped in `acromegalia_analise_medicamentos.ipynb`.
- **Equity (10/11/2026)**: the equity analysis (Table 3) is in `acromegalia_analise_equidade.ipynb`. The notebook rebuilds the 4,231-patient cohort and writes only `tabela_equidade.xlsx`. Federal District administrative-region codes are grouped into Brasília (IBGE 530010).
- **Population (10/11/2026)**: rate denominators are the 2024 population estimates from TabNet/DATASUS (accessed 25/08/2025).

## License

This project is licensed under the GNU General Public License v3.0 - see [LICENSE](LICENSE) for details.
