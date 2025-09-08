# DeliDrop App

Aplicação Rails que representa a parte de **gestão de restaurantes** de um sistema estilo *iFood*.  
Aqui os restaurantes podem **cadastrar produtos, categorias e gerenciar pedidos** que chegam de outra aplicação (lado cliente).

---

## 🚀 Tecnologias

- **Backend:** Ruby on Rails 8, PostgreSQL, Puma  
- **Frontend:** Vue 3, Turbo, Stimulus, Importmap, ESBuild  
- **Autenticação:** Devise  
- **Autorização:** Pundit  
- **Testes:** RSpec, FactoryBot, Capybara, SimpleCov  
- **Infra:** Docker, Docker Compose  

---

## 📂 Estrutura do projeto

```bash
app/
  javascript/       # Frontend Vue + JS utils
    components/     # Componentes Vue
    composables/    # Composables Vue
    controllers/    # Stimulus controllers
    stylesheets/    # Estilos globais
    utils/          # Funções utilitárias
config/             # Configurações da aplicação
db/                 # Migrations e seeds
spec/               # Testes RSpec
```
# Setup rápido
## 🔑 Configuração de variáveis de ambiente

Copie o arquivo `.env.example` para `.env` e edite conforme necessário:

```bash
cp .env.example .env
```

## 🐳 Rodando com Docker
### Pré-requisitos

- Docker

- Docker Compose

### Subir containers
```bash
docker compose up --build
```
####Observações:

- app: aplicaçāo Rails disponível em http://localhost:3000

- postgres: banco PostgreSQL na porta 5432

- mailcatcher: interface de testes de email em http://localhost:1080

- esbuild: compila os arquivos Vue do frontend e já roda em modo watch, recompilando automaticamente sempre que um arquivo muda

### Criar banco de dados
```bash
docker compose run --rm app rails db:create db:migrate
```

### Serviços disponíveis

- App Rails: [http://localhost:3000](http://localhost:3000)

- Mailcatcher: [http://localhost:1080](http://localhost:1080)


## 🧪 Testes

Rodar todos os testes com RSpec:
```bash
docker compose run --rm app bundle exec rspec
```

Gerar relatório de cobertura com SimpleCov (em coverage/):
```bash
docker compose run --rm app bundle exec rspec
```

## 📦 Dependências principais
### Ruby Gems

- rails (~> 8.0.2)

- devise

- pundit

- rspec-rails (~> 8.0.0)

- factory_bot_rails

- capybara

- brakeman

- rubocop-rails-omakase

### JavaScript

- vue (^3.2.0)

- axios

- esbuild

- esbuild-plugin-vue3

- @iconify/vue

- @fontsource/inter

## ✨ Funcionalidades atuais

- Cadastro e gestão de categorias

- Cadastro e gestão de produtos

  - Atributos: nome, categoria, preço base, duração, descrição, imagem, status, destaque

  - Relacionamento com grupos de modificadores e modificadores

- Autenticação com Devise

- Autorização baseada em papéis com Pundit

- API REST para operações de produto (v1)

## 📌 Próximos passos (roadmap)

- Fluxo completo de pedidos de clientes

- Integração entre restaurante e app do cliente

- Relatórios e dashboards

- Promoções e programas de fidelidade

## 👤 Autor

Desenvolvido por **Adoniran**
