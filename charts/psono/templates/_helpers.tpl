{{/*
Expand the name of the chart.
*/}}
{{- define "psono.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "psono.server.fullname" -}}
{{- if .Values.server.fullnameOverride -}}
{{- .Values.server.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.server.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.server.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "psono.client.fullname" -}}
{{- if .Values.client.fullnameOverride -}}
{{- .Values.client.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.client.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.client.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "psono.fileserver.fullname" -}}
{{- if .Values.fileserver.fullnameOverride -}}
{{- .Values.fileserver.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Values.fileserver.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.fileserver.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the server component
*/}}
{{- define "psono.serviceAccountName.server" -}}
{{- if .Values.serviceAccounts.server.create -}}
    {{ default (include "psono.server.fullname" .) .Values.serviceAccounts.server.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.server.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use for the fileserver component
*/}}
{{- define "psono.serviceAccountName.fileserver" -}}
{{- if .Values.serviceAccounts.fileserver.create -}}
    {{ default (include "psono.fileserver.fullname" .) .Values.serviceAccounts.fileserver.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccounts.fileserver.name }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "psono.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ingress.apiVersion" -}}
{{- if semverCompare ">=1.19.0" .Capabilities.KubeVersion.GitVersion }}
{{- print "networking.k8s.io/v1" -}}
{{- else if semverCompare ">=v1.14.0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "networking.k8s.io/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Create unified labels for psono components
*/}}
{{- define "psono.common.matchLabels" -}}
app: {{ template "psono.name" . }}
release: {{ .Release.Name }}
{{- end }}

{{- define "psono.common.metaLabels" -}}
chart: {{ template "psono.chart" . }}
heritage: {{ .Release.Service }}
{{- end -}}

{{- define "psono.server.labels" -}}
{{ include "psono.server.matchLabels" . }}
{{ include "psono.common.metaLabels" . }}
{{- end -}}

{{- define "psono.server.matchLabels" -}}
component: {{ .Values.server.name }}
{{ include "psono.common.matchLabels" . }}
{{- end -}}

{{- define "psono.client.labels" -}}
{{ include "psono.client.matchLabels" . }}
{{ include "psono.common.metaLabels" . }}
{{- end -}}

{{- define "psono.client.matchLabels" -}}
component: {{ .Values.client.name }}
{{ include "psono.common.matchLabels" . }}
{{- end -}}

{{- define "psono.fileserver.labels" -}}
{{ include "psono.fileserver.matchLabels" . }}
{{ include "psono.common.metaLabels" . }}
{{- end -}}

{{- define "psono.fileserver.matchLabels" -}}
component: {{ .Values.fileserver.name }}
{{ include "psono.common.matchLabels" . }}
{{- end -}}

{{/*
Create server external URL
*/}}
{{- define "psono.server.externalUrl" -}}
{{- or .Values.server.ingress.tls .Values.server.forceTls | ternary "https" "http" }}://{{ .Values.server.host -}}{{ .Values.server.path -}}
{{- end -}}

{{/*
Create client external URL
*/}}
{{- define "psono.client.externalUrl" -}}
{{- or .Values.server.ingress.tls .Values.server.forceTls | ternary "https" "http" }}://{{ .Values.server.host -}}
{{- end -}}

{{/*
Create fileserver external URL
*/}}
{{- define "psono.fileserver.externalUrl" -}}
{{- or .Values.fileserver.ingress.tls .Values.fileserver.forceTls | ternary "https" "http" }}://{{ .Values.fileserver.host -}}{{ .Values.fileserver.path -}}
{{- end -}}

{{/*
Define the psono.namespace template if set with forceNamespace or .Release.Namespace is set
*/}}
{{- define "psono.namespace" -}}
{{- if .Values.forceNamespace -}}
{{ printf "namespace: %s" .Values.forceNamespace }}
{{- else -}}
{{ printf "namespace: %s" .Release.Namespace }}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL host name depending on whether an external database is used or not
*/}}
{{- define "psono.db.host" -}}
{{- if .Values.server.db.bundled -}}
{{- printf "%s-%s" .Release.Name "postgresql" -}}
{{- else -}}
{{- .Values.server.db.host -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL port depending on whether an external database is used or not
*/}}
{{- define "psono.db.port" -}}
{{- if .Values.server.db.bundled -}}
{{- .Values.postgresql.primary.service.ports.postgresql -}}
{{- else -}}
{{- .Values.server.db.port -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL SSL mode
*/}}
{{- define "psono.db.ssl-mode" -}}
{{- if .Values.server.db.ssl -}}
require
{{- else -}}
disable
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL container image/tag depending on whether postgres chart is enabled or not
*/}}
{{- define "postgres.image" -}}
{{- if .Values.server.db.bundled -}}
{{- printf "%s:%s" .Values.postgresql.image.repository .Values.postgresql.image.tag -}}
{{- else -}}
{{- printf "%s:%s" "bitnami/postgresql" "latest" -}}
{{- end -}}
{{- end -}}

{{/*
Create PostgreSQL URI to be used witht he postgres metrics exporter
*/}}
{{- define "psono.db.uri" -}}
{{- $dbHost := include "psono.db.host" . -}}
{{- $dbPort := include "psono.db.host" . -}}
{{- $sslMode := include "psono.db.ssl-mode" . -}}
{{- printf "%s:%s/%s?sslmode=%s" $dbHost $dbPort .Values.server.db.name $sslMode -}}
{{- end -}}

{{/*
Create AUTHENTICATION_METHODS based on settings
*/}}
{{- define "psono.server.auth.methods" -}}
{{- $ldap := .Values.server.ldap.enabled | ternary ",'LDAP'" ""  -}}
{{- $saml := .Values.server.saml.enabled | ternary ",'SAML'" ""  -}}
{{- $oidc := .Values.server.oidc.enabled | ternary ",'OIDC'" ""  -}}
{{- printf "[ 'AUTHKEY'%s%s%s ]" $ldap $saml $oidc -}}
{{- end -}}

{{/*
Create AUTHENTICATION_METHODS based on settings
*/}}
{{- define "psono.client.auth.methods" -}}
{{- $ldap := .Values.server.ldap.enabled | ternary ",\"LDAP\"" ""  -}}
{{- $saml := .Values.server.saml.enabled | ternary ",\"SAML\"" ""  -}}
{{- $oidc := .Values.server.oidc.enabled | ternary ",\"OIDC\"" ""  -}}
{{- printf "[ \"AUTHKEY\"%s%s%s ]" $ldap $saml $oidc -}}
{{- end -}}