# Missão 3 — Query no 15º Nível: Comparativo MongoDB vs Postgres

## Estrutura dos 15 níveis

```
empresa → divisao → departamento → equipe → projeto →
sprint → tarefa → subtarefa → etapa → atividade →
responsavel → contato → endereco → bairro → localizacao
```

---

## MongoDB — Query no nível 15

**Buscar pelo campo `descricao` no nível 15 (dot notation):**

```javascript
db.missao2.find({
  "empresa.divisao.departamento.equipe.projeto.sprint.tarefa.subtarefa.etapa.atividade.responsavel.contato.endereco.bairro.localizacao.descricao": "Centro financeiro de SP"
})
```

**Projetar somente o valor do nível 15:**

```javascript
db.missao2.findOne(
  {},
  { "empresa.divisao.departamento.equipe.projeto.sprint.tarefa.subtarefa.etapa.atividade.responsavel.contato.endereco.bairro.localizacao": 1, _id: 0 }
)
```

---

## Postgres — Query no nível 15

**Extrair o campo `descricao` no nível 15 com operadores JSONB:**

```sql
SELECT
  dados
    -> 'empresa'
    -> 'divisao'
    -> 'departamento'
    -> 'equipe'
    -> 'projeto'
    -> 'sprint'
    -> 'tarefa'
    -> 'subtarefa'
    -> 'etapa'
    -> 'atividade'
    -> 'responsavel'
    -> 'contato'
    -> 'endereco'
    -> 'bairro'
    -> 'localizacao'
    ->> 'descricao' AS nivel_15_descricao
FROM missao2;
```

**Filtrar por valor no nível 15:**

```sql
SELECT id
FROM missao2
WHERE dados
  -> 'empresa'
  -> 'divisao'
  -> 'departamento'
  -> 'equipe'
  -> 'projeto'
  -> 'sprint'
  -> 'tarefa'
  -> 'subtarefa'
  -> 'etapa'
  -> 'atividade'
  -> 'responsavel'
  -> 'contato'
  -> 'endereco'
  -> 'bairro'
  -> 'localizacao'
  ->> 'descricao' = 'Centro financeiro de SP';
```

---

## Relatório Comparativo

| Critério                  | MongoDB                                  | Postgres (JSONB)                          |
|---------------------------|------------------------------------------|-------------------------------------------|
| **Sintaxe de acesso**     | Dot notation — uma string longa          | Encadeamento de operadores `->` / `->>`   |
| **Legibilidade**          | Difícil: tudo numa string                | Moderada: operadores separados por linha  |
| **Índice disponível**     | Índice em campo específico (dot path)    | Índice GIN no campo JSONB inteiro         |
| **Desempenho sem índice** | Collection scan (lento)                  | Sequential scan (lento)                   |
| **Desempenho com índice** | Rápido com índice criado no dot path     | Rápido com índice GIN + `@>` operator     |
| **Schema enforcement**    | Nenhum (flexível por natureza)           | Nenhum para JSONB (schema-less dentro)    |
| **Esforço de escrita**    | Baixo — linguagem nativa para documentos | Médio — SQL não foi projetado para isso   |
| **Manutenção**            | Direto — documentos aninhados são nativos| Verboso — 14 operadores encadeados        |

### Conclusão

- **MongoDB** é mais natural para documentos profundamente aninhados: a notação de ponto é concisa para escrever, mas difícil de ler em 15 níveis.
- **Postgres com JSONB** permite consultas poderosas e índices eficientes, porém o encadeamento de 14+ operadores `->` torna a query verbosa e propensa a erros.
- Para dados com estrutura fixa, **normalizar em tabelas relacionais** no Postgres é sempre mais eficiente do que JSONB muito aninhado.
