# rintellix-deployment

**Global deployment orchestrator for the RIntellix credit-risk platform.**

`Docker Compose` · `Git Submodules` · `MongoDB` · `Keycloak` · `Apache Kafka`

---

## 1. Overview

`rintellix-deployment` is the central infrastructure repository for the RIntellix platform. It orchestrates the simultaneous deployment of all 6 platform microservices along with their necessary infrastructure dependencies (database, message broker, and identity provider) using a single command.

Responsibilities at a glance:

- Provide a single entry point to clone the entire platform's source code.
- Spin up external infrastructure dependencies (MongoDB, Kafka, Keycloak).
- Initialize database schemas, synthetic datasets, and security configurations on startup.
- Build and run all microservices locally to ensure they can be tested without relying on external Docker registries.

## 2. Key aspects of the system

- **Git Submodules for code aggregation.** The 6 microservices are linked as Git submodules in the root directory. This allows each service to maintain its own independent repository, CI/CD, and issue tracking, while providing a unified, version-controlled snapshot of the whole platform for reviewers and developers.
- **Local build context.** The `docker-compose.yml` is configured to build the microservices directly from their source code (`build: ./ms-frontend`, etc.) instead of pulling pre-built images. This ensures any local modifications to the code are instantly reflected upon a rebuild, ideal for academic evaluation.
- **Infrastructure as Code (IaC) initialization.** The repository bundles `init-mongo/` and `MongoDB/` directories to automatically restore the necessary database collections on first boot. Similarly, the `Keycloak/` directory contains the realm export (`rintellix-realm.json`) so the entire authentication stack is pre-configured without manual intervention.

## 3. Tech stack

- **Orchestration:** Docker Compose
- **Database:** MongoDB 7.0
- **Messaging:** Apache Kafka 3.8.1 (KRaft mode)
- **Identity Provider:** Keycloak 26.4
- **Version Control:** Git Submodules

## 4. Prerequisites

- Git
- Docker and Docker Compose
- *Recommended: 8GB of free RAM, as 6 services and 3 infrastructure containers are spun up simultaneously.*

## 5. Getting started

```bash
# 1. Clone the repository including all submodules (microservices)
git clone --recurse-submodules https://github.com/TFG-RIntellix/rintellix-deployment.git
cd rintellix-deployment

# 2. Configure the environment
cp .env.example .env
# Edit the .env file and set your real Google Gemini API key in GEMINI_API_KEY.

# 3. Spin up the entire infrastructure
docker compose up --build -d
```

> **Note:** The first time you run `docker compose up --build -d`, Docker will download dependencies and compile the source code of every microservice locally (Maven, pip, npm). This process can take between 5 and 10 minutes depending on your internet connection and CPU.

## 6. Configuration

The following properties are configured via the `.env` file at the root of the repository:

| Property | Description | Default (from `.env.example`) |
|---|---|---|
| `MONGO_INITDB_ROOT_USERNAME` | Root user for MongoDB | `admin` |
| `MONGO_INITDB_ROOT_PASSWORD` | Root password for MongoDB | `RIntellix_Root2026!` |
| `MONGO_APP_USER` | Application-specific user for MongoDB | `rintellix_app` |
| `MONGO_DB_NAME` | Main database name | `RIntellix` |
| `KAFKA_BOOTSTRAP_SERVERS` | Kafka broker internal address | `kafka:9092` |
| `KEYCLOAK_ISSUER_URI` | Internal URI for Keycloak realm | `http://localhost:8180/realms/rintellix` |
| `GEMINI_API_KEY` | API Key for Google Gemini (Reporting) | *(Needs to be provided)* |

## 7. Related services

This repository orchestrates the following microservices:
- **ms-frontend** — Angular SPA (Port 4200).
- **ms-sec-gateway** — Spring Cloud Gateway (Port 8085).
- **ms-core-data** — Spring Boot / MongoDB (Port 8081).
- **ms-risk-engine** — Spring Boot / Kafka (Port 8082).
- **ms-model** — FastAPI / Python (Port 8000).
- **ms-reporting** — Spring Boot / Playwright (Port 8083).

## 8. Author

Lucía Fernández Mancebo — TFG *RIntellix*, Universidad de Cantabria.
