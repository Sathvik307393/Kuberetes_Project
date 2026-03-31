{{/*
Expand the name of the chart.
*/}}
{{- define "ai-agent-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ai-agent-service.labels" -}}
helm.sh/chart: {{ include "ai-agent-service.name" . }}
{{ include "ai-agent-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ai-agent-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ai-agent-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
