# Continuous Delivery on GCP with Cloud Deploy Canary Deployment - K8s Gateway APIs and Anthos Service Mesh

## Simple Manual Tutorial

1. Create a GKE Cluster with Anthos Service Mesh enabled and and Artifact Registry Docker repo
2. Apply K8s Gateway API CRDs:
```
kubectl get crd gateways.gateway.networking.k8s.io &> /dev/null || \
  { kubectl kustomize "github.com/kubernetes-sigs/gateway-api/config/crd?ref=v0.6.1" | kubectl apply -f -; }
```
3. Run [setup.sh](setup.sh) and answer questions with your values
4. Create the gateway with [gateway.yaml](gateway.yaml)
5. Create the Delivery Pipeline and its target with [delivery-pipeline.yaml](delivery-pipeline.yaml) (replace `yourregion` and `yourproject` with your values):
```
gcloud deploy apply --file=delivery-pipeline.yaml --region=yourregion --project=yourproject
```
6. Build your image and create 1st release with [createrelease.sh](createrelease.sh)
7. Advance first-release to stable from GCP Console
8. Change the text in line 25 of [app.go](cdongcp-app/app.go) file to “`cd-on-gcp app updated in target: …`”
9. Rebuild the container image with your new code (replace `yourrepo` with your Artifact Registry repo):
```
skaffold build --default-repo=yourrepo --file-output=artifacts.json
```
10. Create your canary release (replace `yourregion` with the region you created your delivery pipeline into):
```
gcloud deploy releases create canary-release --delivery-pipeline cd-on-gcp-pipeline --region yourregion --build-artifacts artifacts.json
```
11. Get your gateway IP and open a browser to it or do a `"while true;do curl x.x.x.x;done"`, you should see responses both from the old and new (canary) version
12. Advance canary-release to stable from GCP Console, the curl command above should show only responses from the new version
