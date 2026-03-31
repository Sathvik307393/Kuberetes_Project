# FitForge Helm Charts

This directory contains Helm charts for deploying the FitForge microservices application.

## Key Features

- **No RBAC**: Service accounts disabled across all services (no unnecessary RBAC resources)
- **Gateway API**: Frontend uses Kubernetes Gateway API instead of Ingress (requires Gateway Controller like NGINX Gateway, Traefik, or Istio)
- **Health Probes**: All services configured with liveness, readiness, and startup probes
- **Resource Limits**: All services have CPU/memory requests and limits defined
- **MongoDB External**: Database deployed separately (not managed by these charts)

- `Chart.yaml` - Umbrella chart definition with all dependencies
- `values.yaml` - Default configuration values
- `frontend/templates/gateway.yaml` - Gateway API (replaces Ingress)
- `frontend/` - Frontend React application Helm chart (with Gateway API)
- `auth-service/` - Authentication service Helm chart
- `user-service/` - User management service Helm chart
- `workout-service/` - Workout tracking service Helm chart
- `nutrition-service/` - Nutrition tracking service Helm chart
- `progress-service/` - Progress analytics service Helm chart
- `ai-agent-service/` - AI Agent Python service Helm chart
- `redis/` - Redis cache Helm chart
- `otel-collector/` - OpenTelemetry Collector Helm chart

## Prerequisites

- Kubernetes 1.24+
- Helm 3.12+
- **Gateway Controller** (for frontend Gateway API):
  - [NGINX Gateway Fabric](https://docs.nginx.com/nginx-gateway-fabric/)
  - [Traefik](https://doc.traefik.io/traefik/providers/kubernetes-gateway/)
  - [Istio](https://istio.io/latest/docs/tasks/traffic-management/ingress/gateway-api/)
  - Or any other Gateway API implementation

### Install NGINX Gateway Fabric (example):
```bash
kubectl apply -f https://github.com/nginxinc/nginx-gateway-fabric/releases/download/v1.2.0/crds.yaml
kubectl apply -f https://github.com/nginxinc/nginx-gateway-fabric/releases/download/v1.2.0/nginx-gateway.yaml
```

## Installation

```bash
# Install the umbrella chart with all services
helm dependency build .
helm install fitforge . --namespace fit-forge --create-namespace

# Or upgrade existing deployment
helm upgrade fitforge . --namespace fit-forge
```

## Configuration

### Gateway API (Frontend)

The frontend uses Gateway API instead of traditional Ingress:

```yaml
frontend:
  gateway:
    enabled: true
    name: fitforge-gateway
    gatewayClassName: nginx  # Change to your GatewayClass
    listeners:
      - name: http
        protocol: HTTP
        port: 80
        hostname: "fitforge.local"
```

### Service Account Disabled

All services have `serviceAccount.create: false` (no RBAC resources created).

### Health Probes

All microservices include:
- **Liveness Probe**: HTTP GET /health (or TCP for Redis)
- **Readiness Probe**: HTTP GET /health (or TCP for Redis)
- **Startup Probe**: HTTP GET /health (or TCP for Redis) - gives slow-starting containers time to initialize

### Resource Limits

Every service has resource limits configured:
- **Requests**: Guaranteed CPU/memory allocation
- **Limits**: Maximum allowed CPU/memory usage

## MongoDB (External)

MongoDB is NOT included in these Helm charts as per requirements. Deploy MongoDB separately:

```bash
# Option 1: Use MongoDB Community Operator
kubectl apply -f https://raw.githubusercontent.com/mongodb/mongodb-kubernetes-operator/master/config/crd/bases/mongodbcommunity.mongodb.com_mongodbcommunity.yaml

# Option 2: Use Helm chart from Bitnami
helm install mongodb bitnami/mongodb --namespace fit-forge
```

## Secrets

Create required secrets before deployment:

```bash
# MongoDB connection strings
kubectl create secret generic mongodb-secret \
  --from-literal=auth-db-uri="mongodb://mongo:27017/auth_db" \
  --from-literal=user-db-uri="mongodb://mongo:27017/user_db" \
  --from-literal=workout-db-uri="mongodb://mongo:27017/workout_db" \
  --from-literal=nutrition-db-uri="mongodb://mongo:27017/nutrition_db" \
  --from-literal=progress-db-uri="mongodb://mongo:27017/progress_db"

# JWT secret
kubectl create secret generic auth-secret \
  --from-literal=jwt-secret="your-jwt-secret-here"

# AI Agent config
kubectl create secret generic ai-agent-secret \
  --from-literal=google-api-key="your-google-api-key"

kubectl create configmap ai-agent-config \
  --from-literal=llm-model="gemini-pro"
```

## Uninstall

```bash
helm uninstall fitforge --namespace fit-forge
```
