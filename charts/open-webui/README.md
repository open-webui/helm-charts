# open-webui

![Version: 5.24.0](https://img.shields.io/badge/Version-5.24.0-informational?style=flat-square) ![AppVersion: 0.5.20](https://img.shields.io/badge/AppVersion-0.5.20-informational?style=flat-square)

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
| https://charts.bitnami.com/bitnami | redis-cluster(redis) | >=20.6.2 |
| https://helm.openwebui.com | pipelines | >=0.0.1 |
| https://otwld.github.io/ollama-helm/ | ollama | >=0.24.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment |
| annotations | object | `{}` |  |
| clusterDomain | string | `"cluster.local"` | Value of cluster domain |
| containerSecurityContext | object | `{}` | Configure container security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-containe> |
| copyAppData.resources | object | `{}` |  |
| enableOpenaiApi | bool | `true` | Enables the use of OpenAI APIs |
| extraEnvVars | list | `[{"name":"OPENAI_API_KEY","value":"0p3n-w3bu!"}]` | Env vars added to the Open WebUI deployment. Most up-to-date environment variables can be found here: https://docs.openwebui.com/getting-started/env-configuration/ |
| extraEnvVars[0] | object | `{"name":"OPENAI_API_KEY","value":"0p3n-w3bu!"}` | Default API key value for Pipelines. Should be updated in a production deployment, or be changed to the required API key if not using Pipelines |
| extraInitContainers | list | `[]` | Additional init containers to add to the deployment/statefulset ref: <https://kubernetes.io/docs/concepts/workloads/pods/init-containers/> |
| extraResources | list | `[]` | Extra resources to deploy with Open WebUI |
| hostAliases | list | `[]` | HostAliases to be added to hosts-file of each container |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/open-webui/open-webui","tag":""}` | Open WebUI image tags can be found here: https://github.com/open-webui/open-webui |
| imagePullSecrets | list | `[]` | Configure imagePullSecrets to use private registry ref: <https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry> |
| ingress.additionalHosts | list | `[]` |  |
| ingress.annotations | object | `{}` | Use appropriate annotations for your Ingress controller, e.g., for NGINX:   |
| ingress.class | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.existingSecret | string | `""` |  |
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
| persistence.selector | object | `{}` |  |
| persistence.size | string | `"2Gi"` |  |
| persistence.storageClass | string | `""` |  |
| persistence.subPath | string | `""` | Subdirectory of Open WebUI PVC to mount. Useful if root directory is not empty. |
| pipelines.enabled | bool | `true` | Automatically install Pipelines chart to extend Open WebUI functionality using Pipelines: https://github.com/open-webui/pipelines |
| pipelines.extraEnvVars | list | `[]` | This section can be used to pass required environment variables to your pipelines (e.g. Langfuse hostname) |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` | Configure pod security context ref: <https://kubernetes.io/docs/tasks/configure-pod-container/security-context/#set-the-security-context-for-a-container> |
| readinessProbe | object | `{}` | Probe for readiness of the Open WebUI container ref: <https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes> |
| redis-cluster | object | `{"auth":{"enabled":false},"enabled":false,"fullnameOverride":"open-webui-redis","replica":{"replicaCount":3}}` | Deploys a Redis cluster with subchart 'redis' from bitnami |
| redis-cluster.auth | object | `{"enabled":false}` | Redis Authentication |
| redis-cluster.auth.enabled | bool | `false` | Enable Redis authentication (disabled by default). For your security, we strongly suggest that you switch to 'auth.enabled=true' |
| redis-cluster.enabled | bool | `false` | Enable Redis installation |
| redis-cluster.fullnameOverride | string | `"open-webui-redis"` | Redis cluster name (recommended to be 'open-webui-redis') - In this case, redis url will be 'redis://open-webui-redis-master:6379/0' or 'redis://[:<password>@]open-webui-redis-master:6379/0' |
| redis-cluster.replica | object | `{"replicaCount":3}` | Replica configuration for the Redis cluster |
| redis-cluster.replica.replicaCount | int | `3` | Number of Redis replica instances |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
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
| websocket.redis | object | `{"affinity":{},"annotations":{},"args":[],"command":[],"enabled":true,"image":{"pullPolicy":"IfNotPresent","repository":"redis","tag":"7.4.2-alpine3.21"},"labels":{},"name":"open-webui-redis","pods":{"annotations":{}},"resources":{},"service":{"annotations":{},"containerPort":6379,"labels":{},"nodePort":"","port":6379,"type":"ClusterIP"},"tolerations":[]}` | Deploys a redis |
| websocket.redis.affinity | object | `{}` | Redis affinity for pod assignment |
| websocket.redis.annotations | object | `{}` | Redis annotations |
| websocket.redis.args | list | `[]` | Redis arguments (overrides default) |
| websocket.redis.command | list | `[]` | Redis command (overrides default) |
| websocket.redis.enabled | bool | `true` | Enable redis installation |
| websocket.redis.image | object | `{"pullPolicy":"IfNotPresent","repository":"redis","tag":"7.4.2-alpine3.21"}` | Redis image |
| websocket.redis.labels | object | `{}` | Redis labels |
| websocket.redis.name | string | `"open-webui-redis"` | Redis name |
| websocket.redis.pods | object | `{"annotations":{}}` | Redis pod |
| websocket.redis.pods.annotations | object | `{}` | Redis pod annotations |
| websocket.redis.resources | object | `{}` | Redis resources |
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
