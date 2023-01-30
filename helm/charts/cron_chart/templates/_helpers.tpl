{{/*
Expand the name of the chart.
*/}}
{{- define "helm_chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "helm_chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "helm_chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "helm_chart.labels" -}}
helm.sh/chart: {{ include "helm_chart.chart" . }}
{{ include "helm_chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "helm_chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "helm_chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "helm_chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "helm_chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Validate the secret, checking if base64 encoded
*/}}    
{{- define "validateSecret" -}}
{{ $secret := regexReplaceAllLiteral "\u0026#x3D;" (regexReplaceAllLiteral "\u0026#x2F;" . "/") "=" }}
{{- if (b64dec $secret | hasPrefix "illegal base64") -}}
{{ fail "Please b64 encode your secrets!" }}
{{- else }}
{{- $secret }}
{{- end }}
{{- end }}
