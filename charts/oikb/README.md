# oikb

OIKB: Incremental Knowledge Base sync for Open WebUI

**Homepage:** <https://github.com/open-webui/oikb>

## Runtime modes

- `mode: daemon` (default): long-running HTTP service (`oikb daemon`) with an internal
  scheduler, `/health`, `/health/ready`, `/metrics`, and an OpenAPI tool-server interface.
- `mode: cronjob`: a one-shot `oikb sync` on a schedule.

## Open WebUI API key

OIKB needs an Open WebUI API key (`OPEN_WEBUI_API_KEY`). Provide it one of three ways:

1. `openWebuiApiKey` / `existingSecret` — explicit key you already minted.
2. `bootstrapApiKey.enabled` (default) with a fresh Open WebUI where
   `WEBUI_ADMIN_EMAIL` / `WEBUI_ADMIN_PASSWORD` and `ENABLE_API_KEYS=true` are set — the
   chart provisions the key automatically.
3. `bootstrapApiKey.adminEmail` / `adminPassword` — provision against an existing Open
   WebUI you point `openWebuiUrl` at.

## Bundled under open-webui

When bundled as a subchart of `open-webui`, `OPEN_WEBUI_URL` is derived from the release
name (`http://<release>-open-webui...`). If the parent chart sets `fullnameOverride`, this
derivation will not match the actual Open WebUI Service name — set `oikb.openWebuiUrl`
explicitly in that case.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity |
| apiKey | string | `""` | OIKB daemon API key (OIKB_API_KEY) securing the daemon's own endpoints. Random value generated when empty in daemon mode. |
| bootstrapApiKey | object | `{"adminEmail":"","adminExistingSecret":"","adminExistingSecretEmailKey":"admin-email","adminExistingSecretPasswordKey":"admin-password","adminPassword":"","enabled":true,"image":{"pullPolicy":"IfNotPresent","repository":"curlimages/curl","tag":"8.11.1"},"readyTimeoutSeconds":300,"regenerate":false}` | ------------------------------------------------------------------------ |
| bootstrapApiKey.adminEmail | string | `""` | Admin email used to sign in to Open WebUI (case 3). When bundled and OWUI is deployed fresh by the same release, this can reuse the parent's WEBUI_ADMIN_EMAIL. |
| bootstrapApiKey.adminExistingSecret | string | `""` | Use an existing Secret for admin credentials instead of adminEmail/adminPassword |
| bootstrapApiKey.adminExistingSecretEmailKey | string | `"admin-email"` | Key in `adminExistingSecret` holding the admin email |
| bootstrapApiKey.adminExistingSecretPasswordKey | string | `"admin-password"` | Key in `adminExistingSecret` holding the admin password |
| bootstrapApiKey.adminPassword | string | `""` | Admin password (case 3) |
| bootstrapApiKey.enabled | bool | `true` | Provision the Open WebUI API key automatically via a post-install/upgrade Job when no explicit key (openWebuiApiKey/existingSecret) is set. |
| bootstrapApiKey.image.pullPolicy | string | `"IfNotPresent"` | Bootstrap Job image pull policy |
| bootstrapApiKey.image.repository | string | `"curlimages/curl"` | Image for the bootstrap Job (needs curl; talks to OWUI and the Kubernetes API) |
| bootstrapApiKey.image.tag | string | `"8.11.1"` | Bootstrap Job image tag |
| bootstrapApiKey.readyTimeoutSeconds | int | `300` | Seconds to wait for Open WebUI to become ready before failing |
| bootstrapApiKey.regenerate | bool | `false` | Force regeneration of the key (POST) instead of reusing an existing one (GET) |
| clusterDomain | string | `"cluster.local"` | Cluster domain used to build in-cluster service URLs |
| config | object | `{}` | Inline OIKB configuration rendered into a Secret and mounted as .oikb.yaml. Carries connector credentials, so it is stored as a Secret (not a ConfigMap). Values support `${VAR}` interpolation against the container environment. |
| configMountPath | string | `"/app/.oikb.yaml"` | Mount inline config as a Secret at this path (OIKB reads .oikb.yaml from its workdir /app) |
| containerSecurityContext | object | `{}` | Container security context |
| cronjob | object | `{"args":[],"command":["oikb","sync"],"concurrencyPolicy":"Forbid","failedJobsHistoryLimit":1,"restartPolicy":"OnFailure","schedule":"0 * * * *","successfulJobsHistoryLimit":3}` | ------------------------------------------------------------------------ |
| cronjob.command | list | `["oikb","sync"]` | Container command |
| cronjob.concurrencyPolicy | string | `"Forbid"` | Concurrency policy |
| cronjob.failedJobsHistoryLimit | int | `1` | Retained failed jobs |
| cronjob.restartPolicy | string | `"OnFailure"` | Pod restart policy |
| cronjob.schedule | string | `"0 * * * *"` | Cron schedule for one-shot syncs |
| cronjob.successfulJobsHistoryLimit | int | `3` | Retained successful jobs |
| enabled | bool | `false` | Enable the OIKB subchart (consumed by the parent chart's condition; harmless standalone) |
| existingConfigSecret | string | `""` | Use an existing Secret containing the .oikb.yaml config instead of rendering `config` |
| existingConfigSecretKey | string | `".oikb.yaml"` | Key within `existingConfigSecret` holding the config file |
| existingSecret | string | `""` | Use an existing Secret for the Open WebUI API key. When set, disables the bootstrap Job. |
| existingSecretKey | string | `"open-webui-api-key"` | Key within `existingSecret` holding the Open WebUI API key |
| extraEnvVars | list | `[]` | Additional environment variables for the OIKB container (e.g. connector credentials) |
| extraInitContainers | list | `[]` | Additional init containers |
| extraResources | list | `[]` | Extra manifests to deploy with the chart |
| fullnameOverride | string | `""` | Override the fully qualified name |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"ghcr.io/open-webui/oikb"` | OIKB image repository |
| image.tag | string | `""` | Image tag (defaults to the chart appVersion when empty) |
| imagePullSecrets | list | `[]` | Image pull secrets for private registries |
| logFormat | string | `""` | LOG_FORMAT value (e.g. "json"); omitted when empty |
| metrics | object | `{"serviceMonitor":{"enabled":false,"interval":"30s","labels":{}}}` | ------------------------------------------------------------------------ |
| metrics.serviceMonitor.enabled | bool | `false` | Create a Prometheus Operator ServiceMonitor scraping /metrics (daemon mode) |
| metrics.serviceMonitor.interval | string | `"30s"` | Scrape interval |
| metrics.serviceMonitor.labels | object | `{}` | Extra labels for the ServiceMonitor (e.g. Prometheus release selector) |
| mode | string | `"daemon"` | Runtime model: `daemon` (long-running HTTP service + internal scheduler) or `cronjob` (one-shot sync) |
| nameOverride | string | `""` | Override the chart name |
| namespaceOverride | string | `""` | Override the namespace for combined charts |
| nodeSelector | object | `{}` | Node selector |
| openWebuiApiKey | string | `""` | Explicit Open WebUI API key (OPEN_WEBUI_API_KEY). When set, disables the bootstrap Job. |
| openWebuiUrl | string | `""` | Open WebUI base URL (OPEN_WEBUI_URL). Required for standalone installs; derived from the release when bundled under the open-webui parent chart. |
| podAnnotations | object | `{}` | Extra pod annotations |
| podLabels | object | `{}` | Extra pod labels |
| podSecurityContext | object | `{}` | Pod security context (upstream image may run as root; verify before enabling non-root) ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| replicaCount | int | `1` | Number of daemon replicas (daemon mode only) |
| resources | object | `{"limits":{"cpu":"500m","memory":"512Mi"},"requests":{"cpu":"50m","memory":"128Mi"}}` | Resource requests/limits for the OIKB container |
| service | object | `{"annotations":{},"containerPort":8080,"labels":{},"port":8080,"type":"ClusterIP"}` | ------------------------------------------------------------------------ |
| service.annotations | object | `{}` | Extra service annotations |
| service.containerPort | int | `8080` | Container port OIKB listens on |
| service.labels | object | `{}` | Extra service labels |
| service.port | int | `8080` | Service port |
| service.type | string | `"ClusterIP"` | Service type (daemon mode) |
| serviceAccount.annotations | object | `{}` | ServiceAccount annotations |
| serviceAccount.automountServiceAccountToken | bool | `false` | Automount the ServiceAccount token |
| serviceAccount.create | bool | `true` | Create a ServiceAccount for the workload |
| serviceAccount.name | string | `""` | ServiceAccount name (defaults to the fullname) |
| tolerations | list | `[]` | Tolerations |
| toolServerOpenapiPath | string | `"openapi.json"` | Path to the OIKB OpenAPI spec, used when registering OIKB as an Open WebUI tool server |
| topologySpreadConstraints | list | `[]` | Topology spread constraints |
| volumeMounts | list | `[]` | Additional volume mounts |
| volumes | list | `[]` | Additional volumes |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
