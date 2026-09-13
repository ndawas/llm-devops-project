# llm-stack Helm chart

Helm equivalent of the raw manifests in `k8s/base/`. Deploys Ollama and Open WebUI
with the same resources, probes, storage and network policy as the base manifests,
parametrized through `values.yaml`.

## Install

```bash
helm install llm-stack helm/llm-stack
```

## Upgrade

```bash
helm upgrade llm-stack helm/llm-stack
```

## Uninstall

```bash
helm uninstall llm-stack
```

## Key values

| Key | Description | Default |
|---|---|---|
| `namespace` | Target namespace | `llm-app` |
| `ollama.storage` | Ollama PVC size | `20Gi` |
| `webui.storage` | Open WebUI PVC size | `2Gi` |
| `webui.service.nodePort` | NodePort for Open WebUI | `30080` |
| `webui.autoscaling.enabled` | Toggle the HorizontalPodAutoscaler | `true` |
| `networkPolicy.enabled` | Toggle the NetworkPolicy restricting access to Ollama | `true` |
| `podDisruptionBudget.enabled` | Toggle the PodDisruptionBudgets | `true` |

See `values.yaml` for the full list (image repository/tag, resource requests/limits, probe timings).
