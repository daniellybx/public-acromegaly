# Tradução para o inglês dos artefatos salvos em resultados/third_review
# (nomes de arquivos, abas, colunas e valores). As análises continuam em português
# nos notebooks; apenas o que é exportado passa por estas funções.

# Nomes de arquivo (indicador em português -> nome em inglês)
nomes_arquivos_en <- c(
  "sexo" = "sex",
  "idade" = "age",
  "raca_cor" = "race_colour",
  "piramide_etaria" = "age_pyramid",
  "exclusao_sem_cns" = "exclusion_missing_patient_id",
  "janela_extracao" = "extraction_window",
  "definicao_caso_cid" = "case_definition_icd",
  "demografia_ausente_ligacao" = "missing_demographics_linkage",
  "uf_estabelecimento_dispensacao" = "state_dispensing_facility",
  "regiao_estabelecimento_dispensacao" = "region_dispensing_facility",
  "geografia_residencia_taxas" = "geography_residence_rates",
  "codigos_sigtap" = "sigtap_codes",
  "combinacoes_medicamentos" = "medication_combinations",
  "tabela4_categorias_medicamentos" = "table4_medication_categories",
  "medicamentos_recentes" = "most_recent_medication",
  "medicamentos_gasto" = "medication_spending",
  "figura2_dispensacao_mensal_dados" = "figure2_recorded_monthly_dispensing_data",
  "figura2_dispensacao_mensal_registrada" = "figure2_recorded_monthly_dispensing",
  "fluxograma_uniao_dados" = "figure1_flowchart_data_linkage",
  "mapa_uf_estabelecimento_contagens" = "map_state_dispensing_facility_counts",
  "mapa_uf_residencia_quartis" = "map_state_residence_quartiles",
  "mapa_uf_residencia_taxa_por_milhao" = "map_state_residence_rate_per_million",
  "medicamentos_mesma_apac" = "medications_same_apac"
)

nome_arquivo_en <- function(indicador) {
  ifelse(indicador %in% names(nomes_arquivos_en), nomes_arquivos_en[indicador], indicador)
}

# Dicionário de textos exatos (abas, colunas e valores)
dicionario_en <- c(
  # Abas
  "via_inclusao" = "inclusion_route",
  "registros_por_cid" = "records_by_icd",
  "apenas_secundario" = "secondary_diagnosis_only",
  "coorte_x_restrita_E220" = "cohort_vs_primary_E220",
  "sobreposicao" = "overlap",
  "perfil_idade_sexo_AM" = "profile_age_sex_AM",
  "perfil_raca_AM" = "profile_race_colour_AM",
  "perfil_regiao_residencia" = "profile_region_residence",
  "perfil_medicamento" = "profile_medication",
  "concordancia_idade_PA_AM" = "age_agreement_PA_AM",
  "pacientes_por_mes_categoria" = "patients_by_month_category",
  "transicoes_mes_a_mes" = "month_to_month_transitions",
  "regiao_residencia_taxas" = "region_residence_rates",
  "uf_residencia_taxas" = "state_residence_rates",
  "ausente_por_regiao_dispensacao" = "missing_by_dispensing_region",
  "matriz_residencia_x_dispensacao" = "residence_x_dispensing_matrix",
  "resumo_pareado" = "paired_summary",
  "regiao_mesmo_conjunto" = "region_same_patient_set",
  "uf_mesmo_conjunto" = "state_same_patient_set",
  "fontes_residencia" = "residence_sources",
  "Pacientes por Idade" = "Patients by age",
  "Resumo numerico" = "Numeric summary",
  "janela_extracao" = "extraction_window",
  "registros_por_processamento" = "records_by_processing_month",
  "Pacientes por Sexo" = "Patients by sex",
  "analogos_mutuamente_exclusivos" = "analogues_mutually_exclusive",
  "combinacoes_exclusivas" = "exclusive_combinations",

  "resumo" = "summary",
  "pares_de_codigos" = "code_pairs",
  "mudanca_por_paciente" = "change_by_patient",

  # Colunas
  "codigo_principal" = "main_code",
  "codigo_adicional" = "additional_code",
  "principal" = "main_medication",
  "adicional" = "additional_medication",
  "principios_somente_AM" = "active_ingredients_AM_only",
  "principios_AM_mais_PA" = "active_ingredients_AM_plus_PA",
  "med_nome" = "medication",
  "usuarios_frequencia_ano" = "users_in_year",
  "usuarios_abandono_frequencia" = "users_discontinued",
  "usuarios_abandono_percentual" = "users_discontinued_percent",
  "codigo_sigtap" = "sigtap_code",
  "codigo_formatado" = "formatted_code",
  "principio_ativo" = "active_ingredient",
  "principio" = "active_ingredient",
  "descricao" = "description",
  "registros_2024" = "records_2024",
  "pacientes_2024" = "patients_2024",
  "medicamentos" = "medications",
  "quantidade_pacientes" = "patients",
  "indicador" = "indicator",
  "valor" = "value",
  "registros" = "records",
  "pacientes_coorte" = "patients_cohort",
  "registros_coorte" = "records_cohort",
  "pacientes_restrita_E220_principal" = "patients_primary_E220_only",
  "registros_restrita_E220_principal" = "records_primary_E220_only",
  "diferenca_pacientes" = "difference_patients",
  "idade_pa_ausente" = "age_missing_PA",
  "raca_pa_ausente" = "race_colour_missing_PA",
  "registro_selecionado_vinculado" = "selected_record_linked",
  "algum_registro_vinculado" = "any_record_linked",
  "pacientes" = "patients",
  "grupo" = "group",
  "idade_am_mediana" = "age_AM_median",
  "idade_am_q1" = "age_AM_q1",
  "idade_am_q3" = "age_AM_q3",
  "pct_60_mais_am" = "pct_aged_60_plus_AM",
  "pct_feminino" = "pct_female",
  "raca_am" = "race_colour_AM",
  "percentual" = "percent",
  "regiao_residencia" = "region_of_residence",
  "diferenca_absoluta_mediana" = "median_absolute_difference",
  "pct_diferenca_ate_1_ano" = "pct_difference_up_to_1_year",
  "categoria" = "category",
  "mes_origem" = "month_from",
  "mes_destino" = "month_to",
  "categoria_origem" = "category_from",
  "categoria_destino" = "category_to",
  "etapa" = "step",
  "regiao" = "region",
  "pacientes_residentes" = "resident_patients",
  "populacao" = "population",
  "taxa_por_milhao" = "rate_per_million",
  "ic95_inferior" = "ci95_lower",
  "ic95_superior" = "ci95_upper",
  "uf_sigla" = "state",
  "regiao_dispensacao" = "dispensing_region",
  "residencia_ausente_AM" = "residence_missing_AM",
  "residencia_ausente_se_PA" = "residence_missing_if_PA_used",
  "pct_ausente_se_PA" = "pct_missing_if_PA_used",
  "pacientes_por_residencia" = "patients_by_residence",
  "pacientes_por_dispensacao" = "patients_by_dispensing",
  "diferenca_dispensacao_menos_residencia" = "difference_dispensing_minus_residence",
  "residencia_AP_MUNPCN" = "residence_AP_MUNPCN",
  "residencia_PA_MUNPCN_anterior" = "residence_PA_MUNPCN_previous",
  "dispensacao_AP_UFMUN" = "dispensing_AP_UFMUN",
  "faixa_etaria" = "age_group",
  "percentual_coorte_completa" = "percent_full_cohort",
  "percentual_idade_conhecida" = "percent_known_age",
  "mediana" = "median",
  "media" = "mean",
  "dp" = "sd",
  "mes_processamento" = "processing_month",
  "registros_competencia_2024" = "records_competence_2024",
  "medicamento" = "medication",
  "doses_dispensadas" = "doses_dispensed",
  "valor_produzido" = "amount_produced_brl",
  "valor_medio_dose" = "mean_amount_per_dose_brl",
  "doses_aprovadas" = "doses_approved",
  "valor_pago_sus" = "amount_paid_sus_brl",
  "valor_medio_pago" = "mean_amount_paid_per_dose_brl",
  "valor_aprovado" = "amount_approved_brl",
  "medicamentos_recentes" = "most_recent_medications",
  "raca_cor" = "race_colour",
  "pacientes_dispensados" = "patients_dispensed",
  "AP_SEXO" = "sex",
  "categoria_analogo" = "analogue_category",
  "categoria_completa" = "full_category",

  # Valores: categorias
  "Cabergolina" = "Cabergoline",
  "nao recebeu medicamento no mês" = "did not receive medication in the month",
  "TOTAL (pacientes únicos / registros)" = "TOTAL (unique patients / records)",
  "Com idade/raça no PA" = "With age/race in PA (linked)",
  "Sem idade/raça no PA (não vinculado)" = "Without age/race in PA (not linked)",
  "Branca" = "White",
  "Preta" = "Black (Preta)",
  "Parda" = "Brown (Parda)",
  "Amarela" = "Asian (Amarela)",
  "Indígena" = "Indigenous",
  "Não informado" = "Not informed",
  "Outros" = "Other",
  "Centro-Oeste" = "Centre-West",
  "Nordeste" = "Northeast",
  "Norte" = "North",
  "Sudeste" = "Southeast",
  "Sul" = "South",
  "Não identificado" = "Not identified",
  "Brasil (residência conhecida)" = "Brazil (known residence)",
  "Residência ausente" = "Missing residence",
  "Ausente" = "Missing",
  "Idade desconhecida" = "Unknown age",
  "< 18 anos" = "< 18 years",
  "≥ 80 anos" = "≥ 80 years",
  "60 anos ou mais (subtotal)" = "60 years or older (subtotal)",
  "AP_CMP (competência)" = "AP_CMP (competence month)",
  "2024-01 a 2024-12" = "2024-01 to 2024-12",

  # Valores: indicadores
  "Pacientes na coorte" = "Patients in the cohort",
  "Pacientes com E22/E220 no diagnóstico principal em algum registro" = "Patients with E22/E220 as primary diagnosis in at least one record",
  "Pacientes incluídos APENAS pelo diagnóstico secundário (E22/E220)" = "Patients included ONLY through the secondary diagnosis (E22/E220)",
  "Pacientes incluídos APENAS pelo código de três caracteres E22" = "Patients included ONLY through the three-character code E22",
  "Registros com código E22 (três caracteres) em AP_CIDPRI ou AP_CIDSEC" = "Records with the three-character code E22 in AP_CIDPRI or AP_CIDSEC",
  "Pacientes com E220 no diagnóstico principal (coorte restrita)" = "Patients with E220 as primary diagnosis (restricted cohort)",
  "Registros de dispensação em 2024 (antes da exclusão)" = "Dispensing records in 2024 (before exclusion)",
  "Registros sem CNS do paciente (excluídos)" = "Records without patient identifier (excluded)",
  "Autorizações com ao menos um registro sem CNS" = "Authorizations with at least one record without patient identifier",
  "Autorizações excluídas por completo" = "Authorizations excluded entirely",
  "Registros remanescentes" = "Remaining records",
  "Autorizações remanescentes" = "Remaining authorizations",
  "Pacientes únicos (coorte final)" = "Unique patients (final cohort)",
  "Pacientes com residência conhecida (conjunto pareado)" = "Patients with known residence (paired set)",
  "Dispensados na mesma UF de residência" = "Dispensed in the state of residence",
  "Dispensados em outra UF" = "Dispensed in another state",
  "Dispensados na mesma região de residência" = "Dispensed in the region of residence",
  "Dispensados em outra região" = "Dispensed in another region",
  "Primeiro mês de processamento extraído (AM)" = "First processing month extracted (AM)",
  "Último mês de processamento extraído (AM)" = "Last processing month extracted (AM)",
  "Primeiro mês de processamento extraído (PA)" = "First processing month extracted (PA)",
  "Último mês de processamento extraído (PA)" = "Last processing month extracted (PA)",
  "Campo de data que define o período do estudo" = "Date field defining the study period",
  "Competências incluídas" = "Competence months included",
  "Registros AM com competência 2024 processados em 2024" = "AM records with 2024 competence processed in 2024",
  "Registros AM com competência 2024 processados em 2025 (capturados)" = "AM records with 2024 competence processed in 2025 (captured)",
  "Meses de processamento de 2025 com registros de competência 2024" = "2025 processing months with 2024-competence records",

  "Registros de dispensação da coorte (AM)" = "Cohort dispensing records (AM)",
  "Medicamentos adicionais do estudo registrados no PA na mesma APAC (registro x medicamento)" = "Additional study medications recorded in PA within the same APAC (record x medication)",
  "Registros com ao menos um medicamento adicional" = "Records with at least one additional medication",
  "Registros com outro princípio ativo na mesma APAC" = "Records with another active ingredient within the same APAC",
  "Pacientes cujo conjunto de princípios ativos muda ao incluir o PA" = "Patients whose set of active ingredients changes when PA is included",

  # Valores: etapas do fluxograma
  "1a. APAC Medicines (AM) - registros brutos (1 por autorização-competência-processamento)" = "1a. APAC Medicines (AM) - raw records (1 per authorization-competence-processing month)",
  "1b. AM - autorizações únicas" = "1b. AM - unique authorizations",
  "1c. Outpatient Production (PA) - linhas brutas" = "1c. Outpatient Production (PA) - raw rows",
  "1d. PA - autorizações únicas" = "1d. PA - unique authorizations",
  "2. PA agregado para 1 linha por chave (autorização-competência-processamento)" = "2. PA aggregated to 1 row per key (authorization-competence-processing month)",
  "3a. Ligação 1:0..1 - registros AM com chave PA correspondente" = "3a. Linkage 1:0..1 - AM records with a matching PA key",
  "3b. Ligação - registros AM sem chave PA correspondente (mantidos)" = "3b. Linkage - AM records without a matching PA key (kept)",
  "3c. Chaves PA sem registro AM correspondente (excluídas)" = "3c. PA keys without a matching AM record (excluded)",
  "3d. Autorizações PA sem nenhuma correspondência no AM (excluídas)" = "3d. PA authorizations never found in AM (excluded)",
  "3e. Base ligada - registros (igual ao AM)" = "3e. Linked table - records (equal to AM)",
  "4a. Registros com competência fora de 2024 (excluídos)" = "4a. Records with competence outside 2024 (excluded)",
  "4b. Registros com competência 2024" = "4b. Records with 2024 competence",
  "4c. Autorizações com competência 2024" = "4c. Authorizations with 2024 competence",
  "5a. Registros sem identificador do paciente (excluídos)" = "5a. Records without patient identifier (excluded)",
  "5b. Autorizações com registro sem identificador do paciente" = "5b. Authorizations with a record without patient identifier",
  "5c. Autorizações excluídas por completo" = "5c. Authorizations excluded entirely",
  "6a. Coorte final - registros de dispensação" = "6a. Final cohort - dispensing records",
  "6b. Coorte final - registros com correspondência no PA" = "6b. Final cohort - records linked to PA",
  "6c. Coorte final - autorizações" = "6c. Final cohort - authorizations",
  "6d. Coorte final - pacientes únicos (deduplicação pelo CNS)" = "6d. Final cohort - unique patients (deduplicated by encrypted CNS)"
)

# Substituições por padrão (nomes de medicamentos, faixas etárias, colunas mensais)
padroes_en <- c(
  "CABERGOLINA" = "CABERGOLINE",
  "OCTREOTIDA" = "OCTREOTIDE",
  "LANREOTIDA" = "LANREOTIDE",
  "INJETÁVEL" = "INJECTABLE",
  "(\\d),(\\d)" = "\\1.\\2",
  "^(\\d+) a (\\d+) anos$" = "\\1 to \\2 years",
  "^(\\d+)-(\\d+) anos$" = "\\1-\\2 years",
  "^mes_(.+)_frequencia$" = "\\1_patients",
  "^mes_(.+)_percentual$" = "\\1_percent"
)

traduzir_texto <- function(x) {
  x <- as.character(x)
  exato <- !is.na(x) & x %in% names(dicionario_en)
  x[exato] <- dicionario_en[x[exato]]
  x[!exato] <- stringr::str_replace_all(x[!exato], padroes_en)
  x
}

traduzir_df <- function(df) {
  df <- as.data.frame(df, check.names = FALSE)
  names(df) <- traduzir_texto(names(df))
  for (col in names(df)) {
    if (is.character(df[[col]]) || is.factor(df[[col]])) df[[col]] <- traduzir_texto(df[[col]])
  }
  df
}

# Exporta uma tabela (ou lista nomeada de tabelas) para xlsx, em inglês
exportar_xlsx <- function(x, arquivo, sheetName = NULL, ...) {
  if (is.data.frame(x)) {
    aba <- if (is.null(sheetName)) tools::file_path_sans_ext(sub("^\\d{8}_data2024_", "", basename(arquivo))) else sheetName
    x <- setNames(list(x), aba)
  }
  names(x) <- substr(traduzir_texto(names(x)), 1, 31)
  openxlsx::write.xlsx(lapply(x, traduzir_df), arquivo)
}
