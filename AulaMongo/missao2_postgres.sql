-- ============================================================
-- Missão 2 — Postgres: Inserir JSON com 15 níveis usando JSONB
-- Execute com: psql -U postgres -d auladb -f missao2_postgres.sql
-- ============================================================

-- Criar tabela com coluna JSONB
CREATE TABLE IF NOT EXISTS missao2 (
    id          SERIAL PRIMARY KEY,
    dados       JSONB        NOT NULL,
    inserido_em TIMESTAMP    DEFAULT NOW()
);

-- Criar índice GIN para acelerar buscas dentro do JSONB
CREATE INDEX IF NOT EXISTS idx_missao2_dados ON missao2 USING GIN (dados);

-- Inserir o documento com 15 níveis de profundidade
INSERT INTO missao2 (dados) VALUES (
'{
  "empresa": {
    "nome": "TechCorp Brasil",
    "divisao": {
      "nome": "Divisão de Tecnologia",
      "departamento": {
        "nome": "Engenharia de Software",
        "equipe": {
          "nome": "Equipe Backend",
          "projeto": {
            "nome": "Sistema de Entregas",
            "sprint": {
              "numero": 1,
              "tarefa": {
                "titulo": "Implementar API REST",
                "subtarefa": {
                  "titulo": "Criar endpoint de entregas",
                  "etapa": {
                    "descricao": "Definir rotas e controllers",
                    "atividade": {
                      "tipo": "desenvolvimento",
                      "responsavel": {
                        "nome": "João Silva",
                        "contato": {
                          "email": "joao@techcorp.com",
                          "endereco": {
                            "cidade": "São Paulo",
                            "bairro": {
                              "nome": "Vila Olímpia",
                              "localizacao": {
                                "latitude": -23.5987,
                                "longitude": -46.6858,
                                "descricao": "Centro financeiro de SP"
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}'::jsonb
);

-- Verificar a inserção com formatação legível
SELECT id, inserido_em, jsonb_pretty(dados) AS json_formatado
FROM missao2;
