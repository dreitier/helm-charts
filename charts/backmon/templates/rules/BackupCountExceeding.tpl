{{/*
PrometheusRule that checks if the amount of backups present exceeds the expected amount by a certain threshold
*/}}
{{- define "backmon.rules.backupCountExceeding" -}}
- alert: BackupCountExceeding
  expr: sum by (disk, dir, file) (backmon_backup_file_count - on(disk, dir, file) group_right(group) backmon_backup_file_count_max) > (sum by (disk, dir, file) (backmon_backup_file_count_max) * {{ .Values.prometheusRules.backupCountExceeding.thresholdPercentage }})
  for: 1h
  labels:
    severity: warning
  annotations:
    summary: Backup count exceeding expected number!
    description: "Number of backups of file {{` {{ $labels.file }} `}} on disk {{` {{ $labels.disk }} `}} in directory {{` {{ $labels.dir }} `}} is exceeding the expected number"
{{- end }}
