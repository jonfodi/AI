# AI

This repo is designed to test deployment automation of AI workloads on different hardware. 

Current setup is a Jupyter Notebook image on Docker Hub that runs W and B training on CIFAR-10 data. The cluster is hosted on Minikube. 

The first goal is to automate the deployment of Jupyter to Minikube's IP and use a bot to run the training. 

The second goal is to deploy the training workload on multiple cloud instances and use Kubernetes/Bash to pool the compute resources into a single virutal compute to optimize its usage. 

# STEPS TO RUN TRAINING WITH DOCKER 

*Pre-requisites
- install Docker on your machine https://docs.docker.com/engine/install/

1) execute: ./deploy/docker/run_docker.sh 1
2) open a browser and go to localhost:8000
3) enter jupyter notebook (password = test)
4) open a shell and run !python /home/jovyan/work/run_all.py
5) training plots will be available at /home/jovyan/work/training_plots.png

