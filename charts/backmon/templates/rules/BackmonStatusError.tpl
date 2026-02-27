{{/*
PrometheusRule that checks if the size of backups changes by more than a certain threshold
*/}}
{{- define "backmon.rules.backupDefinitionError" -}}
- alert: BackmonStatusError
  expr: backmon_definition_status != 1
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Backmon can't access the definitions file"
    description: "Backmon  reports an error on disk {{` {{ $labels.disk }} `}}"
{{- end }}
