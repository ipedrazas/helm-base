# Helm Chart Prototype

This is a prototype of a helm chart. It containes the following resources:

- Deployment
- Service
- Ingress
- Configmap
- RBAC:
    - ServiceAccount
    - Role
    - Rolebinding
- HorizontalPodAutoscaler
- PodDisruptionBudget

The following command will render all the Resources created by the release:

```
helm template ./myapp --name=x01
```

If you want to render just the `ConfigMap` use the following command:

```
helm template ./myapp --name=x01 -x templates/configmap.yaml --set configmap.enabled=true
```

The `Ingress` rule contains a flag to add the annotations that enable `CORS`.

There is an external file `entries.app` where you define the labels you want to include in all resources. CORS annotation are also defined there. It's important to note that when we do  `{{- include "labels.app" . }}` we're not including a file, we're including a template. These templates are defined in the `entries.app` file.