# Respostas - Aula 10: Modelagem e Consultas em MongoDB

> **Conceitos Principais:**
> - **Modelagem NoSQL:** Incorporação (Embedding) vs. Referência (Reference)
> - **Operadores de Consulta:** $exists, $gte, $lt, $and, $or
> - **Aggregation Framework:** Pipeline para relatórios complexos

---

## Parte 1: Modelagem de Dados

### Exercício 1.1: Incorporação (Embedding)

**Pergunta:** Por que colocar os módulos dentro do documento do curso (incorporar) é melhor para o desempenho de leitura?

**Resposta - Documento com Embedding:**

```javascript
db.cursos.insertOne({
  _id: 1,
  nome: "MongoDB para Iniciantes",
  instrutor: "João Silva",
  preco: 99.90,
  modulos: [
    {
      nome: "Introdução ao MongoDB",
      carga_horaria: 4
    },
    {
      nome: "Operações CRUD",
      carga_horaria: 6
    },
    {
      nome: "Agregação e Pipelines",
      carga_horaria: 8
    }
  ]
})
```

**Justificativa:**
- ✅ **Uma única consulta:** Tudo está em um documento, não precisa fazer joins
- ✅ **Melhor desempenho:** Menos requisições ao banco de dados
- ✅ **Atomicidade:** Todos os dados do curso são atualizados juntos
- ✅ **Ideal quando:** Os módulos sempre são consultados junto com o curso

---

### Exercício 1.2: Referência (Reference)

**Pergunta:** Em que situação seria preferível referenciar o instrutor em vez de copiar os dados dele dentro de cada curso?

**Resposta - Documentos com Referência:**

```javascript
// Documento 1: Instrutor
db.instrutores.insertOne({
  _id: 101,
  nome: "João Silva",
  email: "joao@email.com",
  experiencia: "15 anos",
  especialidade: "Bases de Dados"
})

// Documento 2: Curso (referencia o instrutor)
db.cursos.insertOne({
  _id: 1,
  nome: "MongoDB para Iniciantes",
  instrutor_id: 101,  // Referência para o documento do instrutor
  preco: 99.90,
  duracao_semanas: 4
})

// Documento 3: Outro Curso (mesmo instrutor)
db.cursos.insertOne({
  _id: 2,
  nome: "MongoDB Avançado",
  instrutor_id: 101,  // Reutiliza o mesmo instrutor
  preco: 149.90,
  duracao_semanas: 6
})
```

**Quando usar Referência:**
- ✅ **Um instrutor ministra múltiplos cursos:** Evita duplicação de dados
- ✅ **Os dados do instrutor mudam frequentemente:** Atualiza em um só lugar
- ✅ **Documentos muito grandes:** Mantém cada documento menor
- ✅ **Relações Many-to-Many:** Um instrutor em vários cursos e vice-versa

**Exemplo de Consulta com $lookup (JOIN):**
```javascript
// Para recuperar os dados do instrutor junto com o curso
db.cursos.aggregate([
  {
    $match: { _id: 1 }
  },
  {
    $lookup: {
      from: "instrutores",
      localField: "instrutor_id",
      foreignField: "_id",
      as: "instrutor_dados"
    }
  }
])
```

✅ **Status:** Conceitos explicados corretamente!

---

## Parte 2: Consultas e Filtros

### Exercício 2.1: Filtro de Existência com $exists

**Pergunta:** Encontrar todos os clientes que possuem o campo `email` preenchido

**Resposta:**

```javascript
// Encontrar clientes que têm o campo email (preenchido ou não)
db.clientes.find({
  email: { $exists: true }
})

// Mais restritivo: encontrar clientes com email preenchido e não vazio
db.clientes.find({
  email: { $exists: true, $ne: null }
})

// Encontrar clientes que NÃO têm o campo email
db.clientes.find({
  email: { $exists: false }
})
```

**Explicação:**
- `$exists: true` - O campo existe no documento
- `$exists: false` - O campo não existe no documento
- `$ne: null` - O campo não é nulo (está preenchido)

✅ **Status:** Operador $exists correto!

---

### Exercício 2.2: Filtro de Comparação com $gte

**Pergunta:** Encontrar clientes com `idade` maior ou igual a 21 anos

**Resposta:**

```javascript
// Clientes com idade >= 21
db.clientes.find({
  idade: { $gte: 21 }
})

// Outros operadores de comparação úteis:
// $gt  - maior que (>)
// $gte - maior ou igual (>=)
// $lt  - menor que (<)
// $lte - menor ou igual (<=)
// $eq  - igual (=)
// $ne  - não igual (!=)

// Exemplo: Clientes entre 21 e 65 anos
db.clientes.find({
  idade: { $gte: 21, $lte: 65 }
})
```

✅ **Status:** Operador $gte correto!

---

### Exercício 2.3: Filtro Complexo com $and e $lt

**Pergunta:** Buscar clientes que moram em "São Paulo" **E** têm idade inferior a 30 anos

**Resposta:**

```javascript
// Método 1: Usando a sintaxe implícita (AND implícito)
db.clientes.find({
  cidade: "São Paulo",
  idade: { $lt: 30 }
})

// Método 2: Usando $and explícito (mais legível em casos complexos)
db.clientes.find({
  $and: [
    { cidade: "São Paulo" },
    { idade: { $lt: 30 } }
  ]
})

// Método 3: Se fosse OU (OR), usaria $or
db.clientes.find({
  $or: [
    { cidade: "São Paulo" },
    { idade: { $lt: 30 } }
  ]
})
```

**Explicação:**
- `$lt` = less than (menor que)
- Múltiplas condições no mesmo `find()` = AND implícito
- `$and` = E (ambas condições devem ser verdadeiras)
- `$or` = OU (pelo menos uma condição deve ser verdadeira)

✅ **Status:** Filtros complexos corretos!

---

## Parte 3: Aggregation Framework (Relatórios)

### Exercício 3: Pipeline de Agregação

**Pergunta:** Gerar um relatório que:
1. Filtre apenas as vendas com `status: "concluída"`
2. Agrupe os dados por `categoria`
3. Calcule a soma total da `quantidade` vendida por categoria

**Resposta - Pipeline de Agregação:**

```javascript
// Exemplo: Inserir dados de vendas
db.vendas.insertMany([
  { produto: "Webcam", categoria: "Periféricos", quantidade: 3, preco_unitario: 200.00, status: "concluída" },
  { produto: "Mouse", categoria: "Periféricos", quantidade: 10, preco_unitario: 50.00, status: "concluída" },
  { produto: "Monitor", categoria: "Monitores", quantidade: 2, preco_unitario: 800.00, status: "concluída" },
  { produto: "Teclado", categoria: "Periféricos", quantidade: 5, preco_unitario: 150.00, status: "pendente" },
  { produto: "Headset", categoria: "Áudio", quantidade: 4, preco_unitario: 300.00, status: "concluída" }
])

// Pipeline de Agregação
db.vendas.aggregate([
  // Estágio 1: FILTRO - Apenas vendas concluídas
  {
    $match: {
      status: "concluída"
    }
  },
  
  // Estágio 2: AGRUPAMENTO - Agrupar por categoria
  {
    $group: {
      _id: "$categoria",  // Campo para agrupar
      total_quantidade: { $sum: "$quantidade" },  // Somar as quantidades
      total_vendas: { $sum: 1 },  // Contar quantas vendas
      preco_medio: { $avg: "$preco_unitario" }  // Calcular preço médio
    }
  },
  
  // Estágio 3: ORDENAÇÃO (opcional) - Ordenar pelo maior volume
  {
    $sort: { total_quantidade: -1 }
  }
])
```

**Resultado esperado:**
```javascript
[
  {
    _id: "Periféricos",
    total_quantidade: 13,
    total_vendas: 2,
    preco_medio: 125
  },
  {
    _id: "Monitores",
    total_quantidade: 2,
    total_vendas: 1,
    preco_medio: 800
  },
  {
    _id: "Áudio",
    total_quantidade: 4,
    total_vendas: 1,
    preco_medio: 300
  }
]
```

**Explicação dos Estágios do Pipeline:**

| Operador | Função |
|----------|--------|
| `$match` | Filtra documentos (como WHERE do SQL) |
| `$group` | Agrupa documentos por um campo |
| `$sum` | Soma valores (pode usar `1` para contar) |
| `$avg` | Calcula média |
| `$min` / `$max` | Encontra valor mínimo ou máximo |
| `$sort` | Ordena os resultados (-1 descendente, 1 ascendente) |
| `$project` | Seleciona/projeta campos (como SELECT) |
| `$limit` | Limita o número de documentos |

**Exemplo Avançado: Relatório com Cálculos Adicionais**

```javascript
db.vendas.aggregate([
  { $match: { status: "concluída" } },
  
  {
    $group: {
      _id: "$categoria",
      total_quantidade: { $sum: "$quantidade" },
      total_faturamento: { $sum: { $multiply: ["$quantidade", "$preco_unitario"] } },
      quantidade_produtos: { $sum: 1 }
    }
  },
  
  {
    $project: {
      _id: 1,
      total_quantidade: 1,
      total_faturamento: { $round: ["$total_faturamento", 2] },
      quantidade_produtos: 1,
      ticket_medio: { $divide: ["$total_faturamento", "$quantidade_produtos"] }
    }
  },
  
  { $sort: { total_faturamento: -1 } }
])
```

✅ **Status:** Pipeline de agregação correto!

---

## Resumo dos Conceitos

### Modelagem
- **Embedding:** Melhor para leitura, evita joins, mas causa redundância
- **Reference:** Melhor para atualização, evita redundância, mas requer joins

### Operadores de Filtro
- `$exists` - Verifica existência de campo
- `$gte`, `$gt`, `$lte`, `$lt` - Comparações numéricas
- `$and`, `$or` - Operadores lógicos

### Aggregation Framework
- Pipeline de múltiplos estágios
- `$match` → `$group` → `$project` → `$sort`
- Permite relatórios complexos sem código de aplicação

---

**Aula concluída com sucesso! 🎓**
