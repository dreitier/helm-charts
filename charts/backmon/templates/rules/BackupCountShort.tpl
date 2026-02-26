{{/*
PrometheusRule that checks if the amount of backups present is less than the expected amount by a certain threshold
*/}}
{{- define "backmon.rules.backupCountShort" -}}
- alert: BackupCountShort
  expr: sum by (disk, dir, file) (backmon_backup_file_count - on(disk, dir, file) group_right(group) (backmon_backup_file_count_max * {{ .Values.prometheusRules.backupCountShort.thresholdPercentage }} )) < 0
  for: 1h
  labels:
    severity: warning
  annotations:
    summary: Backup count is too low!
    description: "Number of backups of file {{` {{ $labels.file }} `}} on disk {{` {{ $labels.disk }} `}} in directory {{` {{ $labels.dir }} `}} is lower than the expected number"
{{- end }}
