{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "mcpo.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Set the name of the mcpo resources
*/}}
{{- define "mcpo.name" -}}
{{- default .Release.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Create the chart name and version for the chart label
*/}}
{{- define "chart.name" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the base labels to include on chart resources
*/}}
{{- define "base.labels" -}}
helm.sh/chart: {{ include "chart.name" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Create selector labels to include on all resources
*/}}
{{- define "base.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create selector labels to include on all mcpo resources
*/}}
{{- define "mcpo.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ .Chart.Name }}
{{- end }}

{{/*
Create labels to include on all mcpo resources
*/}}
{{- define "mcpo.labels" -}}
{{ include "base.labels" . }}
{{ include "mcpo.selectorLabels" . }}
{{- end }}

{{/*
Create the default port to use on the service if none is defined in values
*/}}
{{- define "mcpo.servicePort" -}}
{{- .Values.service.port | default 9099 }}
{{- end }}
