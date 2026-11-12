{{/*
PrometheusRule that checks if old backups are still purged.
Fires if the oldest backup is older than the configured maximum age, e.g. because backmon can't delete files anymore.
Unlike BackupCountExceeding it doesn't depend on the number of backups, so additional backups (e.g. created before each deployment) don't trigger it.
Only useful for files with `purge: true`: set maxAgeHours to the retention-age of the backup definitions plus a grace period.
*/}}
{{- define "backmon.rules.backupPurgeStalled" -}}
- alert: BackupPurgeStalled
  expr: max by (disk, dir, file) (backmon_backup_file_age_max_seconds) / 3600 > {{ .Values.prometheusRules.backupPurgeStalled.maxAgeHours }}
  for: {{ .Values.prometheusRules.backupPurgeStalled.for }}
  labels:
    severity: warning
  annotations:
    summary: Backups are not purged anymore!
    description: "Oldest backup of file {{` {{ $labels.file }} `}} on disk {{` {{ $labels.disk }} `}} in directory {{` {{ $labels.dir }} `}} is older than {{ .Values.prometheusRules.backupPurgeStalled.maxAgeHours }} hours"
{{- end }}
