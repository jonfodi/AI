import json
import matplotlib.pyplot as plt

def plot_results():
    # Load the results
    with open("/home/jovyan/work/results.json", "r") as f:
        results = json.load(f)

    acc_list = results["accuracy"]
    loss_list = results["loss"]
    cpu_usage = results["cpu_usage"]
    gpu_usage = results["gpu_usage"]
    epochs = range(2, len(acc_list) + 2)

    # Plotting logic
    plt.figure(figsize=(15, 10))

    # Plot accuracy
    plt.subplot(2, 2, 1)
    plt.plot(epochs, acc_list, label="Accuracy")
    plt.xlabel("Epoch")
    plt.ylabel("Accuracy")
    plt.title("Training Accuracy")
    plt.legend()

    # Plot loss
    plt.subplot(2, 2, 2)
    plt.plot(epochs, loss_list, label="Loss")
    plt.xlabel("Epoch")
    plt.ylabel("Loss")
    plt.title("Training Loss")
    plt.legend()

    # Plot CPU usage
    plt.subplot(2, 2, 3)
    plt.plot(range(len(cpu_usage)), cpu_usage, label="CPU Usage")
    plt.xlabel("Time")
    plt.ylabel("CPU Usage (%)")
    plt.title("CPU Usage During Training")
    plt.legend()

    # Plot GPU usage
    plt.subplot(2, 2, 4)
    plt.plot(range(len(gpu_usage)), gpu_usage, label="GPU Usage")
    plt.xlabel("Time")
    plt.ylabel("GPU Usage (%)")
    plt.title("GPU Usage During Training")
    plt.legend()

    plt.tight_layout()
    plt.savefig("/home/jovyan/work/training_plots.png")

if __name__ == "__main__":
    plot_results()

