{{- define "labels.app" }}
    app: {{ include "myapp.name" . }}
    chart: {{ include "myapp.chart" . }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
{{- end }}


{{- define "cors.app" -}}
nginx.ingress.kubernetes.io/enable-cors: "true"
nginx.ingress.kubernetes.io/cors-allow-methods: "PUT, GET, POST, OPTIONS"
nginx.ingress.kubernetes.io/cors-allow-origin: "https://admin.example.com"
nginx.ingress.kubernetes.io/cors-allow-credentials: "true"
{{- end }}
