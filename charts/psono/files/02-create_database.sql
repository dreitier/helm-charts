CREATE DATABASE {{ .Values.server.db.name }} OWNER {{ .Values.server.db.user }};
\connect {{ .Values.server.db.name }};
CREATE EXTENSION pgcrypto;
CREATE EXTENSION ltree;
ALTER SCHEMA public OWNER TO {{ .Values.server.db.user }};