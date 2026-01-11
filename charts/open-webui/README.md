# open-webui

![Version: 10.2.0](https://img.shields.io/badge/Version-10.2.0-informational?style=flat-square) ![AppVersion: 0.7.2](https://img.shields.io/badge/AppVersion-0.7.2-informational?style=flat-square)

Open WebUI: A User-Friendly Web Interface for Chat Interactions 👋

**Homepage:** <https://www.openwebui.com/>

## Source Code

* <https://github.com/open-webui/helm-charts>
* <https://github.com/open-webui/open-webui/pkgs/container/open-webui>
* <https://github.com/otwld/ollama-helm/>
* <https://hub.docker.com/r/ollama/ollama>

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
| https://helm.openwebui.com | pipelines | >=0.0.1 |
| https://otwld.github.io/ollama-helm/ | ollama | >=0.24.0 |

## Values

### OpenAI API configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| enableOpenaiApi | bool | `true` | Enables the use of OpenAI APIs |
| openaiApiKey | string | `"0p3n-w3bu!"` | OpenAI API key to use. Default API key value for Pipelines if `openaiBaseApiUrl` is blank. Should be updated in a production deployment, or be changed to the required API key if not using Pipelines |
| openaiApiKeys | list | `[]` | List of OpenAI API keys for each OpenAI base API URLs to use. The number of keys must match the number of URLs in `openaiBaseApiUrls` and respect the same order. If `pipelines.enabled` is true, it needs one more key (so the list length should be openaiBaseApiUrls length + 1) and the first key will be used for Pipelines. |
| openaiBaseApiUrl | string | `"https://api.openai.com/v1"` | OpenAI base API URL to use. Defaults to the Pipelines service endpoint when Pipelines are enabled, and "https://api.openai.com/v1" if Pipelines are not enabled and this value is blank |
| openaiBaseApiUrls | list | `[]` | OpenAI base API URLs to use. Overwrites the value in openaiBaseApiUrl if set |

### Image configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.pullPolicy | string | `"IfNotPresent"` | Open WebUI image pull policy |
| image.repository | string | `"ghcr.io/open-webui/open-webui"` | Open WebUI image repository |
| image.tag | string | `""` | Open WebUI image tag (Open WebUI image tags can be found here: https://github.com/open-webui/open-webui) |
| image.useSlim | bool | `false` | Use a slim version of the Open WebUI image |
| imagePullSecrets | list | `[]` | Configure imagePullSecrets to use private registry ref: <https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry> |

### Ingress configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ingress.additionalHosts | list | `[]` | Additional hosts for the Ingress record |
| ingress.annotations | object | `{}` | Use appropriate annotations for your Ingress controller, e.g., for NGINX: |
| ingress.class | string | `""` | Ingress class to use, e.g., for GKE Ingress use "gce", for NGINX Ingress use "nginx". If using an Ingress class other than the default, ensure your cluster has the corresponding Ingress controller installed and configured. |
| ingress.enabled | bool | `false` | Enable Ingress controller for Open WebUI |
| ingress.existingSecret | string | `""` | TLS secret name for the Ingress record |
| ingress.extraLabels | object | `{}` | Additional custom labels to add to the Ingress metadata |
| ingress.host | string | `"chat.example.com"` | Host for the Ingress record |
| ingress.tls | bool | `false` | TLS configuration for the Ingress resource |
| managedCertificate.domains | list | `["chat.example.com"]` | Domains to include in the Managed Certificate |
| managedCertificate.enabled | bool | `false` | Enable GKE Managed Certificate for Ingress TLS |
| managedCertificate.name | string | `"mydomain-chat-cert"` | Name of the Managed Certificate resource to create |

### Probes configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| livenessProbe | object | `{}` | Probe for liveness of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| readinessProbe | object | `{}` | Probe for readiness of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| startupProbe | object | `{}` | Probe for startup of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |

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

### External Tools configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| ollama.enabled | bool | `true` | Automatically install Ollama Helm chart from https://otwld.github.io/ollama-helm/. Use [Helm Values](https://github.com/otwld/ollama-helm/#helm-values) to configure |
| ollama.fullnameOverride | string | `"open-webui-ollama"` | If enabling embedded Ollama, update fullnameOverride to your desired Ollama name value, or else it will use the default ollama.name value from the Ollama chart |
| ollamaUrls | list | `[]` | A list of Ollama API endpoints. These can be added in lieu of automatically installing the Ollama Helm chart, or in addition to it. |
| ollamaUrlsFromExtraEnv | bool | `false` | Disables taking Ollama Urls from `ollamaUrls`  list |
| pipelines.enabled | bool | `true` | Automatically install Pipelines chart to extend Open WebUI functionality using Pipelines: https://github.com/open-webui/pipelines |
| pipelines.extraEnvVars | list | `[]` | This section can be used to pass required environment variables to your pipelines (e.g. Langfuse hostname) |
| tika.enabled | bool | `false` | Automatically install Apache Tika to extend Open WebUI |

### Persistence configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| persistence.accessModes | list | `["ReadWriteOnce"]` | If using multiple replicas, you must update accessModes to ReadWriteMany |
| persistence.annotations | object | `{}` | Additional annotations to add to the PVC |
| persistence.enabled | bool | `true` | Enable persistence using PVC for Open WebUI data |
| persistence.existingClaim | string | `""` | Use existingClaim if you want to re-use an existing Open WebUI PVC instead of creating a new one |
| persistence.provider | string | `"local"` | Sets the storage provider, availables values are `local`, `s3`, `gcs` or `azure` |
| persistence.selector | object | `{}` | Selector to match to get the volume bound to the claim |
| persistence.size | string | `"2Gi"` | Size of the Open WebUI PVC |
| persistence.storageClass | string | `""` | Storage class of the Open WebUI PVC |
| persistence.subPath | string | `""` | Subdirectory of Open WebUI PVC to mount. Useful if root directory is not empty. |

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

### Service configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| service.annotations | object | `{}` | Additional annotations to add to the Service |
| service.containerPort | int | `8080` | Target port for the Open WebUI container |
| service.labels | object | `{}` | Additional custom labels to add to the Service metadata |
| service.loadBalancerClass | string | `""` | Load balancer class to use if service type is LoadBalancer (e.g., for GKE use "gce") |
| service.nodePort | string | `""` | Node port to use if service type is NodePort |
| service.port | int | `80` | Port to expose Open WebUI service on |
| service.type | string | `"ClusterIP"` | Service type to expose Open WebUI pods to cluster. Options are ClusterIP, NodePort, LoadBalancer, or ExternalName |

### Service Account configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| serviceAccount.annotations | object | `{}` | Additional annotations to add to the ServiceAccount |
| serviceAccount.automountServiceAccountToken | bool | `false` | Automount service account token for the Open WebUI pods |
| serviceAccount.create | bool | `true` | If create is set to false, set `name` to existing service account name |
| serviceAccount.enable | bool | `true` | Enable service account creation |
| serviceAccount.name | string | `"existing-sa"` | Service account name to use. If `ServiceAccount.create` is false, this assumes an existing service account exists with the set name. If not set and `serviceAccount.create` is true, a name is generated using the fullname template. |

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

### Websocket configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| websocket.enabled | bool | `true` | Enables websocket support in Open WebUI with env `ENABLE_WEBSOCKET_SUPPORT` |
| websocket.manager | string | `"redis"` | Specifies the websocket manager to use with env `WEBSOCKET_MANAGER`: redis (default) |
| websocket.nodeSelector | object | `{}` | Node selector for websocket pods |
| websocket.redis.affinity | object | `{}` | Redis affinity for pod assignment |
| websocket.redis.annotations | object | `{}` | Redis annotations |
| websocket.redis.args | list | `[]` | Redis arguments (overrides default) |
| websocket.redis.command | list | `[]` | Redis command (overrides default) |
| websocket.redis.containerSecurityContext | object | `{}` | Redis container security context (certain specs are not allowed on a pod level), if readOnlyRootFilesystem is true, an emtpyDir will be mounted on the redis container |
| websocket.redis.enabled | bool | `true` | Enable redis installation |
| websocket.redis.image.pullPolicy | string | `"IfNotPresent"` | Redis image pull policy |
| websocket.redis.image.repository | string | `"redis"` | Redis image repository |
| websocket.redis.image.tag | string | `"7.4.2-alpine3.21"` | Redis image tag |
| websocket.redis.labels | object | `{}` | Redis labels |
| websocket.redis.name | string | `"open-webui-redis"` | Redis name |
| websocket.redis.podSecurityContext | object | `{}` | Redis pod security context |
| websocket.redis.pods.annotations | object | `{}` | Redis pod annotations |
| websocket.redis.pods.labels | object | `{}` | Redis pod labels |
| websocket.redis.resources | object | `{}` | Redis resources |
| websocket.redis.service.annotations | object | `{}` | Redis service annotations |
| websocket.redis.service.containerPort | int | `6379` | Redis container/target port |
| websocket.redis.service.labels | object | `{}` | Redis service labels |
| websocket.redis.service.nodePort | string | `""` | Redis service node port. Valid only when type is `NodePort` |
| websocket.redis.service.port | int | `6379` | Redis service port |
| websocket.redis.service.portName | string | `"http"` | Redis service port name. Istio needs this to be something like `tcp-redis` |
| websocket.redis.service.type | string | `"ClusterIP"` | Redis service type |
| websocket.redis.tolerations | list | `[]` | Redis tolerations for pod assignment |
| websocket.url | string | `"redis://open-webui-redis:6379/0"` | Specifies the URL of the Redis instance for websocket communication. Template with `redis://[:<password>@]<hostname>:<port>/<db>` |

### Other Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment |
| annotations | object | `{}` | Additional annotations to add to the Open WebUI deployment/statefulset metadata |
| args | list | `[]` | Open WebUI container arguments (overrides default) |
| clusterDomain | string | `"cluster.local"` | Value of cluster domain |
| command | list | `[]` | Open WebUI container command (overrides default entrypoint) |
| commonEnvVars | list | `[]` | Env vars added to the Open WebUI deployment, common across environments. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration/ (caution: environment variables defined in both `extraEnvVars` and `commonEnvVars` will result in a conflict. Avoid duplicates) |
| containerSecurityContext | object | `{}` | Configure container security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-containe> |
| copyAppData.args | list | `[]` | Open WebUI copy-app-data init container arguments (overrides default) |
| copyAppData.command | list | `[]` | Open WebUI copy-app-data init container command (overrides default) |
| copyAppData.resources | object | `{}` | Resource requests and limits for the Open WebUI copy-app-data init container |
| databaseUrl | string | `""` | Configure database URL, needed to work with Postgres (example: `postgresql://<user>:<password>@<service>:<port>/<database>`), leave empty to use the default sqlite database. Alternatively, use extraEnvVars to construct the database URL by setting the `DATABASE_TYPE`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_HOST`, and `DATABASE_NAME` environment variables. |
| extraEnvFrom | list | `[]` | Env vars added from configmap or secret to the Open WebUI deployment. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration/ (caution: `extraEnvVars` will take precedence over the value from `extraEnvFrom`) |
| extraEnvVars | list | `[]` | Env vars added to the Open WebUI deployment. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration. Variables can be defined as list or map style. |
| extraInitContainers | list | `[]` | Additional init containers to add to the deployment/statefulset ref: <https://kubernetes.io/docs/concepts/workloads/pods/init-containers/> |
| extraLabels | object | `{}` | Additional custom labels to add to the Open WebUI deployment/statefulset metadata |
| extraResources | list | `[]` | Extra resources to deploy with Open WebUI |
| hostAliases | list | `[]` | HostAliases to be added to hosts-file of each container |
| nameOverride | string | `""` | Provide a name in place of the default application name |
| namespaceOverride | string | `""` | Provide a namespace in place of the default release namespace |
| nodeSelector | object | `{}` | Node labels for pod assignment. |
| podAnnotations | object | `{}` | Additional annotations to add to the Open WebUI pods |
| podLabels | object | `{}` | Additional custom labels to add to the Open WebUI pods |
| podSecurityContext | object | `{}` | Configure pod security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container> |
| priorityClassName | string | `""` | Priority class name for the Open WebUI pods |
| replicaCount | int | `1` | Number of Open WebUI replicas |
| resources | object | `{}` | Resource requests and limits for the Open WebUI container |
| revisionHistoryLimit | int | `10` | Revision history limit for the workload manager (deployment). |
| runtimeClassName | string | `""` | Configure runtime class ref: <https://kubernetes.io/docs/concepts/containers/runtime-class/> |
| strategy | object | `{}` | Strategy for updating the workload manager: deployment or statefulset |
| tolerations | list | `[]` | Tolerations for pod assignment |
| topologySpreadConstraints | list | `[]` | Topology Spread Constraints for pod assignment |
| volumeMounts | object | `{"container":[],"initContainer":[]}` | Configure container volume mounts ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/> |
| volumes | list | `[]` | Configure pod volumes ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/> |
| workload.kind | string | `""` | Workload kind to use. Options are "Deployment", "StatefulSet". If not set, the chart will determine the kind based on persistence settings. NOTE: When using Deployment with local persistence and replicaCount > 1, ensure persistence.accessModes includes ReadWriteMany (RWX). |

----------------------------------------------

Autogenerated from chart metadata using [helm-docs](https://github.com/norwoodj/helm-docs/).
