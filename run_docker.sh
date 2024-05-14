#!/bin/bash

# Function to find an available port
find_available_port() {
    local port
    port=$(comm -23 <(seq 8000 9000) <(ss -Htan | awk '{print $4}' | grep -oP '\d+$' | sort -n) | head -n 1)
    echo $port
}

# Build the Docker image
docker build -t simple_jupyter .

# Check the argument
if [ "$1" == "1" ]; then
    PORT=$(find_available_port)
    echo "Using port $PORT"
    # Spin up the Jupyter server on the available port
    docker run -it -p $PORT:8888 simple_jupyter /home/jovyan/start-up.sh
elif [ "$1" == "2" ]; then
    # Open the container's shell
    docker run -it simple_jupyter /bin/bash
else
    echo "Invalid argument. Use 1 to spin up the Jupyter server or 2 to open the container's shell."
    exit 1
fi
