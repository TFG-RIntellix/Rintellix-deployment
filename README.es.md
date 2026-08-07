# rintellix-deployment

**Orquestador de despliegue global para la plataforma de riesgo de crédito RIntellix.**

`Docker Compose` · `Git Submodules` · `MongoDB` · `Keycloak` · `Apache Kafka`

---

## 1. Descripción general

`rintellix-deployment` es el repositorio central de infraestructura para la plataforma RIntellix. Su rol es orquestar el despliegue simultáneo de los 6 microservicios de la plataforma junto con sus dependencias de infraestructura necesarias (base de datos, broker de mensajería y proveedor de identidad) utilizando un único comando.

Responsabilidades principales:

- Proporcionar un punto de entrada único para clonar todo el código fuente de la plataforma.
- Levantar las dependencias de infraestructura externas (MongoDB, Kafka, Keycloak).
- Inicializar los esquemas de bases de datos, los datasets sintéticos y las configuraciones de seguridad en el arranque.
- Compilar y ejecutar todos los microservicios de forma local para garantizar que se puedan probar sin depender de registros Docker externos.

## 2. Aspectos clave del sistema

- **Git Submodules para agregación de código.** Los 6 microservicios están enlazados como submódulos de Git en el directorio raíz. Esto permite que cada servicio mantenga su propio repositorio independiente, CI/CD y seguimiento de incidencias, al tiempo que proporciona una "foto" unificada y versionada de toda la plataforma para revisores y desarrolladores.
- **Contexto de compilación local.** El fichero `docker-compose.yml` está configurado para construir las imágenes Docker de los microservicios directamente desde su código fuente (`build: ./ms-frontend`, etc.) en lugar de descargar imágenes pre-compiladas. Esto garantiza que cualquier modificación local en el código se refleje instantáneamente tras una recompilación, ideal para evaluación académica.
- **Inicialización de Infraestructura como Código (IaC).** El repositorio empaqueta los directorios `init-mongo/` y `MongoDB/` para restaurar automáticamente las colecciones de base de datos necesarias en el primer arranque. Del mismo modo, el directorio `Keycloak/` contiene la exportación del realm (`rintellix-realm.json`) para que toda la pila de autenticación se configure sola sin intervención manual.

## 3. Tecnologías

- **Orquestación:** Docker Compose
- **Base de datos:** MongoDB 7.0
- **Mensajería:** Apache Kafka 3.8.1 (Modo KRaft)
- **Proveedor de Identidad:** Keycloak 26.4
- **Control de Versiones:** Git Submodules

## 4. Requisitos previos

- Git
- Docker y Docker Compose
- *Recomendado: 8GB de memoria RAM libres, ya que se levantan simultáneamente 6 servicios y 3 contenedores de infraestructura.*

## 5. Puesta en marcha

```bash
# 1. Clonar el repositorio incluyendo todos los submódulos (microservicios)
git clone --recurse-submodules https://github.com/TFG-RIntellix/rintellix-deployment.git
cd rintellix-deployment

# 2. Configurar el entorno
cp .env.example .env
# Edita el fichero .env e introduce tu clave real de la API de Google Gemini en GEMINI_API_KEY.

# 3. Levantar la infraestructura completa
docker compose up --build -d
```

> **Nota:** La primera vez que ejecutes `docker compose up --build -d`, Docker descargará las dependencias y compilará el código fuente de cada microservicio de forma local (Maven, pip, npm). Este proceso puede tardar entre 5 y 10 minutos dependiendo de tu conexión a internet y CPU.

## 6. Configuración

Las siguientes propiedades se configuran a través del archivo `.env` situado en la raíz del repositorio:

| Propiedad | Descripción | Valor por defecto (de `.env.example`) |
|---|---|---|
| `MONGO_INITDB_ROOT_USERNAME` | Usuario administrador para MongoDB | `admin` |
| `MONGO_INITDB_ROOT_PASSWORD` | Contraseña del administrador para MongoDB | `RIntellix_Root2026!` |
| `MONGO_APP_USER` | Usuario específico de la aplicación para MongoDB | `rintellix_app` |
| `MONGO_DB_NAME` | Nombre de la base de datos principal | `RIntellix` |
| `KAFKA_BOOTSTRAP_SERVERS` | Dirección interna del broker de Kafka | `kafka:9092` |
| `KEYCLOAK_ISSUER_URI` | URI interna para el realm de Keycloak | `http://localhost:8180/realms/rintellix` |
| `GEMINI_API_KEY` | Clave API para Google Gemini (Reporting) | *(Debe ser proporcionada)* |

## 7. Servicios relacionados

Este repositorio orquesta los siguientes microservicios:
- **ms-frontend** — SPA en Angular (Puerto 4200).
- **ms-sec-gateway** — Spring Cloud Gateway (Puerto 8085).
- **ms-core-data** — Spring Boot / MongoDB (Puerto 8081).
- **ms-risk-engine** — Spring Boot / Kafka (Puerto 8082).
- **ms-model** — FastAPI / Python (Puerto 8000).
- **ms-reporting** — Spring Boot / Playwright (Puerto 8083).

## 8. Autora

Lucía Fernández Mancebo — TFG *RIntellix*, Universidad de Cantabria.
