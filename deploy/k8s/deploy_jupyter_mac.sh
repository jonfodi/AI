#!/bin/bash

# Function to check if a command exists
command_exists() {
    type "$1" &>/dev/null;
}

# Start Minikube if it is not already running
start_minikube() {
    if minikube status | grep -q 'host: Running'; then
        echo -e "\033[0;32mMinikube is already running.\033[0m"
    else
        echo -e "\033[0;32mStarting Minikube...\033[0m"
        minikube start
    fi
}

# Enable Ingress
enable_ingress() {
    if minikube addons list | grep -q 'ingress: enabled'; then
        echo -e "\033[0;32mIngress is already enabled.\033[0m"
    else
        echo -e "\033[0;32mEnabling ingress...\033[0m"
        minikube addons enable ingress
    fi
}

# Deploy or confirm deployment of Jupyter Notebook
deploy_jupyter() {
    if kubectl get service -n jupyter-notebook | grep -q 'jupyter-notebook'; then
        echo -e "\033[0;32mJupyter Notebook is already deployed and service is running.\033[0m"
    else
        echo -e "\033[0;32mDeploying Jupyter Notebook and creating service...\033[0m"
        kubectl apply -f jupyter-deployment.yaml -n jupyter-notebook
        kubectl apply -f jupyter-service.yaml -n jupyter-notebook
        kubectl apply -f jupyter-ingress.yaml -n jupyter-notebook
    fi
}

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#               (_)
#    _ __ ___   __ _ _ _ __
#   | '_ ` _ \ / _` | | '_ \
#   | | | | | | (_| | | | | |
#   |_| |_| |_|\__,_|_|_| |_|
#
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Check if Minikube is installed
if command_exists minikube; then
    echo -e "\033[0;32mMinikube is installed.\033[0m"
    start_minikube
    enable_ingress

    # Check if the Kubernetes namespace exists
    if kubectl get namespace | grep -q 'jupyter-notebook'; then
        echo -e "\033[0;32mNamespace 'jupyter-notebook' already exists.\033[0m"
    else
        echo -e "\033[0;32mCreating namespace 'jupyter-notebook'...\033[0m"
        kubectl create namespace jupyter-notebook
    fi

    deploy_jupyter

    # Wait for Jupyter Notebook to be ready
    echo -e "\033[0;32mWaiting for Jupyter Notebook to be ready...\033[0m"
    kubectl wait --for=condition=ready pod -l app=jupyter-notebook -n jupyter-notebook --timeout=300s

    # Get the URL to access Jupyter Notebook using the Minikube service command
    echo -e "\033[0;32mJupyter Notebook is available at the URL below\033[0m"
    echo -e "\033[0;32mThis terminal must be kept open to access Jupyter\033[0m"

    minikube service jupyter-notebook -n jupyter-notebook --url

else
    echo -e "\033[0;31mMinikube is not installed. Please install Minikube and try again.\033[0m"
    exit 1
fi

