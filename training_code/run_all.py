import subprocess
import sys

# Function to run a script
def run_script(script_path):
    result = subprocess.run([sys.executable, script_path], capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error running {script_path}:")
        print(result.stdout)
        print(result.stderr)
        return False
    return True

if __name__ == "__main__":
    # Run the training script
    if run_script('/home/jovyan/work/wandb_train.py'):
        # Run the plotting script
        run_script('/home/jovyan/work/plot_results.py')
        
        # Inform the user where the plot is saved
        print("Plots are available in /home/jovyan/work/training_plots.png")

