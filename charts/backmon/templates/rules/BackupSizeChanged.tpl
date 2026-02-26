{{/*
PrometheusRule that checks if the size of backups changes by more than a certain threshold
*/}}
{{- define "backmon.rules.backupSizeChanged" -}}
- alert: BackupSizeChanged
  expr: abs (sum by (disk, dir, file) ((backmon_backup_latest_size_bytes - backmon_backup_latest_size_bytes offset 1h) / backmon_backup_latest_size_bytes offset 1h)) > {{ .Values.prometheusRules.backupSizeChanged.thresholdPercentage }}
  for: 1h
  labels:
    severity: warning
  annotations:
    summary: Backup size changed!
    description: "Size of backups of file {{` {{ $labels.file }} `}} on disk {{` {{ $labels.disk }} `}} in directory {{` {{ $labels.dir }} `}} changed by a large amount"
{{- end }}
