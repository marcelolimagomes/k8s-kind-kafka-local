#!/bin/bash
set -x

kind create cluster --config kind.yml 

kubectl cluster-info --context kind-kind