# Continuous Delivery on GCP with Cloud Deploy Canary Deployment - K8s Gateway API and Anthos Service Mesh

1. Get a GKE Cluster with Anthos Service Mesh enabled
2. Apply Gateway API CRDs:
```
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.6.1" | kubectl apply -f -; }
```
3. Run [setup.sh](setup.sh) if needed
4. Create the gateway with [gateway.yaml](gateway.yaml)
5. Create the Delivery Pipeline and its target with [delivery-pipeline.yaml](delivery-pipeline.yaml)
6. Build your image and create 1st release with [createrelease.sh](createrelease.sh)
7. Advance first-release to stable from GCP Console
8. Create your canary release:
```
gcloud deploy releases create canary-release --delivery-pipeline cd-on-gcp-pipeline --region europe-west1 --build-artifacts artifacts.json
```
9. Get your gateway IP and open a browser to it or do a `while true;do curl x.x.x.x;done``
10. Advance canary-release to stable from GCP Console
