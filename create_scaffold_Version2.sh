#!/usr/bin/env bash
# create_scaffold.sh
# Cria toda a estrutura do scaffold (backend + frontend + docs + tests),
# opcionalmente cria um zip e (se desejar) cria/commita em branch scaffold-pit.
#
# Uso:
# 1) Coloque este script no diretório do repositório local (ou em uma pasta vazia).
# 2) Torne executável: chmod +x create_scaffold.sh
# 3) Execute: ./create_scaffold.sh
#
# O script:
# - cria arquivos e pastas conforme o scaffold que geramos no chat
# - cria scaffold-pit branch (se estiver num repo git local)
# - cria scaffold-pit.zip com tudo
#
set -euo pipefail

ROOT_DIR="$(pwd)"
BRANCH="scaffold-pit"

echo "Criando estrutura de arquivos no diretório: $ROOT_DIR"

mkdir -p src/config src/models src/routes src/controllers src/middleware tests frontend/src/components .github/workflows evidencias

# README.md
cat > README.md <<'EOF'
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
EOF

# .env.example
cat > .env.example <<'EOF'
MONGO_URI=mongodb://localhost:27017/pit_db
PORT=5000
JWT_SECRET=troque_por_um_segredo_forte
NODE_ENV=development
EOF

# package.json
cat > package.json <<'EOF'
{
  "name": "pit-backend",
  "version": "1.0.0",
  "description": "Back-end Node.js (Express) para projeto PIT I",
  "main": "src/index.js",
  "engines": {
    "node": ">=18"
  },
  "scripts": {
    "start": "node src/index.js",
    "dev": "nodemon src/index.js",
    "lint": "eslint . --ext .js",
    "test": "jest --runInBand",
    "test:watch": "jest --watchAll"
  },
  "author": "MOHAMED RADWAN MOHAMED SOLIMAN <Mohamedsoliman2025>",
  "license": "MIT",
  "dependencies": {
    "bcryptjs": "^2.4.3",
    "body-parser": "^1.20.2",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express": "^4.18.2",
    "jsonwebtoken": "^9.0.0",
    "mongoose": "^7.4.0",
    "morgan": "^1.10.0"
  },
  "devDependencies": {
    "@types/jest": "^29.5.5",
    "eslint": "^8.48.0",
    "jest": "^29.7.0",
    "mongodb-memory-server": "^9.8.0",
    "nodemon": "^3.0.1",
    "supertest": "^6.4.4"
  }
}
EOF

# .gitignore
cat > .gitignore <<'EOF'
node_modules/
.env
.env.local
.DS_Store
coverage/
dist/
logs/
evidencias/
frontend/node_modules/
EOF

# Dockerfile
cat > Dockerfile <<'EOF'
# Dockerfile para o back-end
FROM node:18-alpine

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --production

COPY . .

ENV NODE_ENV=production
EXPOSE 5000

CMD ["node", "src/index.js"]
EOF

# docker-compose.yml
cat > docker-compose.yml <<'EOF'
version: "3.8"
services:
  backend:
    build: .
    ports:
      - "5000:5000"
    env_file:
      - .env
    volumes:
      - ./:/usr/src/app
      - /usr/src/app/node_modules
    depends_on:
      - mongo
  mongo:
    image: mongo:6
    restart: always
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db

volumes:
  mongodb_data:
EOF

# src/index.js
cat > src/index.js <<'EOF'
const dotenv = require('dotenv');
dotenv.config();

const app = require('./app');
const connectDB = require('./config/db');

const PORT = process.env.PORT || 5000;

async function start() {
  try {
    await connectDB(process.env.MONGO_URI);
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  } catch (err) {
    console.error('Failed to start server', err);
    process.exit(1);
  }
}

start();
EOF

# src/app.js
cat > src/app.js <<'EOF'
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const morgan = require('morgan');

const authRoutes = require('./routes/auth');
const itemRoutes = require('./routes/items');
const errorHandler = require('./middleware/errorHandler');

const app = express();

app.use(cors());
app.use(morgan('dev'));
app.use(bodyParser.json({ limit: '2mb' }));

app.get('/', (req, res) => res.json({ status: 'ok', message: 'API PIT' }));

app.use('/api/auth', authRoutes);
app.use('/api/items', itemRoutes);

// error middleware (should be last)
app.use(errorHandler);

module.exports = app;
EOF

# src/config/db.js
cat > src/config/db.js <<'EOF'
const mongoose = require('mongoose');

module.exports = async function connectDB(uri) {
  if (!uri) throw new Error('MONGO_URI not provided');
  await mongoose.connect(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true
  });
  console.log('MongoDB connected');
};
EOF

# src/models/User.js
cat > src/models/User.js <<'EOF'
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: { type: String, required: true, trim: true },
  email: { type: String, required: true, unique: true, lowercase: true, trim: true },
  password: { type: String, required: true },
  role: { type: String, enum: ['user','admin'], default: 'user' },
  createdAt: { type: Date, default: Date.now }
});

userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

userSchema.methods.comparePassword = function(candidate) {
  return bcrypt.compare(candidate, this.password);
};

module.exports = mongoose.model('User', userSchema);
EOF

# src/models/Item.js
cat > src/models/Item.js <<'EOF'
const mongoose = require('mongoose');

const itemSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String },
  owner: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Item', itemSchema);
EOF

# src/routes/auth.js
cat > src/routes/auth.js <<'EOF'
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.register);
router.post('/login', authController.login);

module.exports = router;
EOF

# src/routes/items.js
cat > src/routes/items.js <<'EOF'
const express = require('express');
const router = express.Router();
const itemController = require('../controllers/itemController');
const auth = require('../middleware/auth');

router.get('/', auth, itemController.list);
router.post('/', auth, itemController.create);
router.get('/:id', auth, itemController.get);
router.put('/:id', auth, itemController.update);
router.delete('/:id', auth, itemController.remove);

module.exports = router;
EOF

# src/controllers/authController.js
cat > src/controllers/authController.js <<'EOF'
const jwt = require('jsonwebtoken');
const User = require('../models/User');

function signToken(user) {
  return jwt.sign({ id: user._id, email: user.email, role: user.role }, process.env.JWT_SECRET, { expiresIn: '8h' });
}

exports.register = async (req, res, next) => {
  try {
    const { name, email, password } = req.body;
    if (!name || !email || !password) return res.status(400).json({ error: { message: 'Missing required fields' }});
    const exists = await User.findOne({ email });
    if (exists) return res.status(409).json({ error: { message: 'Email already registered' }});
    const user = new User({ name, email, password });
    await user.save();
    const token = signToken(user);
    res.status(201).json({ data: { user: { id: user._id, name: user.name, email: user.email }, token }});
  } catch (err) {
    next(err);
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: { message: 'Missing email or password' }});
    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ error: { message: 'Invalid credentials' }});
    const match = await user.comparePassword(password);
    if (!match) return res.status(401).json({ error: { message: 'Invalid credentials' }});
    const token = signToken(user);
    res.json({ data: { user: { id: user._id, name: user.name, email: user.email }, token }});
  } catch (err) {
    next(err);
  }
};
EOF

# src/controllers/itemController.js
cat > src/controllers/itemController.js <<'EOF'
const Item = require('../models/Item');

exports.list = async (req, res, next) => {
  try {
    const { page = 1, limit = 10, q } = req.query;
    const filter = { owner: req.user.id };
    if (q) filter.title = { $regex: q, $options: 'i' };
    const items = await Item.find(filter)
      .skip((page - 1) * limit)
      .limit(parseInt(limit))
      .sort({ createdAt: -1 });
    res.json({ data: items });
  } catch (err) {
    next(err);
  }
};

exports.create = async (req, res, next) => {
  try {
    const { title, description } = req.body;
    if (!title) return res.status(400).json({ error: { message: 'Title is required' }});
    const item = new Item({ title, description, owner: req.user.id });
    await item.save();
    res.status(201).json({ data: item });
  } catch (err) {
    next(err);
  }
};

exports.get = async (req, res, next) => {
  try {
    const item = await Item.findOne({ _id: req.params.id, owner: req.user.id });
    if (!item) return res.status(404).json({ error: { message: 'Not found' }});
    res.json({ data: item });
  } catch (err) {
    next(err);
  }
};

exports.update = async (req, res, next) => {
  try {
    const item = await Item.findOneAndUpdate({ _id: req.params.id, owner: req.user.id }, req.body, { new: true });
    if (!item) return res.status(404).json({ error: { message: 'Not found' }});
    res.json({ data: item });
  } catch (err) {
    next(err);
  }
};

exports.remove = async (req, res, next) => {
  try {
    const item = await Item.findOneAndDelete({ _id: req.params.id, owner: req.user.id });
    if (!item) return res.status(404).json({ error: { message: 'Not found' }});
    res.status(204).send();
  } catch (err) {
    next(err);
  }
};
EOF

# src/middleware/auth.js
cat > src/middleware/auth.js <<'EOF'
const jwt = require('jsonwebtoken');

module.exports = function (req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader) return res.status(401).json({ error: { message: 'No token provided' }});
  const parts = authHeader.split(' ');
  if (parts.length !== 2) return res.status(401).json({ error: { message: 'Token error' }});
  const [scheme, token] = parts;
  if (!/^Bearer$/i.test(scheme)) return res.status(401).json({ error: { message: 'Token malformatted' }});
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { id: decoded.id, email: decoded.email, role: decoded.role };
    next();
  } catch (err) {
    return res.status(401).json({ error: { message: 'Token invalid' }});
  }
};
EOF

# src/middleware/errorHandler.js
cat > src/middleware/errorHandler.js <<'EOF'
module.exports = function(err, req, res, next) {
  console.error(err);
  if (res.headersSent) return next(err);
  const status = err.status || 500;
  const message = err.message || 'Internal Server Error';
  res.status(status).json({ error: { message } });
};
EOF

# swagger.yaml
cat > swagger.yaml <<'EOF'
openapi: 3.0.1
info:
  title: PIT API
  version: "1.0.0"
  description: API endpoints for Project PIT
servers:
  - url: http://localhost:5000
paths:
  /api/auth/register:
    post:
      summary: Register new user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                name: { type: string }
                email: { type: string }
                password: { type: string }
      responses:
        "201":
          description: Created
  /api/auth/login:
    post:
      summary: Login
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                email: { type: string }
                password: { type: string }
      responses:
        "200":
          description: OK
  /api/items:
    get:
      summary: List items (protected)
      security:
        - bearerAuth: []
      parameters:
        - in: query
          name: page
          schema:
            type: integer
      responses:
        "200":
          description: OK
    post:
      summary: Create item (protected)
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                title: { type: string }
                description: { type: string }
      responses:
        "201":
          description: Created
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
EOF

# jest.config.js
cat > jest.config.js <<'EOF'
module.exports = {
  testEnvironment: 'node',
  testTimeout: 20000
};
EOF

# tests/auth.test.js
cat > tests/auth.test.js <<'EOF'
const request = require('supertest');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
let mongod;
let app;

beforeAll(async () => {
  mongod = await MongoMemoryServer.create();
  process.env.MONGO_URI = mongod.getUri();
  process.env.JWT_SECRET = process.env.JWT_SECRET || 'testsecret';
  app = require('../src/app');
  const connectDB = require('../src/config/db');
  await connectDB(process.env.MONGO_URI);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongod.stop();
});

describe('Auth endpoints', () => {
  it('should register a user', async () => {
    const res = await request(app)
      .post('/api/auth/register')
      .send({ name: 'Test', email: 'test@example.com', password: 'password123' });
    expect(res.statusCode).toEqual(201);
    expect(res.body.data).toHaveProperty('token');
  });

  it('should login the user', async () => {
    const res = await request(app)
      .post('/api/auth/login')
      .send({ email: 'test@example.com', password: 'password123' });
    expect(res.statusCode).toEqual(200);
    expect(res.body.data).toHaveProperty('token');
  });
});
EOF

# tests/items.test.js
cat > tests/items.test.js <<'EOF'
const request = require('supertest');
const mongoose = require('mongoose');
const { MongoMemoryServer } = require('mongodb-memory-server');
let mongod;
let app;

beforeAll(async () => {
  mongod = await MongoMemoryServer.create();
  process.env.MONGO_URI = mongod.getUri();
  process.env.JWT_SECRET = process.env.JWT_SECRET || 'testsecret';
  app = require('../src/app');
  const connectDB = require('../src/config/db');
  await connectDB(process.env.MONGO_URI);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongod.stop();
});

let token;
let itemId;

describe('Items endpoints', () => {
  beforeAll(async () => {
    // register and login
    await request(app).post('/api/auth/register').send({ name: 'A', email: 'a@example.com', password: 'pass' });
    const res = await request(app).post('/api/auth/login').send({ email: 'a@example.com', password: 'pass' });
    token = res.body.data.token;
  });

  it('should create an item', async () => {
    const res = await request(app)
      .post('/api/items')
      .set('Authorization', `Bearer ${token}`)
      .send({ title: 'Item 1', description: 'Desc' });
    expect(res.statusCode).toBe(201);
    expect(res.body.data.title).toBe('Item 1');
    itemId = res.body.data._id;
  });

  it('should list items', async () => {
    const res = await request(app)
      .get('/api/items')
      .set('Authorization', `Bearer ${token}`);
    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body.data)).toBe(true);
  });

  it('should update item', async () => {
    const res = await request(app)
      .put(`/api/items/${itemId}`)
      .set('Authorization', `Bearer ${token}`)
      .send({ title: 'Item 1 updated' });
    expect(res.statusCode).toBe(200);
    expect(res.body.data.title).toBe('Item 1 updated');
  });

  it('should delete item', async () => {
    const res = await request(app)
      .delete(`/api/items/${itemId}`)
      .set('Authorization', `Bearer ${token}`);
    expect(res.statusCode).toBe(204);
  });
});
EOF

# .github/workflows/ci.yml
cat > .github/workflows/ci.yml <<'EOF'
name: CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [18.x]
    steps:
      - uses: actions/checkout@v4
      - name: Use Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
      - run: npm ci
      - run: npm test
EOF

# CHANGELOG.md
cat > CHANGELOG.md <<'EOF'
# CHANGELOG

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-11-09
### Added
- Inicial scaffold do back-end (Express + Mongoose).
- Endpoints de auth (register, login) e CRUD de items.
- Testes automatizados com Jest + supertest.
- Dockerfile e docker-compose para dev.
- Swagger (swagger.yaml).
- Documentação principal (README.md).
EOF

# KNOWN_ISSUES.md
cat > KNOWN_ISSUES.md <<'EOF'
# KNOWN ISSUES

- Upload de arquivos não implementado (carregamento de imagens pode falhar).
- Refresh token não implementado (apenas token de acesso).
- Logs de produção básicos (necessário configurar Winston/Log management).
- Controle refinado de permissões (roles ACL) mínimo.
- Versão do Node sugerida: 18+; caso use outra versão, alguns pacotes podem ter comportamento diferente.
EOF

# evidencias/README.md
cat > evidencias/README.md <<'EOF'
Coloque aqui as evidências dos testes manuais. Nomeie arquivos como:
- teste_<nome>_<YYYYMMDD>_screenshot.png
- teste_<nome>_<YYYYMMDD>_response.json
- logs_server_<YYYYMMDD>.log

Exemplo:
evidencias/
  teste_Ana_20251102_screenshot.png
  teste_Ana_20251102_response.json
  logs_server_20251102.log
EOF

# FRONTEND_README.md
cat > FRONTEND_README.md <<'EOF'
Front-end minimal (template)

Este diretório contém um template React muito simples que consome a API do back-end.

Estrutura:
- frontend/
  - package.json
  - src/
    - index.js
    - App.js
    - components/
      - Login.js

Scripts
- cd frontend
- npm install
- npm start

Notas
- Ajuste a variável REACT_APP_API_URL no frontend/.env para apontar para o backend (ex: http://localhost:5000)
EOF

# frontend/package.json
cat > frontend/package.json <<'EOF'
{
  "name": "pit-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.3.0",
    "react-dom": "^18.3.0",
    "axios": "^1.6.0"
  },
  "scripts": {
    "start": "serve -s build",
    "dev": "react-scripts start",
    "build": "react-scripts build"
  }
}
EOF

# frontend/.gitignore
cat > frontend/.gitignore <<'EOF'
node_modules/
build/
.env
EOF

# frontend/src/index.js
mkdir -p frontend/src
cat > frontend/src/index.js <<'EOF'
import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

const root = createRoot(document.getElementById('root'));
root.render(<App />);
EOF

# frontend/src/App.js
cat > frontend/src/App.js <<'EOF'
import React from 'react';
import Login from './components/Login';

export default function App() {
  return (
    <div style={{ padding: 20 }}>
      <h2>PIT - Frontend (Template)</h2>
      <Login />
    </div>
  );
}
EOF

# frontend/src/components/Login.js
mkdir -p frontend/src/components
cat > frontend/src/components/Login.js <<'EOF'
import React, { useState } from 'react';
import axios from 'axios';

export default function Login() {
  const [email,setEmail] = useState('');
  const [password,setPassword] = useState('');
  const [msg,setMsg] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const res = await axios.post(process.env.REACT_APP_API_URL + '/api/auth/login', { email, password });
      setMsg('Logado com sucesso. Token: ' + res.data.data.token.slice(0,20) + '...');
      localStorage.setItem('token', res.data.data.token);
    } catch (err) {
      setMsg('Erro: ' + (err.response?.data?.error?.message || err.message));
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <label>Email: </label>
        <input value={email} onChange={e=>setEmail(e.target.value)} />
      </div>
      <div>
        <label>Senha: </label>
        <input value={password} onChange={e=>setPassword(e.target.value)} type="password" />
      </div>
      <button type="submit">Login</button>
      <div>{msg}</div>
    </form>
  );
}
EOF

# frontend/.gitkeep (to ensure folder exists)
touch frontend/src/.gitkeep

# frontend deps note file
cat > frontend/FRONTEND_README.txt <<'EOF'
After creating frontend, run:
cd frontend
npm install
npm run dev
EOF

# git commit & branch creation if in a git repo
if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Repo is a git repository. Creating branch '$BRANCH' and committing changes."
  git checkout -b "$BRANCH" || git checkout "$BRANCH" || true
  git add .
  git commit -m "chore(scaffold): add backend + frontend scaffold, docs, tests and CI" || echo "No changes to commit"
else
  echo "Not a git repository — skipping git branch/commit steps."
fi

# create zip
ZIP_NAME="scaffold-pit.zip"
echo "Creating zip: $ZIP_NAME"
# exclude node_modules and .git if present
zip -r "$ZIP_NAME" . -x "node_modules/*" ".git/*" "*/node_modules/*" >/dev/null 2>&1 || echo "zip not available or failed; skipping zip creation"

# create base64 of zip if zip exists
if [ -f "$ZIP_NAME" ]; then
  BASE64_FILE="${ZIP_NAME}.base64"
  base64 "$ZIP_NAME" > "$BASE64_FILE"
  echo "ZIP criado: $ZIP_NAME"
  echo "Base64 do zip salvo em: $BASE64_FILE"
else
  echo "ZIP não foi criado (zip comando não disponível)."
fi

echo
echo "Script encerrado. Se rodar em um repositório git local com permissão de escrita, o script criou a branch '$BRANCH' e fez commit."
echo "Se quiser que eu gere o conteúdo base64 do zip aqui no chat, peça e eu imprimirei (texto grande)."