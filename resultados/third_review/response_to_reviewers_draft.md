# Third review round – draft response and suggested manuscript text

All numbers below were produced by the corrected notebooks (`notebooks/acromegalia_uniao_medicamentos.ipynb` and `notebooks/acromegalia_analise_medicamentos.ipynb`) and are exported in `resultados/third_review/`. File names are given without the date prefix (`20260907_data2024_`).

---

## Item 1 – Patient-level cohort denominator

**Response.** We thank the reviewer for identifying this error. In the 2024 data, 434 dispensing records (282 authorizations, 222 of which had no record with an identifier) had a missing encrypted patient identifier (`AP_CNSPCN`). In the previous version, these records were collapsed into one artificial patient, which produced the total of 4,232. They are now excluded from all patient-level analyses. The cohort comprises **4,231 patients** (38,559 dispensing records; 18,831 authorizations). All tables, rates, confidence intervals, figures, the Abstract, Key Points and the Plain Language Summary were updated. Figure 1 now shows this exclusion explicitly.

**Suggested Methods text.** "Records without a valid encrypted patient identifier could not be deduplicated into individuals and were excluded from all patient-level analyses (434 dispensing records from 282 authorizations)."

Files: `exclusion_missing_patient_id.xlsx`, `figure1_flowchart_data_linkage.png/.xlsx`.

Changes due to the exclusion: the total (4,232 → 4,231), the male group (1,631 → 1,630) and the facility-based Centre-West count (270 → 269). All percentages were recalculated. Age and race/colour now come from the APAC Medicines file (see item 5c), so Table 1 has no missing values.

---

## Item 2 – Diagnostic case definition

**Response.** We clarify the case definition as follows. In the ICD-10, E22 is the three-character category "Hyperfunction of pituitary gland" (E22.0–E22.9), and acromegaly corresponds to E22.0, recorded in SIASUS without the dot as `E220`. The download scripts selected records whose primary (`AP_CIDPRI`) **or** secondary (`AP_CIDSEC`) diagnosis field was **exactly equal** to `E22` or `E220`. This is an exact string comparison, not a prefix or substring search, so subcategories such as `E221` (hyperprolactinaemia) or `E222` are never selected on their own. The three-character code `E22` was included only to capture acromegaly records that might have been registered without the fourth character. In practice, no APAC Medicines record carried `E22`, so no patient was included through this code, and every patient was selected through `E220`.

No additional filter on medication procedure codes was applied at extraction. All APAC Medicines records selected by the diagnostic criterion had one of the eight SIGTAP procedure codes listed in Supplementary Table S1 as their main procedure (`AP_PRIPAL`).

Empirical assessment of the case definition (2024 cohort, file `case_definition_icd.xlsx`):

| | Patients | Records |
|---|---:|---:|
| Cohort | 4,231 | 38,559 |
| E22/E220 recorded as primary diagnosis in at least one record | 4,230 | — |
| Included **only** through the secondary diagnosis (E220) | 1 | 12 |
| Included **only** through the three-character code E22 | 0 | 0 (no APAC Medicines record carried `E22`) |
| Cohort restricted to primary diagnosis E220 | 4,230 | 38,547 |

The only patient included through the secondary field had `E221` as primary diagnosis and `E220` as secondary diagnosis on all 12 records (cabergoline). This patient entered the cohort through the exact match on `E220`, not through `E221`. Restricting the cohort to primary diagnosis E220 changes the count by one patient (cabergoline: 2,021 → 2,020; lanreotide and octreotide unchanged). The case definition therefore does not depend materially on secondary diagnoses or on the three-character code. In the Outpatient Production file, `E22` appears in 933 rows, but that file was used only for linkage and never to select patients.

**Suggested Methods text.** "Patients were identified in the APAC Medicines file by an exact match of the primary (AP_CIDPRI) or secondary (AP_CIDSEC) diagnosis field to the ICD-10 code for acromegaly, E22.0 (recorded in SIASUS as E220), or to the three-character category code E22 (exact string comparison; subcategories such as E221, hyperprolactinaemia, were not selected). No additional procedure-code filter was applied; all selected records had one of the eight SIGTAP medication codes listed in Supplementary Table S1 as their main procedure. In 2024, 4,230 of 4,231 patients had E220 as the primary diagnosis. One patient was included only through the secondary diagnosis, and no patient was included through the three-character code E22."

**Suggested Limitations text (replaces "expected to be minimal").** "No validation study of diagnostic codes in SIASUS was available. Although restricting the cohort to primary diagnosis E220 changed the patient count by one, misclassification cannot be excluded. In particular, cabergoline is also indicated for other pituitary conditions, and the accuracy of diagnosis codes recorded for reimbursement purposes is unknown."

---

## Item 3 – Geographic analysis and residence information

**Response.** We adopted the first option offered by the reviewer: regional and state rates are now calculated using the patient's **municipality of residence**. Residence is taken from `AP_MUNPCN`, a field of the APAC Medicines file that is present in every record. In the previous version, residence was taken from the Outpatient Production field `PA_MUNPCN`, which is missing whenever a record has no Outpatient Production match. This was the source of the missing residence data, and 462 of the 468 affected patients were dispensed in the Southeast (file `geography_residence_rates.xlsx`, sheet `missing_by_dispensing_region`). With `AP_MUNPCN`, residence is known for all 4,231 patients.

The facility-based distribution (`AP_UFMUN`, municipality of the dispensing establishment) is kept only as counts of dispensing locations, without per-million rates.

Rates per million residents (IBGE 2024 population estimates; exact Poisson 95% CI):

| Region of residence | Patients | Rate per million (95% CI) |
|---|---:|---|
| Southeast | 2,309 | 25.76 (24.72–26.83) |
| South | 738 | 24.27 (22.55–26.09) |
| Centre-West | 268 | 16.04 (14.18–18.08) |
| Northeast | 788 | 13.66 (12.73–14.65) |
| North | 128 | 6.77 (5.65–8.05) |
| **Brazil** | **4,231** | **19.83 (19.24–20.44)** |

State-level rates: sheet `state_residence_rates`.

Paired comparison of residence and dispensing region (same 4,231 patients on both sides): 4,212 patients (99.55%) were dispensed in their region of residence, and 4,191 (99.05%) in their state of residence. Only 19 patients (0.45%) were dispensed in another region. Among Southeast residents, 2,306 of 2,309 were dispensed in the Southeast; the Southeast had 2,320 patients by dispensing location versus 2,309 by residence, a net difference of 11. The previous interpretation (473 patients travelling to the Southeast) came from comparing a facility-based total with a residence-based total that excluded the 468 patients missing `PA_MUNPCN`. It has been removed. For any socioeconomic comparison, the same set of patients is used on both sides (sheets `region_same_patient_set` and `state_same_patient_set`).

**Suggested Discussion text (item 3e).** "Lower treated-patient rates in the North and Northeast cannot distinguish lower underlying disease occurrence from differences in diagnosis, treatment initiation, public-sector treatment coverage, or access to specialised care. These rates describe patients treated with the study medicines through the SUS and should not be interpreted as disease prevalence."

---

## Item 4 – Figure 2

**Response.** We adopted option (b): the figure is now labelled and described as **recorded monthly dispensing**, and all claims about treatment coverage and stability were removed. The figure was rebuilt to address every point raised:

- N = 4,231 patients, identical to the corrected cohort.
- The former "NA" category is now labelled "No dispensing record" and defined as a month with no dispensing record for the patient.
- When more than one active ingredient is recorded in the same patient-month, the combination is kept as its own category (e.g., "Octreotide + Cabergoline") instead of retaining one arbitrarily. Medications are now identified from the main procedure of the APAC Medicines record **and** from the other study medications dispensed within the same APAC in the Outpatient Production file (see "Additional corrections" below).
- Each ribbon between two months is coloured by the patient's category in the month of origin, no longer by the January value.

Data underlying the figure (patients by category and month, and month-to-month transitions): `figure2_recorded_monthly_dispensing_data.xlsx`.

**Suggested caption.** "Figure 2. Recorded monthly dispensing of acromegaly medicines in the SUS, 2024 (N = 4,231 patients). Each vertical axis is a competence month. Strata show the number of patients by the active ingredient(s) with a dispensing record in that month. Ribbons show month-to-month transitions and are coloured by the category in the month of origin. 'No dispensing record' indicates a month without any record for the patient. Combinations indicate more than one active ingredient dispensed in the same month, identified from the APAC Medicines main procedure and from the study medications recorded within the same APAC in the Outpatient Production file. The figure reflects administrative dispensing records, not estimated treatment coverage."

---

## Item 5 – Linkage, deduplication and linkage-related missingness

**5a–5b. Response.** The APAC Medicines file contains exactly one record per authorization number + competence month + processing month (verified in code). Each record is a monthly dispensing record. The Outpatient Production file may contain several rows per key (one per procedure line, including identical lines). In the previous version, the uncollapsed tables were joined, which increased the row count from 84,042 to 103,204. Because each Outpatient Production row matched at most one APAC Medicines record, values summed from Outpatient Production were not duplicated, and patient counts used distinct identifiers. The record counts, however, were inflated.

In the corrected pipeline, Outpatient Production is first **aggregated to one row per key**. Demographic fields take the first non-missing value, and quantities and values are summed. The join is then enforced as **one-to-one** (each APAC Medicines record matches zero or one Outpatient Production key), so linkage does not multiply dispensing events: the linked table has exactly 84,042 records. **Authorization-level linkage** (authorization number + competence + processing month) is distinct from **patient-level deduplication**, which uses the encrypted CNS (`AP_CNSPCN`) after linkage, the 2024 filter and the exclusion of missing identifiers. Figure 1 no longer describes the sources as "deduplicated".

Linkage counts (all years extracted): 74,764 APAC Medicines records linked, 9,278 not linked (kept). 613 Outpatient Production keys had no APAC Medicines match, corresponding to 489 authorizations never present in APAC Medicines (excluded). In the final 2024 cohort, 34,097 of 38,559 records (88.4%) were linked.

**5c. Response.** Missing age (`PA_IDADE`) and race/colour (`PA_RACACOR`) correspond exactly to the 468 patients whose selected record had no Outpatient Production match. 460 of these patients had no linked record at all in 2024, and 8 had a linked record in another month (file `missing_demographics_linkage.xlsx`). The missingness is therefore linkage-related. We assessed its direction empirically using the APAC Medicines fields for age (`AP_NUIDADE`), race/colour (`AP_RACACOR`) and sex, which are complete. Among linked patients, the age from APAC Medicines agreed with the Outpatient Production age within one year for 100% of patients.

| | Linked (n = 3,763) | Not linked (n = 468) |
|---|---|---|
| Median age, APAC Medicines (IQR) | 54 (43–64.5) | 54 (47–65) |
| ≥ 60 years | 36.5% | 38.2% |
| Female | 61.6% | 60.5% |
| White / Brown (Parda) / Black (Preta) / Asian (Amarela) | 56.9 / 36.2 / 4.8 / 2.0% | 48.9 / 42.7 / 7.7 / 0.6% |
| Resident in the Southeast | 49.1% | 98.7% |

Non-linkage was therefore strongly concentrated in the Southeast. Unlinked patients had a similar age and sex distribution but a higher proportion of Brown and Black patients, so a complete-case analysis based on Outpatient Production would overstate the proportion of White patients.

Because the APAC Medicines fields are complete and agree with Outpatient Production, **Table 1 now uses age (`AP_NUIDADE`/`AP_COIDADE`) and race/colour (`AP_RACACOR`) from the APAC Medicines file**. Table 1 therefore has no missing age or race/colour (files `age.xlsx` and `race_colour.xlsx`): White 2,371 (56.0%), Brown (Parda) 1,563 (36.9%), Black (Preta) 218 (5.2%), Asian (Amarela) 79 (1.9%).

**Suggested Table 1 footnote.** "Sex, age and race/colour were obtained from the APAC Medicines file, in which these fields were complete. The corresponding Outpatient Production fields were missing for 468 patients (11.1%) without an Outpatient Production match; among linked patients, age agreed between the two files within one year for all patients."

**5d. Suggested Methods text.** "Dispensing records were obtained from the APAC Medicines file. Linkage to the Outpatient Production file supplied the quantities and amounts of each medication procedure and the other study medications dispensed within the same APAC. 489 Outpatient Production authorizations without an APAC Medicines match were not included."

---

## Item 6 – Data period, software and Abstract

**6a. Suggested text.** "Monthly SIASUS files were extracted for processing months January 2023 to February 2025. The study period was defined by the competence date (AP_CMP) from January to December 2024. Authorizations with a 2024 competence processed in January–February 2025 were captured (41 records). Records with a 2024 competence processed after February 2025 were not captured." (File `extraction_window.xlsx`.)

**6b. Suggested text.** "DATASUS files were downloaded with Python (PySUS 1.0.1; pandas 2.3.3). Data preparation, analysis and figure production were carried out in R 4.6.0 (tidyverse, ggalluvial, ggsankey, sf and geobr; openxlsx for table export)." Cite PySUS, R and the R packages.

**6c. Suggested Abstract text.** "Authorization-level records were linked using the authorization number, competence date and processing date, and patients were deduplicated using the encrypted patient identifier."

**6d. Suggested Abstract text.** "...using the APAC Medicines and Outpatient Production databases of the SUS Outpatient Information System (SIASUS)..."

---

## Item 7 – Internal inconsistencies

- **7a.** Age now comes from the APAC Medicines file and is known for all patients, so the full cohort and the patients with known age are the same denominator (n = 4,231; file `age.xlsx`). Patients aged 60 years or older: 1,552 (36.7%). State the denominator in the Table 1 header, for example: "Over one-third (36.7%) of the 4,231 patients were aged 60 years or older."
- **7b.** The label is now "≥ 80" in the tables and the age pyramid.
- **7c. Table 4 (mutually exclusive categories; file `table4_medication_categories.xlsx`):**

| Category | Without cabergoline | With cabergoline | Total (%) |
|---|---:|---:|---:|
| Octreotide without lanreotide | 1,313 | 446 | 1,759 (41.6%) |
| Lanreotide without octreotide | 776 | 424 | 1,200 (28.4%) |
| Both analogues (octreotide and lanreotide) | 45 | 39 | 84 (2.0%) |
| No somatostatin analogue (cabergoline only) | — | 1,188 | 1,188 (28.1%) |
| **Total** | | | **4,231 (100%)** |

  These categories include the study medications dispensed within the same APAC in the Outpatient Production file (see "Additional corrections"). Suggested text: "During 2024, 1,759 patients received octreotide without lanreotide, 1,200 received lanreotide without octreotide and 84 received both analogues; 1,188 received cabergoline only."
- **7d.** Define the population consistently as "patients with acromegaly who received octreotide, lanreotide or cabergoline through the SUS in 2024." Pasireotide and pegvisomant were outside the operational definition, so the cohort does not represent all pharmacologically treated patients.
- **7e.** Median and IQR are now computed (age: median 54 years, IQR 44–65, n = 4,231). Either report them or delete the sentence about central tendency and dispersion.
- **7f.** Use "Specialized Component of Pharmaceutical Assistance (CEAF)" throughout.
- **7g.** "Resolution 466/2012 of the Brazilian National Health Council (Conselho Nacional de Saúde)" throughout.

---

## Item 8 – Reporting, references and accessibility

- **8a.** Supplementary Table S1 lists all 8 SIGTAP codes with formatted code, active ingredient, description, and 2024 counts of dispensing records and patients for each code (file `sigtap_codes.xlsx`).
- **8b. RECORD checklist.**
  - Item 10 (Methods): "No sample-size calculation was performed because all eligible records in the national database for 2024 were included."
  - Item 12.3: "Authorization-level linkage of APAC Medicines and Outpatient Production records used authorization number, competence month and processing month (one-to-one after aggregation of Outpatient Production to one row per key). Patient-level deduplication used the encrypted patient identifier and was performed after linkage."
  - Item 19 (direction and magnitude of bias, where it can be assessed):
    - *Missing identifiers*: 434 records (1.1% of 2024 records) were excluded. The number of patients they represent cannot be determined; the direction is undetermined and the magnitude is at most small.
    - *Residence*: complete in APAC Medicines; 0.45% of patients were dispensed outside their region of residence. Facility-based counts slightly overstate the Southeast (+11 patients) and the Federal District (+8).
    - *Demographic missingness*: avoided by using the complete APAC Medicines fields. The Outpatient Production fields would have been missing for 11.1% of patients, a linkage-related loss concentrated in the Southeast (98.7%) that would have overstated White patients (56.9% among linked versus 48.9% among unlinked). There was no meaningful difference in age or sex.
    - *Diagnostic misclassification*: the direction cannot be established in the absence of a validation study.
- **8c.** In References 8, 23 and 26, remove `?utm_source=chatgpt.com` (and `&utm_source=chatgpt.com`) from the URLs and check that each link opens the final source.
- **8d. Alt-text:**
  - *Figure 1*: "Flowchart of database construction. 84,042 APAC Medicines dispensing records (39,254 authorizations) were linked at the authorization level to 75,377 Outpatient Production authorization-month keys, obtained by aggregating 97,280 rows. The linkage was one-to-one and did not multiply records: 74,764 records were linked and 9,278 were kept without a match. 613 Outpatient Production keys without an APAC Medicines match (489 authorizations) were excluded. Restricting to 2024 competence months left 38,993 records. 434 records (282 authorizations) without a valid patient identifier were excluded, giving a final cohort of 38,559 dispensing records, 18,831 authorizations and 4,231 patients."
  - *Figure 2*: "Alluvial diagram of recorded monthly dispensing for 4,231 patients from January to December 2024. In each month, around 1,030–1,140 patients had octreotide alone, 820–960 cabergoline alone and 580–680 lanreotide alone. About 270–310 had octreotide plus cabergoline, 250–320 lanreotide plus cabergoline, and a few had other combinations; 900–1,230 had no dispensing record. Most ribbons remain in the same category from month to month; the transitions are mainly between a medicine and 'No dispensing record', with few switches between medicines."

---

## Additional corrections (not requested by the reviewer)

These corrections were identified while revising the code. They change Table 4, Figure 2 and the medication tables, so they should be mentioned in the response letter.

- **Medications dispensed within the same APAC.** The previous version identified medications only from the main procedure of the APAC Medicines record (`AP_PRIPAL`). The Outpatient Production file records every medication procedure of the APAC: 7,153 of the 38,559 cohort records (18.6%) had another study medication dispensed within the same APAC (`PA_QTDPRO > 0`), most often cabergoline together with lanreotide or octreotide. Medications are now identified from the main procedure **plus** the other study medications dispensed within the same APAC, restricted to the eight SIGTAP codes. No other procedure codes were recorded in these APACs. With this change, 405 patients moved to a combination category (e.g., 156 from cabergoline only to cabergoline + octreotide, and 149 to cabergoline + lanreotide). Records without an Outpatient Production match (11.6%) are classified by the main procedure only. File: `medications_same_apac.xlsx`.
- **Doses and amounts by medication.** Doses and amounts are now attributed to the procedure recorded in Outpatient Production (`PA_PROC_ID`), restricted to the eight study codes, instead of to the APAC Medicines main procedure. Totals are unchanged (249,034 doses dispensed; R$ 1,366,426 produced), but the per-medication distribution is now correct (file `medication_spending.xlsx`). The SIASUS amount is non-zero only for octreotide LAR 10 mg (R$ 1,366,050) and octreotide 0.1 mg/mL (R$ 376); all other medicines are recorded with a zero amount. The SIASUS amount therefore does not represent the cost of most study medicines and should not be reported as total expenditure.
- **Race/colour codes.** In the analysis notebook (`acromegalia_analise_medicamentos.ipynb`), codes 03 and 04 were swapped (Brown/Asian). Corrected; Table 1 is based on `race_colour.xlsx`.

