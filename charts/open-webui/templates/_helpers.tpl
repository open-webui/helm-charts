{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "open-webui.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Set the name of the Open WebUI resources
*/}}
{{- define "open-webui.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Set the name of the integrated Ollama resources
*/}}
{{- define "ollama.name" -}}
open-webui-ollama
{{- end -}}

{{/*
Set the name of the integrated Pipelines resources
*/}}
{{- define "pipelines.name" -}}
open-webui-pipelines
{{- end -}}

{{/*
Constructs a semicolon-separated string of Ollama API endpoint URLs from the ollamaUrls list 
defined in the values.yaml file
*/}}
{{- define "ollamaUrls" -}}
{{- if .Values.ollamaUrls }}
{{- join ";" .Values.ollamaUrls | trimSuffix "/" }}
{{- end }}
{{- end }}

{{/*
Generates the URL for accessing the Ollama service within the Kubernetes cluster when the 
ollama.enabled value is set to true, which means that the Ollama Helm chart is being installed 
as a dependency of the Open WebUI chart
*/}}
{{- define "ollamaLocalUrl" -}}
{{- if .Values.ollama.enabled -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $ollamaServicePort := .Values.ollama.service.port | toString }}
{{- printf "http://%s.%s.svc.%s:%s" (default .Values.ollama.name .Values.ollama.fullnameOverride) (.Release.Namespace) $clusterDomain $ollamaServicePort }}
{{- end }}
{{- end }}

{{/*
Constructs a string containing the URLs of the Ollama API endpoints that the Open WebUI 
application should use based on which values are set for Ollama/ whether the Ollama
subchart is in use
*/}}
{{- define "ollamaBaseUrls" -}}
{{- $ollamaLocalUrl := include "ollamaLocalUrl" . }}
{{- $ollamaUrls := include "ollamaUrls" . }}
{{- if and .Values.ollama.enabled .Values.ollamaUrls }}
{{- printf "%s;%s" $ollamaUrls $ollamaLocalUrl }}
{{- else if .Values.ollama.enabled }}
{{- printf "%s" $ollamaLocalUrl }}
{{- else if .Values.ollamaUrls }}
{{- printf "%s" $ollamaUrls }}
{{- end }}
{{- end }}

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
app.kubernetes.io/name: {{ include "open-webui.name" . }}
{{- end }}

{{/*
Create selector labels to include on all resources
*/}}
{{- define "base.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create selector labels to include on all Open WebUI resources
*/}}
{{- define "open-webui.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ .Chart.Name }}
{{- end }}

{{- define "open-webui.extraLabels" -}}
{{- with .Values.extraLabels }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Create labels to include on chart all Open WebUI resources
*/}}
{{- define "open-webui.labels" -}}
{{ include "base.labels" . }}
{{ include "open-webui.selectorLabels" . }}
{{- end }}

{{/*
Create selector labels to include on chart all Ollama resources
*/}}
{{- define "ollama.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ include "ollama.name" . }}
{{- end }}

{{/*
Create labels to include on chart all Ollama resources
*/}}
{{- define "ollama.labels" -}}
{{ include "base.labels" . }}
{{ include "ollama.selectorLabels" . }}
{{- end }}

{{/*
Create selector labels to include on chart all Pipelines resources
*/}}
{{- define "pipelines.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ include "pipelines.name" . }}
{{- end }}

{{/*
Create labels to include on chart all Pipelines resources
*/}}
{{- define "pipelines.labels" -}}
{{ include "base.labels" . }}
{{ include "pipelines.selectorLabels" . }}
{{- end }}

{{/*
Create the service endpoint to use for Pipelines if the subchart is used
*/}}
{{- define "pipelines.serviceEndpoint" -}}
{{- if .Values.pipelines.enabled -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $pipelinesServicePort := .Values.pipelines.service.port | toString }}
{{- printf "http://%s.%s.svc.%s:%s" (include "pipelines.name" .) (.Release.Namespace) $clusterDomain $pipelinesServicePort }}
{{- end }}
{{- end }}

{{/*
Create selector labels to include on chart all websocket resources
*/}}
{{- define "websocket.redis.selectorLabels" -}}
{{ include "base.selectorLabels" . }}
app.kubernetes.io/component: {{ .Values.websocket.redis.name }}
{{- end }}

{{/*
Create labels to include on chart all websocket resources
*/}}
{{- define "websocket.redis.labels" -}}
{{ include "base.labels" . }}
{{ include "websocket.redis.selectorLabels" . }}
{{- end }}

{{/*
Validate SSO ClientSecret to be set literally or via Secret
*/}}
{{- define "sso.validateClientSecret" -}}
{{- $provider := .provider }}
{{- $values := .values }}
{{- if and (empty (index $values $provider "clientSecret")) (empty (index $values $provider "clientExistingSecret")) }}
  {{- fail (printf "You must provide either .Values.sso.%s.clientSecret or .Values.sso.%s.clientExistingSecret" $provider $provider) }}
{{- end }}
{{- end }}

{{- /*
Fail template rendering if invalid log component
*/ -}}
{{- define "logging.isValidComponent" -}}
  {{- $component := . | lower -}}
  {{- $validComponents := dict
      "audio" true
      "comfyui" true
      "config" true
      "db" true
      "images" true
      "main" true
      "models" true
      "ollama" true
      "openai" true
      "rag" true
      "webhook" true
  -}}
  {{- hasKey $validComponents $component -}}
{{- end }}


{{- define "logging.assertValidComponent" -}}
  {{- $component := lower . -}}
  {{- $res := include "logging.isValidComponent" $component }}
  {{- if ne $res "true" }}
    {{- fail (printf "Invalid logging component name: '%s'. Valid names: audio, comfyui, config, db, images, main, models, ollama, openai, rag, webhook" $component) }}
  {{- end }}
{{- end }}

{{- /*
Fail template rendering if invalid log level
*/ -}}
{{- define "logging.assertValidLevel" -}}
  {{- $level := lower . }}
  {{- $validLevels := dict "notset" true "debug" true "info" true "warning" true "error" true "critical" true }}
  {{- if not (hasKey $validLevels $level) }}
    {{- fail (printf "Invalid log level: '%s'. Valid values are: notset, debug, info, warning, error, critical" $level) }}
  {{- end }}
{{- end }}

{{- /*
Render a logging env var for a component, validating value
*/ -}}
{{- define "logging.componentEnvVar" -}}
  {{- $name := .componentName }}
  {{- $level := .logLevel }}
{{- include "logging.assertValidComponent" $name -}}
{{- include "logging.assertValidLevel" $level }}
- name: {{ printf "%s_LOG_LEVEL" (upper $name) | quote }}
  value: {{ $level | quote | trim }}
{{- end }}

{{/*
Return true if the user has defined a custom WEBUI_URL in extraEnvVars.
Supports either a map or a list of maps.
Usage: {{ include "open-webui.hasCustomWebUIUrl" . }}
*/}}
{{- define "open-webui.hasCustomWebUIUrl" -}}
  {{- $found := false -}}
  {{- $extra := .Values.extraEnvVars -}}
  {{- if kindIs "map" $extra }}
    {{- if hasKey $extra "WEBUI_URL" -}}
      {{- $found = true -}}
    {{- end -}}
  {{- else if kindIs "slice" $extra }}
    {{- range $extra }}
      {{- if eq .name "WEBUI_URL" }}
        {{- $found = true -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
  {{- if $found }}true{{- end -}}
{{- end -}}

{{- /*
Constructs a string containing the URLs of the Open WebUI based on the ingress configuration
used to populate the variable WEBUI_URL  
*/ -}}
{{- define "open-webui.url" -}}
  {{- $proto := "http" -}}
  {{- if .Values.ingress.tls }}
    {{- $proto = "https" -}}
  {{- end }}
  {{- printf "%s://%s" $proto .Values.ingress.host }}
{{- end }}

{{/*
Convert a map of environment variables to Kubernetes env var format
*/}}
{{- define "open-webui.env" -}}
{{- if kindIs "map" . }}
  {{- range $key, $val := . }}
- name: {{ $key }}
    {{- if kindIs "map" $val }}
      {{- toYaml $val | nindent 2 }}
    {{- else }}
  value: {{ $val | quote }}
    {{- end }}
  {{- end }}
{{- else }}
  {{- toYaml . }}
{{- end }}
{{- end }}

{{- /*
Define a docker tag that should use for the deployment
*/ -}}
{{- define "open-webui.tag" -}}
{{- $image := .Values.image }}
{{- if $image.tag }}
{{- /* If user provided an explicit image.tag, use it */ -}}
{{- $image.tag -}}
{{- else if $image.useSlim }}
{{- /* If useSlim is true and no explicit tag, use Chart.AppVersion-slim */ -}}
{{- printf "%s-slim" .Chart.AppVersion -}}
{{- else }}
{{- /* Fallback to Chart.AppVersion */ -}}
{{- .Chart.AppVersion -}}
{{- end }}
{{- end }}
