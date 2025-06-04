#!/bin/bash
set -x

kind create cluster --config ./cluster/kind.yml 

kubectl cluster-info --context kind-kind