#!/bin/bash
# Deploys 4 replicas which can only run on the "2az" NodePool (pool label) with a zone
# topology spread constraint. Without the Karpenter fix (kubernetes-sigs/karpenter#3181),
# the third zone which only the "3az" NodePool can produce is counted as a topology domain,
# so only 2 of 4 replicas (one per reachable zone) schedule.

cd "$(dirname "$0")"

kubectl apply -f deployment.yaml

echo "waiting 120s for karpenter to provision nodes..."
sleep 120

echo ""
echo "== pods =="
kubectl get pods -l app=2az-app -o wide

echo ""
echo "== nodeclaims =="
kubectl get nodeclaims -o wide

echo ""
echo "== karpenter scheduling events =="
kubectl get events --field-selector reason=FailedScheduling --sort-by=.lastTimestamp | tail -5

echo ""
running=$(kubectl get pods -l app=2az-app --field-selector=status.phase=Running --no-headers | wc -l | tr -d ' ')
pending=$(kubectl get pods -l app=2az-app --field-selector=status.phase=Pending --no-headers | wc -l | tr -d ' ')
echo "Running pods: ${running} / Pending pods: ${pending}"
