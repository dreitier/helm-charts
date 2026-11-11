{{/*
PrometheusRule that fires if backmon reports an error for a disk (definitions file missing or invalid, files not listable).
backmon 5.0.0 changed backmon_definition_status to the documented semantics: 0 = ok, 1 = error.
Before, it reported 1 = ok, 0 = definitions missing. The expression follows the configured image tag.
*/}}
{{- define "backmon.rules.backupDefinitionError" -}}
{{- $tag := toString (.Values.image.tag | default .Chart.AppVersion) | splitList "@" | first -}}
{{- $legacyStatus := and (regexMatch "^v?[0-9]+\\.[0-9]+\\.[0-9]+" $tag) (semverCompare "<5.0.0-0" $tag) -}}
- alert: BackmonStatusError
  expr: backmon_definition_status {{ if $legacyStatus }}!= 1{{ else }}> 0{{ end }}
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Backmon can't access the definitions file"
    description: "Backmon  reports an error on disk {{` {{ $labels.disk }} `}}"
{{- end }}
