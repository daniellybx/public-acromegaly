# Funções auxiliares para matching probabilístico entre bases de internações
# e medicamentos (Soliris)

# Normalização de sexo
normalize_sexo <- function(x) {
  x <- as.character(x)
  x <- trimws(x)
  x <- dplyr::case_when(
    x == "1" ~ "MASCULINO",
    x == "2" ~ "FEMININO",
    x %in% c("0", "9", "", NA) ~ "IGNORADO",
    TRUE ~ "IGNORADO"
  )
  return(x)
}

# Normalização de município
normalize_mun <- function(x, size = 6) {
  x <- as.character(x)
  x <- stringr::str_extract(x, "\\d+")
  x[is.na(x)] <- ""
  x <- stringr::str_pad(x, width = size, side = "left", pad = "0")
  x <- stringr::str_sub(x, 1, size)
  return(x)
}

# Normalização de CID
normalize_cid <- function(x) {
  x <- as.character(x)
  x <- trimws(toupper(x))
  x <- stringr::str_replace_all(x, "[^A-Z0-9]", "")
  # Preenche com zeros à direita para garantir pelo menos 4 chars
  x <- ifelse(nchar(x) < 4, paste0(x, stringr::str_dup("0", 4 - nchar(x))), x)
  x <- stringr::str_sub(x, 1, 4)
  # Valida formato: letra seguida de 3 dígitos
  x <- ifelse(stringr::str_detect(x, "^[A-Z][0-9]{3}$"), x, "")
  return(x)
}

# Normalização de raça/cor
normalize_raca <- function(x) {
  x <- as.character(x)
  x <- stringr::str_pad(x, width = 2, side = "left", pad = "0")
  x <- dplyr::case_when(
    x == "01" ~ "BRANCA",
    x == "02" ~ "PRETA",
    x == "03" ~ "PARDA",
    x == "04" ~ "AMARELA",
    x == "05" ~ "INDIGENA",
    x == "99" ~ "NAO INFORMADO",
    TRUE ~ "NAO INFORMADO"
  )
  return(x)
}

# Normalização de CEP
normalize_cep <- function(x) {
  x <- as.character(x)
  x <- trimws(x)
  # Remove tudo que não é dígito
  x <- stringr::str_replace_all(x, "[^0-9]", "")
  # Preenche com zeros à esquerda até 8 dígitos
  x <- stringr::str_pad(x, width = 8, side = "left", pad = "0")
  # Se não tiver 8 dígitos válidos, retorna vazio
  x <- ifelse(stringr::str_detect(x, "^[0-9]{8}$"), x, "")
  return(x)
}

# Derivar idade a partir de data de nascimento
derive_idade_from_nasc <- function(x, ref_date = NULL) {
  if (is.null(ref_date)) {
    ref_date <- as.Date("2024-12-31")
  }
  # Converter para data (formato YYYYMMDD)
  dt <- lubridate::ymd(x, quiet = TRUE)
  # Calcular idade
  idade <- as.integer((ref_date - dt) / 365.25)
  return(idade)
}

# Coercion de idade
coerce_idade <- function(x) {
  idade <- as.numeric(x)
  idade <- as.integer(idade)
  return(idade)
}

# Função para testar uma combinação de chaves para matching PA-AP com SIH
test_combination_with_sih <- function(keys, df_pa_ap_norm, df_sih_norm, cns_col) {
  # Remover colunas de merge se existirem (do join anterior)
  pa_ap_clean <- df_pa_ap_norm %>%
    dplyr::select(-dplyr::any_of(c("_merge", "merge_status")))
  
  sih_clean <- df_sih_norm
  
  # Preparar dados PA-AP (deduplicar por chaves)
  pa_ap_dedup <- pa_ap_clean %>%
    dplyr::distinct(dplyr::across(dplyr::all_of(keys)), .keep_all = TRUE)
  
  # Preparar dados SIH
  # Se idade está nas chaves, usar intervalo ±1
  if ("idade_clean" %in% keys) {
    # Expandir SIH para incluir idades no intervalo ±1
    sih_expanded_list <- list()
    for (i in 1:nrow(sih_clean)) {
      idade_base <- sih_clean$idade_clean[i]
      if (!is.na(idade_base)) {
        idade_min <- max(0, as.integer(idade_base) - 1)
        idade_max <- as.integer(idade_base) + 1
        for (idade_match in idade_min:idade_max) {
          row_copy <- sih_clean[i, ]
          row_copy$idade_clean <- idade_match
          sih_expanded_list[[length(sih_expanded_list) + 1]] <- row_copy
        }
      }
    }
    
    if (length(sih_expanded_list) > 0) {
      sih_expanded_df <- dplyr::bind_rows(sih_expanded_list)
      sih_dedup <- sih_expanded_df %>%
        dplyr::distinct(dplyr::across(dplyr::all_of(keys)), .keep_all = TRUE)
    } else {
      sih_dedup <- sih_clean[0, ]  # DataFrame vazio
    }
  } else {
    sih_dedup <- sih_clean %>%
      dplyr::distinct(dplyr::across(dplyr::all_of(keys)), .keep_all = TRUE)
  }
  
  # Fazer left join (PA-AP à esquerda, SIH à direita)
  merged <- pa_ap_dedup %>%
    dplyr::left_join(sih_dedup, by = keys, suffix = c("_pa_ap", "_sih"))
  
  # Verificar se houve match usando N_AIH (coluna específica de internações)
  # Primeiro verificar se N_AIH_sih existe (com sufixo)
  n_aih_col_sih <- "N_AIH_sih"
  if (!n_aih_col_sih %in% names(merged)) {
    # Se não tem sufixo, verificar se N_AIH existe sem sufixo
    if ("N_AIH" %in% names(merged)) {
      n_aih_col_sih <- "N_AIH"
    } else {
      # Se não tem N_AIH, usar primeira coluna de SIH que não seja chave
      sih_cols <- setdiff(names(sih_dedup), keys)
      if (length(sih_cols) > 0) {
        n_aih_col_sih <- paste0(sih_cols[1], "_sih")
        if (!n_aih_col_sih %in% names(merged)) {
          n_aih_col_sih <- sih_cols[1]
        }
      } else {
        n_aih_col_sih <- NULL
      }
    }
  }
  
  # Adicionar indicador de match
  if (!is.null(n_aih_col_sih) && n_aih_col_sih %in% names(merged)) {
    merged <- merged %>%
      dplyr::mutate(
        merge_match = dplyr::if_else(
          !is.na(.data[[n_aih_col_sih]]),
          "both",
          "left_only"
        )
      )
  } else {
    merged <- merged %>%
      dplyr::mutate(merge_match = "left_only")
  }
  
  # Contar matches
  matches <- sum(merged$merge_match == "both", na.rm = TRUE)
  
  # Contar CNS únicos que tiveram match
  if (!is.null(cns_col) && cns_col %in% names(merged)) {
    cns_matched <- merged %>%
      dplyr::filter(merge_match == "both") %>%
      dplyr::distinct(.data[[cns_col]]) %>%
      nrow()
  } else {
    cns_matched <- 0
  }
  
  # Contar internações únicas que deram match
  n_aih_col <- NULL
  if ("N_AIH_sih" %in% names(merged)) {
    n_aih_col <- "N_AIH_sih"
  } else if ("N_AIH" %in% names(merged)) {
    n_aih_col <- "N_AIH"
  }
  
  if (!is.null(n_aih_col) && n_aih_col %in% names(merged)) {
    internacoes_matched <- merged %>%
      dplyr::filter(merge_match == "both") %>%
      dplyr::distinct(.data[[n_aih_col]]) %>%
      nrow()
  } else {
    internacoes_matched <- 0
  }
  
  return(list(
    chaves = paste(keys, collapse = " + "),
    matches = matches,
    cns_unicos_internados = cns_matched,
    internacoes_unicas = internacoes_matched,
    media_internacoes_por_cns = ifelse(cns_matched > 0, internacoes_matched / cns_matched, 0)
  ))
}
