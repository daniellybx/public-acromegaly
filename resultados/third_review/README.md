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
| Brazil rate (per million, by residence) | – | 19.83 (95% CI 19.24–20.44) |

## Review item → output

File names below omit the `20260907_data2024_` prefix.

| Item | What was done | File(s) |
|---|---|---|
| 1 – Denominator | Records without `AP_CNSPCN` excluded from all patient-level analyses; the hard-coded check for 4,232 was removed | `exclusion_missing_patient_id.xlsx`, all tables |
| 1c / 5 – Figure 1 | Flowchart rebuilt: PA aggregation, 1:0..1 linkage, 2024 filter, exclusion of missing identifiers; no "deduplicated" label | `figure1_flowchart_data_linkage.png/.xlsx` |
| 2 – Case definition | Patients by inclusion route (primary/secondary/E22) and comparison with the cohort restricted to primary diagnosis E220 | `case_definition_icd.xlsx` |
| 3 – Geography | Rates per million (exact Poisson 95% CI) by patient **residence** (`AP_MUNPCN`); facility used only as counts; missing residence by dispensing region; paired residence × dispensing matrix; same patient set on both sides | `geography_residence_rates.xlsx`, `state_dispensing_facility.xlsx`, `region_dispensing_facility.xlsx`, `map_state_*.png` |
| 4 – Figure 2 | Relabelled as "recorded monthly dispensing"; N = 4,231; "No dispensing record" defined; combinations kept; ribbons coloured by the month of origin | `figure2_recorded_monthly_dispensing.png`, `figure2_recorded_monthly_dispensing_data.xlsx` |
| 5a/5b – Linkage | PA aggregated to 1 row per key before the join; `one-to-one` join; authorization-level linkage separated from patient-level deduplication | notebook section 3, `figure1_flowchart_data_linkage.xlsx` |
| 5c – Missing demographics | The 468 patients with missing age/race are exactly the patients not linked to PA; empirical assessment using AM fields | `missing_demographics_linkage.xlsx` |
| 6a – Period | Extraction window (processing months 2023-01 to 2025-02), `AP_CMP` field, 41 records with 2024 competence processed in 2025 | `extraction_window.xlsx` |
| 7a/7b/7e – Age | Percentages with both denominators, "≥ 80" label, median and IQR | `age.xlsx`, `age_pyramid.png` |
| 7c – Table 4 | Mutually exclusive categories (octreotide without lanreotide, lanreotide without octreotide, both) | `table4_medication_categories.xlsx` |
| 8a – SIGTAP | Supplementary table with the 8 codes | `sigtap_codes.xlsx` |
| 6b–d, 7d, 7f, 7g, 8b–d | Text-only changes in the manuscript | `response_to_reviewers_draft.md` |

Also regenerated with the corrected cohort: `sex.xlsx`, `race_colour.xlsx`, `medication_combinations.xlsx`, `most_recent_medication.xlsx`, `medication_spending.xlsx`, `20260907_acromegaly_annual_discontinuation.xlsx` and `20260907_unique_users_by_medication_month.csv`.

## Findings that change the interpretation

1. **Residence**: the `AP_MUNPCN` field in AM is complete. Missing residence came from using `PA_MUNPCN`. 99.55% of patients are dispensed in their region of residence and 99.05% in their state of residence. The interpretation of 473 patients "travelling" to the Southeast does not hold.
2. **Differential missingness in demographics**: 98.7% of the 468 patients without age/race live in the Southeast. According to the AM fields, they have similar age and sex to linked patients but a higher proportion of Brown and Black patients (42.7% + 7.7% vs 36.2% + 4.8%). The complete-case race/colour distribution overstates White patients. AM age agrees with PA age (±1 year) for 100% of linked patients, so `AP_NUIDADE`/`AP_RACACOR` are an alternative source without missing data, if the authors choose to use them.
3. **ICD**: no AM record carries the three-character code `E22`. Only 1 patient (primary diagnosis E221, secondary E220, cabergoline) was included through the secondary field.

## Notebook changes

In both notebooks:
- Outputs are written to `resultados/third_review/` and translated to English at export (`exportar_xlsx()` in `notebooks/func/translation_en.R`).
- New sections: 1:0..1 AM+PA linkage, exclusion of missing identifiers (4.1), extraction window (5.1), case definition (5.2), demographics × linkage (6.2.1), residence and rates (6.7) and Table 4 (7.2.1).
- Facility-based tables renamed (counts, no rates).
- The non-existent absolute path of the Sankey output was replaced by `../data/processed/`.

Only in `acromegalia_analise_medicamentos.ipynb`:
- Fixed race/colour codes (03 and 04 were swapped: Brown/Asian).
- Maps rebuilt: counts by dispensing facility; counts and rates per million by residence.

Only in `acromegalia_uniao_medicamentos.ipynb`:
- Figure 2 (7.4.4) and the flowchart (9) rebuilt.
- The exploratory alluvial plots 7.4.2/7.4.3 remain in the notebook with a note but are no longer saved to disk.

## Points of attention (not requested by the review, not changed)

- `medication_spending.xlsx`: PA amounts are summed by the AM main medication (`AP_PRIPAL`), including PA lines for other procedures of the same APAC. The resulting distribution across medications looks implausible (almost all the amount falls under octreotide 10 mg) and should be reviewed before being used in the text.
- Medication classification uses only the AM main procedure. Some linked PA lines record another medication in the same APAC, which may indicate concomitant use that is not captured.
