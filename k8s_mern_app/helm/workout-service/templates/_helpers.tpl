{{/*
Expand the name of the chart.
*/}}
{{- define "workout-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "workout-service.labels" -}}
helm.sh/chart: {{ include "workout-service.name" . }}
{{ include "workout-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "workout-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "workout-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
