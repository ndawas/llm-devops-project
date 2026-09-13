# LLM DevOps Project — Ollama + Open WebUI

Self-hosted LLM chat platform (Ollama + Open WebUI), deployed two ways: **Docker Compose** for local development and **Kubernetes (Minikube)** for a production-like setup, with a full observability stack and CI/CD on top.

Three models are served: `llama3.2:3b`, `mistral:7b`, `deepseek-r1:8b`.

## Architecture

```
                 ┌─────────────────────────────┐
  User ──────────▶  webui-ingress / NodePort    │
                 │      (webui-service)         │
                 │           │                  │
                 │      open-webui pod          │
                 │      (1-3 replicas, HPA)      │
                 │           │                  │
                 │   ollama-service (ClusterIP) │
                 │      NetworkPolicy-gated      │
                 │           │                  │
                 │        ollama pod             │
                 │   /root/.ollama → ollama-pvc  │
                 └─────────────────────────────┘
              namespace: llm-app (Kubernetes)
```

Open WebUI never talks to Ollama directly by IP — it resolves `ollama-service` through cluster DNS, and a `NetworkPolicy` only allows traffic from pods labeled `app: open-webui` on port `11434`.

## Quick start

### Docker Compose (local dev)

```bash
cp .env.example .env   # set OLLAMA_PORT / WEBUI_PORT
docker compose up -d
docker exec -it ollama ollama pull llama3.2:3b
docker exec -it ollama ollama pull mistral:7b
docker exec -it ollama ollama pull deepseek-r1:8b
```

Open WebUI: `http://localhost:${WEBUI_PORT}`

### Kubernetes (Minikube)

```bash
minikube start --memory=6500 --cpus=6
minikube addons enable metrics-server
minikube addons enable ingress

kubectl apply -k k8s/base

kubectl exec -n llm-app deploy/ollama -- ollama pull llama3.2:3b
kubectl exec -n llm-app deploy/ollama -- ollama pull mistral:7b
kubectl exec -n llm-app deploy/ollama -- ollama pull deepseek-r1:8b

minikube service webui-service -n llm-app
```

Environment-specific variants live under `k8s/overlays/dev` and `k8s/overlays/prod` (Kustomize patches on resource limits and replica count).

### Kubernetes via Helm (alternative to `kubectl apply -k`)

```bash
helm install llm-stack helm/llm-stack
```

See `helm/llm-stack/README.md` for the full list of overridable values.

## Kubernetes resources (`k8s/base`)

| Resource | Name | Role |
|---|---|---|
| Namespace | `llm-app` | Isolates the project from the rest of the cluster |
| ConfigMap ×2 | `ollama-config`, `webui-config` | `OLLAMA_HOST`, `OLLAMA_BASE_URL` |
| Secret ×1 | `webui-secret` | Shared session-signing key across `open-webui` replicas |
| PersistentVolumeClaim ×2 | `ollama-pvc` (20Gi), `webui-pvc` (2Gi) | Model weights / user data survive pod restarts |
| Deployment ×2 | `ollama`, `open-webui` | Pod lifecycle, probes, resource requests/limits |
| Service ×2 | `ollama-service` (ClusterIP), `webui-service` (NodePort 30080) | Internal vs. external access |
| Ingress ×1 | `webui-ingress` | nginx ingress route to `webui-service` (host `llm-app.local`) |
| NetworkPolicy ×1 | `ollama-network-policy` | Only `open-webui` pods may reach Ollama on port 11434 |
| PodDisruptionBudget ×2 | `ollama-pdb`, `webui-pdb` | `minAvailable: 1` during node maintenance |
| HorizontalPodAutoscaler ×1 | `webui-hpa` | Scales `open-webui` 1→3 on CPU 70% / memory 80% |

## Bonus features

| Feature | Where |
|---|---|
| NetworkPolicy | `k8s/base/09-network-policy.yaml` |
| PodDisruptionBudget | `k8s/base/10-pdb.yaml` |
| HorizontalPodAutoscaler | `k8s/base/11-hpa.yaml` |
| Kustomize overlays (dev/prod) | `k8s/overlays/` |
| Helm chart | `helm/llm-stack/` |
| CI/CD deploy pipeline | `.github/workflows/deploy.yml` (gated by a repo variable + `KUBECONFIG_B64` secret; inert until a remote cluster is wired up) |
| Prometheus + Grafana monitoring | `k8s/monitoring/` |

### Monitoring

```bash
kubectl apply -k k8s/monitoring
minikube addons enable metrics-server   # required for the HPA panel

minikube service prometheus -n monitoring   # Status → Targets
minikube service grafana -n monitoring      # admin / see k8s/monitoring/11-grafana-secret.yaml
```

Grafana ships with a provisioned datasource and a dashboard (**LLM App Overview**): CPU/memory per pod, restart counts, HPA current/desired replicas, node CPU and memory.

## CI

`.github/workflows/validate-k8s.yml` runs on every push touching `k8s/**` or `helm/**`:
- `kustomize build` on `k8s/base` and both overlays
- `kubeconform -strict` against the rendered manifests
- `helm lint` + `kubeconform` on the rendered Helm chart
- `yamllint` on `k8s/`

## Repository layout

```
docker-compose.yaml       # local dev stack
k8s/base/                 # core Kubernetes manifests
k8s/overlays/{dev,prod}/  # Kustomize patches per environment
k8s/monitoring/           # Prometheus + Grafana + kube-state-metrics + node-exporter
helm/llm-stack/           # Helm chart equivalent of k8s/base
.github/workflows/        # CI (validation) + CD (deploy, gated)
screenshots/              # deliverable screenshots
rapport.pdf               # technical report (5 required topics + bonus)
```

## Report

`rapport.pdf` covers: the role of each Kubernetes resource, service-to-service communication, why PersistentVolumeClaims are required, the role of each probe type, Docker Compose vs. Kubernetes, and the seven bonus features implemented above.

---

**Author:** Abdoulaye Sy Ndaw ([ndawas@ept.edu.sn](mailto:ndawas@ept.edu.sn))
**École Polytechnique de Thiès (EPT)** — Cloud & DevOps Bootcamp, 2026
**Instructor:** Ibrahima MBENGUE
