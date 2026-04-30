## Respostas - Aula 09: MongoDB CRUD no Catalogo de E-commerce

> **Conceitos CRUD:**
> - **C (CREATE):** Criar/inserir novos documentos
> - **R (READ):** Ler/consultar documentos existentes
> - **U (UPDATE):** Atualizar/modificar documentos
> - **D (DELETE):** Deletar/remover documentos

---

### Parte 1: Exercicios Praticos

#### Exercicio 1: Criacao e Colecoes (O "C" do CRUD) - CREATE

**Resposta:**

```javascript
// 1. Criar/selecionar banco de dados
use loja_virtual

// 2. Criar colecao
db.createCollection("produtos")

// 3. Inserir um produto com insertOne()
db.produtos.insertOne({
    nome: "Smartphone Galaxy A15",
    categoria: "Eletronicos",
    preco: 1299.90,
    marca: "Samsung",
    armazenamento: "128GB",
    cor: "Azul"
})

// 4. Inserir multiplos produtos com insertMany()
db.produtos.insertMany([
  {
    nome: "MongoDB na Pratica",
    categoria: "Livros",
    preco: 79.90,
    autor: "Joao Silva",
    editora: "Tech Books",
    paginas: 320
  }, 
  {
    nome: "Camiseta Basica",
    categoria: "Roupas",
    preco: 49.90,
    tamanho: "M",
    cor: "Preta",
    material: "Algodao"
  }, 
  {
    nome: "Notebook Ultra X",
    categoria: "Eletronicos",
    preco: 3899.90,
    marca: "Lenovo",
    memoria_ram: "16GB",
    processador: "Intel i7"
  }, 
  {
    nome: "Tenis Runner Pro",
    categoria: "Calcados",
    preco: 299.90,
    tamanho: 42,
    cor: "Branco",
    marca: "Olympikus"
  }
])
```

#### Exercicio 2: Consultas e Filtros (O "R" do CRUD) - READ

**Resposta:**

```javascript
// 1. Listar todos os produtos da colecao
db.produtos.find()

// 2. Buscar produtos com preco superior a 100 (operador $gt = greater than)
db.produtos.find({ preco: { $gt: 100 } })

// 3. Listar apenas produtos da categoria "Eletronicos"
db.produtos.find({ categoria: "Eletronicos" })

// 4. Retornar apenas nome e preco dos produtos (projecao)
// 1 = mostrar o campo, 0 = nao mostrar
db.produtos.find({}, { nome: 1, preco: 1 })
```

#### Exercicio 3: Atualizacao Dinamica (O "U" do CRUD) - UPDATE

**Resposta:**

```javascript
// 1. Atualizar preco de um produto especifico com $set (updateOne)
db.produtos.updateOne(
    { categoria: "Eletronicos" }, 
    { $set: { preco: 5000 } }
)

// 2. Adicionar novo campo "estoque" para TODOS os produtos (updateMany)
db.produtos.updateMany(
    {}, 
    { $set: { estoque: 0 } }
)

// 3. Marcar produtos da categoria "Roupas" com promocao: true (updateMany)
db.produtos.updateMany(
    { categoria: "Roupas" }, 
    { $set: { promocao: true } }
)
```

#### Exercicio 4: Exclusao de Dados (O "D" do CRUD) - DELETE

**Resposta:**

```javascript
// 1. Remover um produto especifico (deleteOne - remove apenas o PRIMEIRO encontrado)
db.produtos.deleteOne({ nome: "Tenis Runner Pro" })

// 2. Remover TODOS os produtos de uma categoria (deleteMany)
db.produtos.deleteMany({ categoria: "Roupas" })
```