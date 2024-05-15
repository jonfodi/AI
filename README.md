# AI

This repo is designed to test deployment automation of AI workloads on different hardware. 

Current setup is a Jupyter Notebook image on Docker Hub that runs W and B training on CIFAR-10 data. The cluster is hosted on Minikube. 

The first goal is to automate the deployment of Jupyter to Minikube's IP and use a bot to run the training. 

The second goal is to deploy the training workload on multiple cloud instances and use Kubernetes/Bash to pool the compute resources into a single virutal compute to optimize its usage. 
