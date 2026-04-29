// ============================================================
// Missão 2 — MongoDB: Inserir JSON com 15 níveis de profundidade
// Execute com: mongosh -u admin -p admin123 --authenticationDatabase admin auladb missao2_mongo.js
// ============================================================

const doc = {
  empresa: {                                              // nível 1
    nome: "TechCorp Brasil",
    divisao: {                                            // nível 2
      nome: "Divisão de Tecnologia",
      departamento: {                                     // nível 3
        nome: "Engenharia de Software",
        equipe: {                                         // nível 4
          nome: "Equipe Backend",
          projeto: {                                      // nível 5
            nome: "Sistema de Entregas",
            sprint: {                                     // nível 6
              numero: 1,
              tarefa: {                                   // nível 7
                titulo: "Implementar API REST",
                subtarefa: {                              // nível 8
                  titulo: "Criar endpoint de entregas",
                  etapa: {                                // nível 9
                    descricao: "Definir rotas e controllers",
                    atividade: {                          // nível 10
                      tipo: "desenvolvimento",
                      responsavel: {                      // nível 11
                        nome: "João Silva",
                        contato: {                        // nível 12
                          email: "joao@techcorp.com",
                          endereco: {                     // nível 13
                            cidade: "São Paulo",
                            bairro: {                     // nível 14
                              nome: "Vila Olímpia",
                              localizacao: {              // nível 15
                                latitude: -23.5987,
                                longitude: -46.6858,
                                descricao: "Centro financeiro de SP"
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
};

db.missao2.insertOne(doc);
print("✓ Documento com 15 níveis inserido com sucesso!");
print(JSON.stringify(db.missao2.findOne({}, { _id: 0 }), null, 2));
