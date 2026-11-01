#!/usr/bin/env bash
set -euo pipefail

CHART_VERSION="92.17.0"
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

echo "Adding Prometheus Helm repository..."

helm repo add prometheus-community \
  https://prometheus-community.github.io/helm-charts \
  --force-update

helm repo update prometheus-community

echo "Installing kube-prometheus-stack..."

helm upgrade --install monitoring \
  prometheus-community/kube-prometheus-stack \
  --version "$CHART_VERSION" \
  --namespace monitoring \
  --create-namespace \
  --values "$PROJECT_DIR/monitoring/values.yaml" \
  --wait \
  --timeout 15m

echo "Monitoring installation completed."

kubectl get pods -n monitoring
