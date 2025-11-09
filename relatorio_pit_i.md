# Relatório de Continuação — PIT I (Entrega Atualizada)

Nome: MOHAMED RADWAN MOHAMED SOLIMAN  
RGM: 40913392  
Data da geração deste documento: 2025-11-09

Narrativa breve do que eu (assistente) fiz aqui:
- Preparei este documento atualizado com a estrutura exigida pela entrega: seção de Documentação (checklist de melhorias), tabela de Codificação preenchida com as escolhas técnicas, template e exemplos de Testes da Solução para 5 avaliadores, Laudo de Qualidade com problemas, evidências e recomendações, e instruções para o Vídeo final.
- O próximo passo é você (estudante) completar os campos com os links reais (repositório, deploy, vídeo), executar os testes com 5 colegas reais, coletar evidências e aplicar correções no código. Depois suba a documentação finalizada no repositório Git indicado.

---

## 1. Documentação (atualizações e melhorias sugeridas)
Revisite a documentação original do projeto da PIT I e aplique as seguintes melhorias recomendadas:

Checklist de atualizações
- [ ] README.md completo (objetivo do projeto, tecnologias, pré-requisitos, instruções de instalação e execução).
- [ ] Arquivo .env.example com todas as variáveis de ambiente necessárias (ex.: MONGO_URI, PORT, JWT_SECRET).
- [ ] Documentação da API (OpenAPI / Swagger ou um arquivo API.md com rotas, parâmetros, exemplos de request/response).
- [ ] Diagrama de arquitetura (pode ser um PNG/SVG explicando front-end, back-end, DB e hosting).
- [ ] Guia de Deploy com passos para Render (ou provedor usado), incluindo build commands e variáveis de ambiente.
- [ ] Guia de testes (como rodar testes automatizados, endpoints de teste e cobertura mínima).
- [ ] CHANGELOG.md (resumo das mudanças entre PIT I e esta versão).
- [ ] Lista de issues conhecidas e limitações (KNOWN_ISSUES.md).
- [ ] Licença e contatos (LICENSE, CONTATO.md com seu e-mail/GitHub).
- [ ] Scripts de lint/test/build no package.json e instruções de uso.

Sugestões de melhorias técnicas a documentar
- Explicar escolha: Node.js (versão), MongoDB (versão e cluster local/Atlas), Driver/ODM usado (ex.: Mongoose ou Prisma).
- Incluir exemplos de payloads e cURL para as principais rotas (login, CRUDs).
- Instruções para restauração do banco (dump/restore) se necessário.
- Política de segurança (procure não commitar secrets; use variáveis de ambiente).

Commit e push
- Sempre rode: git add . && git commit -m "docs: atualizar documentação PIT I" && git push origin main
- Sugestão: criar branch docs/update e abrir PR para main se usar fluxo com revisão.

---

## 2. Codificação (dados fornecidos)
Linguagem do Back-end: Node.js  
Banco de Dados: MongoDB  
Hospedagem: Render  
Plataforma: Web (React)  
Modo de Codificação: (X) Tradicional  ( ) Low-code  ( ) No-code

Links (preencha com suas URLs reais):
- Link do repositório no GitHub com os códigos abertos: [COLOQUE_AQUI]
- Link da solução em funcionamento (deploy): [COLOQUE_AQUI]
- Link do vídeo narrado (mínimo 5 min): [COLOQUE_AQUI]

Observações técnicas/stack sugerida
- Back-end: Node.js + Express ou Fastify, com TypeScript recomendado (opcional).
- ODM: Mongoose (para MongoDB) ou Prisma (agora com melhor suporte).
- Autenticação: JWT com refresh tokens (se aplicável).
- Linter/formatter: ESLint + Prettier.
- Testes: Jest + supertest para endpoints.
- Dockerfile e docker-compose (opcional, facilita desenvolvimento local).

---

## 3. Testes da Solução (modelo para 5 colegas)
Nota: abaixo há 5 relatórios de teste — substitua os nomes/datas/descrições pelos resultados reais obtidos com seus colegas.

1) Nome: Ana Silva  
   Data do teste: 2025-11-02  
   O que testou e funcionou:
   - Cadastro de usuário (POST /api/users) — cadastro concluído, resposta 201.
   - Login (POST /api/auth) — token JWT recebido e utilizado para rotas protegidas.
   O que testou e não funcionou – O que deve ser corrigido:
   - Upload de imagem de perfil retornou 500 em alguns arquivos grandes — limitar tamanho e tratar erro no back-end.
   Funcionalidade não testada (faltou ou não foi implementada):
   - Rotina de recuperação de senha (reset password).

2) Nome: João Pereira  
   Data do teste: 2025-11-03  
   O que testou e funcionou:
   - Listagem de objetos (GET /api/items) com paginação, filtros mínimos ok.
   - Interface React exibiu dados corretamente.
   O que testou e não funcionou – O que deve ser corrigido:
   - Filtro por data não retornou resultados esperados — revisar parsing de datas no backend.
   Funcionalidade não testada (faltou ou não foi implementada):
   - Teste de permissões de usuário (roles/ACL).

3) Nome: Maria Souza  
   Data do teste: 2025-11-04  
   O que testou e funcionou:
   - Edição de registro (PUT /api/items/:id) — atualização feita e refletida no front.
   O que testou e não funcionou – O que deve ser corrigido:
   - Mensagens de erro no front mostravam texto genérico em vez das mensagens detalhadas retornadas pela API — padronizar tratamento de erros no front.
   Funcionalidade não testada (faltou ou não foi implementada):
   - Testes automatizados (unit/integration) não foram executados.

4) Nome: Lucas Oliveira  
   Data do teste: 2025-11-05  
   O que testou e funcionou:
   - Logout e invalidação de token do lado do cliente — sessão encerrada no front.
   O que testou e não funcionou – O que deve ser corrigido:
   - Sessões simultâneas não são isoladas corretamente (mesma conta em dois browsers) — revisar armazenamento de refresh tokens.
   Funcionalidade não testada (faltou ou não foi implementada):
   - Logs de auditoria (histórico de alterações).

5) Nome: Pedro Santos  
   Data do teste: 2025-11-06  
   O que testou e funcionou:
   - Rotas públicas funcionaram (home, about).
   - Deploy na Render acessível.
   O que testou e não funcionou – O que deve ser corrigido:
   - Build falhou localmente em Node v18 (diferença de engines) — travar engine em package.json ou documentar versão suportada.
   Funcionalidade não testada (faltou ou não foi implementada):
   - Teste de carga (stress) / performance.

Instruções para coleta de dados dos testes
- Para cada teste peça: nome completo do colega, data, passos executados, prints/screenshots (UI), logs do console do browser, resposta JSON bruta (quando aplicável), e status HTTP recebido.
- Salve as evidências em uma pasta `evidencias/` no repositório, nomeando arquivos como `teste_<nome>_<data>_screenshot.png` e `teste_<nome>_<data>_api_response.json`.

---

## 4. Laudo de Qualidade (resumo de problemas encontrados, severidade, ação corretiva)
Observação: este laudo contém itens detectados durante testes de amostra e recomendações práticas. Ajuste com base nos testes reais.

Problemas identificados
1) Upload de arquivos grandes causa 500 (Severidade: Alta)  
   - Causa provável: falta de validação de tamanho ou timeouts no servidor.  
   - Correção sugerida:
     - No front, limitar tamanho e tipo de arquivo antes do envio.
     - No back, validar tamanho e tratar erros; configurar body-parser / multer com limites.
     - Adicionar resposta clara 413 Payload Too Large quando exceder limite.

2) Parsing de datas (Severidade: Média)  
   - Causa provável: inconsistência de timezone/formato entre front e back.  
   - Correção sugerida:
     - Padronizar formato (ISO 8601) e usar bibliotecas (luxon/dayjs) para parse.
     - Adicionar testes de integração para filtros por data.

3) Mensagens de erro não padronizadas (Severidade: Baixa/Média)  
   - Causa provável: mensagens de erros diferentes entre camadas e falta de middleware de erro.  
   - Correção sugerida:
     - Implementar middleware global de tratamento de erro no Express.
     - Definir padrão de resposta de erro { error: { code, message, details? } }.

4) Incompatibilidade de versão do Node (Severidade: Média)  
   - Causa provável: projeto desenvolvido/testado com outra versão de Node.  
   - Correção sugerida:
     - Adicionar "engines" no package.json.
     - Atualizar README com versão recomendada e instruções nvm use.

5) Ausência de testes automatizados (Severidade: Média)  
   - Correção sugerida:
     - Criar testes unitários para funções críticas e testes de integração para rotas principais usando Jest + supertest.
     - Adicionar GitHub Action/CICD que roda testes em PR.

Evidências recomendadas a coletar
- Prints das telas que apresentaram erro.
- Capturas da aba Network (devtools) com request/response.
- Logs do servidor contendo stack trace (salvar em arquivos logs/).
- Capturas de testes automatizados (saída do terminal).
- Arquivos de configuração (package.json, .env.example).

Modelo de entrada do laudo final (exemplo breve)
- Item: Upload de perfil
  - Gravidade: Alta
  - Evidência: evidencias/upload_fail_2025-11-02.png, logs/server_upload_2025-11-02.log
  - Ação tomada: limite de 2MB aplicado em multer, tratamento de erro acrescentado.
  - Status: Corrigido / Pendente / Em progresso

---

## 5. Vídeo da Solução atualizada (até 5 minutos)
Checklist do que mostrar no vídeo (sugestão de roteiro para ≤ 5 min)
1. Identificação: Nome, RGM, versão do projeto (10s).
2. Objetivo do projeto e breve stack (Node.js, MongoDB, React, Render) (20s).
3. Principais mudanças feitas desde a PIT I (documentação, correções principais) (40s).
4. Demonstração rápida da aplicação em funcionamento (navegar por 1–2 fluxos principais: login → lista → criação/edição) (90–120s).
5. Mostrar como rodar localmente (comandos principais) e apontar links do repositório e deploy (30s).
6. Mostrar evidências coletadas (prints/logs) e confirmar correções realizadas (30s).
7. Conclusão com próximos passos e agradecimento (10s).

Link para o vídeo: [COLOQUE_AQUI]

Dicas de gravação
- Grave em boa qualidade (resolução mínima 720p).
- Use um narrador claro e siga o roteiro; mostre o terminal e o navegador quando fizer demonstrações.
- Suba o vídeo no YouTube (não listado) ou na plataforma que preferir e coloque o link aqui.

---

## 6. Próximos Passos (resumo)
1. Preencha os links reais (repositório, deploy, vídeo) neste documento.  
2. Convoque 5 colegas reais para testar a aplicação; peça que preencham os campos do template apresentado e enviem evidências.  
3. Aplique correções conforme laudo de qualidade; registre cada correção no CHANGELOG e comite as evidências.  
4. Atualize a documentação final e faça push para o repositório Git (branch e PR se for o caso).  
5. Grave o vídeo de até 5 minutos seguindo o roteiro sugerido e anexe o link.  

---

Se quiser, eu posso:
- Gerar automaticamente um README.md completo pronto para você colar no repositório (com exemplos de comandos e template de .env).
- Gerar um template OpenAPI/Swagger para as rotas principais.
- Gerar exemplos de testes Jest + supertest para 2 endpoints (login e CRUD).
Diga qual dessas opções prefere que eu faça agora e eu já gero os arquivos.