# Terceira revisão (3a_Rev_AcroSUS_Completo) – artefatos corrigidos

Esta pasta reúne as saídas dos dois notebooks corrigidos (`notebooks/acromegalia_uniao_medicamentos.ipynb` e `notebooks/acromegalia_analise_medicamentos.ipynb`), executados em 13/10/2026. Todos os arquivos têm o prefixo `20261013_`. O texto em inglês da resposta aos revisores, com sugestões de redação para o manuscrito, está em [response_to_reviewers_draft.md](response_to_reviewers_draft.md).

## Números principais da coorte corrigida

| Indicador | Antes | Agora |
|---|---:|---:|
| Pacientes | 4.232 | **4.231** |
| Registros de dispensação 2024 | 47.743 (inflado pelo join) | **38.559** |
| Autorizações 2024 | 19.053 | **18.831** |
| Registros excluídos sem CNS | – | 434 (282 autorizações) |
| Residência ausente | 468–496 (`PA_MUNPCN`) | **0** (`AP_MUNPCN`) |
| Taxa Brasil (por milhão, residência) | – | 19,83 (IC95% 19,24–20,44) |

## Item da revisão → artefato

| Item | O que foi feito | Arquivo(s) |
|---|---|---|
| 1 – Denominador | Registros sem `AP_CNSPCN` excluídos de todas as análises de paciente; a validação fixa em 4.232 foi removida | `exclusao_sem_cns.xlsx`, todas as tabelas |
| 1c / 5 – Figura 1 | Fluxograma refeito: agregação do PA, ligação 1:0..1, filtro 2024, exclusão sem CNS; sem o rótulo "deduplicated" | `fluxograma_uniao_dados.png/.xlsx` |
| 2 – Definição de caso | Pacientes por via de inclusão (principal/secundário/E22) e comparação com a coorte restrita a CID principal E220 | `definicao_caso_cid.xlsx` |
| 3 – Geografia | Taxas por milhão (IC95% Poisson exato) por **residência** (`AP_MUNPCN`); estabelecimento só como contagem; ausentes por região de dispensação; matriz pareada residência × dispensação; mesmo conjunto de pacientes | `geografia_residencia_taxas.xlsx`, `uf_estabelecimento_dispensacao.xlsx`, `regiao_estabelecimento_dispensacao.xlsx`, `mapa_uf_*.png` |
| 4 – Figura 2 | Rotulada como "dispensação mensal registrada"; N = 4.231; "No dispensing record" definido; combinações mantidas; cor das faixas pelo mês de origem | `figura2_dispensacao_mensal_registrada.png`, `figura2_dispensacao_mensal_dados.xlsx` |
| 5a/5b – Ligação | PA agregado para 1 linha por chave antes do join; join `one-to-one`; ligação por autorização separada da deduplicação por paciente | notebook seção 3, `fluxograma_uniao_dados.xlsx` |
| 5c – Demografia ausente | Os 468 com idade/raça ausentes são exatamente os não vinculados ao PA; avaliação empírica com os campos do AM | `demografia_ausente_ligacao.xlsx` |
| 6a – Período | Janela de extração (processamento 2023-01 a 2025-02), campo `AP_CMP`, 41 registros de 2024 processados em 2025 | `janela_extracao.xlsx` |
| 7a/7b/7e – Idade | Percentuais com os dois denominadores, rótulo "≥ 80", mediana e IIQ | `idade.xlsx`, `piramide_etaria.png` |
| 7c – Tabela 4 | Categorias mutuamente exclusivas (octreotida sem lanreotida, lanreotida sem octreotida, ambos) | `tabela4_categorias_medicamentos.xlsx` |
| 8a – SIGTAP | Tabela suplementar com os 8 códigos | `codigos_sigtap.xlsx` |
| 6b–d, 7d, 7f, 7g, 8b–d | Ajustes de texto: só no manuscrito | `response_to_reviewers_draft.md` |

Também regeneradas com a coorte corrigida: `sexo`, `raca_cor`, `combinacoes_medicamentos`, `medicamentos_recentes`, `medicamentos_gasto`, `acromegalia_abandono_anual`, `usuarios_unicos_medicamento_mes`.

## Achados que mudam a interpretação

1. **Residência**: o campo `AP_MUNPCN` do AM está completo. A ausência de residência vinha do uso de `PA_MUNPCN`. 99,55% dos pacientes são dispensados na própria região de residência e 99,05% na própria UF; a ideia de 473 pacientes "viajando" para o Sudeste não se sustenta.
2. **Perda diferencial na demografia**: 98,7% dos 468 pacientes sem idade/raça residem no Sudeste. Pelos campos do AM, eles têm idade e sexo semelhantes aos demais, porém mais pardos e pretos (42,7% + 7,7% versus 36,2% + 4,8%). A distribuição de raça/cor por caso completo superestima brancos. A idade do AM coincide com a do PA (±1 ano) em 100% dos vinculados, então usar `AP_NUIDADE`/`AP_RACACOR` é uma alternativa sem dados ausentes, se os autores quiserem.
3. **CID**: nenhum registro do AM traz o código `E22` de três caracteres. Apenas 1 paciente (CID principal E221, secundário E220, cabergolina) entrou pelo campo secundário.

## Mudanças nos notebooks

Nos dois notebooks:
- Saídas gravadas em `resultados/third_review/`.
- Novas seções: ligação AM+PA 1:0..1, exclusão sem CNS (4.1), janela de extração (5.1), definição de caso (5.2), demografia × ligação (6.2.1), residência e taxas (6.7) e Tabela 4 (7.2.1).
- Tabelas por estabelecimento renomeadas (contagens, sem taxa).
- Caminho absoluto inexistente do Sankey trocado por `../data/processed/`.

Só no `acromegalia_analise_medicamentos.ipynb`:
- Corrigido o erro de códigos de raça/cor (03 e 04 estavam trocados: Parda/Amarela).
- Mapas refeitos: contagem por estabelecimento; contagem e taxa por milhão por residência.

Só no `acromegalia_uniao_medicamentos.ipynb`:
- Figura 2 (7.4.4) e fluxograma (9) refeitos.
- Os alluviais exploratórios 7.4.2/7.4.3 continuam no notebook com uma nota, mas não são mais salvos em disco.

## Pontos de atenção (não pedidos pela revisão, não alterados)

- `medicamentos_gasto`: os valores do PA são somados por medicamento do AM (`AP_PRIPAL`), incluindo linhas do PA com outros procedimentos da mesma APAC. A distribuição de valores entre medicamentos parece pouco plausível (quase todo o valor fica em octreotida 10 mg) e merece revisão antes de ser usada no texto.
- A classificação de medicamentos usa só o procedimento principal do AM. Parte das linhas do PA vinculadas registram outro medicamento na mesma APAC, o que pode indicar uso concomitante não capturado.
