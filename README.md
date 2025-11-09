```markdown
# Projeto PIT I — Versão Atualizada

Nome: MOHAMED RADWAN MOHAMED SOLIMAN  
RGM: 40913392  
Autor do repo: Mohamedsoliman2025

Descrição
Projeto fullstack (back-end Node.js + MongoDB, front-end React). Esta versão contém correções, documentação, testes automatizados e instruções de deploy.

Stack
- Back-end: Node.js (Express) + Mongoose (MongoDB)
- Front-end: React (template mínimo)
- Banco: MongoDB (Atlas ou local)
- Deploy: Render (instruções abaixo)
- Testes: Jest + supertest + mongodb-memory-server
- Linter/Formatter: ESLint / Prettier (configuração recomendada)

Pré-requisitos
- Node.js v18+ (ou versão especificada no package.json "engines")
- npm ou yarn
- MongoDB (Atlas URI or local)

Arquivos importantes
- /src — back-end source
- /frontend — front-end React minimal
- swagger.yaml — documentação OpenAPI
- .env.example — variáveis de ambiente de exemplo
- Dockerfile / docker-compose.yml — containers para desenvolvimento
- tests/ — testes automatizados (Jest + supertest)
- .github/workflows/ci.yml — CI para rodar testes

Variáveis de ambiente (.env)
Preencha um arquivo `.env` local baseado em `.env.example`:
- MONGO_URI - string de conexão MongoDB
- JWT_SECRET - segredo para JWT
- PORT - porta do servidor (opcional)
- NODE_ENV - development/production

Instalação e execução (back-end)
1. Clonar
   git clone <repo-url>
   cd <repo-folder>

2. Instalar dependências
   npm install

3. Criar .env baseado em .env.example

4. Rodar em desenvolvimento
   npm run dev

5. Rodar produção
   npm start

Executar testes
- npm test

Docker (desenvolvimento)
- docker-compose up --build
- O backend ficará exposto na porta 5000 (configurável)

Deploy no Render
1. Crie um novo Web Service no Render.
2. Conecte ao GitHub (selecione o repositório).
3. Build Command: npm ci && npm run build (se houver build) ou npm ci
4. Start Command: npm start
5. Adicione variáveis de ambiente no painel do Render: MONGO_URI, JWT_SECRET, NODE_ENV
6. Deploy

OpenAPI / Swagger
- swagger.yaml contém definição das rotas principais. Você pode usar o Swagger UI (https://editor.swagger.io/) para visualizar.

Contribuição
- Use branches feature/* e abra PR para main.
- Execute testes antes de abrir PR.

CHANGELOG e KNOWN_ISSUES
- Veja CHANGELOG.md e KNOWN_ISSUES.md para histórico e problemas conhecidos.

Evidências
- Coloque evidências dos testes manuais na pasta `evidencias/` (screenshots, responses).

Contato
- Mohamedsoliman2025 (GitHub)  
```