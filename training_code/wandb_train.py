import os
import wandb
import random
import json
import psutil
import GPUtil
import time

# Set WANDB_MODE to dryrun to prevent wandb from asking for an account
os.environ["WANDB_MODE"] = "dryrun"

# Start a new wandb run to track this script
wandb.init(
    project="my-awesome-project",
    config={
        "learning_rate": 0.02,
        "architecture": "CNN",
        "dataset": "CIFAR-100",
        "epochs": 10,
    }
)

# Simulate training
epochs = 10
offset = random.random() / 5
acc_list = []
loss_list = []
cpu_usage = []
gpu_usage = []

for epoch in range(2, epochs):
    acc = 1 - 2 ** -epoch - random.random() / epoch - offset
    loss = 2 ** -epoch + random.random() / epoch + offset
    acc_list.append(acc)
    loss_list.append(loss)
    
    # Log metrics to wandb
    wandb.log({"acc": acc, "loss": loss})
    
    # Log CPU and GPU usage
    cpu = psutil.cpu_percent(interval=1)
    gpus = GPUtil.getGPUs()
    gpu = gpus[0].load * 100 if gpus else 0  # Get GPU load percentage
    cpu_usage.append(cpu)
    gpu_usage.append(gpu)
    time.sleep(1)  # Simulate time delay

# [Optional] Finish the wandb run, necessary in notebooks
wandb.finish()

# Save results to a JSON file
results = {
    "accuracy": acc_list,
    "loss": loss_list,
    "cpu_usage": cpu_usage,
    "gpu_usage": gpu_usage
}
with open("/home/jovyan/work/results.json", "w") as f:
    json.dump(results, f)

