# Third review (3a_Rev_AcroSUS_Completo) – corrected outputs

This folder contains the outputs of the two corrected notebooks (`notebooks/acromegalia_uniao_medicamentos.ipynb` and `notebooks/acromegalia_analise_medicamentos.ipynb`) for the review of 07/09/2026. All files have the prefix `20260907_`. File names, sheet names, column names and values are written in English (see `notebooks/func/translation_en.R`). The draft response to the reviewers, with suggested manuscript text, is in [response_to_reviewers_draft.md](response_to_reviewers_draft.md).

## Key figures of the corrected cohort

| Indicator | Before | Now |
|---|---:|---:|
| Patients | 4,232 | **4,231** |
| Dispensing records, 2024 | 47,743 (inflated by the join) | **38,559** |
| Authorizations, 2024 | 19,053 | **18,831** |
| Records excluded without patient identifier | – | 434 (282 authorizations) |
| Missing residence | 468 (`PA_MUNPCN`) | **0** (`AP_MUNPCN`) |
| Missing age / race-colour in Table 1 | 468 (`PA_IDADE`/`PA_RACACOR`) | **0** (`AP_NUIDADE`/`AP_RACACOR`) |
| Patients with a combination of active ingredients | 570 (main procedure only) | **954** (main procedure + same APAC) |
| Brazil rate (per million, by residence) | – | 19.83 (95% CI 19.24–20.44) |

## Review item → output

File names below omit the `20260907_data2024_` prefix.

| Item | What was done | File(s) |
|---|---|---|
| 1 – Denominator | Records without `AP_CNSPCN` excluded from all patient-level analyses; the hard-coded check for 4,232 was removed | `exclusion_missing_patient_id.xlsx`, all tables |
| 1c / 5 – Figure 1 | Flowchart rebuilt: PA aggregation, 1:0..1 linkage, 2024 filter, exclusion of missing identifiers; no "deduplicated" label | `figure1_flowchart_data_linkage.png/.xlsx` |
| 2 – Case definition | Patients by inclusion route (primary/secondary/E22) and comparison with the cohort restricted to primary diagnosis E220 | `case_definition_icd.xlsx` |
| 3 – Geography | Rates per million (exact Poisson 95% CI) by patient **residence** (`AP_MUNPCN`); facility used only as counts; missing residence by dispensing region; paired residence × dispensing matrix; same patient set on both sides | `geography_residence_rates.xlsx`, `state_dispensing_facility.xlsx`, `region_dispensing_facility.xlsx`, `map_state_*.png` |
| 4 – Figure 2 | Relabelled as "recorded monthly dispensing"; N = 4,231; "No dispensing record" defined; combinations kept (including study medications dispensed within the same APAC); ribbons coloured by the month of origin | `figure2_recorded_monthly_dispensing.png`, `figure2_recorded_monthly_dispensing_data.xlsx` |
| 5a/5b – Linkage | PA aggregated to 1 row per key before the join; `one-to-one` join; authorization-level linkage separated from patient-level deduplication | notebook section 3, `figure1_flowchart_data_linkage.xlsx` |
| 5c – Missing demographics | The 468 patients with missing PA age/race are exactly the patients not linked to PA; empirical assessment using AM fields; Table 1 now uses the complete AM fields | `missing_demographics_linkage.xlsx`, `age.xlsx`, `race_colour.xlsx` |
| 6a – Period | Extraction window (processing months 2023-01 to 2025-02), `AP_CMP` field, 41 records with 2024 competence processed in 2025 | `extraction_window.xlsx` |
| 7a/7b/7e – Age | Age from AM (no missing values, single denominator n = 4,231), "≥ 80" label, median and IQR | `age.xlsx`, `age_pyramid.png` |
| 7c – Table 4 | Mutually exclusive categories (octreotide without lanreotide, lanreotide without octreotide, both), using the medications dispensed within the same APAC | `table4_medication_categories.xlsx` |
| 8a – SIGTAP | Supplementary table with the 8 codes | `sigtap_codes.xlsx` |
| 6b–d, 7d, 7f, 7g, 8b–d | Text-only changes in the manuscript | `response_to_reviewers_draft.md` |
| Additional | Medications identified from the main procedure plus the study medications dispensed within the same APAC; doses and amounts attributed to the PA procedure | `medications_same_apac.xlsx`, `medication_spending.xlsx` |

Also regenerated with the corrected cohort: `sex.xlsx`, `race_colour.xlsx`, `medication_combinations.xlsx`, `most_recent_medication.xlsx`, `medication_spending.xlsx`, `20260907_acromegaly_annual_discontinuation.xlsx` and `20260907_unique_users_by_medication_month.csv`.

## Findings that change the interpretation

1. **Residence**: the `AP_MUNPCN` field in AM is complete. Missing residence came from using `PA_MUNPCN`. 99.55% of patients are dispensed in their region of residence and 99.05% in their state of residence. The interpretation of 473 patients "travelling" to the Southeast does not hold.
2. **Demographics**: the 468 patients without PA age/race (98.7% living in the Southeast) had a higher proportion of Brown and Black patients (42.7% + 7.7% vs 36.2% + 4.8%), so a complete-case analysis would overstate White patients. AM age agrees with PA age (±1 year) for 100% of linked patients, so **Table 1 now uses `AP_NUIDADE`/`AP_COIDADE` and `AP_RACACOR` from AM**, with no missing values: White 56.0%, Brown 36.9%, Black 5.2%, Asian 1.9%; median age 54 (IQR 44–65); 36.7% aged 60 or older.
3. **ICD**: in the ICD-10, E22 is the three-character category (E22.0–E22.9); acromegaly is E22.0 (`E220` in SIASUS). The selection used an exact match on `E22` or `E220`, so subcategories such as `E221` are never selected on their own. No AM record carries `E22`, so every patient was selected through `E220`. Only 1 patient (primary diagnosis E221, secondary E220, cabergoline) was included through the secondary field.
4. **Medications within the same APAC**: PA records every medication procedure of the APAC. 7,153 cohort records (18.6%) had another study medication dispensed within the same APAC (`PA_QTDPRO > 0`), most often cabergoline with lanreotide or octreotide. No procedure outside the eight study codes appears in these APACs. Medications are now identified from `AP_PRIPAL` plus these PA lines, restricted to the eight codes; 405 patients moved to a combination category. Records without a PA match (11.6%) are classified by `AP_PRIPAL` only.
5. **Doses and amounts**: they are now attributed to the procedure recorded in PA (`PA_PROC_ID`), not to `AP_PRIPAL`. Totals are unchanged. The SIASUS amount is non-zero only for octreotide LAR 10 mg (R$ 1,366,050) and octreotide 0.1 mg/mL (R$ 376); the other medicines are recorded with a zero amount, so this value does not represent the cost of most study medicines.

## Notebook changes

In both notebooks:
- Outputs are written to `resultados/third_review/` and translated to English at export (`exportar_xlsx()` in `notebooks/func/translation_en.R`).
- New sections: 1:0..1 AM+PA linkage, exclusion of missing identifiers (4.1), extraction window (5.1), case definition (5.2), demographics × linkage (6.2.1), residence and rates (6.7) and Table 4 (7.2.1).
- Section 6: age (`IDADE`) and race/colour (`RACACOR`) taken from AM for Table 1 and the age pyramid.
- Section 7.1: new `dispensacoes` table (main procedure + study medications dispensed within the same APAC), used by all medication analyses (combinations, Table 4, most recent medication, Sankey, Figure 2, discontinuation).
- Section 7.4: doses and amounts grouped by `PA_PROC_ID`, restricted to the eight study codes.
- Facility-based tables renamed (counts, no rates).
- The non-existent absolute path of the Sankey output was replaced by `../data/processed/`.

Only in `acromegalia_analise_medicamentos.ipynb`:
- Fixed race/colour codes (03 and 04 were swapped: Brown/Asian).
- Maps rebuilt: counts by dispensing facility; counts and rates per million by residence.

Only in `acromegalia_uniao_medicamentos.ipynb`:
- Figure 2 (7.4.4) and the flowchart (9) rebuilt.
- The exploratory alluvial plots 7.4.2/7.4.3 remain in the notebook with a note but are no longer saved to disk.
