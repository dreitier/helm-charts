{{/*
PrometheusRule that checks if a backup just disappeared from the monitoring
*/}}
{{- define "backmon.rules.backupMissing" -}}
- alert: BackupMissing
  expr: sum by (disk, dir, file) (-(backmon_backup_file_count_max unless on(disk, dir, file) backmon_backup_file_count))
  for: 1h
  labels:
    severity: warning
  annotations:
    summary: Backup is missing!
    description: "Backup of file {{` {{ $labels.file }} `}} on disk {{` {{ $labels.disk }} `}} in directory {{` {{ $labels.dir }} `}} is missing"
{{- end }}
