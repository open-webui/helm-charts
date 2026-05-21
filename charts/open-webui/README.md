# open-webui

![Version: 14.7.0](https://img.shields.io/badge/Version-14.7.0-informational?style=flat-square) ![AppVersion: 0.9.5](https://img.shields.io/badge/AppVersion-0.9.5-informational?style=flat-square)

Garnet: Privacy-aware AI chat platform built on Open WebUI

**Homepage:** <https://github.com/enclaive/garnet-helm>

## Source Code

* <https://github.com/enclaive/garnet-helm>
* <https://github.com/otwld/ollama-helm/>
* <https://hub.docker.com/r/ollama/ollama>

## Installing

Add the Helm registry and install:

```shell
helm registry login harbor.enclaive.cloud --username <username> --password <password>

helm install garnet oci://harbor.enclaive.cloud/garnet/open-webui \
  --namespace garnet --create-namespace
```

Or install from source:

```shell
git clone https://github.com/enclaive/garnet-helm.git
cd garnet-helm

helm dependency update charts/open-webui

helm install garnet charts/open-webui \
  --namespace garnet --create-namespace
```

Before installing, create the secrets required by the chart:

```shell
kubectl create secret generic garnet-secrets \
  --namespace garnet \
  --from-literal=redis-url='redis://<release>-open-webui-redis.<namespace>.svc.cluster.local:6379'
```

## Upgrading

Please consult the [CHANGELOG](CHANGELOG.md) for important upgrade notes and breaking changes between versions.

## Resource Naming

Resources are named using a combination of the Helm release name and chart name, which allows multiple instances in the same namespace.

| Release Name | Result |
|---|---|
| `garnet` | Resources named `garnet-open-webui` |
| `open-webui` | Resources named `open-webui` |
| `prod` | Resources named `prod-open-webui` |

Override with `fullnameOverride` to use a fixed name regardless of release name.

## Architecture

This chart deploys the following components:

| Component | Description |
|---|---|
| **open-webui** | The main chat UI (StatefulSet) |
| **privacy-proxy** | Intercepts all LLM traffic between open-webui and upstream providers |
| **ollama** | Local LLM inference engine (subchart) |
| **redis** | WebSocket session state |
| **garnet-dashboard** | Monitoring and management dashboard |

All Ollama and OpenAI traffic from open-webui is routed through the privacy-proxy. open-webui never communicates directly with Ollama or external APIs.

## Requirements

| Repository | Name | Version |
|---|---|---|
| https://helm.openwebui.com | pipelines | >=0.10.1 |
| https://otwld.github.io/ollama-helm/ | ollama | >=0.24.0 |

## Secrets

The chart expects a Kubernetes Secret with the following keys:

| Key | Description |
|---|---|
| `redis-url` | Redis connection URL for WebSocket sessions |

Set `garnetSecrets.create: true` to have the chart create the Secret, or provide your own with `garnetSecrets.existingSecret`.

## Values

### Image configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.pullPolicy | string | `"IfNotPresent"` | Open WebUI image pull policy |
| image.repository | string | `"harbor.enclaive.cloud/garnetdemo/garnet-webui"` | Open WebUI image repository |
| image.tag | string | `"1.0.0.nightly"` | Open WebUI image tag |
| image.useSlim | bool | `false` | Use a slim version of the Open WebUI image |
| imagePullSecrets | list | `[]` | Pull secrets for private registries |

### OpenAI API configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enableOpenaiApi | bool | `true` | Enables the use of OpenAI APIs |
| openaiApiKey | string | `""` | OpenAI API key. Set via secret reference in production |
| openaiBaseApiUrl | string | `""` | OpenAI base API URL. Left empty; routing is handled by privacy-proxy via extraEnvVars |
| ollamaUrlsFromExtraEnv | bool | `true` | Instructs the chart to skip rendering OLLAMA_BASE_URLS; set explicitly via extraEnvVars |
| ollamaUrls | list | `[]` | Additional Ollama API endpoints |

### Privacy Proxy configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| privacyProxy.enabled | bool | `true` | Enable the privacy-proxy deployment |
| privacyProxy.image.repository | string | `"harbor.enclaive.cloud/garnetdemo/privacy-proxy"` | Privacy-proxy image repository |
| privacyProxy.image.tag | string | `""` | Image tag (leave empty when using digest) |
| privacyProxy.image.digest | string | `"sha256:..."` | Immutable image digest for production deployments |
| privacyProxy.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| privacyProxy.ollamaUrl | string | `'http://{{ .Release.Name }}-ollama:11434'` | Upstream Ollama URL |
| privacyProxy.openaiApiUrl | string | `"https://api.openai.com/v1"` | Upstream OpenAI API URL |
| privacyProxy.replicaCount | int | `1` | Number of replicas |
| privacyProxy.resources | object | `{limits: {memory: 10Gi, cpu: "2"}}` | Resource requests and limits |

### Garnet Dashboard configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| garnetDashboard.enabled | bool | `true` | Enable the garnet-dashboard deployment |
| garnetDashboard.image.repository | string | `"harbor.enclaive.cloud/garnetdemo/garnet-dashboard"` | Dashboard image repository |
| garnetDashboard.image.tag | string | `"latest"` | Image tag |
| garnetDashboard.dockerSocket.enabled | bool | `true` | Mount the Docker socket for container monitoring |
| garnetDashboard.dockerSocket.path | string | `"/var/run/docker.sock"` | Path to the Docker socket on the host |
| garnetDashboard.resources | object | `{limits: {memory: 256Mi, cpu: "500m"}}` | Resource requests and limits |

### Garnet Secrets configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| garnetSecrets.create | bool | `false` | Let the chart create and manage the Secret |
| garnetSecrets.existingSecret | string | `""` | Name of a pre-existing Secret to use |
| garnetSecrets.keys.redisUrl | string | `"redis-url"` | Key name for the Redis URL inside the secret |

### External Tools configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ollama.enabled | bool | `true` | Deploy Ollama as a subchart |
| ollama.fullnameOverride | string | `""` | Override the Ollama subchart resource name |
| pipelines.enabled | bool | `false` | Deploy the Pipelines subchart |

### Websocket configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| websocket.enabled | bool | `true` | Enable WebSocket support |
| websocket.manager | string | `"redis"` | WebSocket manager to use |
| websocket.existingSecret | string | `""` | Existing secret containing the Redis URL |
| websocket.existingSecretKey | string | `"redis-url"` | Key within the existing secret |
| websocket.redis.enabled | bool | `true` | Deploy a Redis instance |
| websocket.redis.image.repository | string | `"redis"` | Redis image repository |
| websocket.redis.image.tag | string | `"7.4.2-alpine3.21"` | Redis image tag |
| websocket.redis.persistence.enabled | bool | `false` | Enable PVC for Redis data |
| websocket.redis.persistence.size | string | `"1Gi"` | Size of the Redis PVC |
| websocket.redis.persistence.storageClass | string | `""` | Storage class for the Redis PVC |

### Ingress configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.enabled | bool | `false` | Enable Ingress. Disabled by default — configure for your ingress controller |
| ingress.class | string | `""` | Ingress class name |
| ingress.host | string | `"chat.example.com"` | Hostname for the Ingress record |
| ingress.tls | bool | `false` | Enable TLS |
| ingress.annotations | object | `{}` | Ingress annotations |

### Persistence configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.enabled | bool | `true` | Enable persistence for Open WebUI data |
| persistence.size | string | `"2Gi"` | Size of the PVC |
| persistence.storageClass | string | `""` | Storage class |
| persistence.accessModes | list | `["ReadWriteOnce"]` | Access modes. Use ReadWriteMany for multiple replicas |
| persistence.provider | string | `"local"` | Storage provider: `local`, `s3`, `gcs`, or `azure` |

### Service configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.type | string | `"ClusterIP"` | Service type |
| service.port | int | `80` | Service port |
| service.containerPort | int | `8080` | Container port |

### Probes configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| livenessProbe | object | `{}` | Liveness probe configuration |
| readinessProbe | object | `{}` | Readiness probe configuration |
| startupProbe | object | `{}` | Startup probe configuration |

### SSO Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.enabled | bool | `false` | Enable SSO authentication globally |
| sso.google.enabled | bool | `false` | Enable Google OAuth |
| sso.microsoft.enabled | bool | `false` | Enable Microsoft OAuth |
| sso.github.enabled | bool | `false` | Enable GitHub OAuth |
| sso.oidc.enabled | bool | `false` | Enable OIDC authentication |

### Logging configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| logging.level | string | `""` | Global log level: `notset`, `debug`, `info`, `warning`, `error`, `critical` |
| logging.components | object | `{}` | Per-component log level overrides |
