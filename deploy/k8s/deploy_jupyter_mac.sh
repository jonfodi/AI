#!/bin/bash

# Function to check if a command exists
command_exists() {
    type "$1" &>/dev/null;
}

# Start Minikube if it is not already running
start_minikube() {
    if minikube status | grep -q 'host: Running'; then
        echo "Minikube is already running."
    else
        echo "Starting Minikube..."
        minikube start
    fi
}

# Enable Ingress
enable_ingress() {
    if minikube addons list | grep -q 'ingress: enabled'; then
        echo "Ingress is already enabled."
    else
        echo "Enabling ingress..."
        minikube addons enable ingress
    fi
}

# Deploy or confirm deployment of Jupyter Notebook
deploy_jupyter() {
    if kubectl get service -n jupyter-notebook | grep -q 'jupyter-notebook'; then
        echo "Jupyter Notebook is already deployed and service is running."
    else
        echo "Deploying Jupyter Notebook and creating service..."
        kubectl apply -f jupyter-deployment.yaml -n jupyter-notebook
        kubectl apply -f jupyter-service.yaml -n jupyter-notebook
        kubectl apply -f jupyter-ingress.yaml -n jupyter-notebook
    fi
}

# Check if Minikube is installed
if command_exists minikube; then
    echo "Minikube is installed."
    start_minikube
    enable_ingress

    # Check if the Kubernetes namespace exists
    if kubectl get namespace | grep -q 'jupyter-notebook'; then
        echo "Namespace 'jupyter-notebook' already exists."
    else
        echo "Creating namespace 'jupyter-notebook'..."
        kubectl create namespace jupyter-notebook
    fi

    deploy_jupyter

    # Wait for Jupyter Notebook to be ready
    echo "Waiting for Jupyter Notebook to be ready..."
    kubectl wait --for=condition=ready pod -l app=jupyter-notebook -n jupyter-notebook --timeout=300s

    # Get the URL to access Jupyter Notebook using the Minikube service command
    echo "Jupyter Notebook is available at the URL below"
    echo "This terminal must be kept open to access Jupyter"

    minikube service jupyter-notebook -n jupyter-notebook --url
    
else
    echo "Minikube is not installed. Please install Minikube and try again."
    exit 1
fi

