#!/usr/bin/env bash
set -euo pipefail

# Argo CD installation configuration
ARGOCD_CHART_VERSION="10.11.6"
EXPECTED_CONTEXT="arn:aws:eks:eu-north-1:069129260880:cluster/k8s-demo-eks"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Checking Kubernetes context..."

CURRENT_CONTEXT="$(kubectl config current-context)"

if [[ "$CURRENT_CONTEXT" != "$EXPECTED_CONTEXT" ]]; then
  echo "ERROR: Unexpected Kubernetes context!"
  echo "Expected: $EXPECTED_CONTEXT"
  echo "Current:  $CURRENT_CONTEXT"
  exit 1
fi

echo "Kubernetes context verified: $CURRENT_CONTEXT"

echo "Adding Argo CD Helm repository..."

helm repo add argo https://argoproj.github.io/argo-helm \
  --force-update

helm repo update argo

echo "Installing Argo CD Helm chart version $ARGOCD_CHART_VERSION..."

helm upgrade --install argocd argo/argo-cd \
  --version "$ARGOCD_CHART_VERSION" \
  --namespace argocd \
  --create-namespace \
  --values "$PROJECT_DIR/argocd/values.yaml" \
  --wait \
  --timeout 10m

echo "Argo CD installation completed."

kubectl get pods -n argocd
