# open-webui

![Version: 6.29.0](https://img.shields.io/badge/Version-6.29.0-informational?style=flat-square) ![AppVersion: 0.6.18](https://img.shields.io/badge/AppVersion-0.6.18-informational?style=flat-square)

Open WebUI: A User-Friendly Web Interface for Chat Interactions 👋

**Homepage:** <https://www.openwebui.com/>

## Source Code

* <https://github.com/open-webui/helm-charts>
* <https://github.com/open-webui/open-webui/pkgs/container/open-webui>
* <https://github.com/otwld/ollama-helm/>
* <https://hub.docker.com/r/ollama/ollama>
* <https://charts.bitnami.com/bitnami>

## Installing

Before you can install, you need to add the `open-webui` repo to [Helm](https://helm.sh)

```shell
helm repo add open-webui https://helm.openwebui.com/
helm repo update
```

Now you can install the chart:

```shell
helm upgrade --install open-webui open-webui/open-webui
```

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://apache.jfrog.io/artifactory/tika | tika | >=2.9.0 |
| https://charts.bitnami.com/bitnami | postgresql(postgresql) | >=15.5.38 |
| https://charts.bitnami.com/bitnami | redis-cluster(redis) | >=20.6.2 |
| https://helm.openwebui.com | pipelines | >=0.0.1 |
| https://otwld.github.io/ollama-helm/ | ollama | >=0.24.0 |

## Values

### Logging configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| logging.components.audio | string | `""` | Set the log level for the Audio processing component |
| logging.components.comfyui | string | `""` | Set the log level for the ComfyUI Integration component |
| logging.components.config | string | `""` | Set the log level for the Configuration Management component |
| logging.components.db | string | `""` | Set the log level for the Database Operations (Peewee) component |
| logging.components.images | string | `""` | Set the log level for the Image Generation component |
| logging.components.main | string | `""` | Set the log level for the Main Application Execution component |
| logging.components.models | string | `""` | Set the log level for the Model Management component |
| logging.components.ollama | string | `""` | Set the log level for the Ollama Backend Integration component |
| logging.components.openai | string | `""` | Set the log level for the OpenAI API Integration component |
| logging.components.rag | string | `""` | Set the log level for the Retrieval-Augmented Generation (RAG) component |
| logging.components.webhook | string | `""` | Set the log level for the Authentication Webhook component |
| logging.level | string | `""` | Set the global log level ["notset", "debug", "info" (default), "warning", "error", "critical"] |

### Azure Storage configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.azure.container | string | `""` | Sets the container name for Azure Storage |
| persistence.azure.endpointUrl | string | `""` | Sets the endpoint URL for Azure Storage |
| persistence.azure.key | string | `""` | Set the access key for Azure Storage (ignored if keyExistingSecret is set). Optional - if not provided, credentials will be taken from the environment. User credentials if run locally and Managed Identity if run in Azure services |
| persistence.azure.keyExistingSecret | string | `""` | Set the access key for Azure Storage from existing secret |
| persistence.azure.keyExistingSecretKey | string | `""` | Set the access key for Azure Storage from existing secret key |

### Google Cloud Storage configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.gcs.appCredentialsJson | string | `""` | Contents of Google Application Credentials JSON file (ignored if appCredentialsJsonExistingSecret is set). Optional - if not provided, credentials will be taken from the environment. User credentials if run locally and Google Metadata server if run on a Google Compute Engine. File can be generated for a service account following this guide: https://developers.google.com/workspace/guides/create-credentials#service-account |
| persistence.gcs.appCredentialsJsonExistingSecret | string | `""` | Set the Google Application Credentials JSON file for Google Cloud Storage from existing secret |
| persistence.gcs.appCredentialsJsonExistingSecretKey | string | `""` | Set the Google Application Credentials JSON file for Google Cloud Storage from existing secret key |
| persistence.gcs.bucket | string | `""` | Sets the bucket name for Google Cloud Storage. Bucket must already exist |

### Amazon S3 Storage configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.s3.accessKey | string | `""` | Sets the access key ID for S3 storage |
| persistence.s3.accessKeyExistingAccessKey | string | `""` | Set the secret access key for S3 storage from existing k8s secret key |
| persistence.s3.accessKeyExistingSecret | string | `""` | Set the secret access key for S3 storage from existing k8s secret |
| persistence.s3.bucket | string | `""` | Sets the bucket name for S3 storage |
| persistence.s3.endpointUrl | string | `""` | Sets the endpoint url for S3 storage |
| persistence.s3.keyPrefix | string | `""` | Sets the key prefix for a S3 object |
| persistence.s3.region | string | `""` | Sets the region name for S3 storage |
| persistence.s3.secretKey | string | `""` | Sets the secret access key for S3 storage (ignored if secretKeyExistingSecret is set) |
| persistence.s3.secretKeyExistingSecret | string | `""` | Set the secret key for S3 storage from existing k8s secret |
| persistence.s3.secretKeyExistingSecretKey | string | `""` | Set the secret key for S3 storage from existing k8s secret key |

### SSO Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.enableGroupManagement | bool | `false` | Enable OAuth group management through access token groups claim |
| sso.enableRoleManagement | bool | `false` | Enable OAuth role management through access token roles claim |
| sso.enableSignup | bool | `false` | Enable account creation when logging in with OAuth (distinct from regular signup) |
| sso.enabled | bool | `false` | **Enable SSO authentication globally** must enable to use SSO authentication |
| sso.groupManagement.groupsClaim | string | `"groups"` | The claim that contains the groups (can be nested, e.g., user.memberOf) |
| sso.mergeAccountsByEmail | bool | `false` | Allow logging into accounts that match email from OAuth provider (considered insecure) |

### GitHub OAuth configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.github.clientExistingSecret | string | `""` | GitHub OAuth client secret from existing secret |
| sso.github.clientExistingSecretKey | string | `""` | GitHub OAuth client secret key from existing secret |
| sso.github.clientId | string | `""` | GitHub OAuth client ID |
| sso.github.clientSecret | string | `""` | GitHub OAuth client secret (ignored if clientExistingSecret is set) |
| sso.github.enabled | bool | `false` | Enable GitHub OAuth |

### Google OAuth configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.google.clientExistingSecret | string | `""` | Google OAuth client secret from existing secret |
| sso.google.clientExistingSecretKey | string | `""` | Google OAuth client secret key from existing secret |
| sso.google.clientId | string | `""` | Google OAuth client ID |
| sso.google.clientSecret | string | `""` | Google OAuth client secret (ignored if clientExistingSecret is set) |
| sso.google.enabled | bool | `false` | Enable Google OAuth |

### Microsoft OAuth configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.microsoft.clientExistingSecret | string | `""` | Microsoft OAuth client secret from existing secret |
| sso.microsoft.clientExistingSecretKey | string | `""` | Microsoft OAuth client secret key from existing secret |
| sso.microsoft.clientId | string | `""` | Microsoft OAuth client ID |
| sso.microsoft.clientSecret | string | `""` | Microsoft OAuth client secret (ignored if clientExistingSecret is set) |
| sso.microsoft.enabled | bool | `false` | Enable Microsoft OAuth |
| sso.microsoft.tenantId | string | `""` | Microsoft tenant ID - use 9188040d-6c67-4c5b-b112-36a304b66dad for personal accounts |

### OIDC configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.oidc.clientExistingSecret | string | `""` | OICD client secret from existing secret |
| sso.oidc.clientExistingSecretKey | string | `""` | OIDC client secret key from existing secret |
| sso.oidc.clientId | string | `""` | OIDC client ID |
| sso.oidc.clientSecret | string | `""` | OIDC client secret (ignored if clientExistingSecret is set) |
| sso.oidc.enabled | bool | `false` | Enable OIDC authentication |
| sso.oidc.providerName | string | `"SSO"` | Name of the provider to show on the UI |
| sso.oidc.providerUrl | string | `""` | OIDC provider well known URL |
| sso.oidc.scopes | string | `"openid email profile"` | Scopes to request (space-separated). |

### Role management configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.roleManagement.adminRoles | string | `""` | Comma-separated list of roles allowed to log in as admin (receive open webui role admin) |
| sso.roleManagement.allowedRoles | string | `""` | Comma-separated list of roles allowed to log in (receive open webui role user) |
| sso.roleManagement.rolesClaim | string | `"roles"` | The claim that contains the roles (can be nested, e.g., user.roles) |

### SSO trusted header authentication

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| sso.trustedHeader.emailHeader | string | `""` | Header containing the user's email address |
| sso.trustedHeader.enabled | bool | `false` | Enable trusted header authentication |
| sso.trustedHeader.nameHeader | string | `""` | Header containing the user's name (optional, used for new user creation) |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment |
| annotations | object | `{}` |  |
| args | list | `[]` | Open WebUI container arguments (overrides default) |
| clusterDomain | string | `"cluster.local"` | Value of cluster domain |
| command | list | `[]` | Open WebUI container command (overrides default entrypoint) |
| commonEnvVars | list | `[]` | Env vars added to the Open WebUI deployment, common across environments. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration/ (caution: environment variables defined in both `extraEnvVars` and `commonEnvVars` will result in a conflict. Avoid duplicates) |
| containerSecurityContext | object | `{}` | Configure container security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-containe> |
| copyAppData.args | list | `[]` | Open WebUI copy-app-data init container arguments (overrides default) |
| copyAppData.command | list | `[]` | Open WebUI copy-app-data init container command (overrides default) |
| copyAppData.resources | object | `{}` |  |
| databaseUrl | string | `""` | Configure database URL, needed to work with Postgres (example: `postgresql://<user>:<password>@<service>:<port>/<database>`), leave empty to use the default sqlite database |
| enableOpenaiApi | bool | `true` | Enables the use of OpenAI APIs |
| extraEnvFrom | list | `[]` | Env vars added from configmap or secret to the Open WebUI deployment. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration/ (caution: `extraEnvVars` will take precedence over the value from `extraEnvFrom`) |
| extraEnvVars | list | `[{"name":"OPENAI_API_KEY","value":"0p3n-w3bu!"}]` | Env vars added to the Open WebUI deployment. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration/ |
| extraEnvVars[0] | object | `{"name":"OPENAI_API_KEY","value":"0p3n-w3bu!"}` | Default API key value for Pipelines. Should be updated in a production deployment, or be changed to the required API key if not using Pipelines |
| extraInitContainers | list | `[]` | Additional init containers to add to the deployment/statefulset ref: <https://kubernetes.io/docs/concepts/workloads/pods/init-containers/> |
| extraResources | list | `[]` | Extra resources to deploy with Open WebUI |
| hostAliases | list | `[]` | HostAliases to be added to hosts-file of each container |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/open-webui/open-webui","tag":""}` | Open WebUI image tags can be found here: https://github.com/open-webui/open-webui |
| imagePullSecrets | list | `[]` | Configure imagePullSecrets to use private registry ref: <https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry> |
| ingress.additionalHosts | list | `[]` |  |
| ingress.annotations | object | `{}` | Use appropriate annotations for your Ingress controller, e.g., for NGINX: |
| ingress.class | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.existingSecret | string | `""` |  |
| ingress.extraLabels | object | `{}` | Additional custom labels to add to the Ingress metadata Useful for tagging, selecting, or applying policies to the Ingress via labels. |
| ingress.host | string | `"chat.example.com"` |  |
| ingress.tls | bool | `false` |  |
| livenessProbe | object | `{}` | Probe for liveness of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| managedCertificate.domains[0] | string | `"chat.example.com"` |  |
| managedCertificate.enabled | bool | `false` |  |
| managedCertificate.name | string | `"mydomain-chat-cert"` |  |
| nameOverride | string | `""` |  |
| namespaceOverride | string | `""` |  |
| nodeSelector | object | `{}` | Node labels for pod assignment. |
| ollama.enabled | bool | `true` | Automatically install Ollama Helm chart from https://otwld.github.io/ollama-helm/. Use [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) to configure |
| ollama.fullnameOverride | string | `"open-webui-ollama"` | If enabling embedded Ollama, update fullnameOverride to your desired Ollama name value, or else it will use the default ollama.name value from the Ollama chart |
| ollamaUrls | list | `[]` | A list of Ollama API endpoints. These can be added in lieu of automatically installing the Ollama Helm chart, or in addition to it. |
| ollamaUrlsFromExtraEnv | bool | `false` | Disables taking Ollama Urls from `ollamaUrls`  list |
| openaiBaseApiUrl | string | `"https://api.openai.com/v1"` | OpenAI base API URL to use. Defaults to the Pipelines service endpoint when Pipelines are enabled, and "https://api.openai.com/v1" if Pipelines are not enabled and this value is blank |
| openaiBaseApiUrls | list | `[]` | OpenAI base API URLs to use. Overwrites the value in openaiBaseApiUrl if set |
| persistence.accessModes | list | `["ReadWriteOnce"]` | If using multiple replicas, you must update accessModes to ReadWriteMany |
| persistence.annotations | object | `{}` |  |
| persistence.enabled | bool | `true` |  |
| persistence.existingClaim | string | `""` | Use existingClaim if you want to re-use an existing Open WebUI PVC instead of creating a new one |
| persistence.provider | string | `"local"` | Sets the storage provider, availables values are `local`, `s3`, `gcs` or `azure` |
| persistence.selector | object | `{}` |  |
| persistence.size | string | `"2Gi"` |  |
| persistence.storageClass | string | `""` |  |
| persistence.subPath | string | `""` | Subdirectory of Open WebUI PVC to mount. Useful if root directory is not empty. |
| pipelines.enabled | bool | `true` | Automatically install Pipelines chart to extend Open WebUI functionality using Pipelines: https://github.com/open-webui/pipelines |
| pipelines.extraEnvVars | list | `[]` | This section can be used to pass required environment variables to your pipelines (e.g. Langfuse hostname) |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` | Configure pod security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container> |
| postgresql | object | `{"architecture":"standalone","auth":{"database":"open-webui","password":"0p3n-w3bu!","postgresPassword":"0p3n-w3bu!","username":"open-webui"},"enabled":false,"fullnameOverride":"open-webui-postgres","primary":{"persistence":{"size":"1Gi"},"resources":{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"250m","memory":"256Mi"}}}}` | Postgresql configuration (see. https://artifacthub.io/packages/helm/bitnami/postgresql) |
| priorityClassName | string | `""` | Priority class name for the Open WebUI pods |
| readinessProbe | object | `{}` | Probe for readiness of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| redis-cluster | object | `{"auth":{"enabled":false},"enabled":false,"fullnameOverride":"open-webui-redis","replica":{"replicaCount":3},"url":"redis://open-webui-redis:6379/0"}` | Deploys a Redis cluster with subchart 'redis' from bitnami |
| redis-cluster.auth | object | `{"enabled":false}` | Redis Authentication |
| redis-cluster.auth.enabled | bool | `false` | Enable Redis authentication (disabled by default). For your security, we strongly suggest that you switch to 'auth.enabled=true' |
| redis-cluster.enabled | bool | `false` | Enable Redis installation |
| redis-cluster.fullnameOverride | string | `"open-webui-redis"` | Redis cluster name (recommended to be 'open-webui-redis') - In this case, redis url will be 'redis://open-webui-redis-master:6379/0' or 'redis://[:<password>@]open-webui-redis-master:6379/0' |
| redis-cluster.replica | object | `{"replicaCount":3}` | Replica configuration for the Redis cluster |
| redis-cluster.replica.replicaCount | int | `3` | Number of Redis replica instances |
| redis-cluster.url | string | `"redis://open-webui-redis:6379/0"` | Specifies the URL of the Redis instance for websocket communication. Template with `redis://[:<password>@]<hostname>:<port>/<db>` |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| revisionHistoryLimit | int | `10` | Revision history limit for the workload manager (deployment). |
| runtimeClassName | string | `""` | Configure runtime class ref: <https://kubernetes.io/docs/concepts/containers/runtime-class/> |
| service | object | `{"annotations":{},"containerPort":8080,"labels":{},"loadBalancerClass":"","nodePort":"","port":80,"type":"ClusterIP"}` | Service values to expose Open WebUI pods to cluster |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automountServiceAccountToken | bool | `false` |  |
| serviceAccount.enable | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| startupProbe | object | `{}` | Probe for startup of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| strategy | object | `{}` | Strategy for updating the workload manager: deployment or statefulset |
| tika.enabled | bool | `false` | Automatically install Apache Tika to extend Open WebUI |
| tolerations | list | `[]` | Tolerations for pod assignment |
| topologySpreadConstraints | list | `[]` | Topology Spread Constraints for pod assignment |
| volumeMounts | object | `{"container":[],"initContainer":[]}` | Configure container volume mounts ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/> |
| volumes | list | `[]` | Configure pod volumes ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/> |
| websocket.enabled | bool | `false` | Enables websocket support in Open WebUI with env `ENABLE_WEBSOCKET_SUPPORT` |
| websocket.manager | string | `"redis"` | Specifies the websocket manager to use with env `WEBSOCKET_MANAGER`: redis (default) |
| websocket.nodeSelector | object | `{}` | Node selector for websocket pods |
| websocket.redis | object | `{"affinity":{},"annotations":{},"args":[],"command":[],"enabled":true,"image":{"pullPolicy":"IfNotPresent","repository":"redis","tag":"7.4.2-alpine3.21"},"labels":{},"name":"open-webui-redis","pods":{"annotations":{},"labels":{}},"resources":{},"securityContext":{},"service":{"annotations":{},"containerPort":6379,"labels":{},"nodePort":"","port":6379,"type":"ClusterIP"},"tolerations":[]}` | Deploys a redis |
| websocket.redis.affinity | object | `{}` | Redis affinity for pod assignment |
| websocket.redis.annotations | object | `{}` | Redis annotations |
| websocket.redis.args | list | `[]` | Redis arguments (overrides default) |
| websocket.redis.command | list | `[]` | Redis command (overrides default) |
| websocket.redis.enabled | bool | `true` | Enable redis installation |
| websocket.redis.image | object | `{"pullPolicy":"IfNotPresent","repository":"redis","tag":"7.4.2-alpine3.21"}` | Redis image |
| websocket.redis.labels | object | `{}` | Redis labels |
| websocket.redis.name | string | `"open-webui-redis"` | Redis name |
| websocket.redis.pods | object | `{"annotations":{},"labels":{}}` | Redis pod |
| websocket.redis.pods.annotations | object | `{}` | Redis pod annotations |
| websocket.redis.pods.labels | object | `{}` | Redis pod labels |
| websocket.redis.resources | object | `{}` | Redis resources |
| websocket.redis.securityContext | object | `{}` | Redis security context |
| websocket.redis.service | object | `{"annotations":{},"containerPort":6379,"labels":{},"nodePort":"","port":6379,"type":"ClusterIP"}` | Redis service |
| websocket.redis.service.annotations | object | `{}` | Redis service annotations |
| websocket.redis.service.containerPort | int | `6379` | Redis container/target port |
| websocket.redis.service.labels | object | `{}` | Redis service labels |
| websocket.redis.service.nodePort | string | `""` | Redis service node port. Valid only when type is `NodePort` |
| websocket.redis.service.port | int | `6379` | Redis service port |
| websocket.redis.service.type | string | `"ClusterIP"` | Redis service type |
| websocket.redis.tolerations | list | `[]` | Redis tolerations for pod assignment |
| websocket.url | string | `"redis://open-webui-redis:6379/0"` | Specifies the URL of the Redis instance for websocket communication. Template with `redis://[:<password>@]<hostname>:<port>/<db>` |

----------------------------------------------

Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs/).
