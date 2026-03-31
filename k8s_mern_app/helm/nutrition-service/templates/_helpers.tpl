{{/*
Expand the name of the chart.
*/}}
{{- define "nutrition-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nutrition-service.labels" -}}
helm.sh/chart: {{ include "nutrition-service.name" . }}
{{ include "nutrition-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nutrition-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nutrition-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
