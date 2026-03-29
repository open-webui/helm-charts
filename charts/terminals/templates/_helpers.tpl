{{/*
Namespace helper
*/}}
{{- define "terminals.namespace" -}}
{{- .Release.Namespace -}}
{{- end -}}

{{/*
Chart name
*/}}
{{- define "terminals.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Fullname helper
*/}}
{{- define "terminals.fullname" -}}
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
Common labels
*/}}
{{- define "terminals.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: open-terminal
{{- end -}}

{{/*
Operator labels
*/}}
{{- define "terminals.operator.labels" -}}
{{ include "terminals.labels" . }}
app.kubernetes.io/name: {{ include "terminals.fullname" . }}-operator
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: operator
{{- end -}}

{{/*
Operator selector labels
*/}}
{{- define "terminals.operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "terminals.fullname" . }}-operator
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Orchestrator labels
*/}}
{{- define "terminals.orchestrator.labels" -}}
{{ include "terminals.labels" . }}
app.kubernetes.io/name: {{ include "terminals.fullname" . }}-orchestrator
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: orchestrator
{{- end -}}

{{/*
Orchestrator selector labels
*/}}
{{- define "terminals.orchestrator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "terminals.fullname" . }}-orchestrator
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Service account name
*/}}
{{- define "terminals.serviceAccountName" -}}
{{ include "terminals.fullname" . }}-operator
{{- end -}}

{{/*
API key secret name
*/}}
{{- define "terminals.secretName" -}}
{{- if .Values.existingSecret -}}
{{- .Values.existingSecret -}}
{{- else -}}
{{ include "terminals.fullname" . }}-api-key
{{- end -}}
{{- end -}}
