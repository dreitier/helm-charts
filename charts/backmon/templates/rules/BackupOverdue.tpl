{{/*
PrometheusRule that checks if a expected backup is missing
*/}}
{{- define "backmon.rules.backupOverdue" -}}
- alert: BackupOverdue
  expr: (backmon_backup_latest_file_creation_expected_at_timestamp_seconds - on (disk, dir, file) backmon_backup_latest_file_born_at_timestamp_seconds) / 3600 > {{ .Values.prometheusRules.backupOverdue.gracePeriod }}
  for: 1h
  labels:
    severity: warning
  annotations:
    summary: Backup is overdue!
    description: "Backup of file {{` {{ $labels.file }} `}} on disk {{` {{ $labels.disk }} `}} in directory {{` {{ $labels.dir }} `}} is overdue"
{{- end }}
