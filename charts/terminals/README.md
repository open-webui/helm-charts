# terminals

![Version: 0.5.0](https://img.shields.io/badge/Version-0.5.0-informational?style=flat-square) ![AppVersion: 0.0.3](https://img.shields.io/badge/AppVersion-0.0.3-informational?style=flat-square)

Terminals: Kubernetes operator and orchestrator for per-user Open Terminal instances

**Homepage:** <https://github.com/open-webui/open-terminal>

## Source Code

* <https://github.com/open-webui/helm-charts>
* <https://github.com/open-webui/open-terminal>
* <https://github.com/open-webui/terminals>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| apiKey | string | `""` | API key shared between orchestrator and spawned terminals |
| crd | object | `{"install":true}` | ------------------------------------------------------------------------ |
| crd.install | bool | `true` | Install the Terminal CRD (set false if already installed cluster-wide) |
| enabled | bool | `false` | Enable or disable the terminals subchart |
| existingSecret | string | `""` | Use an existing secret for the API key (key: api-key) |
| fullnameOverride | string | `""` | Override the full name of the chart |
| nameOverride | string | `""` | Override the name of the chart |
| networkPolicy | object | `{"enabled":false,"operator":{"egress":[]},"orchestrator":{"egress":[],"ingress":[]},"terminalPodSelector":{"app.kubernetes.io/component":"terminal"},"terminals":{"egress":[],"ingress":[]}}` | ------------------------------------------------------------------------ |
| networkPolicy.enabled | bool | `false` | Enable NetworkPolicy resources to restrict inter-pod traffic. When enabled, the orchestrator is reachable only from pods in the same namespace and terminal pods can communicate only with the orchestrator. |
| networkPolicy.operator.egress | list | `[]` | Custom egress rules for the operator pod |
| networkPolicy.orchestrator.egress | list | `[]` | Custom egress rules for the orchestrator pod |
| networkPolicy.orchestrator.ingress | list | `[]` | Custom ingress rules for the orchestrator pod |
| networkPolicy.terminalPodSelector | object | `{"app.kubernetes.io/component":"terminal"}` | Label selector matching terminal pods spawned by the operator. Must align with the labels the terminals-operator actually applies. |
| networkPolicy.terminals.egress | list | `[]` | Custom egress rules for terminal pods |
| networkPolicy.terminals.ingress | list | `[]` | Custom ingress rules for terminal pods |
| operator | object | `{"containerSecurityContext":{},"image":{"pullPolicy":"IfNotPresent","repository":"ghcr.io/open-webui/terminals-operator","tag":"latest"},"podSecurityContext":{},"replicaCount":1,"resources":{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"64Mi"}}}` | ------------------------------------------------------------------------ |
| operator.containerSecurityContext | object | `{}` | Configure container security context for the operator container |
| operator.podSecurityContext | object | `{}` | Configure pod security context for the operator pod ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| orchestrator | object | `{"backend":"kubernetes-operator","containerSecurityContext":{},"idleTimeoutMinutes":30,"image":{"pullPolicy":"IfNotPresent","repository":"ghcr.io/open-webui/terminals","tag":"latest"},"podSecurityContext":{},"replicaCount":1,"resources":{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"128Mi"}},"service":{"containerPort":8080,"port":8080,"type":"ClusterIP"},"terminalImage":"ghcr.io/open-webui/open-terminal:latest","terminalImagePullPolicy":"IfNotPresent"}` | ------------------------------------------------------------------------ |
| orchestrator.backend | string | `"kubernetes-operator"` | Backend type: kubernetes-operator, kubernetes, docker, local, static |
| orchestrator.containerSecurityContext | object | `{}` | Configure container security context for the orchestrator container |
| orchestrator.idleTimeoutMinutes | int | `30` | Idle timeout in minutes for spawned terminal pods (0 = disabled) |
| orchestrator.podSecurityContext | object | `{}` | Configure pod security context for the orchestrator pod ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| orchestrator.resources | object | `{"limits":{"cpu":"200m","memory":"256Mi"},"requests":{"cpu":"50m","memory":"128Mi"}}` | Resource requests/limits for the orchestrator pod itself |
| orchestrator.terminalImage | string | `"ghcr.io/open-webui/open-terminal:latest"` | Default image for spawned terminal pods |
| orchestrator.terminalImagePullPolicy | string | `"IfNotPresent"` | Pull policy for the terminal image inside spawned pods |
| terminalDefaults | object | `{"persistence":{"enabled":true,"size":"1Gi","storageClass":""}}` | ------------------------------------------------------------------------ Defaults applied to Terminal custom resources when fields are omitted. These values are baked into the CRD's openAPIV3Schema defaults. |
| terminalDefaults.persistence.enabled | bool | `true` | Enable a PVC for each terminal by default |
| terminalDefaults.persistence.size | string | `"1Gi"` | Default PVC size for each terminal |
| terminalDefaults.persistence.storageClass | string | `""` | StorageClass for the terminal PVC. Leave empty to use the cluster's default StorageClass (recommended for EKS/GKE/AKS). Set to a name (e.g. "gp3") to pin a class. Note: the empty value is omitted from the CRD entirely so PVCs fall through to the cluster default; setting it to "" via a Terminal CR is still possible and disables dynamic provisioning. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
