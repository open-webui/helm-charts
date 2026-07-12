{{/*
Chart name
*/}}
{{- define "oikb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Namespace (overridable for combined charts)
*/}}
{{- define "oikb.namespace" -}}
{{- if .Values.namespaceOverride -}}
{{- .Values.namespaceOverride -}}
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
Fully qualified name
*/}}
{{- define "oikb.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Chart label value
*/}}
{{- define "oikb.chartName" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "oikb.labels" -}}
helm.sh/chart: {{ include "oikb.chartName" . }}
{{ include "oikb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: oikb
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "oikb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "oikb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
ServiceAccount name
*/}}
{{- define "oikb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "oikb.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Container image ref (tag falls back to appVersion)
*/}}
{{- define "oikb.image" -}}
{{- printf "%s:%s" .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}

{{/*
Name of the Secret holding the rendered .oikb.yaml config
*/}}
{{- define "oikb.configSecretName" -}}
{{- if .Values.existingConfigSecret -}}
{{- .Values.existingConfigSecret -}}
{{- else -}}
{{- printf "%s-config" (include "oikb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Name of the Secret holding the OIKB daemon key (OIKB_API_KEY)
*/}}
{{- define "oikb.envSecretName" -}}
{{- printf "%s-api-key" (include "oikb.fullname" .) -}}
{{- end -}}

{{/*
Name of the Secret holding the Open WebUI API key (OPEN_WEBUI_API_KEY).
When existingSecret is set, that Secret is used verbatim. Otherwise a chart/Job
owned Secret named "<fullname>-owui-key" is used.
*/}}
{{- define "oikb.owuiKeySecretName" -}}
{{- if .Values.existingSecret -}}
{{- .Values.existingSecret -}}
{{- else -}}
{{- printf "%s-owui-key" (include "oikb.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
True when the automated bootstrap Job should manage the OWUI key
(bootstrap enabled AND no explicit key provided).
*/}}
{{- define "oikb.bootstrapActive" -}}
{{- if and .Values.bootstrapApiKey.enabled (not .Values.openWebuiApiKey) (not .Values.existingSecret) -}}
true
{{- end -}}
{{- end -}}

{{/*
Open WebUI base URL. Uses the explicit value when set; otherwise derives the
in-cluster parent service URL from the shared release name (bundled scenario).
*/}}
{{- define "oikb.openWebuiUrl" -}}
{{- if .Values.openWebuiUrl -}}
{{- .Values.openWebuiUrl -}}
{{- else -}}
{{- printf "http://%s-open-webui.%s.svc.%s" .Release.Name (include "oikb.namespace" .) .Values.clusterDomain -}}
{{- end -}}
{{- end -}}

{{/*
Container environment shared by the daemon and cronjob workloads
*/}}
{{- define "oikb.containerEnv" -}}
- name: OPEN_WEBUI_URL
  value: {{ include "oikb.openWebuiUrl" . | quote }}
- name: OPEN_WEBUI_API_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "oikb.owuiKeySecretName" . }}
      key: {{ .Values.existingSecretKey }}
{{- if or (eq .Values.mode "daemon") .Values.apiKey }}
- name: OIKB_API_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "oikb.envSecretName" . }}
      key: oikb-api-key
{{- end }}
{{- if .Values.logFormat }}
- name: LOG_FORMAT
  value: {{ .Values.logFormat | quote }}
{{- end }}
{{- with .Values.extraEnvVars }}
{{- toYaml . }}
{{- end }}
{{- end -}}

{{/*
Config volume mount shared by both workloads
*/}}
{{- define "oikb.configVolumeMount" -}}
- name: config
  mountPath: {{ .Values.configMountPath }}
  subPath: .oikb.yaml
  readOnly: true
{{- with .Values.volumeMounts }}
{{- toYaml . }}
{{- end }}
{{- end -}}

{{/*
Config volume shared by both workloads
*/}}
{{- define "oikb.configVolume" -}}
- name: config
  secret:
    secretName: {{ include "oikb.configSecretName" . }}
    items:
      - key: {{ .Values.existingConfigSecretKey }}
        path: .oikb.yaml
{{- with .Values.volumes }}
{{- toYaml . }}
{{- end }}
{{- end -}}
